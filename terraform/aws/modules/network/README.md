# Network モジュール

このモジュールは、AWS のネットワークインフラストラクチャを構築するために使用されます。

## 作成されるリソース

このモジュールは以下のリソースを作成します：

- VPC
- パブリックサブネット (複数の AZ)
- プライベートサブネット (複数の AZ)
- アイソレートサブネット (複数の AZ)
- インターネットゲートウェイ
- NAT ゲートウェイ（各パブリックサブネットに 1 つ）
- Elastic IP（NAT ゲートウェイ用）
- パブリックルートテーブル
- プライベートルートテーブル
- アイソレートルートテーブル
- セキュリティグループ
- ネットワーク ACL

## 使用方法

```hcl
module "network" {
  source = "../../modules/network"

  vpc_name             = "my-vpc"
  vpc_cidr_block       = "10.0.0.0/16"
  availability_zones   = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  isolated_subnet_cidrs = ["10.0.21.0/24", "10.0.22.0/24"]
  environment          = "dev"
  tags                 = {
    Project   = "my-project"
    ManagedBy = "terraform"
  }
}
```

## 入力変数

| 名前                  | 説明                                           | タイプ         | デフォルト値                             |  必須  |
| --------------------- | ---------------------------------------------- | -------------- | ---------------------------------------- | :----: |
| vpc_name              | VPC の名前                                     | `string`       | n/a                                      |  はい  |
| vpc_cidr_block        | VPC の CIDR ブロック                           | `string`       | `"10.0.0.0/16"`                          | いいえ |
| availability_zones    | 使用するアベイラビリティゾーンのリスト         | `list(string)` | `["ap-northeast-1a", "ap-northeast-1c"]` | いいえ |
| public_subnet_cidrs   | パブリックサブネットの CIDR ブロックのリスト   | `list(string)` | `["10.0.1.0/24", "10.0.2.0/24"]`         | いいえ |
| private_subnet_cidrs  | プライベートサブネットの CIDR ブロックのリスト | `list(string)` | `["10.0.16.0/20", "10.0.32.0/20"]`       | いいえ |
| isolated_subnet_cidrs | アイソレートサブネットの CIDR ブロックのリスト | `list(string)` | `["10.0.64.0/20", "10.0.80.0/20"]`       | いいえ |
| environment           | 環境名（dev, stg, prod 等）                    | `string`       | n/a                                      |  はい  |
| tags                  | すべてのリソースに適用されるタグのマップ       | `map(string)`  | `{}`                                     | いいえ |

## 出力

| 名前                      | 説明                                   |
| ------------------------- | -------------------------------------- |
| vpc_id                    | 作成された VPC の ID                   |
| vpc_cidr_block            | VPC の CIDR ブロック                   |
| public_subnet_ids         | パブリックサブネット ID のリスト       |
| private_subnet_ids        | プライベートサブネット ID のリスト     |
| isolated_subnet_ids       | アイソレートサブネット ID のリスト     |
| default_security_group_id | デフォルトセキュリティグループの ID    |
| nat_gateway_ids           | NAT ゲートウェイ ID のリスト           |
| public_route_table_id     | パブリックルートテーブルの ID          |
| private_route_table_ids   | プライベートルートテーブル ID のリスト |
| isolated_route_table_ids  | アイソレートルートテーブル ID のリスト |
| availability_zones        | 使用されたアベイラビリティゾーン       |
