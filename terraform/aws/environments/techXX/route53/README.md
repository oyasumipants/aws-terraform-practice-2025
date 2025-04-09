# TechXX Route53 環境

このディレクトリには、TechXX ハンズオン用の Route53 設定を構築するための Terraform コードが含まれています。

## 構成

現在の構成では、以下のリソースを作成します：

- Route53 レコード (ALB へのエイリアス)

## 使用方法

1. `terraform.tfvars`ファイルを作成し、必要な変数を設定してください。

```hcl
domain_name = "example.com"
sub_domain_prefix = "あなたの名前"
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

S3 をバックエンドとして使用しています。`provider.tf`ファイル内の以下の部分を自分のチーム名と名前に変更してください：

```hcl
backend "s3" {
  bucket  = "ca25-techXX-terraform-state" # 自分のチーム名に変更
  key     = "terraform/techXX/route53/user-name/terraform.tfstate" # 自分のチーム名,名前に変更
  region  = "ap-northeast-1"
  encrypt = true
  profile = "aws-handson"
}
```

## 変数

変数の詳細については、`variables.tf`ファイルを参照してください。主な変数は以下の通りです：

- `domain_name`: ドメイン名
- `sub_domain_prefix`: サブドメインのプレフィックス（通常はあなたの名前）
