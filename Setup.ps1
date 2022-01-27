# Props
$baseRepo = 'https://raw.githubusercontent.com/daanwissing/setup/main'

# Install winget

$hasPackageManager = Get-AppPackage -name "Microsoft.DesktopAppInstaller"

if (!$hasPackageManager) {
    Write-Host "Installing winget" -ForegroundColor Yellow
    $releases_url = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $releases = Invoke-RestMethod -uri "$($releases_url)"
    $latestRelease = $releases.assets | Where-Object { $_.browser_download_url.EndsWith("msixbundle") } | Select-Object -First 1

    Add-AppxPackage -Path $latestRelease.browser_download_url
    Write-Host 'winget installed' -ForegroundColor Green
}

Write-Host "Installing Powershell 7" -ForegroundColor Yellow
winget install Microsoft.PowerShell --silent
Write-Host 'Powershell 7 installed' -ForegroundColor Green


Write-Host "Installing VS Code" -ForegroundColor Yellow

# install VS Code
winget install vscode --silent

#extensions
Write-Host "Installing VS Code extensions"
$installBase = "${env:USERPROFILE}/AppData/Local/Programs"
$codeExePath = "$installBase\Microsoft VS Code\bin\code.cmd"
$extensions = @("ms-vscode.Powershell", "ms-dotnettools.csharp")
foreach ($extension in $extensions) {
    Write-Host "`nInstalling extension $extension..." 
    & $codeExePath --install-extension $extension
}

Write-Host 'VS Code installed' -ForegroundColor Green

# install Git
Write-Host 'Installing git' -ForegroundColor Yellow
winget install Git.Git --silent

#copying settings
$dest = "$env:USERPROFILE/.gitconfig"
$gitconfig_url = "$baseRepo/settings/.gitconfig"
Invoke-WebRequest -Uri $gitconfig_url -OutFile $dest
Write-Host 'git installed' -ForegroundColor Green

# install Keepass
winget install KeePass --silent

# install Terminal
Write-Host "Installing Terminal" -ForegroundColor Yellow
winget install Microsoft.WindowsTerminal --silent

# copying settings
$dest = "$env:LocalAppData/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
$terminalconfig_url = "$baseRepo/settings/terminal.json"
Invoke-WebRequest -Uri $terminalconfig_url -OutFile $dest
Write-Host 'Terminal installed' -ForegroundColor Green

# install Firefox
$firefox_url = "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US"
$dest = [System.IO.Path]::GetTempFileName() + ".exe"
Invoke-WebRequest -Uri $firefox_url -OutFile $dest
& $dest /S
