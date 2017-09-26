Set-ExecutionPolicy Unrestricted -force

$a = Get-Date
$a.ToUniversalTime()

If ( -Not (Test-Path c:\git\bin\git.exe) ) {
	Write-Output "Installing Git "
	$source = "https://github.com/git-for-windows/git/releases/download/v2.14.1.windows.1/Git-2.14.1-32-bit.exe"
	$destination = "c:\azurecsdir\git-inst.exe"
	$wc = New-Object System.Net.WebClient
	$wc.DownloadFile($source, $destination)
	invoke-expression -Command "c:\azurecsdir\git-inst.exe /veryslient /norestart /dir=c:\git\ /SP-  /SILENT /COMPONENTS='icons,ext\reg\shellhere,assoc,assoc_sh' | out-null "
}

If ( -Not (Test-Path c:\python27\python.exe) ) {
	Write-Output "Installing Python"
	$source = "https://www.python.org/ftp/python/2.7.8/python-2.7.8.msi"
	$destination = "c:\azurecsdir\python-2.7.8.msi"
	$wc = New-Object System.Net.WebClient
	$wc.DownloadFile($source, $destination)
	invoke-expression -Command "msiexec /i c:\azurecsdir\python-2.7.8.msi TARGETDIR=c:\python27 /qb | out-null " 

	$source = "https://bootstrap.pypa.io/get-pip.py"
	$destination = "c:\azurecsdir\get-pip.py"
	$wc = New-Object System.Net.WebClient
	$wc.DownloadFile($source, $destination)
	invoke-expression -Command "c:\python27\python.exe c:\azurecsdir\get-pip.py | out-null "

	$env:Path += ";C:\git\bin;c:\python27;c:\python27\scripts"
	pip install virtualenv

	$oldpath = (Get-ItemProperty -Path ‘Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment’ -Name PATH).path
	$newpath = "$oldpath;c:\python27;c:\python27\scripts"
	Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath
}

$FileName="C:\WindowsAzure\Logs\Plugins\Microsoft.Compute.CustomScriptExtension\*\CommandExecution*"
if (Test-Path $FileName) {
	Write-Output "remove $FileName"
	Remove-Item –path $FileName
}

$FileName="C:\azurecsdir\aa*"
if (Test-Path $FileName) {
	Write-Output "remove $FileName"
	Remove-Item –path $FileName
}
