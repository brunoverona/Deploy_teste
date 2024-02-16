Write-Host "==========================================="
Write-Host "INICIANDO $PSCommandPath"
Write-Host "Procedimento de atualização da Esteira Deploy."
Write-Host "==========================================="

# URL da API do GitHub para obter informações do arquivo
$githubApiUrl = "https://api.github.com/repos/brunoverona/Deploy_teste/contents/Deploy_On_Client.ps1"

# Caminho local do script
$scriptPath = "$PSScriptRoot\Deploy_On_Client.ps1"

# Obtém as informações do arquivo da API do GitHub
$fileInfo = Invoke-RestMethod -Uri $githubApiUrl -Method Get

# Calcula o hash SHA-256 do conteúdo local
$hashLocal = (Get-FileHash -Path $scriptPath -Algorithm SHA256).Hash

# Converte o conteúdo do GitHub de Base64 para texto
$contentGitHub = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($fileInfo.content))

# Calcula o hash SHA-256 do conteúdo no GitHub
$hashGitHub = (Get-FileHash -Algorithm SHA256 -InputStream ([System.IO.MemoryStream]::new([System.Text.Encoding]::UTF8.GetBytes($contentGitHub)))).Hash

# Compara os hashes para verificar se há uma alteração
if ($hashLocal -ne $hashGitHub) {
    # Baixa o conteúdo do arquivo diretamente do GitHub e sobrescreve o script local
    Invoke-WebRequest -Uri $fileInfo.download_url -OutFile $scriptPath
    Write-Host "O script foi atualizado com sucesso. Continuando com a execução do Deploy."
    Start-Sleep -Seconds 5
    
    #Executa o Deploy
    & $scriptpath

    } else {
        Write-Host "O script está atualizado. Continuando com a execução do Deploy."
        Start-Sleep -Seconds 5
        #Executa o Deploy
        & $scriptpath
    }