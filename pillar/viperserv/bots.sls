# To regenerate the list of scripts in a folder, try `make list` from rVIPER.

viperserv_accounts:
  viperserv:
    fullname: ViperServ
    uid: 833
  tc2:
    fullname: Tau Ceti Central
    uid: 834

viperserv_bots:
  Daeghrefn:
    realname: https://daeghrefn.nasqueron.org
    scripts:
      - Daeghrefn/Time.tcl
      - Daeghrefn/Wolfplex.tcl
      - Daeghrefn/Server.tcl
      - Daeghrefn/Last.fm.tcl
      - Daeghrefn/Wikimedia.tcl
      - Daeghrefn/Bureautique.tcl
      - Daeghrefn/Communication.tcl
      - Daeghrefn/GIS.tcl
      - Daeghrefn/Tools.tcl
      - Daeghrefn/Channel.tcl
      - vendor/oauth.tcl
      - vendor/proxycheck.tcl
    modules:
      - transfer
      - filesys
      - seen
  Wearg:
    realname: RabbitMQ broker client
    scripts:
      - Wearg/Broker.tcl
      - Wearg/Notifications.tcl
      # This one should be last as it initializes
      # startup components, with broker/Notifications
      # dependencies
      - Wearg/Time.tcl
  TC2:
    realname: Tau Ceti Central
    runas: tc2
    scripts:
      - TC2/Time.tcl
      - TC2/Server.tcl
