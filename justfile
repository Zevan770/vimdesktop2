set windows-shell := ["pwsh.exe", "-NoLogo", "-Command"]

default:
  @just run-collect

run-collect:
  AutoHotkey64.exe vimd.ahk | Write-Host

run:
  ./scripts/ahk-console.ps1 ./vimd.ahk

