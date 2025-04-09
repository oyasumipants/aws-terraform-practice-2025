# TechXX ネットワーク環境

このディレクトリには、TechXX ハンズオン用の AWS ネットワーク環境を構築するための Terraform コードが含まれています。

## 構成

現在の構成では、以下のリソースを作成します：

- VPC (CIDR: 10.0.0.0/16)
- パブリックサブネット (2 つの AZ: ap-northeast-1a, ap-northeast-1c)
- プライベートサブネット (2 つの AZ)
- 隔離サブネット (2 つの AZ)
- インターネットゲートウェイ
- NAT ゲートウェイ
- ルートテーブル
- セキュリティグループ

## 使用方法

1. AWS CLI の設定

```bash
aws configure
```

2. Terraform の初期化

```bash
terraform init
```

3. 実行計画の確認

```bash
terraform plan
```

4. インフラストラクチャのデプロイ

```bash
terraform apply
```

5. インフラストラクチャの削除

```bash
terraform destroy
```

## バックエンド設定

このプロジェクトでは S3 をバックエンドとして使用しています。`provider.tf` ファイルで以下の設定を確認してください：

```hcl
backend "s3" {
  bucket  = "ca25-techXX-terraform-state" # 自分のチーム名に変更
  key     = "terraform/techXX/network/terraform.tfstate" # 自分のチーム名に変更
  region  = "ap-northeast-1"
  encrypt = true
}
```

使用前に必ず `techXX` を自分のチーム名に変更してください。

## 変数

`variables.tf` ファイルで以下の主要な変数を定義しています：

- `region`: AWS リージョン (デフォルト: ap-northeast-1)
- `environment`: 環境名 (デフォルト: techXX) <!-- 自分のチーム名に変更 -->
- `vpc_name`: VPC 名 (デフォルト: techXX-vpc) <!-- 自分のチーム名に変更 -->
- `vpc_cidr_block`: VPC の CIDR ブロック (デフォルト: 10.0.0.0/16)
- `availability_zones`: アベイラビリティゾーン (デフォルト: ap-northeast-1a, ap-northeast-1c)

必要に応じて、変数のデフォルト値を変更することができます。
