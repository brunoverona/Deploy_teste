cls
$VerbosePreference = "Continue"
$ErrorActionPreference = "Stop"

<# ! PARA FUNCIONAMENTO DESSE SCRIPT É NECESSÁRIO TER CONFIGURADO A CREDENCIAL AWS "Deploy" segundo manual:
https://docs.google.com/document/d/1HOJ1H16BMm8AaMj6MWpZbv_ozDDop5znCekF4zs7epM/edit#heading=h.jqe18ed4phwf ! #>

# Diretório do Download
$download_dir = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"

# Obter nome da última versão do Portal(.zip) do bucket
$latest_zip = aws --profile Deploy s3api list-objects --bucket ecalc.deploy.develop --query "sort_by(Contents[?ends_with(Key, '.zip')], &Key) | [-1].Key" --output text

Write-Verbose "Iniciando download em $download_dir"

Write-Verbose "Download do Deploy no S3"
aws --profile Deploy s3 cp s3://ecalc.deploy.develop/$latest_zip $download_dir

Write-Verbose "Download do Strut no S3"
aws --profile Deploy s3 cp s3://ecalc.deploy.develop/Strut.xml $download_dir

Write-Verbose "Download finalizado."