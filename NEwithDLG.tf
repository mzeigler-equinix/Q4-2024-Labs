terraform {
  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = "2.6.0"
    }
  }
}

provider "equinix" {
  # Configuration options 
  # Credentials for only Equinix Metal resources 
  auth_token = "my_auth_token"

  client_id = "my_client_id"

  client_secret = "my_client_secret"
}


# Create self configured single Catalyst 8000V (Autonomous Mode) router with license token
# SV Metro 

resource "equinix_network_device" "MZlabSV" {
  name                 = "MZlabSV"
  metro_code           = "SV"
  type_code            = "C8000V"
  self_managed         = true
  byol                 = true
  package_code         = "network-essentials"
  notifications        = ["mzeigler@equinix.com"]
  hostname             = "MZ-SV01"
  account_number       = 1
  version              = "17.09.04a"
  core_count           = 2
  term_length          = 1
  additional_bandwidth = 0
  acl_template_id      = "6ec8552b-aba2-4765-b237-4a1ddc9169b4"

  ssh_key {
    username = "mzeigler"
    key_name = "marcie-test"
  }
}
# Create self configured single Catalyst 800V (Autonomous Mode) router with license token
# DA Metro 

resource "equinix_network_device" "MZlabDA" {
  name                 = "MZlabDA"
  metro_code           = "DA"
  type_code            = "C8000V"
  self_managed         = true
  byol                 = true
  package_code         = "network-essentials"
  notifications        = ["mzeigler@equinix.com"]
  hostname             = "mz-DA01"
  account_number       = 1
  version              = "17.09.04a"
  core_count           = 2
  term_length          = 1
  additional_bandwidth = 0
  acl_template_id      = "6ec8552b-aba2-4765-b237-4a1ddc9169b4"

  ssh_key {
    username = "mzeigler"
    key_name = "marcie-test"
  }
}
resource "equinix_network_device_link" "mzlabdlg" { 
name   = "mzlabdlg"
project_id  = "f1a596ed-d24a-497c-92a8-44e0923cee62"
device { 
id        = equinix_network_device.MZlabSV.uuid
interface_id = 3
}
device {
id       = equinix_network_device.MZlabDA.uuid
interface_id = 3
}
link {
    account_number  =  1
    src_metro_code  = equinix_network_device.MZlabSV.metro_code
    dst_metro_code  = equinix_network_device.MZlabDA.metro_code
    throughput      = "50"
    throughput_unit = "Mbps"
  }
}
