# Terraform AWS ハンズオン

このリポジトリには、AWS インフラストラクチャを Terraform で構築するためのコードが含まれています。

## プロジェクト構造

```
terraform/aws/
├── environments/           # 環境ごとのTerraformコード
│   └── techXX/            # TechXXハンズオン環境
│       ├── main.tf        # メインの設定ファイル
│       ├── variables.tf   # 変数定義
│       ├── outputs.tf     # 出力定義
│       ├── backend.tf     # バックエンド設定
│       └── README.md      # 環境のドキュメント
│
└── modules/               # 再利用可能なモジュール
    ├── network/           # ネットワークモジュール（VPC、Subnet等）
    ├── ecr/               # ECRモジュール
    ├── ecs/               # ECSモジュール
    ├── database/          # データベースモジュール
    └── route53/           # Route 53モジュール
```

## 前提条件

- AWS CLI がインストールされていること
- Terraform がインストールされていること（バージョン 1.10.0 以上推奨）
- AWS アカウントとアクセス権限があること

## 使用方法

1. リポジトリをクローン

```bash
git clone <repository-url>
cd terraform-practice-2025
```

2. 使用したい環境のディレクトリに移動

```bash
cd terraform/aws/environments/techXX
```

3. Terraform を初期化

```bash
terraform init
```

4. 実行計画を確認

```bash
terraform plan
```

5. インフラストラクチャをデプロイ

```bash
terraform apply
```

6. リソースを削除（使用後）

```bash
terraform destroy
```

## モジュール

### Network

基本的なネットワークインフラストラクチャ（VPC、サブネット、ルートテーブル、インターネットゲートウェイ、NAT ゲートウェイなど）を構築します。

詳細は [Network モジュールの README](terraform/aws/modules/network/README.md) を参照してください。

### ECR

コンテナイメージのリポジトリを ECR に構築します。

詳細は [ECR モジュールの README](terraform/aws/modules/ecr/README.md) を参照してください。

### ECS

ECS と ALB により、コンテナ化されたアプリケーションを構築します。

詳細は [ECS モジュールの README](terraform/aws/modules/ecs/README.md) を参照してください。

### Database

AWS オーロラデータベースサービスを利用して、高可用性と耐久性を持つリレーショナルデータベースを構築します。

詳細は [Database モジュールの README](terraform/aws/modules/database/README.md) を参照してください。

### Route53

DNS レコード管理、ドメイン登録、ヘルスチェックなどの DNS 関連機能を提供します。

詳細は [Route53 モジュールの README](terraform/aws/modules/route53/README.md) を参照してください。
