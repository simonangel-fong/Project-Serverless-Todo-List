# ########################################
# Cloudflare
# ########################################

resource "cloudflare_record" "cf_record" {
  zone_id = "ceed00499bed9aba313f36acf8100262"
  name    = "api.arguswatcher.net"
  content = "d-qgu2d1yaqk.execute-api.ca-central-1.amazonaws.com"
  type    = "CNAME"

  ttl     = 1
  proxied = true
}
