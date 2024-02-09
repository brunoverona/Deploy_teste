$VerbosePreference = "Continue"
$ErrorActionPreference = "Stop"

# Para identificar os nomes dos recursos e se estão habilitados ou não, usar o comando:  Get-WindowsOptionalFeature -Online

# Lista dos recursos a serem habilitados
$featureList = @(
    "IIS-Metabase",
    "IIS-ManagementConsole",
    "IIS-ManagementScriptingTools",
    "IIS-ManagementService",
    "IIS-HttpLogging",
    "IIS-HttpCompressionDynamic",
    "IIS-HttpCompressionStatic",
    "IIS-ASP",
    "IIS-ASPNET45",
    "IIS-CGI",
    "IIS-NetFxExtensibility45",
    "IIS-ISAPIExtensions",
    "IIS-ISAPIFilter",
    "IIS-StaticContent",
    "IIS-DefaultDocument",
    "IIS-HttpErrors",
    "IIS-DirectoryBrowsing",
    "IIS-RequestFiltering"
)

# Habilita cada recurso da lista
foreach ($feature in $featureList) {
    Enable-WindowsOptionalFeature -Online -FeatureName $feature
}

# Confirma a conclusão da instalação
Write-Host "Recursos habilitados com sucesso."