#!/bin/bash 

# Connect to wifi (doesn't always work for some reason)
#echo "Attempting to connect wifi, connect manually if unsuccessful!"
#networksetup -setairportnetwork en0 "Aaxl" "\][poiuy"
#echo

# Grab and display Battery Cycle info
battCycles="$(system_profiler SPPowerDataType | grep -A 1 -e "Cycle Count")"
echo "$battCycles"
echo

# Grab design/max capacity to calculate and display health
designCap=$(ioreg -l | grep -Fw "DesignCapacity" | tail -1 | grep -o '[0-9]\+')
maximumCap=$(ioreg -l | grep -Fw "MaxCapacity" | tail -1 | grep -o '[0-9]\+')
battCondition=$(ioreg -l | grep -Fw "Condition" | tail -1)
echo "Current Max Capacity: $maximumCap"
echo "Original Design Capacity: $designCap"
echo "Battery Condition: $battCondition"

batteryHealth=$(echo "scale=2; $maximumCap / $designCap * 100" | bc)

echo "BATTERY HEALTH: $batteryHealth percent"
echo "(Battery health is Maximum Cap divided by Design Cap)"
echo

# Open safari for functionality testing on retest.us
open -a Safari "https://spinning.fish/" "https://testmyscreen.com/" "https://retest.us/macbook"
if pgrep -q "Safari"; then
        echo "Safari successfully started!"
    else
        # Next try opening by pointing to the .app in the Application directory
        open -a "/Applications/Safari.app" "https://spinning.fish/" "https://testmyscreen.com/" "https://retest.us/macbook"
                
        if pgrep -q "Safari"; then
            echo "Safari successfully started!"
        else
            echo "Can't find Safari window! Please start the application manually."
            # Finally, fall back to opening Finder for a manual start
            open "/Applications/"
        fi
    fi