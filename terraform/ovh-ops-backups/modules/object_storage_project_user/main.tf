#   -------------------------------------------------------------
#   Terraform :: OVH :: Public cloud :: ops-backups :: Project user
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        BSD-2-Clause
#   Description:    Create user with access to object storage container
#                   for backups in specified prefix.
#   Provider:       OVH
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Project user
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

resource "ovh_cloud_project_user" "user" {
  service_name = var.service_name
  description  = var.description
}

resource "ovh_cloud_project_user_s3_credential" "s3_credentials" {
  service_name = var.service_name
  user_id      = ovh_cloud_project_user.user.id
}

#   -------------------------------------------------------------
#   Policy for the user
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

locals {
  # Normalize prefixes: remove leading/trailing slashes, ignore empty values.
  normalized_prefixes = distinct([
    for p in var.prefixes : trim(p, "/")
    if trim(p, "/") != ""
  ])

  # Values accepted by the s3:prefix condition.
  #
  # We allow:
  #   prefix
  #   prefix/
  #   prefix/*
  #
  # This is useful because S3 clients may list with different prefix forms.
  list_prefixes = distinct(flatten([
    for p in local.normalized_prefixes : [
      p,
      "${p}/",
      "${p}/*"
    ]
  ]))

  # Object-level resources.
  #
  # Allow both:
  #   arn:aws:s3:::container/prefix
  #   arn:aws:s3:::container/prefix/*
  #
  # The first one is not always required, but it makes the policy more robust
  # if a client ever writes an object exactly named after the prefix.
  object_resources = distinct(flatten([
    for p in local.normalized_prefixes : [
      "arn:aws:s3:::${var.container_name}/${p}",
      "arn:aws:s3:::${var.container_name}/${p}/*"
    ]
  ]))

  policy = jsonencode({
    Statement = [
      {
        Sid    = "ListOwnPrefixOnly"
        Effect = "Allow"

        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:ListBucketMultipartUploads"
        ]

        Resource = [
          "arn:aws:s3:::${var.container_name}"
        ]

        Condition = {
          StringLike = {
            "s3:prefix" = local.list_prefixes
          }
        }
      },

      {
        Sid    = "ReadWriteOwnPrefixOnly"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts"
        ]

        Resource = local.object_resources
      }
    ]
  })
}

resource "ovh_cloud_project_user_s3_policy" "policy" {
  service_name = var.service_name
  user_id      = ovh_cloud_project_user.user.id

  policy = local.policy
}
