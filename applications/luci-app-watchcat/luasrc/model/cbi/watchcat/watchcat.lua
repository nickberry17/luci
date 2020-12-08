-- Copyright 2012 Christian Gagneraud <chris@techworks.ie>
-- Copyright 2020 Nicholas Smith <nicholas@nbembedded.com>
-- Licensed to the public under the Apache License 2.0.

m = Map("system", 
	translate("Watchcat"), 
	translate("Watchcat allows you to specify what action to take if a host becomes unreachable, and to schedule a periodic reboot. " ..
				"You can set rules to monitor specific interfaces and restart those interfaces when a host becomes unreachable via that interface. " ..
				"You can set a rule to reboot this device if a host becomes unreachable."))

s = m:section(TypedSection, "watchcat")
s.anonymous = true
s.addremove = true

mode = s:option(ListValue, "mode",
		translate("Operating mode"))
mode.default = "periodic_reboot"
mode:value("ping_reboot", "Ping Reboot: Reboot on internet connection lost")
mode:value("periodic_reboot", "Periodic Reboot: Scehdule a periodic reboot")
mode:value("restart_iface", "Restart Interface: Restart network interface if a host is unreachable via that interface")

forcedelay = s:option(Value, "force_delay",
		      translate("Forced reboot delay"),
		      translate("When rebooting the system, the watchcat will trigger a soft reboot. " ..
				"Entering a non zero value here will trigger a delayed hard reboot " ..
				"if the soft reboot fails. Enter a number of seconds to enable, " ..
				"use 0 to disable"))
forcedelay.datatype = "uinteger"
forcedelay.default = "0"

period = s:option(Value, "period", 
		  translate("Period"),
		  translate("In periodic mode, it defines the reboot period. " ..
			    "In internet mode, it defines the longest period of " .. 
			    "time without internet access before a reboot is engaged." ..
			    "Default unit is seconds, you can use the " ..
			    "suffix 'm' for minutes, 'h' for hours or 'd' " ..
			    "for days"))

pinghost = s:option(Value, "ping_hosts", 
		    translate("Ping host"),
		    translate("Host address to ping_reboot"))
pinghost.datatype = "host(1)"
pinghost.default = "8.8.8.8"
pinghost:depends({mode="ping_reboot"})
pinghost:depends({mode="restart_iface"})

pingperiod = s:option(Value, "ping_period", 
		      translate("Ping period"),
		      translate("How often to check internet connection. " ..
				"Default unit is seconds, you can you use the " ..
				"suffix 'm' for minutes, 'h' for hours or 'd' " ..
				"for days"))
pingperiod:depends({mode="ping_reboot"})
pingperiod:depends({mode="restart_iface"})

interface = s:option(Value, "interface", 
			translate("Network interface to monitor."), 
			translate("Examples: eth1, wwan0"))
interface:depends({mode="ping_reboot"})
interface:depends({mode="restart_iface"})
			
mm_interface_name = s:option(Value, "mm_iface_name", 
			translate("Name of the ModemManager interface to restart"), 
			translate("Set this if you are using a ModemManager interface. Examples: mobiledata or broadband"))
pingperiod:depends({mode="restart_iface"})
			
pingsize=s:option(ListValue,"pingsize",
			translate("Ping Packet Size"),
			translate("Sets the size in bytes for the ping packet size."))
pingsize:value("small","Small: 1 byte")
pingsize:value("windows","Windows: 32 bytes")
pingsize:value("standard","Standard: 56 bytes")
pingsize:value("big","Big: 248 bytes")
pingsize:value("huge","Huge: 1492 bytes")
pingsize:value("jumbo","Jumbo: 9000 bytes")
pingsize.default = "standard"
pingsize:depends({mode="ping_reboot"})
pingsize:depends({mode="restart_iface"})


return m
