#!/usr/bin/env bash

echo "##################################"
echo "# Jmeter - Running entry.sh file #"
echo "##################################"

##############################################################################################################
# NOTE: Delay of (randomly chosen) 60 seconds added in order to make jmeter run after the petclinic services #
#                                                                                                            #
# The execution of this script is triggered by the service REST endpoints becoming available;                #
# but the services need additional time to actually start working. So we wait a bit longer.                  #
#                                                                                                            #
# This is a pragmatic fix that MAY FAIL if you are on a slow system (until you increase the wait time).      #
##############################################################################################################
sleep 60

echo "#########################"
echo "# Starting JMeter tests #"
echo "#########################"

cd ./bin
./jmeter -n -t /opt/apache-jmeter-5.4/code/petclinic_test_plan.jmx -l /opt/apache-jmeter-5.4/code/test_output.csv

echo "###########################################"
echo "# Jmeter - entry.sh file RAN SUCCESSFULLY #"
echo "###########################################"
