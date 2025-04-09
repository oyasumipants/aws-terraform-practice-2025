# データベース環境の構築と設定

このディレクトリには、Terraform を使用して構築された Aurora MySQL データベースリソースの設定が含まれています。
アプリケーション実行時にデータを保存するための重要なインフラストラクチャコンポーネントです。

## 前提条件

- AWS CLI がインストールされていること
- Terraform がインストールされていること
- AWS 認証情報が設定されていること（`aws-handson`プロファイル）
- ネットワークモジュールが先に適用されていること

## 使用方法

### 1. データベースの作成

1. Terraform の初期化を行います

```bash
terraform init
```

2. 実行計画を確認します

```bash
terraform plan
```

3. データベースリソースを作成します

```bash
terraform apply
```

4. 作成完了後、承認メッセージが表示されたら `yes` と入力して実行を確定します

### 2. データベース接続情報の取得

1. データベースエンドポイントを取得します

```bash
terraform output cluster_endpoint
```

2. Secrets Manager からデータベース認証情報を取得します

```bash
aws secretsmanager get-secret-value --secret-id $(terraform output -raw secret_name) --profile aws-handson | jq -r '.SecretString'
```

## リソース構成

- **データベースタイプ**: Aurora MySQL 8.0
- **インスタンスクラス**: db.t3.medium
- **バージョン**: 8.0.mysql_aurora.3.08.1
- **インスタンス数**: 1
- **バックアップ保持期間**: 1 日
- **バックアップウィンドウ**: 03:00-04:00
- **データベーススケジューラ**: 有効

## 出力値

このモジュールは以下の出力値を提供します：

- `cluster_endpoint`: クラスターエンドポイント
- `cluster_reader_endpoint`: クラスターリーダーエンドポイント
- `database_name`: データベース名
- `master_username`: マスターユーザー名
- `secret_arn`: Secrets Manager シークレットの ARN
- `secret_name`: Secrets Manager シークレットの名前

## ネットワーク構成

データベースは、ネットワークモジュールから提供される以下のリソースを使用します：

- VPC
- 分離されたサブネット
- セキュリティグループ

リモートステートを使用してこれらの値をネットワークモジュールから取得しています。

## 設定可能な変数

`variables.tf`ファイルで以下の変数を設定できます：

- `region`: AWS リージョン（デフォルト: `ap-northeast-1`）
- `default_tags`: すべてのリソースに適用されるタグ

## トラブルシューティング

- データベース接続に失敗する場合、セキュリティグループの設定を確認してください
- Secrets Manager からシークレットを取得できない場合、IAM 権限を確認してください
- リモートステートの参照に失敗する場合、ネットワークモジュールが正しく適用されているか確認してください
