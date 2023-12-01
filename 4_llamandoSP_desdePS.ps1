# LLAMANDO UN SP DESDE PS

# PRIMERO HAY QUE EJECUTAR EL SCRIPT EN SQL SERVER PARA CREAR EL SP

Invoke-Sqlcmd -ServerInstance "localhost" -Database CampingJCV_PS -Query "sp_NumeroTotalClientes"

<#
NumeroTotalClientes
-------------------
                 10
#>

Invoke-Sqlcmd -ServerInstance DESKTOP-V8CCLV8 -Database CampingJCV_PS -Query "sp_NumeroTotalClientes"

<#
NumeroTotalClientes
-------------------
                 10
#>

Invoke-Sqlcmd -ServerInstance localhost -Database CampingJCV_PS -Query "sp_NumeroTotalClientes" -TrustServerCertificate

<#
ERROR
Invoke-Sqlcmd : No se encuentra ningún parámetro que coincida con el nombre del parámetro 'TrustServerCertificate'.
En línea: 1 Carácter: 97
+ ... CampingJCV_PS -Query "sp_NumeroTotalClientes" -TrustServerCertificate
+                                                   ~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidArgument: (:) [Invoke-Sqlcmd], ParameterBindingException
    + FullyQualifiedErrorId : NamedParameterNotFound,Microsoft.SqlServer.Management.PowerShell.GetScriptCommand
#>


$results = Invoke-Sqlcmd -ServerInstance localhost -Database tempdb -Query "CustomerSales" -TrustServerCertificate
foreach ($sale in $results) {Write-Host("Customer: " + $sale.CustomerID + ", TotalSale:$" +$sale.totalsale)}

$results = Invoke-Sqlcmd -ServerInstance localhost -Database CampingJCV_PS -Query "sp_SumarClientesPorMunicipio" 
foreach ($cliente in $results) {Write-Host("Municipio: " + $cliente.ID_municipio + " ,Tiene una" +" CantidadClientes=$" +$cliente.CantidadClientes)}


<#
Municipio: 1 ,Tiene una CantidadClientes=$2
Municipio: 2 ,Tiene una CantidadClientes=$2
Municipio: 3 ,Tiene una CantidadClientes=$2
Municipio: 4 ,Tiene una CantidadClientes=$2
Municipio: 5 ,Tiene una CantidadClientes=$2
Municipio: 6 ,Tiene una CantidadClientes=$0
Municipio: 7 ,Tiene una CantidadClientes=$0
Municipio: 8 ,Tiene una CantidadClientes=$0
#>


$results = Invoke-Sqlcmd -ServerInstance localhost -Database CampingJCV_PS -Query "sp_SumarClientesPorMunicipio" 
$results | Select-Object ID_municipio, CantidadClientes | out-file c:\procesos.txt
notepad c:\procesos.txt

$results = Invoke-Sqlcmd -ServerInstance localhost -Database CampingJCV_PS -Query "sp_SumarClientesPorMunicipio" 
$results | Select-Object ID_municipio, NombreMunicipio, CantidadClientes | Export-Csv -Path "c:\municipios.csv" -NoTypeInformation
notepad c:\municipios.csv

# Calling Procs from PowerShell with Parameters

$results = Invoke-Sqlcmd -ServerInstance localhost -Database AdventureWorks2019 -Query "uspGetBillOfMaterials" 
$results 

<#
Invoke-Sqlcmd : Procedure or function 'uspGetBillOfMaterials' expects parameter '@StartProductID', which was not supplied. 
 Mensaje 201; nivel 16; estado 4; procedimiento uspGetBillOfMaterials; línea 0.

#>


$results = Invoke-Sqlcmd -ServerInstance localhost -Database AdventureWorks2019 -Query "[dbo].[uspGetBillOfMaterials] @StartProductID = 749, @CheckDate = '2010-05-26'" 
$results 

<#
ProductAssemblyID : 401
ComponentID       : 524
ComponentDesc     : HL Spindle/Axle
TotalQuantity     : 1,00
StandardCost      : 0,0000
ListPrice         : 0,0000
BOMLevel          : 3
RecursionLevel    : 2

#>

$productid = 749
$checkdate = "2010-05-26"
$results = Invoke-Sqlcmd -ServerInstance localhost -Database AdventureWorks2019 -Query "[dbo].[uspGetBillOfMaterials] @StartProductID = $productid, @CheckDate = '$checkdate'" -TrustServerCertificate
$results | Export-Csv -Path "c:\BACKUP\sproc.csv" -NoTypeInformation
notepad c:\BACKUP\sproc.csv


############################3

# ADO.NET Ejecutando Procedimiento almacenado con parametros de entrada

$Server = "localhost"
$Database = "AdventureWorks2019"

$SqlConn = New-Object System.Data.SqlClient.SqlConnection("Server = $Server; Database = $Database; Integrated Security = True;")

$SqlConn.Open()
$cmd = $SqlConn.CreateCommand()
$cmd.CommandType = 'StoredProcedure'
$cmd.CommandText = 'dbo.uspGetBillOfMaterials'
$p1 = $cmd.Parameters.Add('@StartProductID',[int])
$p1.ParameterDirection.Input
$p1.Value = 749
$p2 = $cmd.Parameters.Add('@CheckDate',[DateTime])
$p2.ParameterDirection.Input
$p2.Value = '2010-05-26'
$results = $cmd.ExecuteReader()
$dt = New-Object System.Data.DataTable
$dt.Load($results)

$SqlConn.Close()
$dt | Export-Csv -LiteralPath "C:\sproc.txt" -NoTypeInformation
notepad C:\sproc.txt














