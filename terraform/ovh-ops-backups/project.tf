#   -------------------------------------------------------------
#   Terraform :: OVH :: Public cloud :: ops-backups
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Provider:       OVH
#   Target:         OVH public cloud
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Order and create a new public cloud project
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

data "ovh_me" "account" {}

data "ovh_order_cart" "cart" {
  ovh_subsidiary = data.ovh_me.account.ovh_subsidiary
}

data "ovh_order_cart_product_plan" "cart_product_plan" {
  cart_id        = data.ovh_order_cart.cart.id
  price_capacity = "renew"
  product        = "cloud"
  plan_code      = "project.2018"
}

resource "ovh_cloud_project" "nasqueron-ops-backups" {
  description = "Nasqueron :: Operations :: Backups"
  ovh_subsidiary = data.ovh_me.account.ovh_subsidiary

  plan {
    duration     = data.ovh_order_cart_product_plan.cart_product_plan.selected_price.0.duration
    plan_code    = data.ovh_order_cart_product_plan.cart_product_plan.plan_code
    pricing_mode = data.ovh_order_cart_product_plan.cart_product_plan.selected_price.0.pricing_mode

    configuration {
      label = "vrack"
      value = "pn-1250"
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
