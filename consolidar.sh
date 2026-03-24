#!/bin/bash

RUTA_EPN1="$HOME/EPNro1"
ENTRADA="$RUTA_EPN1/entrada"
SALIDA="$RUTA_EPN1/salida"
PROCESADO="$RUTA_EPN1/procesado"

ARCHIVO_SALIDA="$SALIDA/$FILENAME.txt"

# Crea el archivo de salida si no existe
touch "$ARCHIVO_SALIDA"


for archivo in "$ENTRADA"/*.txt; do   #Para cada archivo .txt en la carpeta entrada hace lo siguiente
        [ -e "$archivo" ] || continue

        cat "$archivo" >> "$ARCHIVO_SALIDA"  #copia el contenido del archivo.txt en la carpeta entrada al archivo de salida.txt
        mv "$archivo" "$PROCESADO"           #mueve el archivo de la carpeta entrada a la carpeta de procesado
done


