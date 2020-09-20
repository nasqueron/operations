networks:
  drake:
    netmask: 255.255.255.0
    addr:
      windriver: 172.27.27.27
      ysul: 172.27.27.33

gre_tunnels:
  windriver:
    wind-ysul:
      interface: gre0
      network: drake
      to: ysul

  ysul:
    wind-ysul:
      interface: gre0
      network: drake
      to: windriver
