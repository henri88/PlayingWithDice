[CmdletBinding()]
Param (

    [parameter(Mandatory = $false)]
    [ValidateRange(1, [int]::MaxValue)]
    [int] $NumberOfDice = 2,
    [parameter(Mandatory = $false)]
    [ValidateRange(2, [int]::MaxValue)]
    [int] $NumberOfSides = 6,
    [ValidateRange(1, [int]::MaxValue)]
    [parameter(Mandatory = $false)]
    [int] $NumberOfTrials = 100,
    [parameter(Mandatory = $false)]
    [ValidateScript( { $_ -ge 0 -and $_ -lt $NumberOfSides })]
    [int] $RerollOnAndLowerThan = 0,
    [parameter(Mandatory = $false)]
    [ValidateScript( { $_ -ge 0 -and $_ -le ($NumberOfDice - 1) })]
    [int] $DropLowestNDice = 0

)

$testResults = [int[]]::new($NumberOfTrials)

For ( [int]$t = 0; $t -lt $NumberOfTrials; $t++) {
    $trialRolls = [int[]]::new($NumberOfDice)
    For ( [int]$d = 0; $d -lt $NumberOfDice; $d++) {
        $r = Get-Random -Minimum 1 -Maximum ($NumberOfSides + 1)
        Write-Debug "Rolled a $r"
        if ( $r -le $RerollOnAndLowerThan ) {            
            $r = Get-Random -Minimum 1 -Maximum ($NumberOfSides + 1)
            Write-Debug "Rerolled a $r"
        }
        $trialRolls[$d] = $r
    }
    $testResults[$t] = ($trialRolls | Sort-Object -Descending | Select-Object -First ( $NumberOfDice - $DropLowestNDice ) | Measure-Object -Sum).Sum
}

$avg = [int]($testResults | Measure-Object -Average).Average
return $avg