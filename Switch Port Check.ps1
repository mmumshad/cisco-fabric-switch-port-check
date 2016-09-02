##################################################################
#    Cisco Switch Script                                       #
##################################################################
#
# Windows powershell script to login to a cisco switch 
# and check port status for the ports in input_file.txt
# 
# Depdendency - plink.exe must be in the same directory
#
# Input file - input_file.txt with list of switch ips and credentials
#
# Mumshad Mannambeth - @mmumshad
#
###################################################################

# Input file with list of switch ips and credentials

$input_file = "input_file.txt"

$global:switch_ports = @()

$Switch_Port_details = @{
    SwitchName = "" 
    PortName   = "" 
    Port       = ""  
    Status     = ""
    Oper_Mode  = ""
    Admin_Mode  = ""
    Speed      = ""
    PWWN       = ""
    NWWN       = ""
    VSAN       = ""
    IP         = ""
    FCID       = "" 
    Input_Rate = ""
    Output_Rate = "" 
}


# Connect to each switch, execute command and process output

function Process_Switch($username, $password, $SwitchIP, $SwitchPort, $SwitchName){
    #"Executing command show interface brief | grep `"$SwitchPort[ ]`" "
    $cmd = @("term len 0","show interface brief","show flogi database","show interface $SwitchPort","exit")
    try{
    $global:output = ($cmd | ./plink.exe $SwitchIP -pw $password -l $username)
    }
    catch{}
    #$global:output | select-string "$SwitchPort " | select -first 1
    $temp_switch_port = (New-Object PSObject -Property $Switch_Port_details)
    $temp_switch_port.SwitchName = $SwitchName
    $temp_switch_port.Port = $SwitchPort
    $temp_switch_port.IP = $IP
    $temp_switch_port.VSAN = (($global:output | select-string "$SwitchPort " | select -first 1 ) -split "\s+")[1]
    $temp_switch_port.Status = (($global:output | select-string "$SwitchPort " | select -first 1 ) -split "\s+")[4]
    $temp_switch_port.Speed = (($global:output | select-string "$SwitchPort " | select -first 1 ) -split "\s+")[7]
    $temp_switch_port.Oper_Mode = (($global:output | select-string "$SwitchPort " | select -first 1 ) -split "\s+")[6]
    $temp_switch_port.Admin_Mode = (($global:output | select-string "$SwitchPort " | select -first 1 ) -split "\s+")[2]
    if (@($global:output | select-string "$SwitchPort ").count -gt 2){
    $temp_switch_port.PWWN = (($global:output | select-string "$SwitchPort ")[1] -split "\s+")[3]
    $temp_switch_port.NWWN = (($global:output | select-string "$SwitchPort ")[1] -split "\s+")[4]
    $temp_switch_port.FCID = (($global:output | select-string "$SwitchPort ")[1] -split "\s+")[2]
    }
    $temp_switch_port.Input_Rate = (((($global:output | select-string "input rate" ) -split "\s+")[5..6] -join " ") -split ",")[0]
    $temp_switch_port.Output_Rate = (((($global:output | select-string "output rate" ) -split "\s+")[5..6] -join " ") -split ",")[0]
    $temp_switch_port.PortName = (($global:output | select-string "description" ) -split "\s+")[4]
    
    $global:switch_ports += $temp_switch_port 
}


# Main - Read Input file

Get-Content $input_file | select-string -NotMatch "^#" | %{
 $username = ($_ -split "\s+")[3]
 $password = ($_ -split "\s+")[4]
 $SwitchIP = ($_ -split "\s+")[1]
 $SwitchPort = ($_ -split "\s+")[2]
 $SwitchName = ($_ -split "\s+")[0]
 #"$username $password $SwitchIP $SwitchPort $SwitchName"
 Process_Switch $username $password $SwitchIP $SwitchPort $SwitchName
 }

# Define output view
 
 $Switch_View = @{Expression={$_.SwitchName};Label="Name";width=10}, `
@{Expression={$_.Port};Label="Port";width=10}, `
@{Expression={$_.PortName};Label="Description";width=15}, `
@{Expression={$_.VSAN};Label="VSAN";width=5}, `
@{Expression={$_.Status};Label="Status";width=10}, `
@{Expression={$_.Speed};Label="Speed";width=5}, `
@{Expression={$_.PWWN};Label="PWWN";width=25},
#@{Expression={$_.NWWN};Label="NWWN";width=20},
@{Expression={$_.Input_Rate};Label="Input Rate";width=15},
@{Expression={$_.Output_Rate};Label="Output Rate";width=15}

# Print Results 

$global:switch_ports | ft -Property $Switch_View