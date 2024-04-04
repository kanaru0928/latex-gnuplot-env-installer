#Requires -RunAsAdministrator

$scriptURL = "https://kanaru0928.github.io/latex-gnuplot-env-installer/install-gnuplot-windows.ps1"
$scriptPath = "$env:TEMP/setup-gnu-plot-env-scripts.ps1"

Start-BitsTransfer -Source "$scriptURL" -Destination "$scriptPath"
powershell -ExecutionPolicy Bypass -File "$scriptPath"

Remove-Item -Path "$scriptPath"