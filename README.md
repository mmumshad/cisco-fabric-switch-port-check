# cisco-fabric-switch-port-check

Powershell script to check port status and performance of multiple Cisco Fibre Channel Switches at once.

Download and Copy the files to a windows server with Powershell and connectivity to cisco switches.

### Input File

Update input_file with list of switches, IPs, credentials and port names:

```
#SwitchName 	SwitchIP	SwitchPort	Username	Password	VSAN	PortName
#------------------------------------------------------------------------------------------------
MDS9513		10.0.0.123      fc3/12         	admin 		Pass1234	12	
MDS9513		10.0.0.123      fc3/1         	admin 		Pass1234	12
MDS9513		10.0.0.123      fc3/11         	admin 		Pass1234	12
MDS9513		10.0.0.123      fc3/3         	admin 		Pass1234	12
MDS9513		10.0.0.123      fc3/21         	admin 		Pass1234	12
MDS9513		10.0.0.123      fc3/5         	admin 		Pass1234	12
```

### Execute Script

Open a powershell prompt and run the script


```
PS D:\Cisco> & '.\Switch Port Check'
```

### Output

```
Name       Port       Description     VSAN  Status     Speed PWWN                      Input Rate      Output Rate
----       ----       -----------     ----  ------     ----- ----                      ----------      -----------
MDS9513    fc3/12                     1     down       --                              0 bits/sec      0 bits/sec
MDS9513    fc3/1                      1     notConn... --                              0 bits/sec      0 bits/sec
MDS9513    fc3/11                     1     down       --                              0 bits/sec      0 bits/sec
MDS9513    fc3/3                      1     notConn... --                              0 bits/sec      0 bits/sec
MDS9513    fc3/21
MDS9513    fc3/5                      1     notConn... --                              0 bits/sec      0 bits/sec
```
