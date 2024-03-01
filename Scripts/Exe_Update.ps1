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

# Iterar sobre a lista de URLs e baixar os arquivos
foreach ($url in $urls) {
    $nomeArquivo = [System.IO.Path]::GetFileName($url)
    $caminhoCompleto = Join-Path -Path $destino -ChildPath $nomeArquivo
    Invoke-WebRequest -Uri $url -OutFile $caminhoCompleto -Credential $credenciais -AllowUnencryptedAuthentication
}