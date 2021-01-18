<#
Created:	 11-05-2020
Version:	 1.0
Author       Christian Kusabs    
 
Description: Given a Computer name and a secret, will add them together using bitwise
             XOR function and hash the result. Will then convert to an ASCII password
             that is usable.

#>

function New-Password {
    param(
        [string[]] $compname,
        [string[]] $secret
    )
    
    $hexresult = ""
    $result = ""
    $textToHash = ""
    $convertedString = ""

    for ($i=0; $i -lt $computer.length; $i++) {
        $textToHash += ([int] (($computer.Substring($i, 1)) -replace '\D') -bxor ([int] (($secret.Substring($i, 1)) -replace '\D')))
    }

    $hasher = new-object System.Security.Cryptography.SHA512CryptoServiceProvider
    $toHash = [System.Text.Encoding]::UTF8.GetBytes($textToHash)
    $hashByteArray = $hasher.ComputeHash($toHash)
    foreach($byte in $hashByteArray) {
        $result += "{0:X2}" -f $byte
    }
    
    $result = $result.Substring(25,24)

    for ($i = 0;$i -lt $result.length;$i += 2) {

        [int]$hextemp = [char]([convert]::toint16($result.Substring($i, 2),16))

        while ($hextemp -gt 122) {
            $hextemp -= 122
        }

        if ($hextemp -lt 33) {
            $hextemp += 97
        }

        $hexresult += [Convert]::ToString($hextemp, 16)

    }


    for ($i = 0;$i -lt $hexresult.length;$i += 2) {
        $convertedString += [char]([convert]::toint16($hexresult.Substring($i,2),16))
    }

    return $convertedString
}

Export-ModuleMember -Function New-Password
