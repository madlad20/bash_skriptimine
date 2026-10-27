#!/bin/bash
# =====================================================================
# Skript:  apache_paigaldus.sh
# Autor:   Chris-Luca Homenja, ITS24
# Kirjeldus: kontrollib, kas apache2 teenus on paigaldatud.
# =====================================================================

# Teenuse nimi on muutujas, et skripti saaks vajadusel ka teiste
# teenuste jaoks kasutada (piisab ainult selle rea muutmisest)
TEENUS=apache2

# dpkg-query -W -f='${Status}' annab paketi oleku, nt "install ok installed".
# grep -c loeb, mitu rida sisaldab teksti "ok installed":
#   1 - pakett on paigaldatud, 0 - paketti ei ole paigaldatud
# 2>/dev/null peidab veateate juhul, kui paketti pole kunagi paigaldatud
PAIGALDATUD=$(dpkg-query -W -f='${Status}' $TEENUS 2>/dev/null | grep -c "ok installed")

echo "$TEENUS - leitud ridu 'ok installed': $PAIGALDATUD"
