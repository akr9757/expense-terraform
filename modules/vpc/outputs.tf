output "vpc_id" {
  value = aws_vpc.main.id
}

output "db_subnets_ids" {
  value = aws_subnet.db.*.id
}

output "app_subnets_ids" {
  value = aws_subnet.app.*.id
}

output "web_subnets_ids" {
  value = aws_subnet.web.*.id
}

output "public_subnets_ids" {
  value = aws_subnet.public.*.id
}