data "template_file" "axonserver_properties" {
  template = file("${path.module}/conf/axonserver.properties.tftpl")

  vars = {
    first_name             = "${var.cluster_name}-1"
    public_domain          = var.public_domain
    namespace              = kubernetes_namespace.as_demo.id
    internal_token         = random_uuid.internal_token.result
    devmode_enabled        = var.devmode_enabled
    console_authentication = var.console_authentication
  }
}

resource "kubernetes_config_map" "axonserver_properties" {
  metadata {
    name      = "axonserver.properties"
    namespace = kubernetes_namespace.as_demo.id
  }

  data = {
    "axonserver.properties" = data.template_file.axonserver_properties.rendered
  }
}
