# --*-Powershell-*--
Import-Module "$PSScriptRoot\New-PSBabushkaDep.psm1" -Force

Function Import-PSBabushkaDeps {
  Param (
    [Parameter(Mandatory=$True)] [String] $From
  )

  $PSBabushkaDepFiles = Get-ChildItem -Path $From -File -Include "*.Dep.ps1" -Recurse
    $PSBabushkaDepFiles | ForEach-Object {
        $psbabushka.psfilescriptname = $null 
        if ($_.name -match '(.*)\.dep.ps1') {
            $psbabushka.psfilescriptname = $matches[1]
        }
        Invoke-Expression $_.FullName
    }
}