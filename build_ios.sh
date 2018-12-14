#!/bin/bash

base_dir=$(cd "`dirname "0"`" && pwd)
build_dir=$base_dir/build
lib_dir=$base_dir/lib/ios
framework_name=HomeAwayChallenge
target_name=$framework_name

rm -rf build
rm -rf lib

if [ ! -d "$build_dir" ]; then
  mkdir -p $build_dir
fi

if [ ! -d "$lib_dir" ]; then
  mkdir -p $lib_dir
fi

echo -e "--------------------------------------------------------"
echo -e "-- Compiling $framework_name library (and dependencies) --"
echo -e "--------------------------------------------------------\n"
xcodebuild -target "$target_name" -configuration Release -arch armv7 -arch armv7s -arch arm64 only_active_arch=no defines_module=yes -sdk "iphoneos"
xcodebuild -target "$target_name" -configuration Release -arch x86_64 -arch i386 only_active_arch=no defines_module=yes -sdk "iphonesimulator"
echo -e "Success\n"

echo -e "-------------------------------------------------"
echo -e "-- Creating $framework_name.framework FAT binary --"
echo -e "-------------------------------------------------\n"
cd build
cp -R $build_dir/Release-iphoneos/$framework_name.framework $lib_dir
lipo -create -output $lib_dir/$framework_name.framework/$framework_name $build_dir/Release-iphoneos/$framework_name.framework/$framework_name $build_dir/Release-iphonesimulator/$framework_name.framework/$framework_name
cp -R $build_dir/Release-iphonesimulator/$framework_name.framework/Modules/$framework_name.swiftmodule/* $lib_dir/$framework_name.framework/Modules/$framework_name.swiftmodule/
echo -e "Success: \n" $lib_dir/$framework_name.framework "\n"

echo -e "---------------------------------------------------"
echo -e "-- Validating $framework_name.framework FAT binary --"
echo -e "---------------------------------------------------\n"
lipo -info $lib_dir/$framework_name.framework/$framework_name
echo -e ""
