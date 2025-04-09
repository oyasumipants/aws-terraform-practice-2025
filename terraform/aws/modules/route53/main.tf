# ALBへのエイリアスレコードを作成するリソース（講義の途中から使う）
resource "aws_route53_record" "alias" {
  count = length(var.alias_records)

  zone_id = var.zone_id
  name    = var.alias_records[count.index].subdomain
  type    = "A"

  alias {
    name                   = var.alias_records[count.index].target_dns_name
    zone_id                = var.alias_records[count.index].target_zone_id
    evaluate_target_health = true
  }
}
