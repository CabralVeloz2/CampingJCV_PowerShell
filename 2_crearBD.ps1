# Arrancar el servicio
Start-Service "SQLSERVERAGENT"
# Almacena los BACKUPS en C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup
Backup-SqlDatabase -ServerInstance "localhost" -Database "CampingJCV_PS"
# Nombre del backup: CampingJCV_PS.bak
# Backup completo
$dt = Get-Date -Format yyyyMMddHHmmss
$instancename = "localhost"
$dbname = 'CampingJCV_PS'
Backup-SqlDatabase -Serverinstance $instancename -Database $dbname -BackupFile "c:\BACKUP\$($dbname)_db_$($dt).bak"
#Fin backupRestart-Service "MSSQLSERVER" -Force
# Borro la base de datos AQL_PRUEBA
Invoke-Sqlcmd -Serverinstance localhost -Query "Drop database CampingJCV_PS;"
#restore Restauro la base de datos
Restore-Sqldatabase -Serverinstance $instancename -Database $dbname -Backupfile "C:\BackupJCV\CampingJCV_PS.bak" -replacedatabas
#fin restore## Funciones
# Creamos una funcion para obtener el usuario actual
Function UsuarioActual
{ [System.Security.Principal.WindowsIdentity]::GetCurrent().Name }
# Ejecutamos la funcion
UsuarioActual
#-- DESKTOP-TAAB7EB\laurafunction Get-CurrentUsername {
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $username = $currentUser.Name.Split("\")[1]
    return $username
}

# Llama a la función y muestra el resultado
$currentUser = Get-CurrentUsername
Write-Host "El usuario actual es: $currentUser"
