# 依存関係解決
apt-get update
apt-get install -y git cmake ninja-build clang python uuid-dev libicu-dev icu-devtools libbsd-dev libedit-dev libxml2-dev libsqlite3-dev swig libpython-dev libncurses5-dev pkg-config curl

HOME=/home/vagrant
export $HOME

# swiftenvをクローン
git clone https://github.com/kylef/swiftenv.git $HOME/.swiftenv

# パスの設定
echo 'export SWIFTENV_ROOT="$HOME/.swiftenv"' >> $HOME/.bash_profile
echo 'export PATH="$SWIFTENV_ROOT/bin:$PATH"' >> $HOME/.bash_profile
echo 'eval "$(swiftenv init -)"' >> $HOME/.bash_profile

# Swiftのインストール
$HOME/.swiftenv/bin/swiftenv install 3.0
chmod 777 $HOME/.swiftenv -R
