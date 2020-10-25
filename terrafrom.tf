/*resource "kubernetes_deployment" "wordpress" {
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
          test = "MyExampleApp"
        }
      }

      spec {
        container {
          image = "wordpress"
          name  = "wordpress"
        }*/