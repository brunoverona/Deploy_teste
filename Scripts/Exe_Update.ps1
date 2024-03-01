cls
$VerbosePreference = "Continue"
$ErrorActionPreference = "Stop"

# Lista de URLs para download
$urls = @(
    "http://ecalc.com.br/sistemas/EasyCalc.zip",
    "http://ecalc.com.br/sistemas/Express.zip",
    "http://ecalc.com.br/sistemas/pcp2.zip",
    "http://ecalc.com.br/sistemas/Strut.zip"
)

# Diretório onde você deseja salvar os arquivos
$destino = "D:\Ecalc\Exe\"

# Definir credenciais diretamente no script (substitua com suas credenciais)
$usuario = "ecalc"
$senha = ConvertTo-SecureString "folha" -AsPlainText -Force
$credenciais = New-Object System.Management.Automation.PSCredential($usuario, $senha)

# Executável do XStrut Console
$xstrut_exec = "D:\Ecalc\exe\XStrutCon.exe"

# Diretório do temporário para o Strut.xml
$deploy_temp_strut = "D:\Ecalc\Exe\Strut.xml"

# Bancos a serem reestruturados com Strut.xml no Client
$alias_array = @(
    [pscustomobject]@{Alias='OFAG';Password='masterkey';User='SYSDBA'}
)

# Iterar sobre a lista de URLs e baixar os arquivos
foreach ($url in $urls) {
    $nomeArquivo = [System.IO.Path]::GetFileName($url)
    $caminhoCompleto = Join-Path -Path $destino -ChildPath $nomeArquivo
    Invoke-WebRequest -Uri $url -OutFile $caminhoCompleto -Credential $credenciais -AllowUnencryptedAuthentication

Write-Verbose "Descompactando arquivos"
Expand-Archive $caminhocompleto -DestinationPath $destino -Force
Remove-Item -Path $destino* -Include *.zip
}

#Executando o Strut nos BDs do Client
ForEach ($alias in $alias_array)
{
    Write-Verbose "Atualizando banco: $($alias.Alias)"
    & $xstrut_exec -r -f $deploy_temp_strut -b $alias.Alias -u $alias.User -p $alias.Password
}