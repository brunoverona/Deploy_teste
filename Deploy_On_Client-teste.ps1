cls
$VerbosePreference = "Continue"
$ErrorActionPreference = "Stop"

#ALTERAÇÃO
Write-Verbose "Este script foi atualizado!"
Write-Verbose "Este script foi atualizado novamente!"
Write-Verbose "Este script foi atualizado novamente pela 3ª vez!"
Write-Verbose "Este script foi atualizado novamente pela 4ª vez!"
Write-Verbose "Este script foi atualizado novamente pela 5ª vez!"

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

# Obter nome da última versão do Portal(.zip) do bucket
$latest_zip = aws --profile Deploy s3api list-objects --bucket ecalc.deploy.develop --query "sort_by(Contents[?ends_with(Key, '.zip')], &Key) | [-1].Key" --output text


Write-Verbose "Concedendo acesso aos diretórios..."
ForEach ($dir in $dirs_array)
{
    $backupDir = $dir.backup + "\.."
    if (-Not(Test-Path $backupDir -PathType Container)) { 
        Write-Verbose "Criando diretorio de Backup..."
        Mkdir $backupDir
    }

    $acl_portal = Get-Acl $dir.portal
    $acl_backup = Get-Acl $backupDir

    # Forçando uma ACL (access-control list) com "Full Control"
    $acl_fullcontrol = New-Object System.Security.AccessControl.FileSystemAccessRule($deploy_user,"FullControl","ContainerInherit,ObjectInherit","None","Allow")

    $acl_portal.AddAccessRule($acl_fullcontrol)
    $acl_backup.AddAccessRule($acl_fullcontrol)

    Set-Acl $dir.portal $acl_portal
    Set-Acl $backupDir $acl_backup
}


Write-Verbose "Iniciando BKP instalação anterior..."
$local_bkp_date = Get-Date -Format "_yyyy-MM-dd_HH-mm-ss"
ForEach ($dir in $dirs_array)
{
    if (Test-Path $dir.portal -PathType Container) { 

        $dir_zip = $dir.backup + $local_bkp_date + ".zip"
        $files_zip = Get-ChildItem -Path $dir.portal -Exclude @("*log", "*.log")
        
        #Backup dos arquivos da versão anterior
        Write-Verbose "Compactando conteudo antigo em: $dir_zip"
        Compress-Archive -Path $files_zip -DestinationPath $dir_zip -Force
        
        ###INICIO Apagar/Limpar arquivos da versão anterior
        #Parar o IIS antes de excluir arquivos antigos, pra garantir que não vão estar em uso
        Write-Verbose "Parando IIS..."
        IISReset /STOP
        
        Write-Verbose "Limpando conteudo antigo..."
        Remove-Item -Path $dir.portal -Force -Recurse -Exclude "*.config", "*.json", "*.log", "*log", "constants.js"

        Write-Verbose "Iniciando IIS novamente..."
        IISReset /START
        ###FIM Apagar/Limpar arquivos da versão anterior
    }
}


if ( Test-Path $deploy_temp_dir -PathType Container) { 
    Remove-Item -Path $deploy_temp_dir -Force -Recurse 
}
New-Item -Path $deploy_temp_dir -ItemType "directory"

Write-Verbose "Download do Deploy no S3"
aws --profile Deploy s3 cp s3://ecalc.deploy.develop/$latest_zip $deploy_temp_dir

Write-Verbose "Download do Strut no S3"
aws --profile Deploy s3 cp s3://ecalc.deploy.develop/Strut.xml $deploy_temp_strut


#Executando o Strut nos BDs do Client
ForEach ($alias in $alias_array)
{
    Write-Verbose "Atualizando banco: $($alias.Alias)"
    & $xstrut_exec -r -f $deploy_temp_strut -b $alias.Alias -u $alias.User -p $alias.Password
}


Write-Verbose "Descompactando arquivo"
Expand-Archive $deploy_temp_dir$latest_zip -DestinationPath $deploy_temp_dir -Force
Remove-Item -Path $deploy_temp_dir* -Include *.zip


ForEach ($dir in $dirs_array)
{
    $dir_final = $dir.portal + "\"

    if (-Not(Test-Path $dir_final -PathType Container)) { 
        Write-Verbose "Recriando diretorio de instalacao..."
        Mkdir $dir_final
    }

    Write-Verbose "Copiando para o diretório: $dir_final"
    Copy-item -Force -Recurse -Verbose "$($deploy_temp_dir)\Portal_Release\*" -Destination $dir_final
    
    Write-Verbose "Executando a rotina de restauração LIBMAN no diretório: $dir_final"
    cd $dir_final
    libman restore
}

Write-Verbose "==========================================="
Write-Verbose ""