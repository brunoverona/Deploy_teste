#IMPORTANTE! No computador local, executar o PowerShell(ADM) e rodar o seguinte comando(sem "#"):
# Set-Item WSMan:\localhost\Client\TrustedHosts -Value "192.168.1.180" -Force

# Configurações do servidor remoto
$serverAddress = "192.168.1.180"

# Solicitará suas credenciais
$credential = Get-Credential

# Caminho do script remoto no servidor
$remoteScriptPath = "C:\EcalcSistemas\DevLibrary\scripts\Deploy\Publish_Portal_Develop.ps1"

# Cria um ScriptBlock com o conteúdo do script remoto
$remoteCommand = {
    # Executar o script remoto
    & $using:remoteScriptPath
}

# Executa o comando remotamente no servidor
Invoke-Command -ComputerName $serverAddress -Credential $credential -ScriptBlock $remoteCommand

