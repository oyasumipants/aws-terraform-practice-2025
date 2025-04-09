# Route53 Module

このモジュールは、AWS Route53 を使用して DNS レコードを管理するために使用されます。

## 作成されるリソース

このモジュールは以下のリソースを作成します：

- Route53 エイリアスレコード（ALB への接続用）

## 使用方法

```hcl
module "route53" {
  source = "../../modules/route53"

  zone_id       = aws_route53_zone.primary.zone_id
  domain_name   = "example.com"

  alias_records = [
    {
      subdomain       = "app.example.com"
      target_dns_name = module.alb.dns_name
      target_zone_id  = module.alb.zone_id
    }
  ]

  tags = {
    Project     = "my-project"
    ManagedBy   = "terraform"
  }
}
```

## 入力変数

| 名前          | 説明                           | タイプ         | デフォルト値 |  必須  |
| ------------- | ------------------------------ | -------------- | ------------ | :----: |
| zone_id       | Route53 ゾーン ID              | `string`       | n/a          |  はい  |
| domain_name   | ドメイン名                     | `string`       | n/a          |  はい  |
| alias_records | エイリアスレコードの設定リスト | `list(object)` | `[]`         | いいえ |
| tags          | リソースに付与するタグ         | `map(string)`  | `{}`         | いいえ |

## alias_records の構造

```hcl
alias_records = [
  {
    subdomain       = string       # サブドメイン名
    target_dns_name = string       # 転送先のDNS名（例：ALBのDNS名）
    target_zone_id  = string       # 転送先のゾーンID（例：ALBのゾーンID）
  }
]
```

## 出力値

このモジュールには現在、定義された出力値はありません。
