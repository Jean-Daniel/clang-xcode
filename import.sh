#!/bin/sh

if [ $# != 1 ] ; then
	echo Missing Xcode path parameter.
	exit 1
fi

echo "Importing plugin from " $1

rm -rf "Clang Nightly.xcplugin"
ditto "$1/Contents/PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins/Clang LLVM 1.0.xcplugin" "Clang Nightly.xcplugin"

plutil -convert xml1 "Clang Nightly.xcplugin/Contents/Info.plist"

unexpand -t 4 "Clang Nightly.xcplugin/Contents/Resources/Clang LLVM 1.0.xcspec" > "Clang Nightly.xcplugin/Contents/Resources/Clang Nightly.xcspec"
rm "Clang Nightly.xcplugin/Contents/Resources/Clang LLVM 1.0.xcspec"

mv Clang\ Nightly.xcplugin/Contents/Resources/English.lproj/*LLVM*.strings "Clang Nightly.xcplugin/Contents/Resources/English.lproj/Clang Nightly.strings"

for file in Clang\ Nightly.xcplugin/Contents/Resources/English.lproj/*.strings
do
	iconv -f UTF-16 -t UTF-8 "$file" > "$file.utf8"
	mv -f "$file.utf8" "$file"
done
