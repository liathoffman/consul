##################################################################################
# OUTPUT
##################################################################################

output "dns-of-consul-servers" {
  value = ["${aws_instance.consul.*.public_dns}"]
}

output "dns-of-webserver" {
  value = ["${aws_instance.nginx.*.public_dns}"]
}