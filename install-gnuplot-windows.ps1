#Requires -RunAsAdministrator

function Find-Executable (
  [string] $command
) {
  $null -ne (Get-Command -Name $command -ErrorAction SilentlyContinue)
}

if (!(Find-Executable "kpsewhich")) {
  echo "TeX Liveがインストールされていません。"
  throw
}

if (!(Find-Executable "gnuplot")) {
  echo "gnuplotがインストールされていません。"
  throw
}

echo "スタイルファイルのインストール中"
$texmfPath = kpsewhich -var-value=TEXMFLOCAL
cd $texmfPath
mkdir gnuplot
cd gnuplot
gnuplot -e "set term tikz createstyle"

if (!(Test-Path "C:\Program Files\gnuplot\share\lua\gnuplot-tikz.lua")) {
  echo "luaの設定ファイルが存在しません。gnuplotが壊れている可能性があります。gnuplotを再インストールしてください。"
}

echo "luaの設定を変更中"
$luaFile = "C:\Program Files\gnuplot\share\lua\gnuplot-tikz.lua"
(Get-Content $luaFile) | %{ $_ -replace "^ *notimestamp = false,$", "  notimestamp = true," } | Set-Content $luaFile

mktexlsr

echo "gnuplot設定完了"
