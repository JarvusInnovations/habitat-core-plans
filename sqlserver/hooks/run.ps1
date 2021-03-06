Start-Service 'MSSQL${{cfg.instance}}'
Write-Host "{{pkg.name}} is running"

try {
    while($(Get-Service 'MSSQL${{cfg.instance}}').Status -eq "Running") {
        Start-Sleep -Seconds 1
    }
} finally {
    $currentStatus = (Get-Service 'MSSQL${{cfg.instance}}').Status
    if($currentStatus -eq "Running") {
        Write-Host "{{pkg.name}} stopping..."
        Stop-Service 'MSSQL${{cfg.instance}}'
        $currentStatus = (Get-Service 'MSSQL${{cfg.instance}}').Status
    }
    if($currentStatus -eq "StopPending") {
        Write-Host "Waiting for {{pkg.name}} to stop..."
        while($currentStatus -eq "StopPending") {
            Start-Sleep -Seconds 5
            $currentStatus = (Get-Service 'MSSQL${{cfg.instance}}').Status
        }
    }
    Write-Host "{{pkg.name}} has stopped"
}
