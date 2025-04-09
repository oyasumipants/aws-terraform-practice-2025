# ECS 環境構築

このディレクトリでは、ECS(Elastic Container Service)と ALB(Application Load Balancer)の構築を行います。

## 構成リソース

以下のリソースを作成します：

- ECS クラスター
- ECS サービス
- ECS タスク定義
- Application Load Balancer (ALB)
- ALB ターゲットグループ
- セキュリティグループ（ALB 用、ECS タスク用）
- IAM ロール（タスク実行ロール、タスクロール）
- CloudWatch ロググループ

## 事前準備

- ECR にコンテナイメージをプッシュしておく必要があります
- Network、ECR、Database モジュールが適用済みであること

## 使用方法

1. variables.tf ファイルを編集

   - app_name: アプリケーション名
   - image_tag: ECR のイメージタグ
   - domain_name: ドメイン名

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

## 注意事項

- タスク定義では、ECR にプッシュしたイメージを使用します
- データベース接続情報は Secrets Manager から取得します
- 環境変数はタスク定義で設定されます
