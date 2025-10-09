$archivo = "test.txt"

# Obtener la fecha actual en formato deseado
$fecha = Get-Date -Format "MM/dd/yyyy HH:mm:ss"

# Contenido a escribir
$contenido = "Run script: $fecha"

# Crear el archivo y escribir el contenido
$contenido | Out-File -FilePath $archivo -Encoding utf8

Write-Output "Script ejecutado a las $fecha" | Out-File -FilePath "C:\status_output.txt"