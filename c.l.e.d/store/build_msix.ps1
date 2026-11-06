# Builds build\msix\CLID.msix for the Microsoft Store from the Windows export in build\windows.
# Run after exporting the "CLID" (Windows) preset in Godot. Needs MakeAppx.exe from the Windows SDK.
# The package is left unsigned: the Microsoft Store signs it after certification.
param(
    [string]$Version = ""   # e.g. 1.0.1.0; leave empty to use the version in AppxManifest.xml
)
$ErrorActionPreference = "Stop"
$root   = Split-Path -Parent $PSScriptRoot                 # project folder (c.l.e.d)
$export = Join-Path $root "build\windows"
$src    = Join-Path $PSScriptRoot "msix"
$out    = Join-Path $root "build\msix"
$layout = Join-Path $out "layout"

if (-not (Test-Path (Join-Path $export "CLID.exe"))) { throw "No build\windows\CLID.exe. Export the Windows preset in Godot first." }

$makeappx = Get-ChildItem "${env:ProgramFiles(x86)}\Windows Kits\10\bin" -Recurse -Filter makeappx.exe -ErrorAction SilentlyContinue |
    Where-Object FullName -match '\\x64\\' | Sort-Object FullName -Descending | Select-Object -First 1
if (-not $makeappx) { throw "MakeAppx.exe not found. Install the Windows SDK." }

# Fresh layout: game files + manifest + logos.
if (Test-Path $layout) { Remove-Item $layout -Recurse -Force }
New-Item -ItemType Directory -Force $layout | Out-Null
Copy-Item (Join-Path $export "*") $layout -Recurse
Copy-Item (Join-Path $src "Assets") (Join-Path $layout "Assets") -Recurse
$manifest = Get-Content (Join-Path $src "AppxManifest.xml") -Raw
if ($Version) { $manifest = $manifest -replace '(<Identity[^>]*Version=")[^"]+(")', "`${1}$Version`${2}" }
[IO.File]::WriteAllText((Join-Path $layout "AppxManifest.xml"), $manifest, (New-Object Text.UTF8Encoding $false))

$msix = Join-Path $out "CLID.msix"
& $makeappx.FullName pack /o /d $layout /p $msix
if ($LASTEXITCODE -ne 0) { throw "MakeAppx failed ($LASTEXITCODE)." }
Write-Host "Built $msix"
