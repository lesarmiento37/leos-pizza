resource "aws_ecr_repository" "pizza_repository" {
name                 = var.ecr_name
image_tag_mutability = "MUTABLE"
image_scanning_configuration {
scan_on_push = true
}
}