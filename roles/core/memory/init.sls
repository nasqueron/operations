#   -------------------------------------------------------------
#   Salt — Memory configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-02-12
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Provide SWAP
#
#   Some servers can't be set up without any swap, especially
#   on Scaleway infrastructure. As a fallback, we can create
#   a swap file in such cases.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set swap_size = 8 * 1024 %}

{% if grains['swap_total'] == 0 %}

create_swap_file:
  cmd.run:
    # dd is here used, as fallocate compatibility with XFS and ext4
    # hasn't been verified.
    - name: dd if=/dev/zero of=/swapfile bs=1MiB count={{ swap_size }}
    - creates: /swapfile

secure_swap_file:
   file.managed:
     - name: /swapfile
     - mode: 600
     - replace: False

enable_swap_file:
  cmd.run:
    - name: |
        mkswap /swapfile
        swapon /swapfile
        touch /etc/.swap-enabled
    - creates: /etc/.swap-enabled

configure_fstab_for_swap_file:
  file.append:
    - name: /etc/fstab
    - text: /swapfile none swap sw 0 0

{% endif %}
