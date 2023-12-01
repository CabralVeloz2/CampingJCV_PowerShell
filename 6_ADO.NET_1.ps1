################# PRIMER EJEMPLO      

Import-Module SQLServer

$connectionString = "server=localhost;database=master;integrated security=true"
$sqlConnection = New-Object System.Data.SqlClient.SqlConnection($connectionString)

$sqlCommand = New-Object System.Data.SqlClient.SqlCommand("CREATE DATABASE Daniel1_PS", $sqlConnection)

$sqlConnection.Open()
$sqlCommand.ExecuteNonQuery()
$sqlConnection.Close()

Write-Host "Database Daniel1_PS creada correctamente."




######################################

Import-Module SQLServer

[String]$dbname = "Daniel2_PS";
 
# Abrir ADO.NET Connection con Windows authentification a local SQLSERVER.
$con = New-Object Data.SqlClient.SqlConnection;
$con.ConnectionString = "Data Source=.;Initial Catalog=master;Integrated Security=True;";
$con.Open();
 
# Select-Statement for AD group logins
$sql = "SELECT name
        FROM sys.databases
        WHERE name = '$dbname';";
 
# New command and reader.
$cmd = New-Object Data.SqlClient.SqlCommand $sql, $con;
$rd = $cmd.ExecuteReader();
if ($rd.Read())
{   
    Write-Host "Database $dbname ya existe";
    Return;
}
 
$rd.Close();
$rd.Dispose();
 
# Create the database.
$sql = "CREATE DATABASE [$dbname];"
$cmd = New-Object Data.SqlClient.SqlCommand $sql, $con;
$cmd.ExecuteNonQuery();     
Write-Host "Database $dbname creada!";
 
 
# Close & Clear all objects.
$cmd.Dispose();
$con.Close();
$con.Dispose();

# Si lanzo el Script por segunda vez 
# Database Daniel2_PS ya existe


###############################
# BORRAR BD CON ADO.NET     

$connectionString = "server=localhost;database=master;integrated security=true"
$sqlConnection = New-Object System.Data.SqlClient.SqlConnection($connectionString)

$sqlCommand = New-Object System.Data.SqlClient.SqlCommand("DROP DATABASE Daniel2_PS", $sqlConnection)

$sqlConnection.Open()


$confirm = Read-Host "¿Desea borrar la base de datos ? (S/N):"
if ($confirm -eq "S") {
  $sqlCommand.ExecuteNonQuery()
  Write-Host "Database Daniel2_PS borrada."
}

$sqlConnection.Close()
<#
¿Desea borrar la base de datos ? (S/N):: S
-1
Database Daniel2_PS borrada.

PS C:\Users\Daniel>
#>