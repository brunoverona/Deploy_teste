# Verifica se o .NET Framework 4.8 (ou mais recente) está instalado

# Define a versão mínima do .NET Framework desejada
$versaoMinima = '4.8'

# Obtém as versões instaladas do .NET Framework
$versoesInstaladas = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
                    Get-ItemProperty -Name Version -ErrorAction SilentlyContinue |
                    Where-Object { $_.Version -match '^(\d+\.\d+)' } |
                    ForEach-Object { $Matches[1] }

# Verifica se a versão mínima está instalada
if ($versoesInstaladas -contains $versaoMinima) {
    Write-Host ".NET Framework $versaoMinima (ou mais recente) está instalado."
} else {
    Write-Host ".NET Framework $versaoMinima (ou mais recente) não está instalado."

    # Pergunta ao usuário se deseja instalar o .NET Framework
    $resposta = Read-Host "Deseja instalar o .NET Framework $versaoMinima (ou mais recente)? (y/n)"

    if ($resposta -eq 'y') {
        # Inicia o processo de instalação
        $urlInstalacao = 'https://download.visualstudio.microsoft.com/download/pr/1d82b4da-b688-43b0-8366-36976f618787/e84b26c62477c4608c94b38f82fdedc0/ndp48-x86-x64-allos-enu.exe'
        Start-Process -FilePath $urlInstalacao -Wait
    } else {
        Write-Host "Instalação do .NET Framework cancelada pelo usuário."
    }
}
