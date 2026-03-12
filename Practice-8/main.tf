resource "aws_s3_bucket" "tf-bucket-static-web" {
  bucket = var.s3-bucket-name
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket              = aws_s3_bucket.tf-bucket-static-web.id
  block_public_acls   = true
  block_public_policy = true
}

resource "aws_cloudfront_origin_access_control" "static_website" {
  name                              = "static-website-oac"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_s3_bucket_policy" "allow_cf_access" {
  bucket     = aws_s3_bucket.tf-bucket-static-web.id
  depends_on = [aws_s3_bucket_public_access_block.block]

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowCloudFront",
        Effect = "Allow",

        Principal = {
          Service = "cloudfront.amazonaws.com"
        },

        Action = [
          "s3:GetObject"
        ],

        Resource = [
          "${aws_s3_bucket.tf-bucket-static-web.arn}/*"
        ],

        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.static_web_cdn.arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_object" "bucket_object" {

  bucket = aws_s3_bucket.tf-bucket-static-web.id

  for_each = fileset("${path.module}/Car-catalogue", "**")
  key    = each.value
  source = "${path.module}/Car-catalogue/${each.value}"

  etag = filemd5("${path.module}/Car-catalogue/${each.value}")

  content_type = lookup(
    {
      html = "text/html"
      css  = "text/css"
      js   = "application/javascript"
      jpg  = "image/jpeg"
      png  = "image/png"
    },
    split(".", each.value)[length(split(".", each.value)) - 1],
    "binary/octet-stream"
  )
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_cloudfront_distribution" "static_web_cdn" {
  origin {
    domain_name              = aws_s3_bucket.tf-bucket-static-web.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.static_website.id
    origin_id                = local.origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = var.Environment
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

data "aws_route53_zone" "my_domain" {
  name = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "cloudfront" {
  zone_id = data.aws_route53_zone.my_domain.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.static_web_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.static_web_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}
