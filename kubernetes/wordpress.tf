
resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = "wordpress"
    labels = {
      image = "wordpress"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        image = "wordpress"
      }
    }
    template {
      metadata {
        labels = {
          image = "wordpress"
        }
      }
      spec {
        container {
          image = "wordpress"
          name  = "wordpress"

          env {
            name= "WORDPRESS_DB_HOST" 
            value=  var.db-host
            }
          env {
            name= "WORDPRESS_DB_PASSWORD" 
            value=  var.db-pass
            }
          env {
            name= "WORDPRESS_DB_USER" 
            value=  var.db-uname
            }
          env {
            name= "WORDPRESS_DB_NAME" 
            value=  var.db-dbname
            }
        }
      }
    }
  }
}


resource "kubernetes_service" "lb" {
  depends_on=[ kubernetes_deployment.wordpress]
  metadata {
    name = "terraform-example"
  }
  spec {
    selector = {
      image = "${kubernetes_deployment.wordpress.metadata[0].labels.image}" 
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

output "endpoint" {
  value= kubernetes_service.lb.load_balancer_ingress
}