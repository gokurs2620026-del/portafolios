$folder = "c:\Users\USUARIO\Downloads\Trabajo"
$port = 8888

$listener = New-Object System.Net.HttpListener

# Primero obtener la IP local
$ipLocal = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notmatch "^127"} | Select-Object -First 1).IPAddress

# Agregar prefijos para localhost e IP local
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Prefixes.Add("http://$ipLocal`:$port/")

try {
    $listener.Start()
    Write-Host "Servidor activo en:" -ForegroundColor Green
    Write-Host "http://localhost:$port" -ForegroundColor Cyan
    Write-Host "http://$ipLocal`:$port" -ForegroundColor Yellow
    Write-Host "Presiona Ctrl+C para detener" -ForegroundColor Gray

    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $path = $request.Url.LocalPath
        if ($path -eq "/" -or $path -eq "") {
            $path = "/index.html"
        }
        
        $filePath = Join-Path $folder $path.TrimStart('/')
        
        if ((Test-Path $filePath) -and -not (Get-Item $filePath).PSIsContainer) {
            $buffer = [System.IO.File]::ReadAllBytes($filePath)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
        } else {
            $response.StatusCode = 404
            $buffer = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
        }
        
        $response.OutputStream.Close()
    }
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
} finally {
    $listener.Close()
    Write-Host "Servidor detenido" -ForegroundColor Green
}
