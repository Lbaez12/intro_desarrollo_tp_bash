#exportamos la ruta /home/usuarioX para no hardcodear 
RUTA_EPN1="$HOME/EPNro1"
export RUTA_EPN1

#exportamos FILENAME
export FILENAME="datos_alumnos"


#parámetro optativo -d) Si el usuario corre el script con el parámetro optativo -d se borrará 
#todo el entorno creado en la carpeta EPNro1 y se matarán los procesos creados en 
#background.

if [[ "$1" == "-d" ]]; then
    #borramos el entorno RPNro1(rm) de forma recursiva (-r)
    rm -r $RUTA_EPN1
    #matamos los procesos creados (pkill)
    pkill -f consolidar.sh
fi

#Crea el entorno si aun no esta creado y copia el archivo consolidar.sh dentro del mismo
#Lo del consolidar es ya que si se ejecuta el programa con el parametro optativo se borra todo el entorno junto con el archivo consolidar
#por lo que para evitar perder el archivo, al crear el entorno de la nada, se copia el archivo que fue antes creado y almacenado en home
generar_entorno(){
    mkdir -p $RUTA_EPN1/{entrada,salida,procesado}
    cp consolidar.sh $RUTA_EPN1
    echo ""
    echo "El entorno ha sido creado..."
    echo ""
}


#Muestra el menu
mostrar_menu(){
    echo "//////////MENU//////////"
    echo ""
    echo "1) Crear entorno"
    echo "2) Correr proceso"
    echo "3) Mostrar alumnos"
    echo "4) Mostrar las 10 notas más altas"
    echo "5) Mostrar los datos de un alumno"
    echo "6) Salir"
}
#Muestra todos los alumnos en el padron ordenados por numero de padron (k1 = columna 1 = nro de padron, -n para indicar que es un numero)
mostrar_padron(){
    if [[ -f  /$RUTA_EPN1/salida/$FILENAME.txt ]]; then
        echo "Alumnos en padron: "
        sort -k 1 -n /$RUTA_EPN1/salida/$FILENAME.txt
    else
        echo "El archivo no existe"
    fi
}

#Funcion para mostrar el top 10 alumnos con mejores notas (k5 = columna 5 = notas)(-n para indicar que es un numero)(r = en orden descendente) (head -n 10 = se queda solo con 
#los primeros 10)
mostrar_alumnos(){

        if [[ -f /$RUTA_EPN1/salida/$FILENAME.txt ]]; then
                echo "Top 10 notas mas altas: "
                sort -k 5 -n -r /$RUTA_EPN1/salida/$FILENAME.txt | head -n 10
        else
                echo "El archivo no existe"
        fi
}

#funcion que solicita al usuario el numero de padron y muestra los datos del alumno (grep --> busca el nro de padron en el archivo salida)
solicitar_numero(){
    if [[ -f /$RUTA_EPN1/salida/$FILENAME.txt ]]; then
    read -p "Ingrese el numero de padron para obtener los sus datos: " nropadron
    grep "^$nropadron " /$RUTA_EPN1/salida/$FILENAME.txt
    fi
}





while true;do

   echo ""
    mostrar_menu

    read -p "seleccione una opcion : " opcion

   echo ""
    case $opcion in
        1)  #crear entorno 
            generar_entorno
            ;;
        2)  #correr proceso (& permite que el menu siga apareciendo aunque se haya ejecutado otro script)
                bash "$RUTA_EPN1/consolidar.sh" &
                echo "Proceso ejecutándose en background..."
                echo "El proceso se completo..."
            ;;
        3)  #(si esta el archivo) listado de alumnos ordenados por número de padrón
            mostrar_padron
	    echo ""
            read -p "Presione cualquier tecla para volver al menu..."  #Pauso la funcion asi el usuario puede ver el padron y luego continuar
            ;;
        4)  #(si esta el archivo) 10 notas más altas del listado
            mostrar_alumnos
            echo ""
            read -p "Presione cualquier tecla para volver al menu..."
            ;;
        5)  #(si esta el archivo)  Solicitar al usuario un nro de padrón, y mostrar por pantalla, los datos del mismo provenientes del archivo FILENAME.txt 
            solicitar_numero
            echo ""
            read -p "Presione cualquier tecla para salir del menu..."
            ;;
        6)  echo "has salido del menu..."
            echo ""
            break
            ;;
    esac


 done
