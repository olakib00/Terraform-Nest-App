# create a launch template
resource "aws_launch_template" "app_server_launch_template" {
  name                   = "${var.project_name}-${var.environment}-nest-app-launch-template"
  image_id               = var.amazon_linux_ami_id
  instance_type          = var.ec2_instance_type
  description            = "Launch template for Nest App Web Server instances"
  vpc_security_group_ids = [aws_security_group.app_server_security_group.id]

  iam_instance_profile {
    name = "S3FullAccessInstanceProfile"
  }

  monitoring {
    enabled = true
  }

  user_data = base64encode(templatefile("${path.module}/install-and-configure-nest-app.sh.tpl", {
    PROJECT_NAME = var.project_name
    ENVIRONMENT  = var.environment
    RECORD_NAME  = var.record_name
    DOMAIN_NAME  = var.domain_name
    RDS_ENDPOINT = var.rds_endpoint
    RDS_DB_NAME  = var.database_name
    USERNAME     = var.database_username
    PASSWORD     = var.database_password
  }))
}

# create auto scaling group
resource "aws_autoscaling_group" "auto_scaling_group" {
  vpc_zone_identifier = [aws_subnet.private_app_subnet_az1.id, aws_subnet.private_app_subnet_az2.id]
  desired_capacity    = 2
  max_size            = 4
  min_size            = 1
  name                = "${var.project_name}-${var.environment}-nest-app-asg"
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.app_server_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "test"
    value               = "nest-app-test"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes        = [target_group_arns]
    create_before_destroy = true
  }

  depends_on = [aws_instance.data_migrate_ec2]
}

# attach auto scaling group to alb target group
resource "aws_autoscaling_attachment" "asg_alb_target_group_attachment" {
  autoscaling_group_name = aws_autoscaling_group.auto_scaling_group.id
  lb_target_group_arn    = aws_lb_target_group.alb_target_group.arn
}

# create an auto scaling group notification
resource "aws_autoscaling_notification" "webserver_asg_notifications" {
  group_names = [aws_autoscaling_group.auto_scaling_group.name]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.user_updates.arn
}
