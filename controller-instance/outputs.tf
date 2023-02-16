output "controller_public_ip" {
  value = google_compute_address.avx_controller_publicip.address
}

output "controller_private_ip" {
  value = google_compute_instance.avx_controller_vm.network_interface.0.network_ip
}

output "controller_network" {
  value = data.google_compute_subnetwork.avx_subnetwork.network
}