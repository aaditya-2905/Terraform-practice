module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  viewer_certificate = {
    cloudfront_default_certificate = true
  }

  default_root_object = "index.html"

  origin_access_control = {
    s3_origin = {
      description      = "CloudFront Access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  origin = {
    # S3 (frontend)
    s3_origin = {
      domain_name               = var.bucket_regional_domain_name
      origin_id                 = "s3-${var.region}"
      origin_access_control_key = "s3_origin"
    }

    # PRIMARY ALB
    primary_alb = {
      domain_name = var.primary_alb_dns_name
      origin_id   = "primary-alb"

      custom_header = {
        "x-origin-secret" = var.cf_origin_secret
      }

      custom_origin_config = {
        origin_protocol_policy = "http-only"
        http_port              = 80
        https_port             = 443
      }
    }

    # SECONDARY ALB
    secondary_alb = {
      domain_name = var.secondary_alb_dns_name
      origin_id   = "secondary-alb"

      custom_header = {
        "x-origin-secret" = var.cf_origin_secret
      }

      custom_origin_config = {
        origin_protocol_policy = "http-only"
        http_port              = 80
        https_port             = 443
      }
    }
  }

  # FAILOVER ONLY FOR READ
  origin_group = {
    alb_failover = {
      failover_criteria = {
        status_codes = [500, 502, 503, 504]
      }

      member = [
        { origin_id = "primary-alb" },
        { origin_id = "secondary-alb" }
      ]
    }
  }

  # FRONTEND (S3)
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

  # ✅ CORRECT ORDER (VERY IMPORTANT)
  ordered_cache_behavior = [

    # 🔥 WRITE APIs FIRST (PRIMARY ONLY)

    {
      path_pattern           = "/api/addstudent"
      target_origin_id       = "primary-alb"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS", "POST", "PUT", "PATCH", "DELETE"]
      cached_methods  = ["GET", "HEAD"]

      forwarded_values = {
        query_string = true
        headers      = ["*"]
        cookies      = { forward = "all" }
      }
    },

    {
      path_pattern           = "/api/addteacher"
      target_origin_id       = "primary-alb"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS", "POST", "PUT", "PATCH", "DELETE"]
      cached_methods  = ["GET", "HEAD"]

      forwarded_values = {
        query_string = true
        headers      = ["*"]
        cookies      = { forward = "all" }
      }
    },

    {
      path_pattern           = "/api/student/*"
      target_origin_id       = "primary-alb"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS", "POST", "PUT", "PATCH", "DELETE"]
      cached_methods  = ["GET", "HEAD"]

      forwarded_values = {
        query_string = true
        headers      = ["*"]
        cookies      = { forward = "all" }
      }
    },

    {
      path_pattern           = "/api/teacher/*"
      target_origin_id       = "primary-alb"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS", "POST", "PUT", "PATCH", "DELETE"]
      cached_methods  = ["GET", "HEAD"]

      forwarded_values = {
        query_string = true
        headers      = ["*"]
        cookies      = { forward = "all" }
      }
    },

    # ✅ READ APIs LAST (FAILOVER)

    {
      path_pattern           = "/api/*"
      target_origin_id       = "alb_failover"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD"]
      cached_methods  = ["GET", "HEAD"]

      forwarded_values = {
        query_string = true
        headers      = ["*"]
        cookies      = { forward = "all" }
      }
    }
  ]

  web_acl_id = aws_wafv2_web_acl.cloudfront_waf.arn
}

# WAF (CloudFront)
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
