# OPERACIONES SOBRE BD SQL SERVER USANDO POWERSHELL Y LIBRERIAS
# SMO - ADO.NET


# ADO.NET


# ADO.NET Ejecutando Procedimiento almacenado con parametros de entrada

<#
Ejecutando Procedimiento Almacenado desde T_SQL

-- EN SSMS
USE AdventureWorks2019
GO

-- VARIANTE 1
DECLARE @STARTPRODUCTID INT = 749
DECLARE @CHECKDATE DATETIME = '2010-05-26'
EXEC uspGetBillOfMaterials @STARTPRODUCTID, @CHECKDATE
GO

-- VARIANTE 2
EXECUTE [dbo].[uspGetBillOfMaterials] @StartProductID = 749, @CheckDate = '2010-05-26'
GO

#>

$Server = "localhost"
$Database = "CampingJCV_PS"

$SqlConn = New-Object System.Data.SqlClient.SqlConnection("Server = $Server; Database = $Database; Integrated Security = True;")

$SqlConn.Open()

# creamos objeto comando sobre la conexión a la BD AdventureWorks2019
$cmd = $SqlConn.CreateCommand()
# Propiedad CommandType
$cmd.CommandType = 'StoredProcedure'
# Propiedad CommandText
$cmd.CommandText = 'dbo.sp_ObtenerMunicipioPorCliente'

# Parametro de entrada @StartProductID
$p1 = $cmd.Parameters.Add('@ID_cliente',[int])
$p1.ParameterDirection.Input
$p1.Value = 1


# Almacenamos los resultados en una variable
$results = $cmd.ExecuteReader()

# Crea un objeto DataTable
$dt = New-Object System.Data.DataTable
$dt.Load($results)

# Cerramos la conexión 
$SqlConn.Close()

# Almacenamos los resulstados e un documento csv (comma separated value) y lo abrimos con NOTEPAD
$dt | Export-Csv -LiteralPath "C:\BD\sproc.txt" -NoTypeInformation
notepad C:\BD\sproc.txt



