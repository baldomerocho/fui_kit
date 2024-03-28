#!/bin/bash

# Verificar los argumentos
if [ $# -ne 4 ]; then
    echo "Uso: $0 <nombre_archivo_saliente.dart> <nombre_clase> <carpeta_iconos> <prefijo_eliminar>"
    exit 1
fi

# Asignar argumentos a variables
dest_file="$1"
class_name="$2"
src_folder="$3"
prefix_to_remove="$4"

# Comprobación de existencia de la carpeta de origen
if [ ! -d "$src_folder" ]; then
  echo "La carpeta de origen $src_folder no existe."
  exit 1
fi

# Comprobación de existencia de archivos en la carpeta de origen
files=("$src_folder"*)
if [ ${#files[@]} -eq 0 ]; then
  echo "No hay archivos en la carpeta de origen $src_folder."
  exit 1
fi

# Eliminar el archivo de destino si ya existe
if [ -f "$dest_file" ]; then
  rm "$dest_file"
fi

# Crear el archivo de destino y escribir el encabezado
cat <<EOF > "$dest_file"
/*

Don't modify this file manually.
This file is generated automatically
by datogedon.com on $(date).

*/

/// [$class_name] contains the paths to the SVG icons.
EOF
echo "class $class_name {" >> "$dest_file"

# Mapear la carpeta y generar las propiedades estáticas
for file_path in "$src_folder"*; do
  if [ -f "$file_path" ]; then
    file_name=$(basename -- "$file_path" .svg)
    # Quitar los prefijos
    file_name_2=${file_name}
    file_name=${file_name#$prefix_to_remove}

    # Convertir de kebab-case a snake_case
    prop_name="$(echo $file_name | sed 's/.*/\ &/; s/-/_/g')"
    # Convertir a UPPER_CASE
    prop_name="$(echo $prop_name | tr '[:lower:]' '[:upper:]')"
    # Agregar comentario con el nombre del archivo SVG
    echo "  /// this icon is ${file_name_2}.svg" >> "$dest_file"
    # Definir la propiedad estática
    echo "  static const String $prop_name = '$file_path';" >> "$dest_file"
  fi
done

# Cerrar la clase y finalizar el archivo
echo "}" >> "$dest_file"

echo "El archivo $dest_file se ha generado exitosamente."
