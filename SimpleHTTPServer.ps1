param(
    $uri              = "http://localhost:579",
    $targetController = ".\TestController.cs",
    $name             = "DefaultApi",
    $routeTemplate    = "api/{controller}/{id}",
    $options
)

.\LoadDlls.ps1

if(!$options -And $targetController -eq ".\TestController.cs") {
    $options = [PSCustomObject]@{id=[System.Web.Http.RouteParameter]::Optional}    
}

$conf = New-Object System.Web.Http.SelfHost.HttpSelfHostConfiguration $uri

[System.Web.Http.HttpRouteCollectionExtensions]::MapHttpRoute(
    $conf.Routes, 
    $name, 
    $routeTemplate, 
    $options) | Out-Null

$server = New-Object System.Web.Http.SelfHost.HttpSelfHostServer($conf)

try {    
    Add-Type -LiteralPath $targetController -ReferencedAssemblies (Resolve-Path "$pwd\libs\System.Web.Http.dll") -OutputAssembly "$pwd\controllers.dll" -ErrorAction SilentlyContinue
    Add-Type -Path "$pwd\controllers.dll" -ErrorAction SilentlyContinue
} catch {}

Write-Host @"
 URI              = $($uri)
 TargetController = $($targetController)
 RouteTemplate    = $($routeTemplate)
"@

$server.OpenAsync().Wait()

Read-Host

$server.CloseAsync() | Out-Null