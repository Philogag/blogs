
$hosts=(
    "github.com",
    "raw.githubusercontent.com",
    "assets-cdn.github.com",
    "github.global.ssl.fastly.net"
)

#### use https://geo.ipify.org/ api to get domain ip
$apikey="at_4LQunUcDLPt7fhpmmR0HEslDISFpT"
$hostfile = [System.Collections.ArrayList](Get-Content "C:\Windows\System32\drivers\etc\hosts")

foreach ($h in $hosts) {
    Write-Host "${h}:"
    $jsontext = curl -Uri "https://geo.ipify.org/api/v1?apiKey=${apikey}&domain=${h}" | Select -ExpandProperty Content
    $data = ConvertFrom-Json -InputObject $jsontext
    $hip = $data.ip
    Write-Host "  -> $hip"

    # $hostfile.GetType()
    foreach ($line in $hostfile)
    {
        if ($line -match "^\d+\.\d+\.\d+\.\d+ $h # auto_update$")
        {
            $hostfile.Remove($line)
            break
        }
    }

    $newlineid = $hostfile.Add("$hip $h # auto_update")
    Write-Host "  -> replace ok"
}

$hostfile | Out-File "C:\Windows\System32\drivers\etc\hosts"