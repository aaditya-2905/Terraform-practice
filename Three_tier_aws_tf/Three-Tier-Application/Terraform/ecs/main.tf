module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "three-tier-app-cluster-${var.aws_region}"

  cluster_capacity_providers = ["FARGATE"]

  services = {
    "three-tier-app" = {
      cpu    = 512
      memory = 1024

      name          = "three-tier-app-${var.aws_region}"
      launch_type   = "FARGATE"
      desired_count = 2

      container_definitions = {
        app = {
          image = var.ecr_image_url

          port_mappings = [
            {
              name          = "app"
              containerPort = 3000
              protocol      = "tcp"
            }
          ]

          essential = true

          environment = [
            {
              name  = "DB_HOST"
              value = var.db_cluster_endpoint
            }
          ]

          log_configuration = {
            logDriver = "awslogs"
            options = {
              awslogs-group         = "/ecs/app-${var.aws_region}"
              awslogs-region        = var.aws_region
              awslogs-stream-prefix = "ecs"
            }
          }
        }
      }

      load_balancer = {
        service = {
          target_group_arn = var.alb_target_group_arn
          container_name   = "app"
          container_port   = 3000
        }
      }

      subnet_ids         = var.pvt_subnet_ids
      security_group_ids = var.sg_id

      assign_public_ip = false
    }
  }
}
