# 
#   Created by @sh1l0n
# 
#   Licensed by GPLv3
#   This file is part of Flutter-Kraken project
# 
#   Script for getting packages of all flutter subpackages
#

echo '[+] Going to update packages'
cd libs
for d in *; do
    echo '[+] Getting packages for' $d
    cd $d
    flutter pub get
    cd ..
done
cd ..
echo '[+] Getting packages for main'
flutter pub get