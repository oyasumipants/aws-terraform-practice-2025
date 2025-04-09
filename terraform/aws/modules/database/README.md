# Database Module

このモジュールは、AWS Aurora データベースを構築するために使用されます。

## 作成されるリソース

このモジュールは以下のリソースを作成します：

- Aurora DB クラスター
- Aurora DB インスタンス
- DB サブネットグループ
- DB パラメータグループ
- DB クラスターパラメータグループ
- セキュリティグループ
- CloudWatch アラーム
- KMS キー（暗号化用）

## 使用方法

```hcl
module "database" {
  source = "../../modules/database"

  db_name             = "myapp"
  environment         = "dev"
  vpc_id              = module.network.vpc_id
  private_subnet_ids  = module.network.private_subnet_ids

  # データベース設定
  engine              = "aurora-mysql"
  engine_version      = "5.7.mysql_aurora.2.11.2"
  instance_class      = "db.t3.medium"
  instance_count      = 2
  master_username     = "admin"

  # オプションのパラメータ
  backup_retention_period = 7
  preferred_backup_window = "02:00-03:00"
  apply_immediately      = true

  tags = {
    Project     = "my-project"
    ManagedBy   = "terraform"
  }
}
```

## 入力変数

| 名前                    | 説明                               | タイプ         | デフォルト値                |  必須  |
| ----------------------- | ---------------------------------- | -------------- | --------------------------- | :----: |
| db_name                 | データベース名                     | `string`       | n/a                         |  はい  |
| environment             | 環境名（dev, stg, prod 等）        | `string`       | n/a                         |  はい  |
| vpc_id                  | VPC ID                             | `string`       | n/a                         |  はい  |
| private_subnet_ids      | プライベートサブネット ID のリスト | `list(string)` | n/a                         |  はい  |
| engine                  | データベースエンジン               | `string`       | `"aurora-mysql"`            | いいえ |
| engine_version          | エンジンバージョン                 | `string`       | `"5.7.mysql_aurora.2.11.2"` | いいえ |
| instance_class          | インスタンスクラス                 | `string`       | `"db.t3.medium"`            | いいえ |
| instance_count          | インスタンス数（1 以上）           | `number`       | `2`                         | いいえ |
| master_username         | マスターユーザー名                 | `string`       | `"admin"`                   | いいえ |
| backup_retention_period | バックアップ保持期間（日）         | `number`       | `7`                         | いいえ |
| preferred_backup_window | バックアップウィンドウ             | `string`       | `"02:00-03:00"`             | いいえ |
| apply_immediately       | 変更をすぐに適用するか             | `bool`         | `false`                     | いいえ |
| deletion_protection     | 削除保護を有効にするか             | `bool`         | `true`                      | いいえ |
| tags                    | リソースに付与するタグ             | `map(string)`  | `{}`                        | いいえ |

## 出力値

| 名前              | 説明                        |
| ----------------- | --------------------------- |
| cluster_endpoint  | クラスターエンドポイント    |
| reader_endpoint   | リーダーエンドポイント      |
| cluster_id        | DB クラスター ID            |
| cluster_arn       | DB クラスター ARN           |
| security_group_id | セキュリティグループ ID     |
| subnet_group_name | DB サブネットグループ名     |
| instance_ids      | DB インスタンス ID のリスト |
| kms_key_id        | KMS キー ID                 |
| master_username   | マスターユーザー名          |
| database_name     | データベース名              |

## リソースの命名規則

このモジュールでは、以下の形式でリソース名が生成されます：

```
{db_name}-{environment}-{resource_type}
```

例：

- myapp-dev-cluster
- myapp-dev-instance
- myapp-dev-subnet-group
