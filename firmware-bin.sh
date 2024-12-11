#!/bin/sh

BYellow='\033[1;33m'
BGreen='\033[1;32m'
BRed='\033[1;31m'
BCyan='\033[1;36m'
NC='\033[0m'

# Имя файла для прошивки, содержится в каталоге <project_folder>/build/<name>.bin

APP_BIN="main.bin"
BOOTLOADER_BIN="bootloader.bin"
PARTION_TABLE_BIN="partition-table.bin"

# путь к каталогу для файлов .bin
TARGET_DIR="firmware-bin"

BUILD_DIR="build"
APP="$BUILD_DIR/$APP_BIN"
BOOTLOADER="$BUILD_DIR/bootloader/$BOOTLOADER_BIN"
PARTION_TABLE="$BUILD_DIR/partition_table/$PARTION_TABLE_BIN"

# Функция для проверки каталога, создания или очистки
manage_directory() {
    local dir_path=$1

    if [ -d "$dir_path" ]; then
        printf "Каталог $dir_path существует. Очищаю его содержимое...\n"
        rm -rf "$dir_path"/*
    else
        printf "Каталог $dir_path не существует. Создаю...\n"
        mkdir -p "$dir_path"
    fi

    printf "${BGreen}Каталог готов: $dir_path${NC}\n"
}

check_and_copy_file() {
    local file_path=$1
    local target_dir=$2
    local target_file_name=$3

    printf "Проверка файла: ${file_path}\n"

    if [ -f "$file_path" ]; then
        printf "${BGreen}Файл найден.${NC}\n"
        printf "Копирую файл: ${file_path} --> ${target_dir}/${target_file_name}\n"
        cp "$file_path" "$target_dir/$target_file_name"
    else
        printf "${BRed}ОШИБКА: Файл не найден! Завершение работы.${NC}\n"
				printf "${BCyan}\nВозможные причины ошибки:\n${NC}"
				printf " ${BCyan}1.${NC} Возможно вы не сделали сборку проекта! Соберите проект и повторите попытку!\n"
				printf " ${BCyan}2.${NC} Проверьте название бинарного файла и путь к нему:\n"
				printf "     - полный путь для копирования .bin файла: ${BCyan}${file_path}${NC}\n"
				printf "     - имя .bin файла: ${BCyan}${target_file_name}${NC}\n"
				printf "     - если имя файла отличается, измените значение необходимой переменной в файле ${BCyan}prepare.sh${NC}:\n"
				printf "       - ${BCyan}APP_BIN${NC} - файл основной прошивки\n"
				printf "       - ${BCyan}BOOTLOADER_BIN${NC} - файл загрузчика\n"
				printf "       - ${BCyan}PARTION_TABLE_BIN${NC} - файл таблицы разделов\n"
				printf "\n${BRed}Завершение работы.${NC}\n"
        exit 1
    fi
}

clear

# Управление каталогом
printf "${BYellow}Проверка каталога для сбора .bin файлов:${NC}\n"
manage_directory "$TARGET_DIR"

# Проверка файлов и копирование
printf "${BYellow}\nПроверка файла прошивки:${NC}\n"
check_and_copy_file "$APP" "$TARGET_DIR" "$APP_BIN"
printf "${BYellow}\nПроверка файла загрузчика:${NC}\n"
check_and_copy_file "$BOOTLOADER" "$TARGET_DIR" "$BOOTLOADER_BIN"
printf "${BYellow}\nПроверка файла таблицы разделов:${NC}\n"
check_and_copy_file "$PARTION_TABLE" "$TARGET_DIR" "$PARTION_TABLE_BIN"

