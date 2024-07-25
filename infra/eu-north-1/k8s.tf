provider "helm" {
  kubernetes {
    host                   = module.eks_vi_test.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_vi_test.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks_vi_test.cluster_name]
    }
  }
}


resource "helm_release" "mongodb" {
  name       = "mongodb"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"
  namespace  = "mongodb"
  version    = "15.6.14"
  create_namespace = true

  set {
    name  = "persistence.enabled"
    value = "false"
  }
}
