# --*-Powershell-*--
Import-Module "$PSScriptRoot\Import-PSBabushkaDeps.psm1" -Force
Import-Module "$PSScriptRoot\Select-PSBabushkaDep.psm1" -Force
Import-Module "$PSScriptRoot\Invoke-PSBabushkaDep.psm1" -Force

Function Invoke-PSBabushka {
  Param (
    [Parameter(Mandatory=$True)]  [String] $Name,
    [Parameter(Mandatory=$False)] [String] $Path
  )

  if (-not $Path) { $Path = $env:PATH_BABUSHKA }
  if (-not $Path) { $Path = (Get-Location) }

  $PSBabushka.Deps = Import-PSBabushkaDeps -From $Path
  $PSBabushka.Dep = Select-PSBabushkaDep -Name $Name
  Invoke-PSBabushkaDep $PSBabushka.Dep
}
