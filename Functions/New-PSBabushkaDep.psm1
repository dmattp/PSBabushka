#--*-Powershell-*--
Function New-PSBabushkaDep {
  Param (
    [Parameter(Mandatory=$False)]  [String]     $Name,
    [Parameter(Mandatory=$False)] [String[]]    $Requires,
    [Parameter(Mandatory=$False)] [String[]]    $RequiresWhenUnmet,
    [Parameter(Mandatory=$True)]  [ScriptBlock] $Met,
    [Parameter(Mandatory=$True)]  [ScriptBlock] $Meet,
    [Parameter(Mandatory=$False)] [ScriptBlock] $Before            = {},
    [Parameter(Mandatory=$False)] [ScriptBlock] $After             = {}
  )

  return @{
    Name              = if ($Name) { $Name } else { $psbabushka.psfilescriptname }
    Requires          = $Requires
    RequiresWhenUnmet = $RequiresWhenUnmet
    Met               = $Met
    Meet              = $Meet
    Before            = $Before
    After             = $After
    Path              = $MyInvocation.PSCommandPath
  }
}