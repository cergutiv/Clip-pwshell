$i = 0
#Poner que el input (video de entrada) y el output (video salida del comando) sean argumentos
if (Test-Path -Path .\mylist.txt) {
    Remove-Item .\mylist.txt
}
if ((Test-Path -Path .\clips) ) {
    Remove-Item -Recurse .\clips
}
if ((Test-Path -Path .\clips)) {
    mkdir .\clips
}

Get-Content .\lostiempos.txt | ForEach-Object {
    $tiempos = $_ -split " "
    $inicio = $tiempos[0] -split ":"
    $fin = $tiempos[1] -split ":"
    $tiempoInicio = [int]$inicio[0] * 3600 + [int]$inicio[1] * 60 + [int]$inicio[2]
    $tiempoFin = [int]$fin[0] * 3600 + [int]$fin[1] * 60 + [int]$fin[2] - $tiempoInicio - 2
    $nombre = '{0:d3}' -f $i++
    #mirar si $1 es el argumento 1
    ffmpeg -ss $tiempos[0] -to $tiempos[1] -i .\laberintoMikragor1.mp4 -vf "fade=t=in:st=0:d=2,fade=t=out:st=$tiempoFin\:d=2" -af "afade=t=in:st=0:d=2,afade=t=out:st=$tiempoFin\:d=2" -vcodec hevc_nvenc -b:v 7M -acodec aac -b:a 128k ".\clips\$nombre.mkv"
}
foreach ($i in Get-ChildItem .\clips\*.mp4) { Write-Output "file '$i'" | out-file -append -encoding ASCII mylist.txt }
ffmpeg -f concat -safe 0 -i mylist.txt -c copy output.mkv
Remove-Item .\mylist.txt
Remove-Item -Recurse .\clips