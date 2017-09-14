#!/bin/bash


runner_pass$1
runner_ip=$2
runner_user=$3

automate-ctl install-runner $runner_ip $runner_user --password $runner_pass
