# 依存関係解決
apt-get update
apt-get install -y git cmake ninja-build clang python uuid-dev libicu-dev icu-devtools libbsd-dev libedit-dev libxml2-dev libsqlite3-dev swig libpython-dev libncurses5-dev pkg-config

# Swiftのスナップショットをダウンロードする
wget https://swift.org/builds/development/ubuntu1404/swift-DEVELOPMENT-SNAPSHOT-2016-06-06-a/swift-DEVELOPMENT-SNAPSHOT-2016-06-06-a-ubuntu14.04.tar.gz

# 展開
mkdir -p swift/snapshots
tar zxvf swift-DEVELOPMENT-SNAPSHOT-2016-06-06-a-ubuntu14.04.tar.gz -C swift/snapshots/
rm swift-DEVELOPMENT-SNAPSHOT-2016-06-06-a-ubuntu14.04.tar.gz

# 権限変更
chmod 777 swift/snapshots/swift-DEVELOPMENT-SNAPSHOT-2016-06-06-a-ubuntu14.04 -R

# PATHを通す
echo export PATH=$PATH:/home/vagrant/swift/snapshots/swift-DEVELOPMENT-SNAPSHOT-2016-06-06-a-ubuntu14.04/usr/bin >> /home/vagrant/.bash_profile
