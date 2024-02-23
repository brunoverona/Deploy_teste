# Obtém todos os sites no IIS
$sites = Get-Website

# Itera sobre cada site
foreach ($site in $sites) {
    Write-Host "Site: $($site.Name)"

    # Obtém todas as aplicações do site
    $applications = Get-WebApplication -Site $site.Name

    # Exibe o nome de cada aplicação
    foreach ($app in $applications) {
        Write-Host "  Nome da Aplicação: $($app.Path)"
    }

    Write-Host "`n"  # Adiciona uma linha em branco entre os sites para melhor legibilidade
}
