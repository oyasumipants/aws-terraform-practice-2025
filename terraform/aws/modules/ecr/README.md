# ECR Module

このモジュールは、AWS ECR（Elastic Container Registry）リポジトリを作成します。

## 作成されるリソース

- ECR リポジトリ（プライベート）

## 使用方法

```hcl
module "ecr" {
  source = "../../modules/ecr"

  repository_name = "myapp"
  environment     = "dev"

  tags = {
    Project     = "my-project"
    ManagedBy   = "terraform"
  }
}
```

## 入力変数

| 名前            | 説明                                                                  | タイプ        | デフォルト値 |  必須  |
| --------------- | --------------------------------------------------------------------- | ------------- | ------------ | :----: |
| repository_name | リポジトリ名。{repository_name}-{environment}という名前で作成される。 | `string`      | n/a          |  はい  |
| environment     | 環境名（dev, stg, prod 等）                                           | `string`      | n/a          |  はい  |
| tags            | リソースに付与するタグ                                                | `map(string)` | `{}`         | いいえ |

## 出力値

| 名前            | 説明               |
| --------------- | ------------------ |
| repository_url  | ECRリポジトリのURL |
| repository_name | ECRリポジトリ名    |
| repository_arn  | ECRリポジトリのARN |
