# Script de sincronización directa al servidor Nginx
param(
    [string]$HostName = "54.81.134.211",
    [string]$User = "ubuntu",
    [string]$KeyPath = "$HOME\.ssh\patrick-key.pem"
)

Write-Host "Sincronizando archivos con el servidor $HostName..." -ForegroundColor Cyan

scp -i $KeyPath -o StrictHostKeyChecking=no "$PSScriptRoot\index.html" "$User@${HostName}:/var/www/html/index.html"

if ($LASTEXITCODE -eq 0) {
    ssh -i $KeyPath -o StrictHostKeyChecking=no "$User@$HostName" "sudo nginx -t && sudo systemctl reload nginx"
    Write-Host "Sincronización completada exitosamente." -ForegroundColor Green
    Write-Host "Ver sitio web: http://$HostName" -ForegroundColor Yellow
} else {
    Write-Host "Error al sincronizar archivos." -ForegroundColor Red
}
