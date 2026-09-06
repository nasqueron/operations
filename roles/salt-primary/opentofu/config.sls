#   -------------------------------------------------------------
#   Salt — Provision a salt primary server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   ZFS datasets
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if salt["node.has"]("zfs:pool") %}
{% set tank = salt["node.get"]("zfs:pool") %}

{{ tank }}/opt/terraform:
  zfs.filesystem_present:
    - properties:
        mountpoint: /opt/terraform
        compression: lz4
        atime: off
        recordsize: 128K
        xattr: sa

{{ tank }}/opt/terraform.enc:
  zfs.filesystem_present:
    - properties:
        mountpoint: /opt/terraform.enc
        compression: zstd
{% endif %}

#   -------------------------------------------------------------
#   Terraform / OpenTofu non encrypted working directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/opt/terraform:
  file.directory:
    - user: deploy
    - group: ops
    - mode: 770

/opt/terraform/tf-data:
  file.directory:
    - user: deploy
    - group: ops
    - mode: 770

#   -------------------------------------------------------------
#   Terraform / OpenTofu encrypted directory for states
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/opt/terraform.enc:
  file.directory:
    - user: deploy
    - group: ops
    - mode: 770

# Will be mounted from /opt/terraform.enc to /opt/terraform/encrypted
/opt/terraform/encrypted:
  file.directory:
    - user: deploy
    - group: ops
    - mode: 770

#   -------------------------------------------------------------
#   Wrapper for tofu/terraform/pefs commands
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/bin/initialize-pefs:
  file.managed:
    - source: salt://roles/salt-primary/opentofu/files/initialize-pefs.sh
    - mode: 755

/usr/local/bin/tf:
  file.managed:
    - source: salt://roles/salt-primary/opentofu/files/tf.sh
    - mode: 755
