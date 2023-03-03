TOKEN=$(cat ~/do_token)
droplet_name="bootcamp-9"

curl -X POST -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer '$TOKEN'' \
    -d '{"name":"'$droplet_name'",
        "size":"s-4vcpu-8gb",
        "region":"fra1",
        "image":"ubuntu-22-10-x64",
        "vpc_uuid":"f265ac76-f85c-4c38-867f-0d79fecaec30",
        "ssh_keys":[36871863],
	"user_data":"'"$(cat entrypoint.sh)"'"}' \
    "https://api.digitalocean.com/v2/droplets"
firewall_id=$(curl -X GET -H "Content-Type: application/json"   -H "Authorization: Bearer $TOKEN"   "https://api.digitalocean.com/v2/firewalls" | jq -c '.firewalls[] | select( .name == "test-vm-firewallrules" )' | jq -r '.id')

droplet_id=$(curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN"   "https://api.digitalocean.com/v2/droplets" | jq -c '.droplets[] | select( .name == "'$droplet_name'" )' | jq -r '.id')
payload='{"droplet_ids":['$droplet_id']}'

curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d $payload \
  "https://api.digitalocean.com/v2/firewalls/$firewall_id/droplets"
