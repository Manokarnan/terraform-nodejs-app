resource "kubernetes_deployment" "nodejs_app" {
  metadata {
    name = "nodejs-app-deployment"
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
          image = "<account_id>.dkr.ecr.us-west-1.amazonaws.com/nodejs-app:latest"
          name  = "nodejs-container"
          ports {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nodejs_service" {
  metadata {
    name = "nodejs-service"
  }

  spec {
    selector = {
      app = "nodejs-app"
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}
