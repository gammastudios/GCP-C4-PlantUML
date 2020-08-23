$cwd = Get-Location
$template_dir = Join-Path -Path (Split-Path -Path $cwd -Parent) -ChildPath "templates"
$examples_dir = Join-Path -Path (Split-Path -Path $cwd -Parent) -ChildPath "examples"

$startStr = "@startuml"
$pumlFile = Join-Path -Path $examples_dir -ChildPath "gcp-includes.puml"
New-Item $pumlFile -ItemType File -Force -Value $startStr | Out-Null
$commonStr = @"
!define GCPPuml https://raw.githubusercontent.com/gamma-data/GCP-C4-PlantUML/master/templates
!includeurl GCPPuml/C4_Context.puml
!includeurl GCPPuml/C4_Component.puml
!includeurl GCPPuml/C4_Container.puml
!includeurl GCPPuml/GCPC4Integration.puml
!includeurl GCPPuml/GCPCommon.puml

' COMMENT OUT OR REMOVE THE SERVICES BELOW THAT ARE NOT REQUIRED IN YOUR DIAGRAM
"@
Add-Content -Path $pumlFile -Value $commonStr

foreach ($file in Get-ChildItem -Path $template_dir -Recurse –File) {

$resourceName = $file.Name
$serviceName = (Split-Path (Split-Path $file.FullName -Parent) -leaf)

if ($serviceName -ne "templates") {
$inclStr = "!includeurl GCPPuml/${serviceName}/${resourceName}"
Add-Content -Path $pumlFile -Value $inclStr
}
}

$endStr = "@enduml"
Add-Content -Path $pumlFile -Value $endStr

