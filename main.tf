provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = "us-central1"  # Replace with your desired region
}

resource "google_compute_network" "tfvpc" {
  name                    = "tfvpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public_subnet" {
  name          = "public-subnet"
  network       = google_compute_network.tfvpc.self_link
  ip_cidr_range = "10.0.1.0/24"
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = "private-subnet"
  network       = google_compute_network.tfvpc.self_link
  ip_cidr_range = "10.0.2.0/24"
}

resource "google_compute_instance" "example_instance" {
  name         = "example-instance"
  machine_type = "n1-standard-1"  # Replace with your desired machine type
  zone         = "us-central1-a"  # Replace with your desired zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"  # Replace with your desired OS image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private_subnet.self_link
  }
}