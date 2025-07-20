#!bin/bash

# Disable the MDM agent.

sudo mount -uw /
sudo mkdir /System/Library/LaunchAgentsDisabled
sudo mkdir /System/Library/LaunchDaemonsDisabled
sudo mv /System/Library/LaunchAgents/com.apple.ManagedClientAgent.agent.plist /System/Library/LaunchAgentsDisabled
sudo mv /System/Library/LaunchAgents/com.apple.ManagedClientAgent.enrollagent.plist /System/Library/LaunchAgentsDisabled
sudo mv /System/Library/LaunchDaemons/com.apple.ManagedClient.cloudconfigurationd.plist /System/Library/LaunchDaemonsDisabled
sudo mv /System/Library/LaunchDaemons/com.apple.ManagedClient.enroll.plist /System/Library/LaunchDaemonsDisabled
sudo mv /System/Library/LaunchDaemons/com.apple.ManagedClient.plist /System/Library/LaunchDaemonsDisabled
sudo mv /System/Library/LaunchDaemons/com.apple.ManagedClient.startup.plist /System/Library/LaunchDaemonsDisabled


# Remove the “enroll” notifications
sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound

sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound

sudo launchctl disable system/com.apple.ManagedClient.enroll
sudo launchctl disable system/com.apple.mdmclient.daemon
sudo launchctl disable system/com.apple.mdmclient
sudo launchctl disable system/com.apple.devicemanagementclient.teslad



touch /Volumes/data/private/var/db/.AppleSetupDone

rm -rf /Volumes/system/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
rm -rf /Volumes/system/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound

touch /Volumes/system/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
touch /Volumes/system/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound

# create pass for root
dscl -f /Volumes/Macintosh\ HD/private/var/db/dslocal/nodes/Default localhost -passwd /Local/Default/Users/root


# create local user
dscl . -create /Users/vgladush
dscl . -create /Users/vgladush RealName "Vitalii Gladush"
dscl . -create /Users/vgladush UniqueID 501
dscl . -create /Users/vgladush PrimaryGroupID 20
dscl . -create /Users/vgladush NFSHomeDirectory /Users/vgladush
dscl . -create /Users/vgladush UserShell /bin/zsh
dscl . -passwd /Users/vgladush password
dscl . -append /Groups/admin GroupMembership vgladush


# Add to hosts
echo "MDM disable" >> /etc/hosts
echo "0.0.0.0 gdmf.apple.com" >> /etc/hosts
echo "0.0.0.0 acmdm.apple.com" >> /etc/hosts
echo "0.0.0.0 albert.apple.com" >> /etc/hosts
echo "0.0.0.0 iprofiles.apple.com" >> /etc/hosts
echo "0.0.0.0 mdmenrollment.apple.com" >> /etc/hosts
echo "0.0.0.0 deviceenrollment.apple.com" >> /etc/hosts
