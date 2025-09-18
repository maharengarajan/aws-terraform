# Cloudwatch Log Group for system logs
resource "aws_cloudwatch_log_group" "system_logs" {
    name              = "aws-terraform-case6-logs"
    retention_in_days = 7

    tags = {
        Name        = "${var.project_name}-${var.environment}-system-logs"
        Environment = var.environment
        Project     = var.project_name
    }
}

# Cloudwatch Log Group for application logs
resource "aws_cloudwatch_log_group" "application_logs" {
    name              = "aws-terraform-case6-app-logs"
    retention_in_days = 7

    tags = {
        Name        = "${var.project_name}-${var.environment}-application-logs"
        Environment = var.environment
        Project     = var.project_name
    }
}
