# ---------------------------------------------------------------------------------------------------------------------
# CREATE A NODE POOL
# ---------------------------------------------------------------------------------------------------------------------

resource "google_container_node_pool" "node_pool" {


  provider = google-beta

  name     = "main-pool"
  project  = var.project
  location = var.location
  # cluster  = module.gke_cluster.name
  cluster  = google_container_cluster.cluster.name

  initial_node_count = "1"

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    image_type   = "COS_CONTAINERD"
    machine_type = var.machine_type

    labels = {
      all-pools-example = "true"
    }

    # Add a public tag to the instances. See the network access tier table for full details:
    # https://github.com/gruntwork-io/terraform-google-network/tree/master/modules/vpc-network#access-tier
    tags = [
    #   module.vpc_network.public,
      var.public_vpc_tag,
      "public-pool", # This can be set to whatever we want
    ]

    disk_size_gb = "30"
    disk_type    = "pd-standard"
    preemptible  = var.preemptible

    spot = var.spot

    service_account = module.gke_service_account.email

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}
