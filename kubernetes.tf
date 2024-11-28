# kubernetes.tf

# Configure the Kubernetes provider to interact with AWS EKS
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

# Get the credentials of the EKS cluster
data "aws_eks_cluster_auth" "cluster_auth" {
  name = module.eks.cluster_name
}

# Define the Kubernetes Namespace (optional but recommended)
resource "kubernetes_namespace" "nodejs_app" {
  metadata {
    name = "nodejs-app"
  }
}

# Define the Deployment for Node.js Application
resource "kubernetes_deployment" "nodejs_app" {
  metadata {
    name      = "nodejs-app"
    namespace = kubernetes_namespace.nodejs_app.metadata[0].name
    labels = {
      app = "nodejs-app"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nodejs-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "nodejs-app"
        }
      }

      spec {
        container {
          name  = "nodejs-app"
          image = "${module.ecr.repository_url}:latest"  # Reference the ECR repository URL
          ports {
            container_port = 80
          }
        }
      }
    }
  }
}

# Define the Service to expose the Node.js app to the internet
resource "kubernetes_service" "nodejs_app_service" {
  metadata {
    name      = "nodejs-app-service"
    namespace = kubernetes_namespace.nodejs_app.metadata[0].name
  }

  spec {
    selector = {
      app = "nodejs-app"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
