provider "google" {
 version = "1.4.0"
 project = "${var.project}"
 region = "${var.region}"
	}
resource "google_compute_instance" "app" {
 name = "reddit-app"
 machine_type = "g1-small"
 zone = "europe-west1-b"
 tags = ["reddit-app"]
 boot_disk {
 initialize_params {
 image = "${var.disk_image}"
 	}	
 }
 network_interface {
 network = "default"
 access_config {}
 }
metadata {
 ssh-keys = "appuser:${file(var.public_key_path)}"
 }
connection {
 type = "ssh"
 user = "appuser2"
 agent = false
 private_key = "${file(var.private_key)}"
 }
provisioner "file" {
source = "files/puma.service"
destination = "/tmp/puma.service"
	} 
provisioner "remote-exec" {
 script = "files/deploy.sh"
	}
}
resource "google_compute_firewall" "firewall_puma" {
 name = "allow-puma-default"
 network = "default"
 allow {
 protocol = "tcp"
 ports = ["9292"]
 }
 source_ranges = ["0.0.0.0/0"]
 target_tags = ["reddit-app"]
} 
resource "google_compute_project_metadata" "app_appuser3" {
metadata {
ssh-keys = "appuser3:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZHv7EnLpujeP8LJxt9BxZbqk70k8izrjJw5aQT+s8trb5gPGd1hmANonjJNr03HQPfyvsAXvzDPNnUmqwxIbS5WyfXMFQz7MaaetDTFDZl0LzXcm4HBnrj5lkEhdR5+wTotdQQw7OFf0sCta0MV5hDQ1x/+4P7ojDn2YcXbsVe1Zsx/HYDXAeGXW43SmIgo6vwTTTtU6HgeNps5fi5jhivQQd9aSG5AKwvm3uzyMce0j9VovUf+j0a/WC0IllWURVUpwozP2/iCtIJ9jhiQsluU9eNcR6RoJaI/ZN3y+u0PGhYY2H5UKfdgfWKjTzPTubOtw2Db+RVsJ8SJ7feyvx appuser3"  
}
}
resource "google_compute_project_metadata" "app_appuser1" {
metadata {
ssh-keys = "appuser1:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNZaLRYqJ7vb3V0UfuorMveOuwRtTjbT4tBkEeDbfNGPHocmTg1sYp9G6Lpx53FjnTderr1/eZdYSGAvmT4t286N/URgqEhh585bXMZ+FX+I5CAiNSYAVBWAYvlDU/r1q8oINK59APxGKk/+suavwrfSKcvA3dxtVNxnfMhGuEWfQL9GbCslzanGZHxoSszIa0iS585pJoKVZL2ffzg8Bg3rFZ6AnK+czQOpBpsd+VFGLz0tbxcWL05srf4TNH4ljbFyLuR9DObVEJ7F/+SfKXf2E1jEoZeMW82u+cYo5lZBzaJt/EQMfEvS3/e/6Pb2dm5JfyBcY9mkKRSRkTKDPB appuser1"
}
}
