# ECS Module

このモジュールは、AWS ECS（Elastic Container Service）環境を構築するために使用されます。

## 作成されるリソース

このモジュールは以下のリソースを作成します：

- ECS クラスター
- ECS サービス
- ECS タスク定義
- Application Load Balancer (ALB)
- ALB ターゲットグループ
- セキュリティグループ（ALB用、ECSタスク用）
- IAM ロール（タスク実行ロール、タスクロール）
- CloudWatch ロググループ
- VPCエンドポイント（ECR API、ECR DKR、S3）

## 使用方法

```hcl
# ECRリポジトリの作成
module "ecr" {
  source = "../ecr"

  app_name    = "myapp"
  environment = "dev"
}

# ECSクラスターとサービスの作成
module "ecs" {
  source = "../../modules/ecs"

  app_name           = "myapp"
  environment        = "dev"
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  private_route_table_ids = module.network.private_route_table_ids
  
  # ECRリポジトリの参照
  ecr_repository_url = module.ecr.repository_url
  image_tag          = "latest"

  # オプションのパラメータ
  container_port     = 80
  desired_count      = 2
  cpu               = 256
  memory            = 512
  task_cpu          = 256
  task_memory       = 512
  health_check_path = "/"

  tags = {
    Project     = "my-project"
    ManagedBy   = "terraform"
  }
}
```

## 入力変数

| 名前                    | 説明                                 | タイプ         | デフォルト値 |  必須  |
| ----------------------- | ------------------------------------ | -------------- | ------------ | :----: |
| app_name                | アプリケーション名                   | `string`       | n/a          |  はい  |
| environment             | 環境名（dev, stg, prod 等）          | `string`       | n/a          |  はい  |
| vpc_id                  | VPC ID                               | `string`       | n/a          |  はい  |
| public_subnet_ids       | パブリックサブネットIDのリスト       | `list(string)` | n/a          |  はい  |
| private_subnet_ids      | プライベートサブネットIDのリスト     | `list(string)` | n/a          |  はい  |
| private_route_table_ids | プライベートルートテーブルIDのリスト | `list(string)` | n/a          |  はい  |
| ecr_repository_url      | ECRリポジトリURL                     | `string`       | n/a          |  はい  |
| image_tag               | コンテナイメージのタグ               | `string`       | n/a          |  はい  |
| container_port          | コンテナポート                       | `number`       | `80`         | いいえ |
| desired_count           | ECSサービスのタスク数                | `number`       | `2`          | いいえ |
| cpu                     | タスク定義のCPUユニット              | `number`       | `256`        | いいえ |
| memory                  | タスク定義のメモリ(MiB)              | `number`       | `512`        | いいえ |
| task_cpu                | タスクのCPUユニット                  | `number`       | `256`        | いいえ |
| task_memory             | タスクのメモリ(MiB)                  | `number`       | `512`        | いいえ |
| health_check_path       | ヘルスチェックパス                   | `string`       | `/`          | いいえ |
| log_retention_days      | ログの保持日数                       | `number`       | `30`         | いいえ |
| tags                    | リソースに付与するタグ               | `map(string)`  | `{}`         | いいえ |

## 出力値

| 名前                        | 説明                              |
| --------------------------- | --------------------------------- |
| alb_dns_name                | ALBのDNS名                        |
| alb_zone_id                 | ALBのホストゾーンID               |
| alb_arn                     | ALBのARN                          |
| target_group_arn            | ターゲットグループのARN           |
| ecs_cluster_id              | ECSクラスターのID                 |
| ecs_cluster_name            | ECSクラスター名                   |
| ecs_service_id              | ECSサービスのID                   |
| ecs_service_name            | ECSサービス名                     |
| task_definition_arn         | タスク定義のARN                   |
| task_execution_role_arn     | タスク実行ロールのARN             |
| task_role_arn               | タスクロールのARN                 |
| cloudwatch_log_group_name   | CloudWatchロググループ名          |
| security_group_alb_id       | ALBのセキュリティグループID       |
| security_group_ecs_tasks_id | ECSタスクのセキュリティグループID |

## リソースの命名規則

このモジュールでは、以下の形式でリソース名が生成されます：

```
{app_name}-{environment}-{resource_type}
```

例：
- myapp-dev-alb
- myapp-dev-cluster
- myapp-dev-ecs-tasks
