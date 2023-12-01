# Recuperación de datos a través de un objeto SqlDataReader
# Crear objeto SqlConnection y definir cadena de conexión
$con = New-Object System.Data.SqlClient.SqlConnection
$con.ConnectionString = "Server=.; Database=CampingJCV2; Integrated Security=true"
$con.open()
# Cree el objeto SqlCommand, defina el texto del comando y establezca la conexión
$cmd = New-Object System.Data.SqlClient.SqlCommand
$cmd.CommandText = "SELECT TOP 3 Nombre, Apellido FROM Cliente2"
$cmd.Connection = $con
# Crear SqlDataReader
$dr = $cmd.ExecuteReader()
Write-Host
If ($dr.HasRows)
{
Write-Host Number of fields: $dr.FieldCount
Write-Host
While ($dr.Read())
{
Write-Host $dr["Nombre"] $dr["Apellido"]
}
}Else{
Write-Host The DataReader contains no rows.
}
Write-Host
# Cierra el lector de datos y la conexión.
$dr.Close()
$con.Close()