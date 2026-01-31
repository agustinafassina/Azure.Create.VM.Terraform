$archivo = "test.txt"

# Get the current date in the desired format
$fecha = Get-Date -Format "MM/dd/yyyy HH:mm:ss"

# Content to write
$contenido = "Run script at $fecha"

# Create the file and write the content
$contenido | Out-File -FilePath $archivo -Encoding utf8

Write-Output "Run script at $fecha" | Out-File -FilePath "C:\status_output.txt"