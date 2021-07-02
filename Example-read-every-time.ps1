# Application (client) ID, tenant Name and secret
$clientID = "ID"
$tenantName = "TENANT.onmicrosoft.com"
$clientSecret = "SECRET"
$resource = "https://graph.microsoft.com/"

$ReqTokenBody = @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    client_Id     = $clientID
    Client_Secret = $clientSecret
} 

$TokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token" -Method POST -Body $ReqTokenBody
#write-host $TokenResponse


Function Get-AuthorizationHeader {
    <#
    .SYNOPSIS
    Gets bearer access token and builds REST method authorization header.
    .DESCRIPTION
    Uses Office 365 Application ID and Application Secret to generate an authentication header for Microsoft Graph.
    .PARAMETER AppId
    Microsoft Azure Application ID.
    .PARAMETER AppSecret
    Microsoft Azure Application secret.
    #>
    Param (
        [parameter(Mandatory = $true)]
        [string]$AppId,

        [parameter(Mandatory = $true)]
        [string]$AppSecret,

        [parameter(Mandatory = $true)]
        [pscredential]$Credential
    )

    $Uri = "https://login.microsoftonline.com/tunelcom.onmicrosoft.com/oauth2/v2.0/token"
    $Body = @{
        grant_type = 'password'
        username = $Credential.UserName
        password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Credential.Password))
        client_id = $AppId
        client_secret = $AppSecret
        scope = 'https://graph.microsoft.com/.default'
        redirect_uri = 'https://localhost/'
    }
    $AuthResult = Invoke-RestMethod -Method Post -Uri $Uri -Body $Body

    #Function output
    @{
        'Authorization' = 'Bearer ' + $AuthResult.access_token
        'Content-type'  = "application/json;odata.metadata=minimal;odata.streaming=true;IEEE754Compatible=false;charset=utf-8"
    }
}


#get all data from KNX 
function GetKNXValue {
    param ( $idgroup )

    $user = "USER"
    $pass = "PASSWORD"
    $Headers = @{ Authorization = "Basic {0}" -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$pass))) }    

    $url = "http://IP-SERVER/scada-remote?m=json&r=grp&fn=find&alias=$idgroup"

    $obj = Invoke-WebRequest -Uri $url -Headers $Headers  -ContentType  'application/json; charset=utf-8'
    write-host $obj

    #convert to JSON 
    $objValue = ConvertFrom-Json $obj.content

    write-host $objValue.value
    write-host $objValue.id
    write-host $objValue.name

    #insert into SPlist
    WiserKNX -idgroup $robjValue.name -value $objValue.value
}

#This function is for insert values into SharePoint List
function WiserKNX {
    param ($idgroup,$value)
    #if you use SharePoint List
    #$url = "https://graph.microsoft.com/v1.0/sites/$site/lists/$list/items"
    #Use this if you have SharePoint List in a group > REMEMBER to change IDGROUP and IDLIST
    $url = "https://graph.microsoft.com/v1.0/groups/IDGROUP/sites/root/lists/IDLIST/items"
    $newRow = "{ 'fields': {'Title': '"+$idgroup+"' ,'value': '"+$value+"'}}" 
    write-host $newRow
    Invoke-RestMethod -Headers @{Authorization = "Bearer $($Tokenresponse.access_token)"} -Uri $url -Method "POST" -Body $newRow -ContentType "application/json;charset=utf-8"
}

#EXAMPLES
#WiserKNX -idgroup "asdasd" -value "123"
#GetKNXValue -idgroup "1/1/1"
