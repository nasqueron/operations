#   -------------------------------------------------------------
#   Salt — Kubernetes
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-09-21
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

# Kubelet requires swap to be disabled

disable_swap_in_fstab:
  mount.fstab_absent:
    - name: swap
    - fs_file: swap
    - mount_by: uuid

disable_swap_at_runtime:
  cmd.run:
    - name: swapoff -a
    - onchanges:
      - mount: disable_swap_in_fstab
