networks:
  drake:
    netmask: 255.255.255.0
    addr:
      cloudhugger: 172.27.27.28
      router-001: 172.27.27.1
      windriver: 172.27.27.27
      ysul: 172.27.27.33

gre_tunnels:
  router-001:
    drake-cloud:
      interface: gre1
      network: drake
      from: 172.27.27.228
      to: cloudhugger

    drake-wind:
      interface: gre2
      network: drake
      from: 172.27.27.227
      to: windriver

    drake-ysul:
      interface: gre3
      network: drake
      from: 172.27.27.233
      to: ysul

  windriver:
    drake-wind: &gre_drake
      interface: gre0
      network: drake
      to: router-001

  ysul:
    drake-ysul: *gre_drake

  cloudhugger:
    drake-cloud: *gre_drake
