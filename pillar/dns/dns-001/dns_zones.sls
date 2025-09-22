dns_zones:
  - testdom2.ook.space
  - nasqueron.org

dns_identity: ns1.nasqueron.org

dns_zone_variables:
   www:

     # Alternative to CNAME www-alkane.nasqueron.org
     alkane:
       A: 51.255.124.10
       AAAA: "2001:41d0:303:d971::517e:c0de"

     # Alternative to CNAME www-dev.nasqueron.org
     dev:
       A: 195.154.30.15
       AAAA: "2001:bc8:2e84:700::da7a:7001"
