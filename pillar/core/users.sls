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
  akoe:
    fullname: akoe
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCnHqvG6y/6houv8onS4phfqmg5hlVaAbQxg6tcRRD/HF09Pdt5cHQEA793PqcNcxMIfIMuz8KoqVnwh7ixaSsn6buaTxckDkOzhZCT6uubFCyCKhkkP69xp+HyhlaHEPVIWShQ/nzudTnFmICJsUXt10+bb3oh3gjJHJXOxRaJBAUTFCCuIZxpfERmF+w7wnPxcE9FHGiur/b9Sh3Z/Mhlpnkpp4kqF4/E7A1OGKDrxEKCQdQNjClUCeVyREgaIdxhCY4j/FwSKyfpq7omR5Cldj74+VBsl7bm7HvVJfiN3jJwc7mp1Hs2nrRk2Adm1n43F4f2sYG61Eoy/51QZAAD akoe
    uid: 2024
  amj:
    fullname: Amaury J.
    shell: zsh
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHRDb+9juQM0Dr/lUKwVF0iYid6iZbO8ZFqshxklaIpnzOgKqpkjEE7JhgegDZW+zH+WqlvKXC0ce6KkHAbmCsnu3wdXVkKS2IAfLCa6rQYMXFc8GYU929UMj4LilVCgDi2sXEOSTI6uh2yc8WkVGEOguMt9E7f5za44q+kJGnLJRK/1gu/1eDbCOe/dFfZg7o4hBlMrFcCbb2r+iUevOj92K7jJcYm8x3wmt4FTJbh5/6LJ3lgstLWYmY2jzbxKeJ1ONGg9e1tDNqkKMHcsvMeEyMTdGykYYhEI7tGMoEoxJQIWILpO0h7o8dnxvm6jC7lfBYbZtZttBPBkEsac+RUCX2Zejib0GioOnOXCKSqdk383ZXbyXIHogCn8ya2R/399Fw/40QVTFTvX8A1alSXQUJShA2RgWucPkSaufUKu3uSjGN4pUdtAkuSdcs/78mbQZkGOs29YdVSZIR5TbTld2uPiID6VLu1oLZtoEPvCrr7G5fDv02P7DR7YPKcouMyJwHswWwIQ/WKPawdDNdGEw0Cr8It0dRpI7nNZh79hdlJsqSNa1ezND4qfbm89SlmwpkypaualzvUnxfffW4hpAJp4Y1M7CNkNWLO3mdM1z/5y7vZgIzKURAClCE6h/pJASnZjA/BBxoXg5fgDf+nEGx652GaKIEtyF3PdIoFQ== am@gentam
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCTQ7Tt/wm+eDc6bTbWX2HHQbdMJVS40mlEfit6usDGKb9PUDtV2pn1KumnsevFge3OArnCLDqp0pmIuMy8loMjyyFeMMsrMNvE4i1Zl/xXcss3siwlqzMDozGBpxC3jMielUnm64BMCtnURfFZsIZfnpZoG6jsfLKWUSKJro9SNrxQptnSH5xkvEOF7gZS8HTkEvjE1sgfIEabZrYIIo5nLrz9yxmuiHIOqx1uyhJGw1dr4pJSGAMcYGGOpfy8uOy80+46MUW8ZtpSTspaTiHnUgs7gSPyCThrgdiNjiAj+mAeUKYytQDt5MQxp0FbUvv34bCJ9Q8G7hXVqBaXO7N/wyyiJ2WL8BbfZhoKM0vmn/oaYmomdlWF08YmkJyeqvf0N9/s6gyzjdj7Aqihi/02YiOqdL5m5WZAREiqIGo/HtlpCoShiqtNn545mD+KwanMdJbJp8ALn7yjJJEKpXVCcUaZOPR7kTF4fZ0eUTuVH3SeyCf3z3OpZ55MeGOkjKfVRkHS6FJ9Uhkjxi0K/2apROB/XCtS0Bv3AjOxt7f7HvabmYzx3J/43JLFKK5BkmqTBGUTowKU/40kxbWug1MAnSzbmDEucZ/eu34SE4R2oXarLrflH9kAIZ6+cftMpAAOKd5VVHeVJKnl4MTSU4C67iwsVpVoJ+mQOPHsf5Ekuw== am@debian-am
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0zIEBYPoa9jQLE1+vRv3oMCwn5VM1EpwCb/K5Utqb1+VOpamWEFy3tkJrkppKFxjst+rDl5ztPLKal6LMURuOQhcGmVux+hJM/ucVtzvx/LHJsBmFsZGRJ2Y2cUXwDzedWqvJybzDhLWcuxPSdvIIiv7bTCLLSIatwsGEnDJ1ffSRgkcrXAd8Pu6/ghPAQwkpIv+POB6kvu5mDHcV5xqliMvI3C4pznheFX603WZ4qA2n0sokQ+2bHSDQHZqziGw4vwQc692JauVEHUDoznTGgMlzuiC2f7Aw1q2V9WFPvOifSr+uhTU8DCDlnssSZ/3m7dnh0soFVodju3s2Wpr32fWocyNqay6FDRYQLuFPziGqlQ6wMJE6nDXr+dYTwZm6ktMGp12/Go3KROCr06Q23JSrT5uaQ+UImoU1Y6veejpU34uo1kMQnoV16OsYARa0Aza5S9S8I3evIOGxPGNAsTb+mlylRwqUm7QSpQGpn3ov7fefG4EvH6ytQlZDAou9GyaeVFfhToqQ8cSqyDU4MOLTfILXTB2tjIRnIjs9U0B6Vczv/sZ9rp/614A5mzXapsfhDyx4FieDtVkr/gFNhI1s3f8y5VJcvL7NX2ggeaqq+kfHkIxAwUUjaVCLB+E3LgUeTG5bzz/ErZbRuDqTKpHUaHKinTNoObR9xpz7+w== amj@dwabyam
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCCKtSulhB9uva1RYOtwcLMcO+1V5oGti50OXntqG0OZfEauz/oLTQpt+nkKYNUN6MazL+9ienYQ8ZZPgZbOs9WGh0acxBcPM5Dw5b0ZWEJ8h9Dk2M7P144aeRS/HuHVvc/JyI3+gYHgqWGe5ycEzlrFeegX7/Zr76eaFDQPGMnsJCFZVga24TiSPiEBTuyszq0/emsLJe41zFY4J6Y2kbaWuJYbiAvA0mZAD+g6+ltEa6vdUOF1BI2kTPFeKXc2dCnbaJAz00I437zUGdaU4533iyLHygxLPjAsjxO8q4f163VR7Rd2jibvRUW2EXgVoY1mJjkNwi2XLQCCwgG/6G8IuQaMjPAx0v7bf+vAJ3x+esJtVFNa55sgU7uHWPaRAwtovspCFBpTRIsp6J5f+1WLqWQVBVBZHdR+5PC2H5Zwb5Hq33Jn8ksQoPMCWcbIbjgF78a/B4LgtsJpA2x8cGJi6p1DEKT5bC6ROGMxqPwA8pFgI3+0X5ukZvTMDH7BjiXkbdyCaFfwo7UofRrPHIUyPAYh/XD7rUddc/6rjVBzmkXTeyYvevOOlmTxM5BDJZI/w6Gc2/XQchCDoWT9ttw7VWX19fHaHtx8KE/I8JaSS5hW77Kl3PzWJxewOAcJMh9HNza3jBgqZFTHktPCPUBZbsjD27YWJcYPrhzpQErQ== amj@thinbiam
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
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBzD5VzetMFTUHLWrLyBsnZ6bdwDa4Ip9WWAh5nLxKyR dereckson@ysul.nasqueron.org
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIURiX8gBIv91sxutRQeESip7Ympmqe6miepoNDvXpZ9 dereckson@orin.dereckson.drake
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFGIYBdz8pW4vaSyA/QPlcU81uLI8SHoq7I+K6FPO9oh dereckson@graywell.dereckson.drake
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGV4p25jLQQHLgKH1SawoNLKuxkfyHuERRDUN9QZ7i5m dereckson@yakin.dereckson.drake
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHN4kIcBjQuVqwaTjH9/Y2g9zghh/zjzQH2QipMdzhRQ dereckson@xyrogh.dereckson.drake
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEVY2Oeppn//0Jm4W3ejLDe+D/+4FMFZR9rzeVrnFkPE dereckson@yakin.dereckson.drake
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB9u1AFDK0mo7bDQZAiV9AXXdxUiH8H1B0rLY8NIP8/f phone
    yubico_keys:
      - ccccccbjncrt
    deploy_dotfiles_to_devserver: True
    uid: 5001
  erol:
    fullname: Erol Unutmaz
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdHrSRJGwaGFTpoZIvkoWTMpnXgke77emVicMT8b37kcUepeD91pA3UPQ7UOEQl/Af3Ly7ePneymZ6NjAkM06oPeIjxE6Nz+i6p7rVIZhCb9qz+hdKgt4wSEQLWponegFNdCUs6HvMjDGlsI0kajHgIakXiKAwNyxhQzpBoGranO9c2PdAq2HGq7Kcq8ApC1kdKG0W3dT4PWborzmt1jWna2yosEn+TTHj5wi2p/E9BsCbmfokBO3xn491lr1P4shh4zg7Mv3SPD3j4/mZb9EMwD8cl4y9ZIoMEbL8p4s8J7Joqs3gK9hmMN5ZCNUFrNrJu3TCRZre2k7cV3+U3IXT erol@fedai
    uid: 2002
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
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHIngmKZJUTBgps2LpfrjFwMtW8U5Zd0olKnmG0YZbApN9UHmiVKw6ow0U+KxI6kYGrNi6acKRnZHrnip8io8swW8PnLsgFKoCO2Ywrz/uDFaNJIVdTiNNB1Msm4dd2SiRwtn09SUVwSKBIFQFEoPG7q7v1OgvhIAk13/qbrOV+u6ZgoY8ssYH7qlRElAc4cptjtTen63f87wHFUN65T70ce6nFxOsZfTrB5Y+O7DTO25y7RV6q7CXq+i1uxJutDWDOLhb+dAqQHb5JEqBTF+CElyZtJtK+GxiXfMTWTyNBlv/4up/fRDMRxZ1F69Wowjn3MSnvsFgqxhwxW6Fksr7
    uid: 2022
  rama:
    fullname: Rama
    ssh_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIADXRCZ9fFZJAJLOF0PakwhuU9b5Ne4PPr7ESwJzYndn
    uid: 2013
  rashk0:
    fullname: Rashk0
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJJKU6dVl19vQFPMUWS2iGRzBV1uD9YEaMijBkY2oPYjwhFXc1fouGGr17kkSK9D0c4pr9A6jk/gH9GWE5SpwaZY94VK5QfdvHpyA1hLevdUc4mwuIbsMp893kr0e9Miys1/v+UdFhUq0n3rWiER3oo9rJjx3qloBqSfD18y3sCFTyM1AheVMp7E71kgViG7wWtHrkmnrBo3V5ENc2snTCQy7lF7eQ5a6D45a5n2KYV94YrMvGDbfYUnw8IJHNN6XB1KBK6mksbm2p6fc3ow0UJDOK3bfJNUkp9tfRJV/EeYxGPYJRE60Ng2Dqc3zZaH7FDgbBLoK0UwGURQozNSQT campari@Beta
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
    uid: 2001
  vigilant:
    fullname: Anser Quraishi
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFGEJdMywTtuUcEtk+7JtRvq0zY49NMI885flAl+3FTbjBiCh+ozq0kSaHeFOen/c8ZTYFom9qyoANuAPvifoJeYigI8TPyqz3tQwuL8Fgj36VNcsa/kICZ77HFLWaLFG1//97tPKy8W9VFK0F8YqOYzss1xAav58OsxnLEkpn31B4XPtRNaInUNNJo155WLtOy/h+YrIvy899SLjVH+ui4tBHpmRja7pM2vq/h7ssRFnQGcvkHYKkCXm/BE8sT8yjk4hdxPmOkA2GaCxm5S6YYJeF/SqCEKbJ1tGq7UKq6jooasjQ8PHAvtmVNoXhJczFfNzNN0ybPbKYjxdzAKj12c0eTVclmMDdsGWloqCpeWQsrOFeXUxjjCCO11J8vxHDLaxaMuY3IDclAsePqXQI6zZ6wzedQ5ieEKNF2VIgsUDhyB1jIaklA0Td1MhpogEolm9juEkNaJBR8NHCvQZKByod6dc6cGQ1TFqD8LSXHVhTV7L0MqCVgsgy77wdOSk=
    uid: 2025
  xcombelle:
    fullname: Xavier Combelle
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9KJQDTtuxGCOaeFtip+yel45zMNS4tvrYg0AzNhT22K8g3F8wiY1GKvYw6Czj8Zo+rqA5/Rt7BCQwNtZyI+Nh23Cvg5wZQ2A6dtzQI69HZVSi+FRA5o4/SG4wyp7AT6wuWn+7tTE/pH69D0keDmaNpLSzhkxKFQd2DuOD2BENobEIE9DzbRf2DeUJ15uCzX/mnEXykklYvQ5AontiwL7VNB1VpNebrfnecAaAua0RhuYp+XwxBaSM4KB4lIA6hTBYEOG6J3TaC3GofMtAANI/n8gcCQkadkqtQHrap2Wh9X6bzekwROVGui1TW6sM7+hS4P7PM80nK05iVnGzIfYR xavier.combelle@gmail.com
    uid: 2017
  xray:
    fullname: xray
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAzSj3sQYbrBBdceBRUAbuzCS9vZWycVV0OSZ0ofoWx/dOTIalhc3O+aett7J34GqwDgpcTEkEpa/MrlO/2TOGOFIsPlvbZW4fXXFADCbOWkRRNuYW5rv/Sg6ZliGtw4cj0dKEkn9+L/JAuGwKV5KJNTPcp5w8hZyQYczZ8KhcyNVv7mfzLnId03wPnuTTe+AmCTOitbVb3gxjdXDYeS46PkbV8m/23KpcdLigo3ClDwE/SIoA+YddaAbpWDMEwhnWyKmLGI6xkFcqSY1NT0eYnL2waZMEnfluxt+D0V0IT5NeOmQcTuVWPvjFdSKbKepPhdrFmzGNtytfZWoFOPiG+Q== rsa-key-20170119
    uid: 2011
  windu:
    fullname: Windu
    ssh_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAigDNiN5GS+HeFrynIaW62kAHdt8EWbsCbIVCKRWM10/JiJiTJt41uezCj4i4JiIjgdemZxBXSdBpKKEkUHpfZ9B+0+a3aWxcAzdnwtsjiv8Pju2GkYmwY5ecBVipnW5ojPj1DyJaTGYJSI2wUXGUSOTn29Xh2lSm+Fm2VFq8MGw/nuDtyzWhub1TPpIwz4kFyZPh6t/avzskYdyo/amkPX3KsT3oearJLB4ZINj3fzTWUPr3vMM4W23Y3dzS5ekMZFL+T+51dCJl6eyXJ6jk4R+JnrRlT8e5mH6C5F6useHFVb/Nfi9zKbEsZG7Tqxs4MF+7dlI/Cmj1POe/P1FaMQ== rsa-key-20180130
    uid: 2026
