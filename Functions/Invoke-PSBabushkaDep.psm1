# --*-Powershell-*--
Import-Module "$PSScriptRoot\Select-PSBabushkaDep.psm1" -Force

Function Get-PSBabushkaInorderDeplist {
    Param (
        [Parameter(Mandatory=$True)] $Name,
        [Parameter(Mandatory=$False)] [HashTable] $previouslyRequired = [HashTable] @{}
    )

    $PSBabushkaDep = Select-PSBabushkaDep $name
    
    if ($PSBabushkaDep.Requires -ne $NULL) {
        $PSBabushkaDep.Requires | ForEach-Object {
            $dependencyName = $_
            if (-not $previouslyRequired.ContainsKey($dependencyName)) {
                # echo "adding <$dependencyName>"
                $previouslyRequired.Add($dependencyName, $true)
                Get-PSBabushkaInorderDeplist $dependencyName $previouslyRequired
            }
        }
    }

    $name
}


Function Invoke-PSBabushkaDepWithoutdeps {
  Param (
    [Parameter(Mandatory=$True)] [Hashtable] $PSBabushkaDep
  )
    
  $Name = $PSBabushkaDep.Name

  if($PSBabushkaDep.Met.Invoke()) {
    Write-Output "[$Name] - Already met!"
  } else {
      
    if ($PSBabushkaDep.RequiresWhenUnmet -ne $NULL) {
        $PSBabushkaDep.RequiresWhenUnmet | ForEach-Object {
            $depName = $_
            $depObject = Select-PSBabushkaDep -Name $depName
            if ($depObject) {
                Invoke-PSBabushkaDep $depObject
            } else {
                throw "Did find definition for dependency named '$depName'"
            }
        }
    }

    Write-Output "[$Name] - Not met. Meeting now."
    
    Invoke-Command $PSBabushkaDep.Before
    Invoke-Command $PSBabushkaDep.Meet
    Invoke-Command $PSBabushkaDep.After

    if ($PSBabushkaDep.Met.Invoke()) {
      Write-Output "[$Name] - Now met!"
    } else {
      throw "[$Name] - Still not met!"
    }
  }
}


Function Invoke-PSBabushkaDep {
    Param (
        [Parameter(Mandatory=$True)] [Hashtable] $PSBabushkaDep
    )

    $name = $PSBabushkaDep.name
    Get-PSBabushkaInorderDeplist $name | ForEach-Object {
        $depName = $_
        $depObject = Select-PSBabushkaDep -Name $depName
        if ($depObject) {
            Invoke-PSBabushkaDepWithoutdeps $depObject
        } else {
            throw "Did find definition for dependency named '$depName'"
        }
    }
}

