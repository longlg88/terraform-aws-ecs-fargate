# ecs service

resource "aws_ecs_service" "main" {
  name            = "${var.name}"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  desired_count   = "${var.count}"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.tasks.id}"]
    subnets         = ["${aws_subnet.public.*.id}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.app.id}"
    container_name   = "${var.name}"
    container_port   = "${var.internal_port}"
  }

  depends_on = [
    "aws_alb_listener.front",
  ]
}