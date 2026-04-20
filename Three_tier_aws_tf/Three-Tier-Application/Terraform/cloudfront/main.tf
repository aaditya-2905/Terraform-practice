module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"
  viewer_certificate = {
    cloudfront_default_certificate = true
  }

  origin = {
    s3_origin = {
      domain_name = var.bucket_regional_domain_name
      origin_id   = "s3-${var.region}"
    }

    primary_alb = {
      domain_name = var.primary_alb_dns_name
      origin_id   = "primary-alb"
      custom_header = {
        x-origin-secret = var.cf_origin_secret
      }
      custom_origin_config = {
        origin_protocol_policy = "http-only"
        http_port              = 80
        https_port             = 443
      }
    }

    secondary_alb = {
      domain_name = var.secondary_alb_dns_name
      origin_id   = "secondary-alb"
      custom_header = {
        x-origin-secret = var.cf_origin_secret
      }
      custom_origin_config = {
        origin_protocol_policy = "http-only"
        http_port              = 80
        https_port             = 443
      }
    }
  }

  origin_group = {
    alb_failover = {
      failover_criteria = {
        status_codes = [500, 502, 503, 504]
      }

      member = [
        {
          origin_id = "primary-alb"
        },
        {
          origin_id = "secondary-alb"
        }
      ]
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3-${var.region}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    forwarded_values = {
      query_string = false
      cookies      = { forward = "none" }
    }
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/api/*"
      target_origin_id       = "alb_failover"
      viewer_protocol_policy = "redirect-to-https"
      allowed_methods        = ["GET", "HEAD"]
      cached_methods         = ["GET", "HEAD"]
      forwarded_values = {
        query_string = true
        headers      = ["*"]
        cookies      = { forward = "all" }
      }
    }
  ]

  web_acl_id = aws_wafv2_web_acl.cloudfront_waf.arn
}

resource "aws_wafv2_web_acl" "cloudfront_waf" {
  name        = "CloudFrontProtection"
  description = "WAF for CloudFront with Managed Rules"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 0

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "CloudFrontWAF"
    sampled_requests_enabled   = true
  }
}

