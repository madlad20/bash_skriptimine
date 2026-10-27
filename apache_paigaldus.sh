#!/bin/bash
# =====================================================================
# Skript:  apache_paigaldus.sh
# Autor:   Chris-Luca Homenja, ITS24
# Kirjeldus: kontrollib, kas apache2 teenus on paigaldatud.
#   - kui EI OLE paigaldatud, siis paigaldab selle
#   - kui ON paigaldatud, siis annab sellest teada ja naitab staatust
# Kasutamine (root kasutajana):
#   chmod +x apache_paigaldus.sh
#   ./apache_paigaldus.sh   voi   sh apache_paigaldus.sh
# =====================================================================

# Teenuse nimi on muutujas, et skripti saaks vajadusel ka teiste
# teenuste jaoks kasutada (piisab ainult selle rea muutmisest)
TEENUS=apache2

# Paigaldamiseks on vaja root oigusi - id -u annab rootile 0
if [ "$(id -u)" -ne 0 ]; then
    echo "Viga: skript tuleb kaivitada root kasutajana!"
    exit 1
fi

# dpkg-query -W -f='${Status}' annab paketi oleku, nt "install ok installed".
# grep -c loeb, mitu rida sisaldab teksti "ok installed":
#   1 - pakett on paigaldatud, 0 - paketti ei ole paigaldatud
# 2>/dev/null peidab veateate juhul, kui paketti pole kunagi paigaldatud
PAIGALDATUD=$(dpkg-query -W -f='${Status}' $TEENUS 2>/dev/null | grep -c "ok installed")

# Tingimuslause: kui leitud ridu on 0, siis teenus puudub
if [ "$PAIGALDATUD" -eq 0 ]; then
    echo "$TEENUS ei ole paigaldatud. Alustan paigaldamist..."
    # Uuendame paketiloendi, et saada paketi uusim versioon
    apt-get update
    # Paigaldame teenuse, -y vastab koigile kusimustele automaatselt "jah"
    apt-get install -y $TEENUS
    # Kontrollime uuesti, kas paigaldus onnestus
    if dpkg-query -W -f='${Status}' $TEENUS 2>/dev/null | grep -q "ok installed"; then
        echo "$TEENUS on edukalt paigaldatud!"
        # Lubame teenuse automaatse kaivitumise ja kaivitame selle
        systemctl enable --now $TEENUS
        # Naitame teenuse staatust (--no-pager - valjund otse ekraanile)
        systemctl status $TEENUS --no-pager
    else
        echo "Viga: $TEENUS paigaldamine ebaonnestus!"
        exit 1
    fi
else
    # Teenus on juba olemas - anname teada ja naitame staatust
    echo "$TEENUS on juba paigaldatud."
    echo "Teenuse $TEENUS staatus:"
    systemctl status $TEENUS --no-pager
fi
