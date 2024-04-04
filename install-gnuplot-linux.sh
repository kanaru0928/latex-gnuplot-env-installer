#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "管理者権限を付けて実行してください(sudo)。"
  exit 1
fi

existsCommand () {
  command -v $1 > /dev/null 2>&1
}

if ! existsCommand "kpsewhich"; then
  echo "TeX Liveがインストールされていません。"
  exit 1
fi

if ! existsCommand "gnuplot"; then
  echo "gnuplotがインストールされていません。"
  exit 1
fi

echo "スタイルファイルのインストール中"

cd $(kpsewhich -var-value=TEXMFLOCAL)
sudo mkdir gnuplot
cd gnuplot
sudo gnuplot -e "set term tikz createstyle"

if [ ! -f /usr/share/gnuplot/gnuplot/*/lua/gnuplot-tikz.lua ]; then
  echo "luaの設定ファイルが存在しません。gnuplotが壊れている可能性があります。gnuplotを再インストールしてください。"
  exit 1
fi

echo "luaの設定を変更中"
sudo sed -i -E '/^ *notimestamp *=/s/false/true/' /usr/share/gnuplot/gnuplot/*/lua/gnuplot-tikz.lua

sudo mktexlsr

echo "gnuplot設定完了"
