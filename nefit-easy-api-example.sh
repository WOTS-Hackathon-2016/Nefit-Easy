#!/bin/bash  

#README, Use This Script as Example for the Nefit Easy API
################################################################################################
# Use at own Risk
# Use this script as an Example.
# Please fill in the DeviceID and Token provided by the organisation of the WOTS Hackathon
# 
# Contacts
# Ralph Plantagie ralph.plantagie@nl.bosch.com
# Henk Kalk henk.kalk@nl.bosch.com
#
#SETTINGS
################################################################################################
Debug='false' 		#true
ServerURL='https://ohbi-auth.thermotechnology.bosch.com/hvacc/tt-hvacproxy/hackathon2016/v1/'
DeviceID='<CHANGE WITH YOUR DeviceID>' 	#enter 9 digit DeviceID here (see manual) 
Token='<CHANGE WITH YOUR TOKEN>'	#enter token
 
#Fixed
##################################################################################################
Program="curl" 
Oauth2Header='--insecure --header "Authorization: Bearer '
Oauth2HeaderEnd='"' 

#DEBUG
##################################################################################################
if [ $Debug = "true" ]; then
  echo $"DEBUG ON"
  echo $"DEBUG: Running script with arguments: \"$@\" "
  echo $""
fi

#PROCESS GET COMMAND
##################################################################################################
if [ $1 = "GET" ]; then
  
  if [ $2 = "TEMP"  ]; then
    # GET THE ROOM TEMPERATURE OF THE RRC
    setting='heatingCircuits/hc1/roomtemperature'
    # REPLY {"id":"/heatingCircuits/hc1/roomtemperature","type":"floatValue","recordable":0,
    #"writeable":1,"value":14.0,"unitOfMeasure":"C","minValue":5.0,"maxValue":30.0}

  elif [ $2 = "OUTDOOR-TEMP" ]; then
    # GET THE OUTDOOR TEMPERATURE OF THE RRC'S LOCATION
    setting='system/sensors/temperatures/outdoor_t1'
    # REPLY {"id":"/system/sensors/temperatures/outdoor_t1","type":"floatValue","recordable":0,
    #"writeable":0,"value":13.0,"unitOfMeasure":"C","minValue":-25.0,"maxValue":50.0,"status":"ok",
    #"srcType":"virtual","timestamp":"2016-08-11T15:55:13"}
        
  elif [ $2 = "USER-MODE" ]; then
    # GET THE USER MODE MANUAL, OR .....
    setting='heatingCircuits/hc1/usermode'
    # REPLY {"id":"/heatingCircuits/hc1/usermode","type":"stringValue","recordable":0,"writeable":1,
    #"value":"manual"}

  elif [ $2 = "SETPOINT" ]; then
    # GET THE CONFIGURED SETPOINT
    setting='heatingCircuits/hc1/temperatureRoomSetpoint'
    # {"id":"/heatingCircuits/hc1/temperatureRoomSetpoint","type":"floatValue","recordable":0,
    #"writeable":0,"value":14.0,"unitOfMeasure":"C","minValue":5.0,"maxValue":30.0}
  
  elif [ $2 = "HOME-ENTRANCE" ]; then
    # GET IF USERPROFILE 0 IS AT HOME
    setting='ecus/rrc/homeentrancedetection/userprofile0/detected'
    # REPLY {"id":"/ecus/rrc/homeentrancedetection/userprofile0/detected","type":"stringValue",
    #"recordable":0,"writeable":1,"value":"off"}

  elif [ $2 = "APPLIANCE-POWER" ]; then
    # GET IF THE APPLIANCE IS BURNING GAS
    setting='system/appliance/actualPower'
    # REPLY {"id":"/system/appliance/actualPower","type":"floatValue","recordable":0,"writeable":0,
    #"value":0,"unitOfMeasure":"%","minValue":0,"maxValue":100,"reason":"CH"}

  elif [ $2 = "STATUS" ]; then
    # GET IF THE APPLIANCE IS BURNING GAS
    setting='ecus/rrc/uiStatus'
    # REPLY {"id":"/ecus/rrc/uiStatus","type":"uiUpdate","recordable":0,"writeable":0,"
    # value":{"CTD":"2016-09-14T16:14:34+01:00 We","CTR":"room","UMD":"manual","MMT":"10.0","CPM":"auto",
    #"CSP":"18","TOR":"on","TOD":"0","TOT":"10.0","TSP":"10.0","IHT":"26.10","IHS":"ok","DAS":"off",
    #"TAS":"off","HMD":"off","ARS":"init","FPA":"off","ESI":"on","BAI":"No","BLE":"false","BBE":"false",
    #"BMR":"false","PMR":"false","RS":"off","DHW":"off","HED_EN":"true","HED_DEV":"false","FAH":"false",
    #"DOT":"false","HED_DB":"temporary override"}}

  else
    echo $"ERROR: GET $2 is an unknown command" 
  fi 
  
  # execute command 
  echo "DEBUG " $Program "$Oauth2Header$Token$Oauth2HeaderEnd $ServerURL$DeviceID/$setting"
  eval $Program "$Oauth2Header$Token$Oauth2HeaderEnd $ServerURL$DeviceID/$setting"

#PROCESS PUT COMMAND 
##################################################################################################
elif [ $1 = "PUT" ]; then
  
  if [ $2 = "TEMP" ]; then
    # SET MANUAL ROOM TEMPERATURE
    # todo Check if $3 is greater than 5 and smaller than 30
      json='{"value":'$3'}'
      setting='heatingCircuits/hc1/temperatureRoomManual'
  
  elif [ $2 = "USER-MODE" ]; then
    # SET THE USER MODE MANUAL, OR .....
    json='{"value":"'$3'"}'
    setting='heatingCircuits/hc1/usermode'
  fi

  # execute command 
  echo "DEBUG " $Program "$Oauth2Header$Token$Oauth2HeaderEnd -X PUT -d '$json' $ServerURL$DeviceID/$setting"
  eval $Program "$Oauth2Header$Token$Oauth2HeaderEnd -X PUT -d $json $ServerURL$DeviceID/$setting"

#ELSE PRINT HELP
##################################################################################################
else
  # print Help
  echo $"Running script with arguments $@"
  echo $""
  echo $"EXAMPLE:"
  echo $"   ./nefit-api.sh GET INDOOR_TEMP"
  echo $""
  echo $"GET COMMANDS: "
  echo $"    GET TEMP"
  echo $"    GET OUTDOOR-TEMP"
  echo $"    GET USER-MODE"
  echo $"    GET SETPOINT"
  echo $"    GET HOME-ENTRANCE"
  echo $"    GET APPLIANCE-POWER"
  echo $"SET COMMANDS: "
  echo $"    PUT TEMP {value e.g. 12}" 
  echo $"    PUT USER-MODE {manual/ .....}"
fi

