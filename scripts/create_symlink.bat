@echo off
setlocal

REM symlink元のフォルダパスを指定
set source_folder=../src

REM symlink先のBlenderのaddonフォルダを探索
set blender_folder=
set addon_folder=

REM Blenderの設定   フォルダを探索
if exist "%APPDATA%\Blender Foundation\Blender" (
    set blender_folder=%APPDATA%\Blender Foundation\Blender
    goto :found_blender_folder
)

REM Blenderの設定フォルダが見つからなかった場合は、ユーザーに入力を求める
if "%blender_folder%"=="" (
    do (
        set /p blender_folder=Blenderの設定フォルダのパスを入力してください(例: %APPDATA%\Blender Foundation\Blender\):
        if not exist "%blender_folder%" (
            echo 指定されたフォルダが見つかりませんでした。
        )
    ) until exist "%blender_folder%"
)

:found_blender_folder
@REM Blenderのaddonフォルダを探索、リストアップしてユーザーに選択させる
set blender_version=
set /a i=0
for /d %%d in ("%blender_folder%\%blender_version%\scripts\addons\*") do (
    set /a i+=1
    set version_folders[!i!]=%%d
    echo !i!: %%d
)
set /p addon_folder_number=
set addon_folder=!version_folders[%addon_folder_number%]!

REM Blenderのaddonフォルダが見つからなかった場合は、ユーザーに入力を求める
if not exist "%addon_folder%" (
    do (
        set /p addon_folder=Blenderの指定のバージョンフォルダのパスを入力してください:
        if not exist "%addon_folder%" (
            echo 指定されたフォルダが見つかりませんでした。
        )
    ) until exist "%addon_folder%"
)

:found_addon_folder
REM symlinkの名前をユーザーに入力させる
set /p symlink_name=symlinkの名前(アドオンの名前)を入力してください:

REM symlinkの作成
mklink /d "%addon_folder%\%symlink_name%" "%source_folder%"

echo symlinkの作成が完了しました。
:eof
endlocal