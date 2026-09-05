#   -------------------------------------------------------------
#   Terraform :: OVH :: Public cloud :: ops-backups :: Storage
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Description:    Object storage bucket, clients and prefixes
#   Provider:       OVH + Vault / OpenBao
#   Target:         OVH Public Cloud > Nasqueron :: Operations :: Backups
#                   complector.nasqueron.drake (Vault)
#   -------------------------------------------------------------

locals {
  default_tags = {
    group         = "operations"
    role          = "backup"
    encryption    = "client-side"
    privacy_level = "sensible"
  }

  backup_containers = {
    amaris = {
      container_name = "nasqueron-backups-amaris"
      purpose        = "Main backup container"

      tags = local.default_tags

      # Each server should get access
      # For database servers, prefixes are by cluster.
      clients = {
        windriver = {
          prefixes = [
            "windriver",
          ]
        }

        db-a-001 = {
          prefixes = [
            "db-a",
          ]
        }

        db-b-001 = {
          prefixes = [
            "db-b",
          ]
        }

        dns-001 = {
          prefixes = [
            "dns-001",
          ]
        }

        docker-002 = {
          prefixes = [
            "docker-002",
          ]
        }

        dwellers = {
          prefixes = [
            "dwellers",
          ]
        }

        hervil = {
          prefixes = [
            "hervil",
          ]
        }

        router-001 = {
          prefixes = [
            "router-intranought",
          ]
        }

        router-002 = {
          prefixes = [
            "router-intranought",
          ]
        }

        router-003 = {
          prefixes = [
            "router-intranought",
          ]
        }

        web-001 = {
          prefixes = [
            "web-001",
          ]
        }
      }
    }

    darak = {
      container_name = "nasqueron-backups-darak"
      purpose        = "Dereckson backups"

      tags = merge(local.default_tags, {
        group = "user-dereckson"
      })

      clients = {
        windriver = {
          prefixes = [
            "windriver-home",
          ]
        }
      }
    }

    vakor = {
      container_name = "nasqueron-backups-vakor"
      purpose        = "Vault backups"

      tags = local.default_tags

      clients = {
        complector = {
          prefixes = [
            "complector",
          ]
        }
      }
    }
  }
}
