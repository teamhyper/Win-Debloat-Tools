# Syntax
#   powercfg [Options]
#      /Change settingvalue
#      /x setting value
#            Modify one of the following settings in the current power scheme:
#               monitor-timeout-ac minutes
#               monitor-timeout-dc minutes
#               disk-timeout-ac minutes
#               disk-timeout-dc minutes
#               standby-timeout-ac minutes
#               standby-timeout-dc minutes
#               hibernate-timeout-ac minutes
#               hibernate-timeout-dc minutes
#            Setting any value to 0 will set the timeout=Never
#            AC settings are used when the system is on AC power. DC settings on battery power.
#      /Hibernate [on|off]
#      /H [on|off]
#            Enable or disable the hibernate feature.
#            This will also turn off Fast Startup (or hybrid sleep)
#            Hibernate timeout is not supported on all computers.

Powercfg /Hibernate on

Powercfg /Change monitor-timeout-ac 5
Powercfg /Change disk-timeout-ac 5
Powercfg /Change standby-timeout-ac 0
Powercfg /Change hibernate-timeout-ac 0

Powercfg /Change monitor-timeout-dc 2
Powercfg /Change disk-timeout-dc 2
Powercfg /Change standby-timeout-dc 10
Powercfg /Change hibernate-timeout-dc 180
