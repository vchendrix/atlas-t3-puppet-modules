#!/bin/bash
source $HOME/panda_setup.sh
python $PANDA_HOME/autopilot/cleanSpace.py > /dev/null
cd $PANDA_HOME/autopilot
svn update
cd $PANDA_HOME/monitor
svn update
cd $PANDA_HOME/panda-server
svn update
