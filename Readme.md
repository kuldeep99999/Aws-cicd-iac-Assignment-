aws-microservices/
├── modules/
│   ├── network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │  
│   ├── compute/
│   │   ├── main.tf (ECS Cluster, Services, Task Definitions)
│   │   ├── alb.tf (Application Load Balancer)
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │  
│   ├── data/
│   │   ├── main.tf (RDS, Secrets Manager)
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │  
│   └── edge/
│       ├── main.tf (CloudFront, WAF)
│       ├── variables.tf
│       ├── outputs.tf
│      
├── environments/
│   ── dev/
│      ├── main.tf
│      ├── variables.tf
│      ├── terraform.tfvars
│      └── outputs.tf
│  
│   
├── ci-cd/
│   ├── jenkinsfile
│   ├── docker/
│   │   ├── web-app/
│   │   │   └── Dockerfile
│   │   └── admin-api/
│   │       └── Dockerfile
│   └── scripts/
│       ├── deploy.sh
│       |── rollback.sh
|        -- build.images.sh
└── README.md


### services used -

1. AWS VPC - for network isolation
2. AWS ECS with Fargate - for container orchestration
3. Amazon Application Load Balancer (ALB) – Layer 7 load balancing to route incoming requests to ECS services with health checks.
4. Amazon RDS multi Az (PostgreSQL) - managed relational database service
5. AWS Secrets Manager – Centralized, secure storage and rotation of sensitive secrets like database passwords.
6. AWS IAM – Role-based access control for ECS tasks
7. AWS CloudFront – CDN for caching and global distribution of static assets.
8. AWS WAF (Web Application Firewall) – Web security firewall to protect against common vulnerabilities and attacks.
9. Ecr- container regestery
10. jenkins - automating ci/cd pipelines
11. docker - deploying on dev env


### Prerequisites

1. Aws Cli configured
2. Terraform installed
3. jenkins server with nessecery plugins
4. docker installed locally for image builds


# secrets -
1. - AWS Secrets Manager stores sensitive data like database passwords
2. - ECS tasks fetch secrets dynamically at runtime using IAM roles with `secretsmanager:GetSecretValue` permission
3. - Jenkins securely injects AWS and Docker credentials during pipeline runs

# cost optimization
1. - Uses AWS Fargate Spot for cost savings on compute where suitable
2. - Auto scaling configured based on CPU metrics
3. - Multi-AZ deployments for high availability balanced with cost


### Requirements fullfilled -
1. used terraform as a iac code - for networks,compute,data and edge
2. used multi Az's 3 to be specific, idempotent, tagged.

3. used Jenkins for ci/cd - Build, Test and deplyes with automatic rollback on failure and health checks
4. secrets managed securely in aws secrets manager and jenkins creditial store (no secrets hardcoded)

