cls
$VerbosePreference = "Continue"
$ErrorActionPreference = "Stop"

# URL da API do GitHub para obter informações do arquivo
$githubApiUrl = "https://api.github.com/repos/brunoverona/Deploy_teste/contents/Deploy_On_Client.ps1"

# Usuario que executa o Deploy (deve ser o mesmo que esta logado)
$deploy_user = "bruno"

# Diretório do temporário para o Deploy
$deploy_temp_dir = "D:\Ecalc\temp_TESTE\Portal_Deploy\"

# Diretório do temporário para o Strut.xml
$deploy_temp_strut = "D:\Ecalc\temp_TESTE\Strut.xml"

# Executável do XStrut Console
$xstrut_exec = "D:\Ecalc\exe\XStrutCon.exe"

# Diretórios a serem atualizados
$dirs_array = @(
    [pscustomobject]@{
        portal="D:\Ecalc\Sistemas\Portal"; 
        backup="D:\Ecalc\Sistemas\BKP\Portal"}
)

# Bancos a serem reestruturados com Strut.xml no Client
$alias_array = @(
    [pscustomobject]@{Alias='OFAG';Password='masterkey';User='SYSDBA'}
)

Write-Verbose "INICIANDO $PSCommandPath"

& "$PSScriptRoot\Update_Deploy.ps1"
& "$PSScriptRoot\Deploy_On_client-teste.ps1"