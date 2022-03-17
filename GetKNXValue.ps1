#obtiene todos los datos del KNX
function GetKNXValue {
    param ( $idgroup )
    $user = "user"
    $pass = "pass"
    $Headers = @{ Authorization = "Basic {0}" -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$pass))) }    

    $url = "http://IP-SERVER/scada-remote?m=json&r=grp&fn=find&alias=$($idgroup)"

    $obj = Invoke-WebRequest -Uri $url -Headers $Headers  -ContentType  'application/json; charset=utf-8'
    #write-host $obj

    #convierte a formato JSON para poder ser procesado
    $objectValue = ConvertFrom-Json $obj.content

    write-host $objectValue.value
    write-host $objectValue.id
    write-host $objectValue.name
    
   return $objectValue
}
