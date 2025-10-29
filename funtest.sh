#!/bin/bash 

# Connect to wifi (doesn't always work for some reason)
#echo "Attempting to connect wifi, connect manually if unsuccessful!"
#networksetup -setairportnetwork en0 "Aaxl" "\][poiuy"
#echo

# Display general device info for SKU usage: Model Name, Basic(?), CPU, and GPU(s)
echo "========== DEVICE INFO =========="
model=$(sysctl -n hw.model)    
echo "DEVICE MODEL: $model"

cpuInfo="$(sysctl -n machdep.cpu.brand_string)"
echo "CPU DETECTED: $cpuInfo"

gpuInfoIntel="$(system_profiler SPDisplaysDataType | grep -A 1 -e "Intel" | head -1| awk '{$1=$1}1')"
gpuInfoAMD="$(system_profiler SPDisplaysDataType | grep -A 1 -e "AMD" | head -1| awk '{$1=$1}1')"
gpuInfoM1="$(system_profiler SPDisplaysDataType | grep -A 1 -e "Apple" | head -1| awk '{$1=$1}1')"
echo "GPU(s) DETECTED: $gpuInfoIntel|$gpuInfoAMD|$gpuInfoM1"
echo

memSize=$(sysctl -n hw.memsize)
memSize=$(expr $memSize / $((1024**3)))
echo "SYSTEM MEMORY: $memSize GB"

storageSize=$(df -H / | awk 'NR==2 {print $2}' | awk '{$1=$1}1')
echo "TOTAL STORAGE: $storageSize"
echo

# Grab and display Battery Cycle info
echo "========== BATTERY INFO =========="
battCycles="$(system_profiler SPPowerDataType | grep -A 1 -e "Cycle Count")"
echo "$battCycles" | awk '{$1=$1}1'
echo

# Grab design/max capacity to calculate and display health
designCap=$(ioreg -l | grep -Fw "DesignCapacity" | tail -1 | grep -o '[0-9]\+')
maximumCap=$(ioreg -l | grep -Fw "AppleRawMaxCapacity" | tail -1 | grep -o '[0-9]\+')
echo "Current Max Capacity: $maximumCap"
echo "Original Design Capacity: $designCap"

batteryHealth=$(echo "scale=2; $maximumCap / $designCap * 100" | bc)

echo
echo "BATTERY HEALTH: $batteryHealth percent"
echo "(Battery health is Maximum Cap divided by Design Cap)"
echo

# Open safari for functionality testing on retest.us
echo "Attempting to open Safari, please start manually if needed."        
# Attempt one
open -a Safari "https://spinning.fish/" "https://testmyscreen.com/" "https://retest.us/macbook"
# Attempt two
open "/Applications/Safari.app" "https://spinning.fish/" "https://testmyscreen.com/" "https://retest.us/macbook"
# Fallback
open "/Applications/"
