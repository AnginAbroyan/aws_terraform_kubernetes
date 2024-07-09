# DevOps Project

## Brief Description of the Project

This documentation provides a detailed overview of the infrastructure setup and configuration for deploying a web application (JS, PHP) using AWS resources, managed through Terraform. The deployment includes setting up a Virtual Private Cloud (VPC), subnets, Internet Gateway, NAT Gateway, Route Tables, ECR, RDS MySQL instance, EKS cluster, Kubernetes configurations, an NGINX Ingress controller, and remote state management using S3 and DynamoDB.

- **Project Name:** Defined by the `project_name` variable.
- **Region:** Defined by the `region` variable.
- **Tags:** Common tags applied to AWS resources are defined in the `tags` variable.

## Prerequisites

- **Terraform:** Installed and configured.
- **AWS CLI:** Configured with the necessary permissions.
- **Docker:** For container operations.

## Project Structure

### Helm Charts Package

- `Chart.yaml`: Defines chart metadata.
- `values.yaml`: Specifies default values.
- `templates/deployment.yaml`: Deployment configuration.
- `templates/service.yaml`: Service configuration.
- `templates/ingress.yaml`: Ingress Controller configuration.
- `templates/secrets.yaml`: Sensitive data configuration.

### Terraform Package

#### Modules

This package contains configuration structured as Terraform modules.

- **Path:** `modules`
- **Description:** The modules package contains Terraform configuration structured as reusable modules. These modules encapsulate all the resources and configurations needed for specific components of the infrastructure.

**Modules Included:**

- **VPC:** Manages Virtual Private Cloud (VPC) resources including subnets, route tables, and gateways. The VPC is designed with two private subnets and two public subnets.
  - **Private Subnets:** For deploying instances and RDS without direct internet access, utilizing a NAT gateway for internet connectivity.
  - **Public Subnets:** For resources requiring direct internet access, such as NAT gateways and load balancers.
  
- **Security Groups:** Defines and manages Security Groups to control inbound and outbound traffic.
  - **MySQL RDS Security Group:** Port 3306 open for inbound traffic, with all outbound traffic allowed.
  
- **ECR:** Manages Amazon Elastic Container Registry (ECR) repositories for storing Docker images.
- **RDS:** Manages Relational Database Service (RDS) instances, including MySQL configuration.
- **EKS:** Responsible for provisioning and managing the Amazon Elastic Kubernetes Service (EKS) cluster.

  **Key Components:**
  - **IAM Roles and Policies:**
    - `eks_node_role`: IAM role assigned to EKS worker nodes, with necessary permissions.
  - **EKS Cluster Configuration:**
    - **Cluster Details:** Named by the `cluster_name` variable, with specified Kubernetes version.
    - **Cluster Add-ons:** CoreDNS, kube-proxy, and VPC-CNI.
    - **Subnets:** Deployed in private subnets for security.
  - **Managed Node Groups:**
    - **Node Group Configuration:** Configured with instance types, disk size, and capacities.
  - **Kubernetes Namespace:** Created to segregate resources.
  - **Kubeconfig Update:** Ensures the local kubeconfig file is updated with EKS cluster details.
  - **NGINX Ingress Controller:** Deployed using Helm, configured with AWS Network Load Balancer.
  - **Kubernetes Deployment and Service:** Application deployment and service configuration.
  - **Ingress Configuration:** Manages HTTP traffic with rules for routing requests.
  - **Secrets Management:** Stores database credentials and sensitive information securely.

#### Root Package

- **Path:** `root`
- **Description:** Contains top-level Terraform configuration responsible for orchestrating resource creation.
  - Instantiates and configures modules.
  - Manages overall infrastructure state and dependencies.
  - Orchestrates deployment process.

#### S3 Package

- **Path:** `s3`
- **Description:** Manages AWS S3 buckets and DynamoDB tables for Terraform state management.
  - **AWS S3 Bucket:** Stores Terraform state files.
  - **DynamoDB Table:** Used for state locking.

## Appendix

### Variables

- **General:**
  - `project_name`
  - `region`
  - `tags`
- **VPC and Subnets:**
  - `vpc_cidr`
  - `public_subnet_cidr`
  - `private_subnet_cidr`
- **Database:**
  - `db_identifier`
  - `db_engine`
  - `instance_class`
  - `allocated_storage`
  - `storage_type`
  - `db_name`
  - `db_username`
  - `db_password`
  - `engine_version`
  - `db_sg_id`
- **EKS:**
  - `cluster_name`
  - `vpc_id`
  - `private_subnet_id`
  - `instance_type`
  - `node_disk_size`
  - `node_desired_capacity`
  - `node_max_capacity`
  - `node_min_capacity`
  - `node_capacity_type`
  - `kube_namespace`
  - `docker_image`
  - `port`
- **S3 and DynamoDB:**
  - `state_bucket_name`
  - `state_bucket_versioning`
  - `kms_key_description`
  - `dynamodb_table_name`

## Deployment Steps

1. **Terraform Initialization and Application:**
   - Run `terraform init`, `terraform plan`, and `terraform apply`. Kubernetes resources like deployment, service, and ingress are created by Helm charts with the following configurations:

2. **IAM Roles:**
   - Added necessary IAM roles and policies for the EKS cluster.

3. **EKS Module:**
   - Setup EKS cluster using Terraform AWS EKS module.
   - Configured with private and public endpoint access, cluster addons, and enabled IAM roles for service accounts (IRSA).
   - Defined managed node groups.
   - Assigned IAM role ARN for EKS node role.

4. **Kubernetes Namespace:**
   - Created Kubernetes namespace for deployment.

5. **Kubeconfig Update:**
   - Configured a null_resource to update the kubeconfig.

6. **Helm Releases:**
   - Added `helm_release` resource to deploy the application using Helm charts.
   - Configured NGINX Ingress Controller using `helm_release`.

7. **Access the Application:**
   - Access the application using the NLB’s DNS address.

## Additional Information

- **AWS Credentials:** Ensure AWS credentials are properly configured.
- **Variable Values:** Review and update values in `variables.tf` or pass them as command-line arguments.

This structured approach ensures modular, maintainable, and scalable infrastructure management.

