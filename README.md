| [Visual Studio Code](https://code.visualstudio.com/) | [ESP-IDF](https://marketplace.visualstudio.com/items?itemName=espressif.esp-idf-extension) |
| ----------------- | ----- |
| boards |**ESP32**|

## Ссылки
- плагин установка и настройка https://docs.espressif.com/projects/vscode-esp-idf-extension/en/latest/installation.html
- программа для прошивки (WIN) https://www.espressif.com/en/support/download/other-tools


## Сочетания клавиш

|Назначение|Mac|Linux / Win|
| ----------------- | ----- | ----- | 
|SDK Конфигуратор| ⌘ I G |	Ctrl E G |
|Сборка проекта| ⌘ I B	| Ctrl E B |
|Анализ сборки| ⌘ I S |Ctrl E S|
|Прошивка проекта| ⌘ I F | Ctrl E F |
|Сборка+Прошивка+Монитор| ⌘ I D |	Ctrl E D|
|IDF Монитор| ⌘ I M | Ctrl E M |
|ESP-IDF Терминал| ⌘ I T	| Ctrl E T |
|Очистка памяти на устройстве| ⌘ I R	| Ctrl E R |

## Devcontainer сборка при помощи VSCode
  - Откройте командную панель (`Ctrl+Shift+P` или `Cmd+Shift+P` на macOS).
  - Введите и выберите команду: `Dev Containers: Rebuild and Reopen in Container`

VS Code автоматически пересоберет контейнер, используя новый devcontainer.json

## Стартовый проект
Содержит минимальную стркуткуру для первого запуска

**Стркуткура проекта:**
```
├── .devcontainer                Файлы сборки devcontainer
│   ├── rules                     только для Linux
│   │   ├── 50-myusb.rules 
│   │   └── 99-esp32.rules
│   ├── devcontainer.json         
│   ├── docker-compose.yml        конфиг для docker-compose
│   └── Dockerfile
├── main
│   ├── CMakeLists.txt
│   └── main.c
├── .gitignore
├── CMakeLists.txt
├── firmware-bin.sh               подготовка для прошивки   
└── README.md          
```

**firmware-bin.sh**:
> работает после сборки(build) проекта
- создает каталог в корне проекта `firmware-bin`
- копирует в него файлы необходимые для прошивки при помощи Flash Download Tools

## Прошивка через Flash Download Tools
> Flash Download Toolsскачать [тут](https://www.espressif.com/en/support/download/other-tools)
> Cтатья про прошивку [тут](https://wifi-iot.com/p/wiki/169/ru/)
>> Перед первой прошивкой в некоторых случаях, когда модуль не стартует из-за мусора в памяти требуется прошить пустой файл. Или воспользоваться опцией ERASE в настройках Flash tools.

сперва необходимо сделать сборку проекта и запустить firmware-bin.sh
в созданом каталоге firmware-bin - лежат 3 файла

**прошить 3 файла по указанным адресам:**

`0x1000` - загрузчик прошивки (bootloader), адрес для ESP32, ESP32S2. Для ESP32C3 и ESP32S3 - 0x0000 адрес;
`0x8000` - таблица разметки разделов. Определяет размер секций и наличие SPIFFS  диска;
`0x10000` - сама прошивка. Только этот файл изменяется при компиляции новой прошивки.

Обратите внимание на размер flash памяти, обычно в модулях установлена память на 4 или 16 мегабайт. В прошивающей программе необходимо указать этот размер в мегабитах ! Установленный размер памяти в мегабитах видно в программе Flash download tools в окне Detected info.

**Важно !** 
Если в модуле 4 мегабайта памяти, то  при прошивке через программатор файл прошивки(адрес 0x10000) должен быть не больше 1.6 мегабайта  !

Необходимо указать режим работы flash памяти DIO. В режиме QIO модули не работают, bootloader собран в режиме DIO.

Для загрузки прошивки необходимо GPIO 0 подтянуть к GND и нажать reset.

Готовые платы с USB-UART обычно автоматически запускаются в режиме прошивки, но иногда при проблемах требуется так же замыкать GPIO 0. Иногда для этого отдельно выведена кнопка BOOT.


## Настройки vscode:
> создаются после сборки

- c_cpp_properties.json обеспечивает данные для IntelliSense, которые используются при написании кода.
- settings.json задает общие настройки среды разработки, влияющие на работу всех расширений, включая расширение C/C++.
- launch.json определяет, как запускать и отлаживать конкретные программы, используя информацию из c_cpp_properties.json.


## Комманды для tasks.json и launch.json

`"miDebuggerPath": "${command:espIdf.getToolchainGdb}"`

| Параметр                         | Описание                                                                                                  |
|----------------------------------|----------------------------------------------------------------------------------------------------------|
| `espIdf.getExtensionPath`        | Возвращает абсолютный путь к установленной директории расширения.                                        |
| `espIdf.getOpenOcdScriptValue`   | Возвращает значение переменной `OPENOCD_SCRIPTS`, вычисленной из пути инструментов ESP-IDF, параметра `idf.customExtraVars` или системной переменной окружения `OPENOCD_SCRIPTS`. |
| `espIdf.getOpenOcdConfig`        | Возвращает конфигурационные файлы OpenOCD в виде строки. Пример: `-f interface/ftdi/esp32_devkitj_v1.cfg -f board/esp32-wrover.cfg`. |
| `espIdf.getProjectName`          | Возвращает имя проекта из текущей папки рабочей области, используя файл `build/project_description.json`. |
| `espIdf.getToolchainGcc`         | Возвращает абсолютный путь к GCC из инструментов ESP-IDF для текущей цели (`IDF_TARGET`), заданной в `sdkconfig`. |
| `espIdf.getToolchainGdb`         | Возвращает абсолютный путь к GDB из инструментов ESP-IDF для текущей цели (`IDF_TARGET`), заданной в `sdkconfig`. |
| Документация                     | Пример использования этих параметров можно найти в документации по отладке.                              |


Доступные задачи в tasks.json
Шаблонные задачи.json включается при создании проекта с использованием ESP-IDF: Создайте проект из шаблона расширения. Эти задачи можно выполнить, нажав клавишу F1, написав Tasks: Запустить задачу и выбрав одно из следующих действий:

- `Build` - Сборка проекта
- `Set Target to esp32`
- `Set Target to esp32s2`
- `Clean` - Очистка проекта
- `Flash` - Прошивка устройства
- `Monitor` - Запуск монитора терминала
- `OpenOCD` - Запуск OpenOCD server
- `BuildFlash` - Выполните сборку с последующей командой flash

> Обратите внимание, что для задач OpenOCD вам необходимо определить OpenOCD_SCRIPTS в переменных системного окружения, указав путь к папке OpenOCD scripts.