# ECR リポジトリの構築と設定

このディレクトリでは、AWS ECR（Elastic Container Registry）リポジトリを作成します。
ECS 構築時にコンテナイメージを参照するため、この段階でイメージをプッシュしておくことが重要です。

## 前提条件

- AWS CLI がインストールされていること
- Docker がインストールされていること
- AWS 認証情報が設定されていること（`aws-handson`プロファイル）

## 使用方法

### 1. リポジトリの作成

1. Terraform の初期化を行います

```bash
terraform init
```

2. 実行計画を確認します

```bash
terraform plan
```

3. ECR リポジトリを作成します

```bash
terraform apply
```

4. 作成完了後、承認メッセージが表示されたら `yes` と入力して実行を確定します

### 2. コンテナイメージのプッシュ手順

1. リポジトリ URL を取得します（以降の手順で使用）

```bash
REPO_URL=$(terraform output -raw repository_url)
echo $REPO_URL
```

2. ECR へログインします

```bash
aws ecr get-login-password --region ap-northeast-1 --profile aws-handson | docker login --username AWS --password-stdin $REPO_URL
```

3. コンテナイメージにタグを付けます（`myimage:latest`は実際のイメージ名に変更してください）

```bash
docker tag myimage:latest $REPO_URL:v1
```

4. イメージを ECR にプッシュします

```bash
docker push $REPO_URL:v1
```

5. 正常にプッシュされたことを確認します

```bash
aws ecr describe-images --repository-name $(terraform output -raw repository_name) --profile aws-handson
```

## 設定可能な変数

`variables.tf`ファイルで以下の変数を設定できます：

- `region`: AWS リージョン（デフォルト: `ap-northeast-1`）
- `repository_name`: ECR リポジトリ名（デフォルト: `bookshelf`）
- `environment`: 環境名（デフォルト: `dev`）
- `default_tags`: すべてのリソースに適用されるタグ

## トラブルシューティング

- ECR へのログインに失敗する場合、AWS 認証情報が正しく設定されているか確認してください
- イメージのプッシュに失敗する場合、ネットワーク接続やディスク容量を確認してください
