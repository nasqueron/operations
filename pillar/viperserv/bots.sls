# To regenerate the list of scripts in a folder, try:
# find . -type f -name '*.tcl' | grep -v tests/ | grep -v Maintenance/ | grep -v ForUsers/ | grep -v PreSurfBoard | sed 's@\./@      - @'

viperserv_accounts:
  viperserv:
    fullname: ViperServ
    uid: 833
  tc2:
    fullname: Tau Ceti Central
    uid: 834

viperserv_bots:
  Daeghrefn:
    scripts:
      - Core.tcl
      - Tech.tcl
      - Daeghrefn/Time.tcl
      - Daeghrefn/Wolfplex.tcl
      - Daeghrefn/Server.tcl
      - Daeghrefn/Last.fm.tcl
      - Daeghrefn/Wikimedia.tcl
      - Daeghrefn/Bureautique.tcl
      - Daeghrefn/oauth.tcl
      - Daeghrefn/Communication.tcl
      - Daeghrefn/GIS.tcl
      - Daeghrefn/Tools.tcl
      - Daeghrefn/Channel.tcl
      - vendor/proxycheck.tcl
  Wearg:
    scripts:
      - Core.tcl
      - Tech.tcl
      - Wearg/Broker.tcl
      - Wearg/Time.tcl
      - Wearg/Notifications.tcl
  TC2:
    runas: tc2
    scripts:
      - Core.tcl
      - Tech.tcl
      - TC2/Time.tcl
      - TC2/Server.tcl
