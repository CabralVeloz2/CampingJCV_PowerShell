# get-executionpolicy
# set-executionpolicy unrestricted
# Crear Base de datos
# Lo primero es importar la librería de SQLServer (si no la tenemos)
Import-Module SQLSERVER

# Cargamos en una variable el nombre de nuestro equipo y la instancia
$instanceName = "localhost"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

# Comprobamos que no existe la base de datos , que queremos crear, listando las bases de datos de nuestro servidor
$server.Databases | Select Name, Status, Owner, CreateDate 
<#
Name                 Status Owner                  CreateDate        
----                 ------ -----                  ----------        
AdventureWorks2019   Normal DESKTOP-V8CLLV8\Daniel 28/09/2023 1:32:09
Camping_IN_MEMORY    Normal DESKTOP-V8CLLV8\Daniel 28/11/2023 1:02:27
CampingJCV           Normal DESKTOP-V8CLLV8\Daniel 30/11/2023 4:56:12
CampingJCV_filetable Normal DESKTOP-V8CLLV8\Daniel 23/11/2023 1:26:59
CampingJCV_particion Normal DESKTOP-V8CLLV8\Daniel 24/11/2023 4:52:54
CampingJCV_PS        Normal DESKTOP-V8CLLV8\Daniel 29/11/2023 4:38:00
CampingJCV2          Normal DESKTOP-V8CLLV8\Daniel 23/10/2023 2:22:20
Contenida_CampingJCV Normal DESKTOP-V8CLLV8\Daniel 04/11/2023 9:03:07
db_smo               Normal sa                     30/11/2023 5:10:09
master               Normal sa                     08/04/2003 9:13:36
model                Normal sa                     08/04/2003 9:13:36
msdb                 Normal sa                     08/10/2022 6:31:57
Northwind            Normal DESKTOP-V8CLLV8\Daniel 28/09/2023 6:34:43
pubs                 Normal DESKTOP-V8CLLV8\Daniel 28/09/2023 6:02:02
tempdb               Normal sa                     29/11/2023 4:34:28
WideWorldImporter... Normal DESKTOP-V8CLLV8\Daniel 28/09/2023 7:04:56
#>

# Creamos una BD nueva 
$dbName = "pruebaSMO"
$db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database($server, $dbName)
$db.Create()

# Comprobamos que esta creada
$server.Databases | Select Name, Status, Owner, CreateDate 
# pruebaSMO               Normal DESKTOP-V8CLLV8\Daniel 30/11/2023 22:42:31


# testar conectividad a una determinada Bd usando cmdlet Get-DbaDatabase de DBATOOLS

Get-DbaDatabase -SqlInstance localhost -Database pruebaSMO 

<#
PS C:\Users\Daniel> Get-DbaDatabase -SqlInstance localhost -Database pruebaSMO 
ADVERTENCIA: [22:43:31][Get-DbaDatabase] Failure | La cadena de certificación fue emitida por una entidad en la que no se confía
#>


$MyConnection = Connect-DbaInstance -SqlInstance LOCALHOST -TrustServerCertificate
Get-DbaDatabase -SqlInstance $MyConnection -Database PruebaSMO
<#
Name                 Status          Containment Type Recovery Model CompatLvl Collation                      Owner                    
----                 ------          ---------------- -------------- --------- ---------                      -----                    
pruebaSMO            Normal          None             Full                 160 Modern_Spanish_CI_AS           DESKTOP-V8CLLV8\Daniel   

#>



##########################
# BORRAR BD
$instanceName = "localhost"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName
$dbName = "pruebaSMO"

#need to check if database exists, and if it does, drop it
$db = $server.Databases[$dbName]
if ($db)
{
      #we will use KillDatabase instead of Drop
      #Kill database will drop active connections before 
	  #dropping the database
      # Usamos KillDatabase en lugar de DROP porque cierra conexion previamente
      $server.KillDatabase($dbName)
}

# testar conectividad a una determinada Bd usando cmdlet Get-DbaDatabase de DBATOOLS

Get-DbaDatabase -SqlInstance localhost -Database pruebaSMO

# no devuelve nada. No existe.


# Si da error 
$MyConnection = Connect-DbaInstance -SqlInstance LOCALHOST -TrustServerCertificate
Get-DbaDatabase -SqlInstance $MyConnection -Database PruebaSMO

# no devuelve nada. No existe.

#####################3

# Create SQL Server Database Using PowerShell and SQL Server Management Object (SMO)
# CREAR BD DE SQL SERVER USANDO PS Y SQL SERVER MANAGEMENT OBJECT (SMO)
# SI NO HUBIERAMOS IMPORTADO EL MODULO SQL SERVER PREVIAMENTE
# import SqlServer module
# Import-Module -Name "SqlServer"
 
# set instance and database name variables
$inst = "localhost"
$dbname = "SMO"  
 
# change to SQL Server instance directory  
# Set-Location SQLSERVER:\$inst        
 
# create object and database  
$db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -Argumentlist $inst, $dbname  
$db.Create()  
 
# set recovery model
$db.RecoveryModel = "simple"
$db.Alter()
 
# change owner
$db.SetOwner('sa')
 
# change data file size and autogrowth amount
foreach($datafile in $db.filegroups.files) 
{
 $datafile.size= 1048576
 $datafile.growth = 262144
 $datafile.growthtype = "kb"
 $datafile.alter()
}
 
# change log file size and autogrowth
foreach($logfile in $db.logfiles)
{
 $logfile.size= 524288
 $logfile.growth = 131072
 $logfile.growthtype = "kb"
 $logfile.alter()
} 
			
$SqlConn.Close()



# testar conectividad a una determinada Bd usando cmdlet Get-DbaDatabase de DBATOOLS

Get-DbaDatabase -SqlInstance localhost -Database smo

<#
Name                 Status           Size     Space  Recovery Compat. Owner                     Collation                      Containment 
                                            Available  Model     Level                                                          Type        
----                 ------           ---- ---------- -------- ------- -----                     ---------                      ------------
SMO                  Normal         1,5 GB 1021,64 MB Simple       150 sa                        Modern_Spanish_CI_AS           None        

#>

# Si da error 
$MyConnection = Connect-DbaInstance -SqlInstance LOCALHOST -TrustServerCertificate
Get-DbaDatabase -SqlInstance $MyConnection -Database smo
<#
Name                 Status          Containment Type Recovery Model CompatLvl Collation                      Owner                    
----                 ------          ---------------- -------------- --------- ---------                      -----                    
SMO                  Normal          None             Simple               160 Modern_Spanish_CI_AS           sa 
#>
