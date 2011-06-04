#!/bin/bash

puppet apply --debug --noop --modulepath=./../ $1
