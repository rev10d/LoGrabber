function clearAllEventLogs($computerName="localhost")
{
   Clear-EventLog -ComputerName $computerName -LogName Application
   Clear-EventLog -ComputerName $computerName -LogName Security
   Clear-EventLog -ComputerName $computerName -LogName System
}

function dumpAllEventLogs($computerName="localhost")
{
    Enter-PSSession $computerName # open remote session on computerName
    wevtutil epl Application C:\Application.evtx
    wevtutil epl Security C:\Security.evtx
    wevtutil epl System C:\System.evtx
    Exit-PSSession # back to local

    # copy files to local PC
    Copy-Item -Path \\$computerName\c$\Application.evtx -Destination Application.evtx
    Copy-Item -Path \\$computerName\c$\Security.evtx -Destination Security.evtx
    Copy-Item -Path \\$computerName\c$\System.evtx -Destination System.evtx
}

do 
{ 
    cls
    Write-Host "~~~~~ Remote Log Grabber ~~~~~" 
    Write-Host "1: Clear logs from specified machine" 
    Write-Host "2: Dump logs for specified machine" 
    Write-Host "3: Dump and clear logs from specified machine" 
    Write-Host "Q: Exit program" 

    $input = Read-Host "Please make a selection" 
    switch ($input) 
    { 
        '1' { 
            $computerName = Read-Host "Please enter the network computer name"
            clearAllEventLogs -computerName $computerName
        } 
        '2' { 
            $computerName = Read-Host "Please enter the network computer name"
            dumpAllEventLogs -computerName $computerName
        } 
        '3' { 
            $computerName = Read-Host "Please enter the network computer name"
            dumpAllEventLogs -computerName $computerName
            clearAllEventLogs -computerName $computerName
        } 
        'q' { 
            return 
        } 
    } 
    pause 
} 
until ($input -eq 'q') 
