#!/bin/bash

# symlink元のフォルダパスを指定
source_folder="../src"

# symlink先のBlenderのaddonフォルダを探索
blender_folder=""
addon_folder=""

# Blenderの設定フォルダを探索
# MacOSの場合、 ~/Library/Application Support/Blender/ に存在する
if [ -d "$HOME/Library/Application Support/Blender" ]; then
    blender_folder="$HOME/Library/Application Support/Blender"
    goto found_blender_folder
fi
# Linuxの場合、 ~/.config/blender/ に存在する
if [ -d "$HOME/.config/blender" ]; then
    blender_folder="$HOME/.config/blender"
    goto found_blender_folder
fi

# Blenderの設定フォルダが見つからなかった場合は、ユーザーに入力を求める
if [ -z "$blender_folder" ]; then
    while [ ! -d "$blender_folder" ]; do
        read -p "Blenderの設定フォルダのパスを入力してください(例: $HOME/.config/blender): " blender_folder
        if [ ! -d "$blender_folder" ]; then
            echo "指定されたフォルダが見つかりませんでした。"
        fi
    done
fi

found_blender_folder:
# バージョンを探索、リストアップしてユーザーに選択させる
blender_version=""
i=0
for d in "$blender_folder"/*; do
    i=$((i + 1))
    version_folders["$i"]=$d
    echo "$i: $d"
done
read -p "addon_folder_number: " addon_folder_number
addon_folder="${version_folders[$addon_folder_number]}"

# Blenderのaddonフォルダが見つからなかった場合は、ユーザーに入力を求める
if [ ! -d "$addon_folder" ]; then
    while [ ! -d "$addon_folder" ]; do
        read -p "Blenderの指定のバージョンフォルダのパスを入力してください: " addon_folder
        if [ ! -d "$addon_folder" ]; then
            echo "指定されたフォルダが見つかりませんでした。"
        fi
    done
fi

found_addon_folder:
# symlinkの名前をユーザーに入力させる
read -p "symlinkの名前(アドオンの名前)を入力してください: " symlink_name

# symlinkの作成
ln -s "$source_folder" "$addon_folder/$symlink_name"

echo "symlinkの作成が完了しました。"
