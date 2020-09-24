networks:
  drake:
    netmask: 255.255.255.0
    addr:
      cloudhugger: 172.27.27.28
      router-001: 172.27.27.1
      windriver: 172.27.27.27
      ysul: 172.27.27.33

gre_tunnels:
  windriver:
    wind-cloud:
      interface: gre0
      network: drake
      to: cloudhugger

    wind-ysul:
      interface: gre0
      network: drake
      to: ysul

  ysul:
    wind-ysul: &gre_drake_to_windriver
      interface: gre0
      network: drake
      to: windriver

  cloudhugger:
    wind-cloud: *gre_drake_to_windriver
