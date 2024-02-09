cls
$VerbosePreference = "Continue"
$ErrorActionPreference = "Stop"

# Usuario que executa o Deploy (deve ser o mesmo que esta logado)
$deploy_user = "bruno"

# Diretórios a serem atualizados
$portal = "D:\Ecalc\Sistemas\Portal"

# Caminho do diretório onde estão os arquivos
$bkp_dir = "D:\Ecalc\Sistemas\BKP\"

# Obter o arquivo mais recente no diretório de BKP
$backup = Get-ChildItem -Path $bkp_dir | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Verificar se o arquivo mais recente foi encontrado
if ($backup -ne $null) {
    # Caminho completo do arquivo mais recente
    $bkp_path = $backup.FullName
    Write-Host "O arquivo mais recente é: $bkp_path"
} else {
    Write-Host "Nenhum arquivo encontrado no diretório especificado."
}

#Parar o IIS antes de excluir arquivos antigos, pra garantir que não vão estar em uso
Write-Verbose "Parando IIS..."
IISReset /STOP
       
Write-Verbose "Limpando conteudo antigo..."
Remove-Item -Path $portal\* -Recurse -Force

Write-Verbose "Iniciando IIS novamente..."
IISReset /START

Write-Verbose "Descompactando arquivo"
Expand-Archive $backup -DestinationPath $portal -Force
    
Write-Verbose "Executando a rotina de restauração LIBMAN no diretório: $portal"
cd $portal
libman restore

Write-Verbose "==========================================="
Write-Verbose ""