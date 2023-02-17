output "subnetwork_self_link" {
  value = local.create_vpc == 0 ? var.subnetwork_self_link : google_compute_subnetwork.avx_subnetwork.self_link
}