# Hotel-Management-System

Simple hotel booking website with content management system. Users can book rooms for specific dates. Admin can create, update, and delete room details. Admin can manage everything in the app.

## Video
<!--<a href="https://www.youtube.com/watch?v=rKwBxxVXWkM">click here..</a>-->
https://github.com/tushar-2223/Hotel-Management-System/assets/87109400/08742fd7-5e7b-4459-90ef-c4e6b3e0cabd


# Documentation for Task 6

## Brief Description of the Project
This documentation provides a detailed overview of the infrastructure setup and configuration for deploying a web application (JS, PHP) using AWS resources, which are managed through Terraform. The deployment includes setting up a Virtual Private Cloud (VPC), subnets, Internet Gateway, NAT Gateway, Route Tables, ECR, RDS MySQL instance, EKS cluster, Kubernetes configurations, an NGINX Ingress controller, and remote state management using S3 and DynamoDB.

- **Project Name**: Defined by the `project_name` variable.
- **Region**: Defined by the `region` variable.
- **Tags**: Common tags applied to AWS resources are defined in the `tags` variable.

## Prerequisites
- **Terraform**: Terraform installed and configured.
- **AWS CLI**: AWS CLI with the necessary permissions.
- **Docker**: Docker for container operations.

## Project Structure

### Terraform Package

#### Modules
- **Path**: `modules`
- **Description**: The `modules` package contains Terraform configuration structured as reusable modules. These modules are self-contained units of Terraform code that encapsulate all the resources and configurations needed for a specific component of our infrastructure.
- **Modules Included**:
    - **VPC**: Manages Virtual Private Cloud (VPC) resources including subnets, route tables, and gateways.
        - **Private Subnets**: Used for deploying instances and RDS. These subnets do not have direct internet access but can reach the internet via a NAT gateway.
        - **Public Subnets**: Used for resources that require direct internet access, such as NAT gateways and load balancers.
    - **Security Groups**: Defines and manages Security Groups to control inbound and outbound traffic to our resources.
        - **MySQL RDS Security Group**: Has port 3306 open for inbound traffic, allowing access to the MySQL database. All outbound traffic is allowed, ensuring the database can communicate with other services as needed.
    - **ECR**: Manages Amazon Elastic Container Registry (ECR) repositories for storing Docker images.
    - **RDS**: Manages Relational Database Service (RDS) instances, including configuration for MySQL databases.
    - **EKS**: The EKS module is responsible for provisioning and managing the Amazon Elastic Kubernetes Service (EKS) cluster.

#### Root Package
- **Path**: `root`
- **Description**: The `root` package contains the top-level Terraform configuration responsible for orchestrating the creation of all necessary resources. This package ties together the individual modules and applies them in the correct order, ensuring dependencies are handled appropriately.

#### S3 Package
- **Path**: `s3`
- **Description**: The `s3` package is dedicated to managing the creation of AWS S3 buckets and DynamoDB tables used for Terraform state management. Using S3 for state files and DynamoDB for state locking ensures our Terraform state is stored securely and can be accessed by multiple team members simultaneously without conflicts.

## Key Components

### IAM Roles
- Added necessary IAM roles and policies for the EKS cluster, including policies for EC2 Container Registry ReadOnly, EKS Worker Node, EKS CNI, and RDS Full Access.

### EKS Module
- Used the Terraform AWS EKS module to set up the EKS cluster.
- Configured the EKS cluster with private and public endpoint access, cluster addons, and enabled IAM roles for service accounts (IRSA).
- Defined managed node groups with desired capacity and instance types.
- Assigned the IAM role ARN for the EKS node role.

### Kubernetes Namespace
- Created a Kubernetes namespace for deployment.

### Kubeconfig Update
- Configured a `null_resource` to update the kubeconfig for accessing the EKS cluster.

### Helm Releases
- Added a `helm_release` resource to deploy the application (`angin_app`) using Helm charts from the specified path (`../../charts/webapp`).
- Configured the NGINX Ingress Controller using a `helm_release` resource with annotations for AWS Network Load Balancer (NLB).

## Deployment Steps
1. Terraform Initialization and Application: Now, only run `terraform init`, `plan`, and `apply`, and the Kubernetes resources like deployment, service, and ingress are created by Helm charts with the following configurations:
    - IAM Roles: Added necessary IAM roles and policies for the EKS cluster.
    - EKS Module: Set up the EKS cluster with required configurations.
    - Kubernetes Namespace: Created for deployment.
    - Kubeconfig Update: Configured for accessing the EKS cluster.
    - Helm Releases: Deployed the application and NGINX Ingress Controller using Helm charts.
2. Access the application with the NLB's DNS address.

## Additional Information
- **AWS Credentials**: Ensure your AWS credentials are properly configured in your environment. This can be done through the AWS CLI or by setting the appropriate environment variables.
- **Variable Values**: Review and update the values in the `variables.tf` file or pass them as command-line arguments when running Terraform commands. This ensures that all configurations are tailored to your specific environment and requirements.

## Appendix

### Variables
- **General**:
    - `project_name`: The name of the project.
    - `region`: The AWS region where the resources will be deployed.
    - `tags`: Common tags applied to AWS resources.
- **VPC and Subnets**:
    - `vpc_cidr`: The CIDR block for the VPC.
    - `public_subnet_cidr`: A list of CIDR blocks for the public subnets.
    - `private_subnet_cidr`: A list of CIDR blocks for the private subnets.
- **Database**:
    - `db_identifier`: Identifier for the RDS instance.
    - `db_engine`: The database engine (e.g., MySQL).
    - `instance_class`: The instance class for the RDS.
    - `allocated_storage`: The storage allocated for the RDS.
    - `storage_type`: The storage type for the RDS.
    - `db_name`: The name of the database.
    - `db_username`: The username for the database.
    - `db_password`: The password for the database.
    - `engine_version`: The version of the database engine.
    - `db_sg_id`: The security group ID for the database.
- **EKS**:
    - `cluster_name`: The name of the EKS cluster.
    - `vpc_id`: The VPC ID for the EKS cluster.
    - `private_subnet_id`: A list of private subnet IDs.
    - `instance_type`: The instance type for the EKS nodes.
    - `node_disk_size`: The disk size for the EKS nodes.
    - `node_desired_capacity`: The desired capacity for the node group.
    - `node_max_capacity`: The maximum capacity for the node group.
    - `node_min_capacity`: The minimum capacity for the node group.
    - `node_capacity_type`: The capacity type for the node group (e.g., SPOT).
    - `kube_namespace`: The Kubernetes namespace for the deployment.
    - `docker_image`: The Docker image for the application.
    - `port`: The port on which the application runs.
- **S3 and DynamoDB (for Remote State)**:
    - `state_bucket_name`: The name of the S3 bucket for Terraform state.
    - `state_bucket_versioning`: Whether versioning is enabled for the S3 bucket.
    - `kms_key_description`: Description for the KMS key used for encryption.
    - `dynamodb_table_name`: The name of the DynamoDB table for state locks.
