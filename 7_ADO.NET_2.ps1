# OPERACIONES SOBRE BD SQL SERVER USANDO POWERSHELL Y LIBRERIAS
# SMO - ADO.NET


# ADO.NET

### Prueba Conexión BD

# USANDO CONTROL DE EXCEPCIONES try-catch
try
{
    $connString = "Data Source=.;Database=CampingJCV_PS;User ID=sa;Password=123"
    $conn = New-Object System.Data.SqlClient.SqlConnection $connString
    $conn.Open()

    if($conn.State -eq "Open")
    {
        Write-Host "Test connection successful - Conectado"
        $conn.Close()
    }

}
catch
{

    Write-Host "Test connection failed - No Conectado"

}


########################
# CONEXION CON ADO-NET USANDO FUNCIÓN

# Primero creamos la función 
Function GetDataFromMSSQL {
    Write-Host "====================================="
    $sqlConn = New-Object System.Data.SqlClient.SqlConnection
    $sqlConn.ConnectionString = "Server=localhost;Integrated Security=true;Initial Catalog=CampingJCV_PS;"
    
    try {
        $sqlConn.Open()
        Write-Host "Data Source is connected.Fuente de datos conectada"
        $sqlcmd = New-Object System.Data.SqlClient.SqlCommand
        $sqlcmd.Connection = $sqlConn
        $selectQuery = "SELECT TOP 2 [ID_cliente],[DNI],[Nombre],[Apellido],[Email],[Direccion] FROM [CLIENTE]"
        $sqlcmd.CommandText = $selectQuery
        $sqladp = New-Object System.Data.SqlClient.SqlDataAdapter $sqlcmd
        $data = New-Object System.Data.DataSet
        $sqladp.Fill($data) | Out-Null
        $rowCount = $data.Tables[0].Rows.Count
        Write-Host "$rowCount rows returned.Número de filas devueltas"
        $data.Tables
        $true
    } catch {
        Write-Host "Data Source cannot be connected."
        Write-Host $Error[0].Exception.Message
        $false
    } finally {
        $sqlConn.Close()
    }
};

# Ejecutar Función
GetDataFromMSSQL

<#
=====================================
Data Source is connected.Fuente de datos conectada
2 rows returned.Número de filas devueltas


ID_cliente : 1
DNI        : 123456789
Nombre     : Juan
Apellido   : Pérez
Email      : juan@example.com
Direccion  : Calle Principal 123

ID_cliente : 2
DNI        : 987654321
Nombre     : María
Apellido   : González
Email      : maria@example.com
Direccion  : Avenida Secundaria 456

True
#>
#######################################################

# Recuperando datos a traves de un Objeto SqlDataReader 
# Creamos un objeto Conexion y definimos una connection string (cadena de conexión)
$con = New-Object System.Data.SqlClient.SqlConnection
$con.ConnectionString = "Server=.; Database=CampingJCV_PS;   Integrated Security=true"
$con.open()

# Creamos un objeto comando, definimos el texto del comando y establecemos la conexión 
# Create SqlCommand object, define command text, and set the connection
$cmd = New-Object System.Data.SqlClient.SqlCommand
$cmd.CommandText = "SELECT TOP 10 ID_municipio, Municipio FROM MUNICIPIO"
$cmd.Connection = $con

# Creamos un objeto  SqlDataReader
$dr = $cmd.ExecuteReader()

Write-Host

If ($dr.HasRows)
{
  Write-Host Numero de Campos: $dr.FieldCount
  Write-Host
  While ($dr.Read())
  {
    Write-Host $dr["ID_municipio"] $dr["Municipio"]
  }
}
Else
{
  Write-Host El conjunto de Datos (DataReader) no contiene Filas.
}

Write-Host

# Cerramos el lector de datos y la conexión
# Close the data reader and the connection
$dr.Close()
$con.Close()

<#
Numero de Campos: 2

1 Barcelona
2 Castelldefels
3 Hospitalet
4 Arteixo
5 Carballo
6 Finisterra
7 Ferrol
8 Oleiros
#>

#######################################################3