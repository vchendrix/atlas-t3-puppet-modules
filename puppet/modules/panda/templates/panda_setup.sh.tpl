#!/bin/bash
## PANDA_HOME should point to where you checked out the Panda code, see above
#export PANDA_HOME=$HOME/pilots
export PANDA_HOME = <%= $pandaHome %>
## PANDA_LOGS should point to the directory that maps to the web URL you support for web access to pilot log files
#export PANDA_LOGS=/export/share/pilot
export PANDA_LOGS=<%= $pandaLogDir %>
export SCHEDULER_LOGS=$PANDA_LOGS/scheduler
export CRON_LOGS=$PANDA_LOGS/cron
export PYTHONPATH=$PANDA_HOME/monitor:$PANDA_HOME/panda-server/current/pandaserver:$PYTHONPATH
