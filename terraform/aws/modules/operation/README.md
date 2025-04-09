# Operation Module

このモジュールは、AWS での運用管理用のインスタンスとリソースを構築するために使用されます。

## 作成されるリソース

このモジュールは以下のリソースを作成します：

- EC2 インスタンス（運用管理用）
- セキュリティグループ
- IAM ロール（SSM アクセス用）
- IAM ポリシー（Secrets Manager アクセス用）
- IAM インスタンスプロファイル
- S3 バケット（運用スクリプト保存用）

## 使用方法

```hcl
module "operation" {
  source = "../../modules/operation"

  prefix     = "myapp-dev"
  vpc_id     = module.vpc.vpc_id
  subnet_id  = module.vpc.private_subnet_ids[0]

  # オプション
  instance_type    = "t3.micro"
  root_volume_size = 30
  key_name         = "my-key-pair"
  db_secret_arn    = module.rds.db_secret_arn

  tags = {
    Project     = "my-project"
    ManagedBy   = "terraform"
  }
}
```

## 入力変数

| 名前             | 説明                                           | タイプ        | デフォルト値 |  必須  |
| ---------------- | ---------------------------------------------- | ------------- | ------------ | :----: |
| prefix           | リソースの接頭辞                               | `string`      | n/a          |  はい  |
| vpc_id           | VPC ID                                         | `string`      | n/a          |  はい  |
| subnet_id        | EC2 インスタンスを起動するサブネット ID        | `string`      | n/a          |  はい  |
| ami_id           | EC2 インスタンスの AMI ID                      | `string`      | null         | いいえ |
| instance_type    | EC2 インスタンスタイプ                         | `string`      | "t3.micro"   | いいえ |
| root_volume_size | ルートボリュームサイズ（GB）                   | `number`      | 30           | いいえ |
| key_name         | SSH キーペア名                                 | `string`      | null         | いいえ |
| db_secret_arn    | Secrets Manager のデータベースシークレット ARN | `string`      | null         | いいえ |
| tags             | リソースに付与するタグ                         | `map(string)` | {}           | いいえ |

## 出力値

| 名前                 | 説明                                       |
| -------------------- | ------------------------------------------ |
| instance_id          | EC2 インスタンス ID                        |
| instance_private_ip  | EC2 インスタンスのプライベート IP アドレス |
| instance_arn         | EC2 インスタンス ARN                       |
| security_group_id    | セキュリティグループ ID                    |
| iam_role_arn         | IAM ロール ARN                             |
| instance_profile_arn | IAM インスタンスプロファイル ARN           |
| scripts_bucket_name  | 運用スクリプト用 S3 バケット名             |
| scripts_bucket_arn   | 運用スクリプト用 S3 バケット ARN           |

## リソースの命名規則

このモジュールでは、以下の形式でリソース名が生成されます：

```
{prefix}-{resource_type}
```

例：

- myapp-dev-operation-sg
- myapp-dev-ssm-role
- myapp-dev-operation-scripts
