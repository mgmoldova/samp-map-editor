# Сборка SA-MP Map Editor

Эта инструкция описывает подготовку среды, сборку и запуск Windows-приложения из исходников репозитория [mgmoldova/samp-map-editor](https://github.com/mgmoldova/samp-map-editor).

> Проект старый и использует Delphi/VCL, Win32, OpenGL, внешние компоненты и две 32-битные DLL. Полностью автоматическая сборка из чистого клона пока невозможна: в репозитории отсутствуют `gtainterface.dll`, `Newton.dll` и современный файл `editor.dproj`.

## 1. Что понадобится

### Обязательные инструменты

| Инструмент | Для чего нужен | Ссылка |
| --- | --- | --- |
| Windows 10/11 x64 | Среда разработки и запуска; само приложение собирается как Win32 | [Скачать Windows](https://www.microsoft.com/software-download/windows11) |
| Delphi / RAD Studio | Компилятор Object Pascal, VCL, дизайнер форм и отладчик | [Delphi Community Edition](https://www.embarcadero.com/products/delphi/starter/free-download) |
| Git for Windows | Клонирование репозитория и работа с ветками | [Git for Windows](https://git-scm.com/download/win) |
| madExcept | В проекте напрямую используются `madExcept`, `madLinkDisAsm`, `madListHardware`, `madListProcesses`, `madListModules` и `madExceptVcl` | [Официальный сайт madExcept](https://www.madshi.net/) |

Delphi Community Edition имеет лицензионные ограничения. Перед установкой проверьте [условия Community Edition](https://www.embarcadero.com/products/delphi/starter/faq).

### Необязательные инструменты

| Инструмент | Назначение | Ссылка |
| --- | --- | --- |
| GitHub Desktop | Графическая работа с Git вместо командной строки | [GitHub Desktop](https://desktop.github.com/download/) |
| Visual Studio Code | Быстрый просмотр и поиск по Pascal-коду; проект всё равно собирается Delphi | [Visual Studio Code](https://code.visualstudio.com/download) |
| 7-Zip | Распаковка старых SDK и подготовка архива релиза | [7-Zip](https://www.7-zip.org/download.html) |
| Dependencies | Проверка разрядности и отсутствующих DLL у собранного EXE | [lucasg/Dependencies](https://github.com/lucasg/Dependencies/releases) |

## 2. Рекомендуемая версия Delphi

Исходники написаны в стиле Delphi 2009/2010:

- используются VCL и WinAPI;
- имеются условные директивы для `Delphi2009AndUp`;
- точка входа представлена старым файлом `editor.dpr`;
- современного `editor.dproj` нет;
- код и внешние DLL рассчитаны на Win32.

Наиболее совместимый вариант — **Delphi 2009 или Delphi 2010, Win32**. Если такой версии нет, можно использовать актуальную Delphi Community Edition, но IDE может предложить миграцию проекта, а часть старых компонентов потребует исправлений.

Не выбирайте Windows 64-bit как Target Platform: `EliRT.obj`, указатели, OpenGL-код и внешние DLL рассчитаны на 32 бита.

## 3. Клонирование репозитория

Откройте PowerShell или Git Bash:

```powershell
git clone https://github.com/mgmoldova/samp-map-editor.git
cd samp-map-editor
git switch master
```

Для разработки отдельной функции создайте ветку:

```powershell
git switch -c feature/my-change
```

Не размещайте проект в каталоге с кириллицей или очень длинным путём. Рекомендуемый путь:

```text
C:\Projects\samp-map-editor
```

## 4. Что уже находится в репозитории

В проект включены или представлены исходниками:

- основная программа `editor.dpr`;
- VCL-формы `*.pas` и `*.dfm`;
- работа с GTA IMG через `Struct\GTADLL.PAS`;
- парсеры IDE/IPL, RenderWare DFF/TXD и COL;
- OpenGL-объявления в `OpenGL12.pas`;
- Pascal-заголовок Newton Dynamics в `Newton.pas`;
- `EliRT.obj`;
- BESEN JavaScript engine;
- SynEdit;
- собственные DNK-компоненты и элементы управления.

Наличие Pascal-файла-обёртки не заменяет соответствующую runtime DLL.

## 5. Обязательные внешние файлы

### 5.1. gtainterface.dll

Файл `Struct\GTADLL.PAS` содержит:

```pascal
const
  gtainterface = 'gtainterface.dll';
```

Эта DLL предоставляет функции `IMGLoadImg`, `IMGExportFile`, `IMGExportBuffer` и другие операции с GTA IMG.

Требования:

- DLL должна быть **32-битной**;
- имя должно быть строго `gtainterface.dll`;
- файл нужно положить рядом с собранным `editor.exe`;
- версия должна экспортировать все функции, объявленные в `Struct\GTADLL.PAS`.

Сейчас DLL отсутствует в репозитории. Получите её из доверенной оригинальной сборки JernejL Map Editor или соберите из исходников соответствующего GTA interface, если они доступны. Не скачивайте случайные DLL с сайтов-агрегаторов.

Проверить экспорты можно программой Dependencies. В DLL должны присутствовать как минимум:

- `IMGLoadImg`;
- `IMGISV2`;
- `IMGExportFile`;
- `IMGExportBuffer`;
- `IMGFileCount`;
- `IMGGetFileName`;
- `IMGGetThisFile`.

### 5.2. Newton.dll 2.12

`Newton.pas` явно ожидает:

```pascal
const
  newtondll = 'Newton.dll';
  NEWTON_MAJOR_VERSION = 2;
  NEWTON_MINOR_VERSION = 12;
```

Нужна именно совместимая **32-битная Newton Dynamics 2.12**. Современная Newton Dynamics может иметь другой ABI и не является прямой заменой.

Официальный репозиторий движка: [MADEAPPS/newton-dynamics](https://github.com/MADEAPPS/newton-dynamics).

Положите совместимую `Newton.dll` рядом с `editor.exe`.

## 6. Установка и настройка madExcept

1. Скачайте madExcept с [официального сайта](https://www.madshi.net/).
2. Установите интеграцию для вашей версии Delphi.
3. Перезапустите Delphi.
4. Убедитесь, что компилятор видит units:
   - `madExcept`;
   - `madLinkDisAsm`;
   - `madListHardware`;
   - `madListProcesses`;
   - `madListModules`;
   - `madExceptVcl`.
5. Убедитесь, что компонент `TMadExceptionHandler` доступен дизайнеру VCL.

Если madExcept не установлен, проект остановится на ошибке вида:

```text
F1026 File not found: 'madExcept.dcu'
```

Временно удалить madExcept сложнее, чем просто убрать units из `editor.dpr`: форма `u_edit.dfm` содержит компонент `TMadExceptionHandler`. Для чистой сборки без madExcept необходимо одновременно удалить компонент из DFM, поле `MadExceptionHandler1` и unit `madExceptVcl`.

## 7. Настройка Library/Search Path

Проект использует units из корня и нескольких вложенных каталогов. Delphi не всегда ищет Pascal-файлы рекурсивно.

Получить список каталогов с `*.pas` можно в PowerShell:

```powershell
$dirs = git ls-files "*.pas" |
  ForEach-Object { Split-Path $_ } |
  Where-Object { $_ -ne "" } |
  Sort-Object -Unique

$searchPath = @(".") + ($dirs -replace "/", "\")
$searchPath -join ";"
```

Скопируйте результат в Delphi:

1. Откройте **Project → Options**.
2. Выберите **Delphi Compiler → Search path**.
3. Добавьте полученные каталоги.
4. Примените настройку только к платформе **Windows 32-bit** и конфигурации **All configurations**.

Минимально понадобятся:

```text
.
Struct
components
mapviewerstuff
```

Если компилятор сообщает `Unit 'X' not found`, найдите файл:

```powershell
git ls-files | Select-String -Pattern "(^|/)X\.pas$"
```

и добавьте его каталог в Search path.

## 8. Первая сборка через Delphi IDE

1. Запустите Delphi.
2. Выберите **File → Open Project**.
3. Откройте `editor.dpr`.
4. Если IDE предложит создать или обновить `editor.dproj`, согласитесь.
5. Выберите:
   - **Target Platform:** Windows 32-bit;
   - **Build Configuration:** Debug для первой сборки.
6. Проверьте **Project → Options → Delphi Compiler → Compiling**:
   - Use debug DCUs — по необходимости;
   - Range checking — можно включить для диагностики, но старый код может выдавать дополнительные ошибки;
   - Overflow checking — аналогично.
7. Выполните **Project → Build editor**.

Точка входа создаёт следующие формы:

- `TGtaEditor`;
- `Twnd_about`;
- `Twnd_showcode`;
- `Twnd_carcolorpicker`;
- `Twnd_report`.

Если добавлена новая форма, её unit должен быть достижим через секцию `uses` либо явно добавлен в `editor.dpr`.

## 9. Сборка из командной строки

### Вариант A: DCC32 напрямую

Откройте **RAD Studio Command Prompt**, перейдите в репозиторий и выполните:

```bat
dcc32 editor.dpr
```

Этот способ подходит старым проектам без `.dproj`, но Search path должен быть передан через настройки среды или ключ `-U`.

Пример:

```bat
dcc32 -U".;Struct;components;mapviewerstuff" editor.dpr
```

Если units находятся глубже, добавьте все каталоги, полученные командой из раздела 7.

### Вариант B: MSBuild после создания editor.dproj

После первого открытия и сохранения проекта современной Delphi появится `editor.dproj`. Затем используйте RAD Studio Command Prompt:

```bat
msbuild editor.dproj /t:Build /p:Config=Release /p:Platform=Win32
```

Официальная инструкция Embarcadero: [Building a Project Using an MSBuild Command](https://docwiki.embarcadero.com/RADStudio/Florence/en/Building_a_Project_Using_an_MSBuild_Command).

Не пытайтесь запустить MSBuild до создания `editor.dproj`: одного `editor.dpr` для MSBuild недостаточно.

## 10. Подготовка каталога запуска

Создайте отдельный каталог, например:

```text
dist\
  editor.exe
  gtainterface.dll
  Newton.dll
```

Скопируйте EXE после сборки:

```powershell
New-Item -ItemType Directory -Force dist | Out-Null
Copy-Item .\editor.exe .\dist\
Copy-Item C:\Path\To\gtainterface.dll .\dist\
Copy-Item C:\Path\To\Newton.dll .\dist\
```

Если Delphi настроена выводить EXE в `Win32\Debug` или `Win32\Release`, скорректируйте путь:

```powershell
Copy-Item .\Win32\Release\editor.exe .\dist\
```

## 11. Данные GTA: San Andreas

Для полноценной работы редактору нужны легально полученные файлы GTA: San Andreas:

- `models\gta3.img`;
- соответствующий `gta3.dir`, если используется конкретной версией IMG;
- IDE/IPL из каталога `data\maps`;
- TXD/DFF/COL внутри IMG;
- `carcols.dat` для цветов транспорта;
- дополнительные SA-MP IMG/IDE-файлы при работе с SA-MP-объектами.

Репозиторий не должен распространять оригинальные файлы GTA: San Andreas.

Рекомендуется использовать отдельную резервную копию игровых данных. Код содержит функции изменения IMG, поэтому не работайте с единственной копией архива.

## 12. Проверка сборки

### 12.1. Проверка разрядности и DLL

Откройте `editor.exe`, `gtainterface.dll` и `Newton.dll` в Dependencies.

Все три файла должны иметь архитектуру x86. Ошибки вида:

```text
The application was unable to start correctly (0xc000007b)
```

обычно означают смешивание 32- и 64-битных файлов.

### 12.2. Минимальный smoke test

1. Запустите `editor.exe`.
2. Укажите тестовую копию каталога GTA.
3. Загрузите IMG/IDE/IPL.
4. Убедитесь, что список моделей заполнился.
5. Выберите объект и дождитесь его появления в OpenGL viewport.
6. Добавьте объект.
7. Измените координаты и поворот.
8. Откройте генератор кода.
9. Проверьте вывод `CreateObject(...)`.
10. Экспортируйте `.pwn` и `.ipl`.
11. Закройте и повторно откройте редактор, убедившись, что он запускается без отсутствующих DLL.

### 12.3. Проверка SetObjectMaterial

После слияния поддержки материалов:

1. Выберите добавленный объект.
2. Откройте расширенную информацию.
3. Нажмите **Materials...**.
4. Добавьте TXD, texture, model ID, material index и ARGB color.
5. Откройте Pawn export.
6. Убедитесь, что объект с материалом экспортирован в переменную.
7. Проверьте следующую строку `SetObjectMaterial`.
8. Убедитесь, что объект без материалов экспортируется в прежнем формате.
9. Экспортируйте IPL и проверьте создание соседнего `*.materials.ini`.

## 13. Типичные ошибки

### Unit not found

```text
F1026 File not found: 'SynEdit.dcu'
```

Причина: каталог с исходником unit отсутствует в Search path.

Решение:

```powershell
git ls-files | Select-String "SynEdit.pas"
```

Добавьте найденный каталог в Project Options.

### Class TMadExceptionHandler not found

Причина: madExcept не установлен в IDE либо пакет компонента не загружен.

Решение: установите совместимую версию madExcept и перезапустите Delphi.

### Bad object file format: EliRT.obj

Причина: выбран Win64 или современный линкер несовместим со старым объектным файлом.

Решение:

- переключить Target Platform на Win32;
- использовать 32-битный Delphi linker;
- при необходимости пересобрать/заменить `EliRT.obj` из доверенного исходника.

### Procedure entry point could not be located

Причина: версия `Newton.dll` или `gtainterface.dll` не соответствует Pascal-объявлениям.

Решение: использовать Newton 2.12 x86 и DLL GTA interface, совместимую с `Struct\GTADLL.PAS`.

### Access violation при загрузке модели

Проверьте:

- соответствие IDE, IPL и IMG одной версии игры;
- наличие DFF/TXD для model ID;
- разрядность DLL;
- путь без кириллицы;
- тестовую копию оригинальных игровых архивов.

### Изображение не появляется или виден красный квадрат

Возможные причины:

- модель ещё не загрузилась из streamer;
- отсутствует DFF или TXD;
- IMG не соответствует IDE;
- OpenGL-драйвер работает через базовый Microsoft renderer.

Обновите драйвер видеокарты с официального сайта Intel, AMD или NVIDIA.

## 14. Release-сборка

1. Выберите **Release / Win32**.
2. Выполните полную команду **Build**, а не только Compile.
3. Запустите smoke test.
4. Подготовьте каталог `dist`.
5. Не включайте GTA-файлы.
6. Создайте тег:

```powershell
git tag v1.0.0
git push origin v1.0.0
```

Workflow [Release](https://github.com/mgmoldova/samp-map-editor/actions/workflows/release.yml) создаст GitHub Release и архив исходников.

Текущий workflow не компилирует Delphi-проект: для автоматической бинарной сборки нужен Windows runner с установленным и лицензированным Delphi, настроенными компонентами и доступными runtime DLL.

## 15. Что нужно улучшить для воспроизводимой сборки

Чтобы проект собирался автоматически из чистого клона, рекомендуется:

- добавить и закоммитить `editor.dproj`;
- точно зафиксировать версию Delphi;
- перечислить версии всех design-time компонентов;
- добавить скрипт настройки Search path;
- документировать происхождение `EliRT.obj`;
- добавить разрешённые к распространению x86 runtime DLL либо инструкции их воспроизводимой сборки;
- добавить Windows GitHub Actions runner;
- создать минимальные тестовые ресурсы, не содержащие файлов GTA;
- заменить или сделать опциональным madExcept.

## Полезные ссылки

- [Delphi Community Edition](https://www.embarcadero.com/products/delphi/starter/free-download)
- [Документация Delphi compiler](https://docwiki.embarcadero.com/RADStudio/en/Delphi_Compiler)
- [Сборка через MSBuild](https://docwiki.embarcadero.com/RADStudio/Florence/en/Building_a_Project_Using_an_MSBuild_Command)
- [Git for Windows](https://git-scm.com/download/win)
- [madExcept](https://www.madshi.net/)
- [SynEdit](https://github.com/SynEdit/SynEdit)
- [Newton Dynamics](https://github.com/MADEAPPS/newton-dynamics)
- [Dependencies](https://github.com/lucasg/Dependencies)
- [Оригинальный JernejL/samp-map-editor](https://github.com/JernejL/samp-map-editor)
