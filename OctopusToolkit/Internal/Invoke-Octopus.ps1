    function Invoke-Octopus {
        param(
            $Uri,
            $Body,
           [ValidateSet("Get", "Put")]$Method = "Get",
            $OctopusUri = $env:OctopusUri,
            $OctopusApiKey = $env:OctopusApiKey
        )

        $absoluteUri = "{0}/{1}" -f $OctopusUri, $uri.Trim('/')
        Invoke-WebRequest -Uri $absoluteUri -Method $Method -Body ($Body | ConvertTo-Json) -Headers @{"X-Octopus-ApiKey" = $OctopusApiKey} -UseBasicParsing |  `
        % Content | ConvertFrom-Json
    }
