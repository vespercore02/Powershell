# Import Computers from txt file
$Computers = "."

# Foreach loop
$BigOutput = foreach ($Computer in $Computers) {
    
    # Create output object
    $output = "" | Select-Object -Property Computer, Manufacturer, ProductCode, SerialNumber, Name, Week, Year
    
    # Get all connected monitors using WMI class WmiMonitorID
    $Monitors = Get-WmiObject -Namespace root\wmi -Class WmiMonitorID -ComputerName $Computer

        # Internal foreach loop to go over each connected monitor
        foreach ($Monitor in $Monitors) {
            
            $output.Computer = $Computer
            # get monitor info and convert to char
            $Monitor.ManufacturerName | foreach {$output.Manufacturer += [char]$_}
            $Monitor.ProductCodeID | foreach {$output.ProductCode += [char]$_}
            $Monitor.SerialNumberID | foreach {$output.SerialNumber += [char]$_}
            $Monitor.UserFriendlyName | foreach {$output.Name += [char]$_}
            # Get week and year
            $output.Week = $Monitor.WeekOfManufacture
            $output.Year = $Monitor.YearOfManufacture
            $output
            $output = "" | Select-Object -Property Computer, Manufacturer, ProductCode, SerialNumber, Name, Week, Year

        } #END internal foreach loop

} # END foreach loop

# Export result to CSV file
$BigOutput | Export-Csv GetMonitorSN.csv