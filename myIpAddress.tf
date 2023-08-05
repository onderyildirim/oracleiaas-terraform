#retrieve my ip address to add into ip_rules for storage firewall
data "http" "myIpAddress" {
  url = "https://ipv4.icanhazip.com"
}
