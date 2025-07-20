#!/bin/bash

# Enable debugging mode
set -x

RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'
NC='\033[0m'

DATA_PATH="/Volumes/data"
SYSTEM_PATH="/Volumes/system"
mount -uw /

echo
echo -e "MDM Bypass script"
echo

PS3='Please enter option: '
options=("Bypass on Recovery" "Disable MDM agent Notification" "Disable MDM agent Notification (Recovery)" "Check MDM Enrollment" "Exit")

select opt in "${options[@]}"; do
	case $opt in
		"Bypass on Recovery")
			# echo -e "${GRN}Bypass on Recovery"
			# if [ -d "/Volumes/Macintosh HD - Data" ]; then
			# 	diskutil rename "Macintosh HD - Data" "data"
			# fi

			echo -e "${GRN}Creating new user"
			echo -e "${BLU}Press Enter to proceed to the next step. If nothing is entered, default values will be used."
			echo -e "Enter full name (Default: MAC)"
			read realName
			realName="${realName:=Vitalii Gladush}"

			echo -e "${BLU}Enter username ${RED}(NO SPACES)${GRN} (Default: MAC)"
			read username
			username="${username:=vgladush}"

			echo -e "${BLU}Enter password (Default: 1234)"
			read passw
			passw="${passw:=1234}"

			dscl_path="${DATA_PATH}/private/var/db/dslocal/nodes/Default"

			echo -e "${GRN}Creating user"
			# Create user
			dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username"
			dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UserShell "/bin/zsh"
			dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
			dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UniqueID "501"
			dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" PrimaryGroupID "20"

			# install -d -o "$username" -g staff "/Volumes/Data/Users/$username"
			dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" NFSHomeDirectory "/Users/$username"
			dscl -f "$dscl_path" localhost -passwd "/Local/Default/Users/$username" "$passw"
			dscl -f "$dscl_path" localhost -append "/Local/Default/Groups/admin" GroupMembership $username
			echo -e "${GRN}Creating $username successful${NC}"

			# dscl -f /Volumes/Macintosh\ HD/private/var/db/dslocal/nodes/Default localhost -passwd /Local/Default/Users/root
			echo -e "${GRN}Host blocking ${NC}"
			echo "# MDM disable" >> ${SYSTEM_PATH}/etc/hosts
			echo "0.0.0.0 gdmf.apple.com" >> ${SYSTEM_PATH}/etc/hosts
			echo "0.0.0.0 acmdm.apple.com" >> ${SYSTEM_PATH}/etc/hosts
			echo "0.0.0.0 albert.apple.com" >> ${SYSTEM_PATH}/etc/hosts
			echo "0.0.0.0 iprofiles.apple.com" >> ${SYSTEM_PATH}/etc/hosts
			echo "0.0.0.0 mdmenrollment.apple.com" >> ${SYSTEM_PATH}/etc/hosts
			echo "0.0.0.0 deviceenrollment.apple.com" >> ${SYSTEM_PATH}/etc/hosts
			echo -e "${GRN}Host blocking successful${NC}"

			# Remove config profile
			echo -e "${GRN}Removing MDM profile${NC}"
			touch ${DATA_PATH}/private/var/db/.AppleSetupDone
			rm -rf ${SYSTEM_PATH}/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
			rm -rf ${SYSTEM_PATH}/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
			touch ${SYSTEM_PATH}/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
			touch ${SYSTEM_PATH}/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
			echo -e "${GRN}MDM profile removal successful${NC}"
			echo "----------------------"
			break
			;;
		"Disable MDM agent Notification")
			echo -e "${RED}Please insert your password to proceed${NC}"
			sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
			sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
			sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
			sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound


			sudo mkdir /System/Library/LaunchAgentsDisabled
			sudo mkdir /System/Library/LaunchDaemonsDisabled
			sudo mv /System/Library/LaunchAgents/com.apple.ManagedClientAgent.agent.plist /System/Library/LaunchAgentsDisabled
			sudo mv /System/Library/LaunchAgents/com.apple.ManagedClientAgent.enrollagent.plist /System/Library/LaunchAgentsDisabled
			sudo mv /System/Library/LaunchDaemons/com.apple.ManagedClient.cloudconfigurationd.plist /System/Library/LaunchDaemonsDisabled
			sudo mv /System/Library/LaunchDaemons/com.apple.ManagedClient.enroll.plist /System/Library/LaunchDaemonsDisabled
			sudo mv /System/Library/LaunchDaemons/com.apple.ManagedClient.plist /System/Library/LaunchDaemonsDisabled
			sudo mv /System/Library/LaunchDaemons/com.apple.ManagedClient.startup.plist /System/Library/LaunchDaemonsDisabled

			sudo launchctl disable system/com.apple.ManagedClient.enroll
			sudo launchctl disable system/com.apple.mdmclient.daemon
			sudo launchctl disable system/com.apple.mdmclient
			sudo launchctl disable system/com.apple.devicemanagementclient.teslad
			break
			;;
		"Disable MDM agent Notification (Recovery)")
			echo -e "${GRN}Removing MDM Notification${NC}"
			rm -rf ${SYSTEM_PATH}/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
			rm -rf ${SYSTEM_PATH}/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
			touch ${SYSTEM_PATH}/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
			touch ${SYSTEM_PATH}/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound

			mkdir ${SYSTEM_PATH}/System/Library/LaunchAgentsDisabled
			mkdir ${SYSTEM_PATH}/System/Library/LaunchDaemonsDisabled
			mv ${SYSTEM_PATH}/System/Library/LaunchAgents/com.apple.ManagedClientAgent.agent.plist /System/Library/LaunchAgentsDisabled
			mv ${SYSTEM_PATH}/System/Library/LaunchAgents/com.apple.ManagedClientAgent.enrollagent.plist /System/Library/LaunchAgentsDisabled
			mv ${SYSTEM_PATH}/System/Library/LaunchDaemons/com.apple.ManagedClient.cloudconfigurationd.plist /System/Library/LaunchDaemonsDisabled
			mv ${SYSTEM_PATH}/System/Library/LaunchDaemons/com.apple.ManagedClient.enroll.plist /System/Library/LaunchDaemonsDisabled
			mv ${SYSTEM_PATH}/System/Library/LaunchDaemons/com.apple.ManagedClient.plist /System/Library/LaunchDaemonsDisabled
			mv ${SYSTEM_PATH}/System/Library/LaunchDaemons/com.apple.ManagedClient.startup.plist /System/Library/LaunchDaemonsDisabled

			launchctl disable system/com.apple.ManagedClient.enroll
			launchctl disable system/com.apple.mdmclient.daemon
			launchctl disable system/com.apple.mdmclient
			launchctl disable system/com.apple.devicemanagementclient.teslad

			echo -e "${GRN}MDM Notification removal successful${NC}"
			echo "----------------------"
			break
			;;
		"Check MDM Enrollment")
			echo ""
			echo -e "${GRN}Checking MDM Enrollment. Error is considered success${NC}"
			echo ""
			echo -e "${RED}Please insert your password to proceed${NC}"
			echo ""
			sudo profiles show -type enrollment
			break
			;;
		"Exit")
			break
			;;
		*)
			echo "Invalid option $REPLY"
			;;
	esac
done
