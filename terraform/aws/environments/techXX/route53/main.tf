module "route53" {
  source = "../../../modules/route53"

  tags = var.default_tags

  domain_name = var.domain_name
  alias_records = [
    {
      subdomain       = var.sub_domain_prefix
      target_dns_name = data.terraform_remote_state.ecs.outputs.alb_dns_name
      target_zone_id  = data.terraform_remote_state.ecs.outputs.alb_zone_id
    }
  ]
  zone_id = data.aws_route53_zone.handson.zone_id
}
