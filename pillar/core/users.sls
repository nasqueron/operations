#   -------------------------------------------------------------
#   Salt — Users accounts list
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-08
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Users accounts
#
#   shellusers:
#     When an account isn't included in a group, this is a no-op.
#     As such, users hereby listed don't have access to any server.
#
#   revokedusers:
#     Users in this list will be removed from the servers.
#
#   To rename an user:
#     Edit the username in the shellusers section,
#     add the former username to the revokedusers list.
#
#   Sort the accounts by their username alphabetic order.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

revokedusers:
  # Account renamed to erol // T808
  - fedai
  # Temporary test account // D608, D609
  - amjtest
  # Account renamed to sandlayth // T789
  - kalix
  # Users who never have connected to Eglide's accounts (SSH key issues)
  - tarik

shellusers:
  adrien:
    fullname: Adrien
    ssh_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID12BxPqs2pqkhJHZOVUzcbp3KlDsWOBWKxdwnjNFP7S adrien@Adrien-Latitude-E6510
    uid: 2029

  akoe:
    fullname: akoe
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCY5PLKcpxx2TbM+gZGK7tiDFrPt9kGe5rwyg2hWbSBI+Qpj0BimxD7XKgqXU08mHLO3R3bfdFbr1QApLvHGKa2DKoj6kJfax8T1uodOcSf6F/q2jlmqnlIX8ezS9ysSHreEFrqjkge5/Z4v4TJd4co2hvF4Kg1H4ZL0wpuDavu20f6YpqmtV9CXHvotYhvwcYQEpykjJrR7mvmm2vGEuMpvcnXlbl3q6FGnhJ4q5u7o9hHoEA+HgEsM8TBAtFkiFS2bGfMOq8ulNyrkB8lMNgqtFf1g5YaCTfHVxbLyl19+KBb6AeReQK71OMWCLdYy/cpoWUq0EyUYNB9QVlVeEUb akoe
    uid: 2024

  alinap:
    fullname: alina-precup
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA3mxUhsVuSdh7sMwKlXgUF1h9Rn/Sstt8V+mhbjRQE/joBL5K6blRzHaDEEBgYpcLexJVh7Z5GlAX7E/RU5UTF/I/fr+EfFue3pJAIGDVncjOGHO5tJGQ+InD/+dA7sPYrksBjnGHWpkilYrFwZXcNQjwacOc3OGOBjWZqnBE/rfPRAt8O/Q6BQgibAr7LeFVLepTengQx2kU0Nd9KJRf0v9NupQfU5l8MftSVKuRbjayXQTW3lg/tOdoAEo17sKuqFkRMXHgUSrjRNLFZ3shzNiXr29aNCausucIYwQ5NYs5j+k+nLVF1a8zx79ZP/zEUMiQ//hzPQMAyIKeVQ08EQ== alinap
    uid: 2031

  amj:
    fullname: Amaury J.
    shell: zsh
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHRDb+9juQM0Dr/lUKwVF0iYid6iZbO8ZFqshxklaIpnzOgKqpkjEE7JhgegDZW+zH+WqlvKXC0ce6KkHAbmCsnu3wdXVkKS2IAfLCa6rQYMXFc8GYU929UMj4LilVCgDi2sXEOSTI6uh2yc8WkVGEOguMt9E7f5za44q+kJGnLJRK/1gu/1eDbCOe/dFfZg7o4hBlMrFcCbb2r+iUevOj92K7jJcYm8x3wmt4FTJbh5/6LJ3lgstLWYmY2jzbxKeJ1ONGg9e1tDNqkKMHcsvMeEyMTdGykYYhEI7tGMoEoxJQIWILpO0h7o8dnxvm6jC7lfBYbZtZttBPBkEsac+RUCX2Zejib0GioOnOXCKSqdk383ZXbyXIHogCn8ya2R/399Fw/40QVTFTvX8A1alSXQUJShA2RgWucPkSaufUKu3uSjGN4pUdtAkuSdcs/78mbQZkGOs29YdVSZIR5TbTld2uPiID6VLu1oLZtoEPvCrr7G5fDv02P7DR7YPKcouMyJwHswWwIQ/WKPawdDNdGEw0Cr8It0dRpI7nNZh79hdlJsqSNa1ezND4qfbm89SlmwpkypaualzvUnxfffW4hpAJp4Y1M7CNkNWLO3mdM1z/5y7vZgIzKURAClCE6h/pJASnZjA/BBxoXg5fgDf+nEGx652GaKIEtyF3PdIoFQ== am@gentam
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCTQ7Tt/wm+eDc6bTbWX2HHQbdMJVS40mlEfit6usDGKb9PUDtV2pn1KumnsevFge3OArnCLDqp0pmIuMy8loMjyyFeMMsrMNvE4i1Zl/xXcss3siwlqzMDozGBpxC3jMielUnm64BMCtnURfFZsIZfnpZoG6jsfLKWUSKJro9SNrxQptnSH5xkvEOF7gZS8HTkEvjE1sgfIEabZrYIIo5nLrz9yxmuiHIOqx1uyhJGw1dr4pJSGAMcYGGOpfy8uOy80+46MUW8ZtpSTspaTiHnUgs7gSPyCThrgdiNjiAj+mAeUKYytQDt5MQxp0FbUvv34bCJ9Q8G7hXVqBaXO7N/wyyiJ2WL8BbfZhoKM0vmn/oaYmomdlWF08YmkJyeqvf0N9/s6gyzjdj7Aqihi/02YiOqdL5m5WZAREiqIGo/HtlpCoShiqtNn545mD+KwanMdJbJp8ALn7yjJJEKpXVCcUaZOPR7kTF4fZ0eUTuVH3SeyCf3z3OpZ55MeGOkjKfVRkHS6FJ9Uhkjxi0K/2apROB/XCtS0Bv3AjOxt7f7HvabmYzx3J/43JLFKK5BkmqTBGUTowKU/40kxbWug1MAnSzbmDEucZ/eu34SE4R2oXarLrflH9kAIZ6+cftMpAAOKd5VVHeVJKnl4MTSU4C67iwsVpVoJ+mQOPHsf5Ekuw== am@debian-am
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0zIEBYPoa9jQLE1+vRv3oMCwn5VM1EpwCb/K5Utqb1+VOpamWEFy3tkJrkppKFxjst+rDl5ztPLKal6LMURuOQhcGmVux+hJM/ucVtzvx/LHJsBmFsZGRJ2Y2cUXwDzedWqvJybzDhLWcuxPSdvIIiv7bTCLLSIatwsGEnDJ1ffSRgkcrXAd8Pu6/ghPAQwkpIv+POB6kvu5mDHcV5xqliMvI3C4pznheFX603WZ4qA2n0sokQ+2bHSDQHZqziGw4vwQc692JauVEHUDoznTGgMlzuiC2f7Aw1q2V9WFPvOifSr+uhTU8DCDlnssSZ/3m7dnh0soFVodju3s2Wpr32fWocyNqay6FDRYQLuFPziGqlQ6wMJE6nDXr+dYTwZm6ktMGp12/Go3KROCr06Q23JSrT5uaQ+UImoU1Y6veejpU34uo1kMQnoV16OsYARa0Aza5S9S8I3evIOGxPGNAsTb+mlylRwqUm7QSpQGpn3ov7fefG4EvH6ytQlZDAou9GyaeVFfhToqQ8cSqyDU4MOLTfILXTB2tjIRnIjs9U0B6Vczv/sZ9rp/614A5mzXapsfhDyx4FieDtVkr/gFNhI1s3f8y5VJcvL7NX2ggeaqq+kfHkIxAwUUjaVCLB+E3LgUeTG5bzz/ErZbRuDqTKpHUaHKinTNoObR9xpz7+w== amj@dwabyam
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCCKtSulhB9uva1RYOtwcLMcO+1V5oGti50OXntqG0OZfEauz/oLTQpt+nkKYNUN6MazL+9ienYQ8ZZPgZbOs9WGh0acxBcPM5Dw5b0ZWEJ8h9Dk2M7P144aeRS/HuHVvc/JyI3+gYHgqWGe5ycEzlrFeegX7/Zr76eaFDQPGMnsJCFZVga24TiSPiEBTuyszq0/emsLJe41zFY4J6Y2kbaWuJYbiAvA0mZAD+g6+ltEa6vdUOF1BI2kTPFeKXc2dCnbaJAz00I437zUGdaU4533iyLHygxLPjAsjxO8q4f163VR7Rd2jibvRUW2EXgVoY1mJjkNwi2XLQCCwgG/6G8IuQaMjPAx0v7bf+vAJ3x+esJtVFNa55sgU7uHWPaRAwtovspCFBpTRIsp6J5f+1WLqWQVBVBZHdR+5PC2H5Zwb5Hq33Jn8ksQoPMCWcbIbjgF78a/B4LgtsJpA2x8cGJi6p1DEKT5bC6ROGMxqPwA8pFgI3+0X5ukZvTMDH7BjiXkbdyCaFfwo7UofRrPHIUyPAYh/XD7rUddc/6rjVBzmkXTeyYvevOOlmTxM5BDJZI/w6Gc2/XQchCDoWT9ttw7VWX19fHaHtx8KE/I8JaSS5hW77Kl3PzWJxewOAcJMh9HNza3jBgqZFTHktPCPUBZbsjD27YWJcYPrhzpQErQ== amj@thinbiam
      - ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAGTsWhz2x/ONqeMupnd0kQi8aJmMSWDmviNwuZY1WeDuggTylFv9hDUxPUQ+gNydZHEmFRs5qTzcM/P9AYK+0CZOwGluJD5Nfd7LsqgxRVTJ1jb71kOHF2ektjW+OJufWGZv1bTJG5SU/bFXzIgxkDVjwitM0OSeKzERe2PKjQ/ydxqjw== amj@debiam
    uid: 2005

  ariel:
    fullname: ariel
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwaTYlLZ90/oQ5tDYDkhI2mHa1L6Vh+zcekCt8D08N7/CrFI5sUVteTwMWw2ytQlWnyT3HVgHb4IS1EPjpjyuqseRcNW0HYsqBk3E36PCBQIqjLZ0nDAeHQtm6T6pXiKC5qUppghwrvDxVYFpF3lFzAzfYMrF7iugk0xRPTHZWm8df7dqIB/6FfbxSD95yQVAlJefxoFWbo3Yn+exEZQvWv6lQYXnjV5DSwMf8tPGDkc2DRjrnR52ZrXPRZFCqc9JGkA/l8QsYtjmqJdnOgq5raOb56aRulJYdP2j//B4lRJJlglMuj8dSZE/j04zub+P2QhfdqeEHmeaTUqbwcnZZw==
    uid: 2021

  axe:
    fullname: axe
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAjrcYXZ2/bfTdxVI1ZMXknB7WJa8uY1RLZ5Vrs2LPRTzBqaXzpY6/Iw5Ibiy8KMbVo/vQtAWrGY00ucHE+swS2VEtWIZc72kSznkL65bKtqHbZa+IqktRUBsg6ay/3Xups0DBfZ1T+SRSiLh0rya1dXd2NyIrvSo5eCxEPqAPm87rOrgC95GRxqlJUZ5ZOjV92K9v6TcTQWn61nGl2DQviAugNGtHGXhq0Xk98lWkLeGhDLedJOqFmHvqGrkSQpEps7ivlh3Mstv49pXqH1dIA7UhnyX5DTR6YjhIKehZnCfsl8wt6FMCs5QMor1giY4ZpUhY2D4ezvzFD2kqbOUvQQ== 2017-06-14
    uid: 2019

  balaji:
    fullname: Balaji Ramasubramanian
    shell: bash
    ssh_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG9mJZLoqSiPgMxChZxkfkqLxjZw/WuqUC1m7jn93jZp Balaji@Balajis-MacBook-Air.local
    uid: 2027

  bogani:
    fullname: bogani
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCW8ca/Agw6GuRTUHJpptRVunNJvqewQLV39uT0JIBiANFawI/SWkCm/dS78I4ELiJ61tpJhWMZuWjh3ebnJP/Zbv0AUAsMlilW1K2lIjgnOxpqkqHNzm5sUAccmUO/U6kRE7B1/t8ndY9fC31QPr13XY1hjCLl3vOM9BIWc6RkB4tU/W60o0hsFPkVFQ1RvOy/+oji1Q6L5Epqzz9pmm39XxlTsnP1+4zrt8NaCvH1oOQI1q4Hg0xYy5PADWj/C+AafvQ3rNy7MkdifdbM9mgEKUZAqpgEjmhjVMRhhjRVv2B3ZeMFqvYbB+h/AqXpT/H0/NIfuPdcXg8pzHtND1X9 rsa-key-20220325
    uid: 2036

  c2c:
    fullname: c2c
    shell: fish
    ssh_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPyoC7ekLYc7nsd1QsgfdEatYw1FC7z92miIdXvx0n8O c2c@ender
    uid: 2012

  chan:
    fullname: Chanel
    ssh_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvDcmKHfTrCBRpjJxYyIELMRknrMpDXfcKDhfXqmB09 chan@Calculon
    uid: 2009

  dereckson:
    fullname: Sebastien Santoro
    shell: zsh
    ssh_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINgiReRjBvGGZ7QZC9ATJ2UIWAd9yH0Is7Xqz1kG1QQt windriver.nasqueron.org
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBzD5VzetMFTUHLWrLyBsnZ6bdwDa4Ip9WWAh5nLxKyR ysul.nasqueron.org

      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFGIYBdz8pW4vaSyA/QPlcU81uLI8SHoq7I+K6FPO9oh graywell.dereckson.drake
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIURiX8gBIv91sxutRQeESip7Ympmqe6miepoNDvXpZ9 orin.dereckson.drake
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGV4p25jLQQHLgKH1SawoNLKuxkfyHuERRDUN9QZ7i5m yakin.dereckson.drake
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEVY2Oeppn//0Jm4W3ejLDe+D/+4FMFZR9rzeVrnFkPE yakin.dereckson.drake

      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHhtNG5Nc1R6XDgqcwWow/JVB2d9nMqQfNI5cDA99gLS work-laptop

      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAhXyFekC8WTIn6qjguB813I79aJ6uLpu47Z8vX22ipc yggdrasil-20220419

      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIImalLypfV9TtSeAymY8C2pOOCfNtCRI51RZ+jGdIf3Z whiteraven.dereckson.drake
    yubico_keys:
      - ccccccbjncrt
    devserver_tasks:
      - deploy_dotfiles
      - deploy_nanotab
      - install_rustup
      - install_diesel
    everywhere_tasks:
      - deploy_dotfiles
    uid: 5001

  dorianwinty:
    fullname: Dorian Winty
    shell: zsh
    ssh_keys_by_forest:
      nasqueron-dev: &dorianwintyDefault
        - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG04iMvqgusA7/3x+RlFCtZXhUEBMzNN58XIujnuO+Us dorianwinty@Portable_NasqUser
        - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJTy1gvUMYwagFoj23dh04oIBYJKYHe6BkcUJ4j0i8nb dorianwinty@Tour_NasqUser
      eglide: *dorianwintyDefault
      nasqueron-dev-docker: *dorianwintyDefault
      nasqueron-infra:
        - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJvsKoZ8zu6epX/t+5f376OMFjSEphnVkfIslORK7HWk dorianwinty@Portable_NasqOPS
        - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIATc5qI/lUp8JfEyqOJOrOy6rGd3hJUgrB1TEL01cVuY dorianwinty@Tour_NasqOPS
    uid: 2035

  erol:
    fullname: Erol Unutmaz
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdHrSRJGwaGFTpoZIvkoWTMpnXgke77emVicMT8b37kcUepeD91pA3UPQ7UOEQl/Af3Ly7ePneymZ6NjAkM06oPeIjxE6Nz+i6p7rVIZhCb9qz+hdKgt4wSEQLWponegFNdCUs6HvMjDGlsI0kajHgIakXiKAwNyxhQzpBoGranO9c2PdAq2HGq7Kcq8ApC1kdKG0W3dT4PWborzmt1jWna2yosEn+TTHj5wi2p/E9BsCbmfokBO3xn491lr1P4shh4zg7Mv3SPD3j4/mZb9EMwD8cl4y9ZIoMEbL8p4s8J7Joqs3gK9hmMN5ZCNUFrNrJu3TCRZre2k7cV3+U3IXT erol@fedai
    uid: 2002

  fauve:
    fullname: Fauve
    shell: zsh
    ssh_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILQAhf4Du37UglM/hh9ZW2HCq3VtMfj+bgnbjvcIEwo0 fove48@OperateurNoir
      - ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBABsfXPdhHqjAL7AOSCymUZU/7jXL95mfU+HeFuelF+Re+T35u6Qe5KSzQ1iT7lhLafGt6ARQgVvflQ1OgtvhlLhwwDb7MUNbThyr5SNbHfkZpDBGY5sNZfMPJLsYWvKXkxJ5ev8rxcCmER+g3qUAf5oKCDKY3cyODDAhMGKl1POemiaDQ== fauve@CrepusculeEcarlate
    uid: 2030

  fluo:
    fullname: fluo
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCf9bNQ8yL9Ej/RTA6QSD6iqSK89kVUcaR8KF6P4cc516we9VuEardtCvd9juOO5f2LwFW08qkxj7mgC180ue7unEK1C228gyyupQk3sPKgAaeBm1o2HWz6x2B86HxZj0vh6K228KMZkHHOGE9NThmfa29flqW6aOvElh9lyv13ki5Kw2dN5dg3i/SU2FmJrj2oDbv837ezkeVM7wczfy+ZVvh5/3G+RVLJVoL68E/m/9SjuX+zzUtWqCG9c/eb5eab36LD/LijIVn1rpN3179f8uh2jV8gFEc+NegPtk9rx/da3WWh/qH/UzIEJ4MvkvaGIud3qGXM5RxAEuSa/VnB mobile
    uid: 2034

  harshcrop:
    fullname: Harsh Shah
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1ANaxVViiL8s2KTdb+p4FWBBZjXz3zH9/es0SSLuXzCjcs1opEeMeb4roQWWgxrZ3j0aOJAj0smSP1THtrwW1xUE5DidmueuqokgbQuvkrsvcDaJYbNjUr/3fAw7/JcWgh4lSSxCLgflpjBr5aTlMQZj/KPrGnlzjr/hPvb8cAomS2HD+hLuC2z26cvOhY811scTZWMoBrxSkmrXOTkutRdZm+TrYJyZy7xQ9ncfsARYzrOZ4be+0mfb6i4tJfMbBvadSu/gyJdOLCfV5SxdjpMLPqIXO9hWkRKYH8SFX5ZWVw8C06iJWcnFCIw1YMTFYe1MNqV8YICiYUmJ2CWaL harshcrop@Harshs-MacBook-Pro.local
    uid: 2020

  hlp:
    fullname: hlp
    ssh_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIP+04Jhq2toJ+RLx41NKrtDGgmSCfOsAY/BnJ6EzNXC hlp@sonny
    uid: 2018

  inidal:
    fullname: inidal
    ssh_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOm2usb7qaeD25nokB/PdEFqnNab9HOHQqR7qDvaNrB inidal@exia
    uid: 2032

  kazuya:
    fullname: Kazuya
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtCcRQ6HVKD5mj602UJkpI/TMGVt1R0yYx1HxP6SWJb6FM2E4wzkxtf0sp2cxW/9Lz/0OsQV8fSSo/qfUhQXfRcL+rxsM+iixD0WMffMC8CrqsYS+VV32HR2sIm8J7yyMweJrfYneErdFisGmMgOFw8vBGX01XfdwGqbSflf3Tal7L3R0g65rclGsg7JckWE6RQMXnvGwXQxv4QahaNtZK74AlyeFgsXYlv14UeaGE4Pz+rkgZKoC4tvAOBQMNxWtCPMcydJOacoCZO7Jcxv0jMUo0y26mulQ6vbz5hqAPS612c47gh8VNDDkQaznQMeiSyIlnvDEkHmzvC8Z3UAeJ eglide
    uid: 2004

  khmerboy:
    fullname: khmerboy
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAxg4+y6QxyyeHvmcWHy5Q9pjh8YBNC+Q1w3+QHWH/7WKw9odKHgtpu2hixfOeZl5k/E9+XPw2oGmQzs3pInz/yyegGB57kb3xAftqJkHVuBKsrz+7q3fPjnoqk3VZ62k5II3oqEEjizdVhEVacU+149m3LJWo+FKoRAKxlX39KwEM+UMDfynck7OJvKRWTTP/cbPzR7kaMifQLWZF6stFilRnYBAesK2DzLgO37DovwxmQO1CbBuitgsHwLDXGW0gePyC39REIrntZSte1xdlEfC27rQnXcH3YPcTm9bwNBXnK1Jiwfp3fJ6q6FIz9IaybhO6CGNOOODHN4R4DTbbfQ== rsa-key-20170922
    uid: 2023

  kumkum:
    fullname: Kumkum
    ssh_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJnCIiESqqsGOhaS16jwboLplQIP0FwKMhk0oRF7EP55 kumkum@kumkum-E200HA
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGDjGAJrUHKDTNnd6fpypm2A09lScdK6jAA4w5BRQZvx mobile
    uid: 2008

  pkuz:
    fullname: PK of UZ
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+UZbXGwJ7OqxiwsQiTCbL13Vtia1dCPcj7OhiDOzvKGE376Ua2ZB3bNCl3LzPCvyKbNeYyglZe2lrab2e99GkNvdf8e2H2bvoubnB75ZGjz9IZenzz2YahLb7NyLq3kfKLYW8Yff9HqENJbVQCOouAZhP6yXR4fvoHQ+/bdxbHwtoMeetfQH9n5nywqtt0X0Se1qiSbGKLAO+59KRM+D3K4NMBgpkmEbnU1tVi6Bf8ti5Nie5vKKhHw5WGR8FTsuffE9WjbZcxWQvLnhPOu2Rbl3G5lLm8p68VWY9zZscIbcB6uhF8mKH2qazu95T2RJxEBCwFLLG9v6EHORtAWNL pkuz
    uid: 2022

  rama:
    fullname: Rama
    ssh_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIADXRCZ9fFZJAJLOF0PakwhuU9b5Ne4PPr7ESwJzYndn
    uid: 2013

  rashk0:
    fullname: Rashk0
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNr1VcyT8cSDsylMn4zHmfD4ulLbCM8gK+2GrXwlidMNX5pWOs3svSRbF62r9s8jGILzCGc/dOsYFxsX2CI378Io1ybBZsV2PpkBpjnAHSTHCSD5qbrzPWFoOyn7YLUXzKZ64Jss5Mb3x0SCTD0BNJ1xmNI+OCZNOtkw7yeXHgwCKOGVwiCViNsYt7j1N0st4tUMpFv5OPohs2f+AEKjDPsLODfzMR0MrFRSItmqPmE1er/noPFtHH4GOvyiENZeERClkeiM6XrLtQi+awD0Chf8c2++4BfNNwRrIkJuMkQ78kT0uU7vVO3WlcLdyv0Tokgc79CJ89yqnH4+tS/jzx campari@Alpha
    uid: 2003

  ringa:
    fullname: Ringa
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAiTobf2i/IveVlpdntX9M6p9rOe60HuODq5FslTIFxA/RwKQbJKafCQZ3ci+Pt9BKAKtBGSJANNfbxxN7VRB+iO6UZUh2Qjb012CfigC5g1r9MEryqh8LBP27NqTkCqjMZrwUa6pYMBG1/ydbOA0BIr3C72QfpXC/qCSvXNgQzL7DGSR7cgjhGvMDn5ewJuxsvXAcajMLEORxeYooONG9ELGRUMFI4WcX6gmiYcrMVsMF+7ByshIngV5v9esWadi+RdTWUVOYt2yVS7hkYHZwUX/bN1AOfkRiuD1w3DFFiHhSoquCwaOOZjKxAw6VOrV6O/toLGe0kXXfRFzeB29/1w== rsa-key-20170111
    uid: 2010

  rix:
    fullname: Rix
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAjFnOi4rwBVdw69U9y1xgWXrfNNgxEXAmbXthzHae07COwN190xoWv8VeogKxfMdxE2Tj4E0BDFt2i7Jbk9BploFdNXG46lrnoszmgRsuRx5jERfvMyOPvCAQHbL0N53AL6zH9wXF/51a5bJJ3n4wkmO1nDj9WqrDNk0in+knICiPHQX4TxwRXqBuf61gQMxwy8Aoy1WCCfCeAesZxjdFM47C6X3PPHVaXvF6x6iX8OzIHqoVT18yQAQxbET+PWMtlmNFJFx76+Sov4eQm/d2KeRg0aqw49gKLpigYnHfd2uitmSQixBNl5jyvDMoR92vZmZnScmqA9cXQikQ9HCW6Q== rsa-key-20170110
    uid: 2007

  sandlayth:
    fullname: Yassine Hadj Messaoud
    ssh_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL4H4SF3NZ0/o5uTYhIUKUEzP7hlZ0mGqMxs6wt/dhQs kalix@arch-laptop
    uid: 5002

  shark:
    fullname: Shark
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAjKehL1PdhcpLNiGdWLuVCUpNawUhQoxon3nmhZm/B+oU2nwygqvx9YU3LFzTEDNXWtU0aH2UVgC5bkRyVdmVKjX878luoluYwhKJFrYoEd9zS+EPDNmNYSoKntDbZoB17iacVEUM4Kg3RAzwStw3L8OO9DlB9NdXUzS8/9wlSy43ddoRRy83FvnvhRNXWScUIQyBolxqyoVvXdLZ2t0PnCdU3Bz2Wkcg24XjwDOR0R0A3780b+VGcsjXtjYxK6xCpNo9l2DqLAfpw+BFusWy6au5U15vfHgR91Lbcd1xtfvJAElI97fR6DGf+HSrtYZe+9gMU1nofibdiNWSJ/Vn+Q== rsa-key-20161212
    uid: 2006

  thrx:
    fullname: ThrX
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAqm65UgRA1ZJaGnam+PQiFmXKOKZHAUc5jN8zRQsAaFv5Kgxks857DPBX8eO7Wolh70C/UVXAqYgHS2yg74KKKzyjv2vd/de4vQuC4m24IRWkuGJ6xr+dgqNRMn3YklJ2W/SzMCLIFNWUlM3JnvIPElxrLVMSm9ZCACAvWGgy8uF+vBkJYsmfN5AokyzSZcAUqREBbnsC33erGz50it4Oxn4QpAGWtYBHz+kHz89rZBMbMRAoMyQ1EfnzH076jtufHuTdqibmQRB39GbY8bgJJk0tpntwTvx4pHAnMK6CUwbjtFU03LByYNiIzDjwHXqfwuQZl8WlQjx7oTVNHCJ9fw== rsa-key-20170221
    uid: 2014

  tomjerr:
    fullname: Tommy Aditya
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7WGzb6h6i8H81nkw0E2PvFwi1yqODeltyGwFQxEwL4+bc75LlbxtpIsxS+D4vkervfGjMwgAJSFOv6uimRhubmp1I2Pf85APTf/a9xXmNzAuNnhR8ur93I08cQ2kKlY19q3EX4H4qj2HizRZxgusG8dYyBWuKuq6P7vIn5zn55IzFJKxCekydAjQsDUTOaio5brLD3sY8IfnWtKWDgrszozUOEqZdquJDS6LBEHHDTpWK/Mzuwd6YkpfdG2GVLwuN6Rj43jNoxcvk2W7oJyJQQ7xSpNR3QIFzTAu9VL9AAv4qak4o2AYpmg8HXsgGR2ARvJ0mFzWw8qy/c/5plPgp tomjerr
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwWJfo9s+Uqd/JPIYFEYJ3g/H9G9wPActHXJfKul/ImK7oTFqDADGx0pr26aL7tcjVIK7vK1EF41f2JhphjsiUj9H1y38qIWGdHHVJg/NBsA2ZRmIWtBi4G5TkV/0y8lPwBjLwFMh55C1HDFLgw9CG8fujuYFqmyFc/CmH+W4ffm31LX70zC1m/ApgWXjbKDfO1tm7fP2JdkzsWe+Rce5SQb/w+ieyymG9uJgkfOkG04TXA27uAffYTZ2nPBdz00x62u6Sxc8n1muE1k/3ofyOv5tMXMv4VYs//8kWWuRhfGLM/t7lO5HR5V+P7f8WkMDzcG72EyYqJOIep6uRoiSz tomjerr
    uid: 2001

  vigilant:
    fullname: Anser Quraishi
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDXWSDaKgPYpbH2pz7Ohrt3ryzHSQyM6kPjjkJPPkFKmVamDq4+kVnR9ukXn5jD+WolvRlyhzBOhXk8wMiZ1zq3mTplYEXQDEMjr9LmFXSXt3odgbwXCjvyewAeXQvDhcGyoqh5txneEeBFQJNFaQ/YhNEYr27RLl46jGareM3GibAC/eudnOsxnyf6Rg+IA/2GrXj8r3d9p/Yxu/IhETiFltSQycrdrblEQ424zUNaUNtpDRoukZTnFqT/78KWpLgFQCYWWA/YXRRn86f6stA5bkyM8FXeUEi0a26M/9OEj3z9mWSw7zvTd+0tYlQ4B+4yS5ks/NvxaVUjY6eWIsNUOARnt7u2Qx6XPoijL1ywvyh/myWZkARjekl0ZqbhXWxYffIqYUG/91bE6qKlWJaf6gUnRdA3OSLz2iVqQAXkPzqmmcrASqD9bki8m9VbL1K94Vv0Bj+CUgyOCslDru7DULHlNBFkzKbuaE/BeuUxG3BbhMHHYDFaFcd7/kOUwik=
    uid: 2025

  xcombelle:
    fullname: Xavier Combelle
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9KJQDTtuxGCOaeFtip+yel45zMNS4tvrYg0AzNhT22K8g3F8wiY1GKvYw6Czj8Zo+rqA5/Rt7BCQwNtZyI+Nh23Cvg5wZQ2A6dtzQI69HZVSi+FRA5o4/SG4wyp7AT6wuWn+7tTE/pH69D0keDmaNpLSzhkxKFQd2DuOD2BENobEIE9DzbRf2DeUJ15uCzX/mnEXykklYvQ5AontiwL7VNB1VpNebrfnecAaAua0RhuYp+XwxBaSM4KB4lIA6hTBYEOG6J3TaC3GofMtAANI/n8gcCQkadkqtQHrap2Wh9X6bzekwROVGui1TW6sM7+hS4P7PM80nK05iVnGzIfYR xavier.combelle@gmail.com
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwWF3cUmuc8CTt4/6z+wNtMld2MG4f0CAuAqYvOEfMHpJ1w7ufVvKTHRqxiWihqf+DYSoCDjvnZ32xOr0i+g38tsq9wRV6BTfT2L209K2cn/VfKOLeK4v6ZybVn7I2l9SKduk3KuzHqjQpI5DV5x9317lz5BgEh7ur1oiMdQbbLE4O81fKe1REVD+EvT6/0dYU0mNPY/bEk6AHLxo86yMEU0eaFgJWUAxrRTLMQ0gd+a4GpJ59MhyPO4zzD8YJ6TWQOD4UQRNjzVKU7LE3RoelDcEuTU+pZ72rKQh6ZOPr0D33o9qWIaQ1Ak4MwPPs6252s+hqHzjacvf73a824CDv
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOirrO7Mdgi+HVSSD1EaK0hx/nSKoseyIatvLb02/ouu Termius
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtzoAxYsC1O3Hw7a/JgHRa92pxWYS+L4+vc+A1FWUEj xavie@LAPTOP-6UJB32E3
    uid: 2017

  xray:
    fullname: xray
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAzSj3sQYbrBBdceBRUAbuzCS9vZWycVV0OSZ0ofoWx/dOTIalhc3O+aett7J34GqwDgpcTEkEpa/MrlO/2TOGOFIsPlvbZW4fXXFADCbOWkRRNuYW5rv/Sg6ZliGtw4cj0dKEkn9+L/JAuGwKV5KJNTPcp5w8hZyQYczZ8KhcyNVv7mfzLnId03wPnuTTe+AmCTOitbVb3gxjdXDYeS46PkbV8m/23KpcdLigo3ClDwE/SIoA+YddaAbpWDMEwhnWyKmLGI6xkFcqSY1NT0eYnL2waZMEnfluxt+D0V0IT5NeOmQcTuVWPvjFdSKbKepPhdrFmzGNtytfZWoFOPiG+Q== rsa-key-20170119
    uid: 2011

  whoami:
    fullname: whoami
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAi1xD6FNf+w9kOjLJU6yd6bt7T8t3q7WXBewpkqRk4eBdJhomyjiNWuspke8STOf0VGamoPqLfxr4wbDa3UfgfBOBITgscwR26hOjtJ8Wra7XfIJU3OH/GBlUBfvf1T/m0fZDY2fKVku4R73pClQ2UhoUxJsU8/PVdEnN88IWAUeUbFgjtRds2SKPgCd/sg6XvoIEuYo8hbkmzVY+vIlrACuCEXjnRF+30lSMluo6OvMYHulfiZk7TPzXrX0YZ+3vFHscgwiwV6PL7qnQvnzwqEF2SfQduyg+vnOC//X7fezU0CfDzdbDG1tj1CftSrLoejMmU8wTDllq7Rrux/lu9w== rsa-key-20200207
    uid: 2033

  windu:
    fullname: Windu
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAigDNiN5GS+HeFrynIaW62kAHdt8EWbsCbIVCKRWM10/JiJiTJt41uezCj4i4JiIjgdemZxBXSdBpKKEkUHpfZ9B+0+a3aWxcAzdnwtsjiv8Pju2GkYmwY5ecBVipnW5ojPj1DyJaTGYJSI2wUXGUSOTn29Xh2lSm+Fm2VFq8MGw/nuDtyzWhub1TPpIwz4kFyZPh6t/avzskYdyo/amkPX3KsT3oearJLB4ZINj3fzTWUPr3vMM4W23Y3dzS5ekMZFL+T+51dCJl6eyXJ6jk4R+JnrRlT8e5mH6C5F6useHFVb/Nfi9zKbEsZG7Tqxs4MF+7dlI/Cmj1POe/P1FaMQ== rsa-key-20180130
    uid: 2026
