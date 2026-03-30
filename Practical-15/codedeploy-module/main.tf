resource "aws_codedeploy_app" "codedeploy_app" {
  name             = var.codedeploy_app_name
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "codedeploy_deployment_group" {
  app_name               = aws_codedeploy_app.codedeploy_app.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.codedeploy_app_name}-deployment-group"
  service_role_arn       = var.codedeploy_role_arn


  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  ecs_service {
    cluster_name = var.cluster_name
    service_name = var.service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.alb_listener_arn]
      }
      test_traffic_route {
        listener_arns = [var.test_listener_arn]
      }
      target_group {
        name = var.alb_tg1_name
      }
      target_group {
        name = var.alb_tg2_name
      }
    }
  }

}
