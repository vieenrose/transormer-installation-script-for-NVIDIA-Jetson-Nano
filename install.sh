#! /bin/sh

# install jetsonUtilities, a tool to find JetPack version
if [ ! -d "jetsonUtilities" ]; then
	git clone https://github.com/jetsonhacks/jetsonUtilities.git
fi

# check JetPack version
cd jetsonUtilities
JetPackVersion=$(python3 jetsonInfo.py | grep -oP "(?<= JetPack )([0-9]{1,}\.)+[0-9]{1,}")
cd ..
echo "Your JetPack Version is" $JetPackVersion

if [ $JetPackVersion != "4.2.2" ]; then
	echo "This scirpt is only comptible with Jetson Nano with JetPack 4.2.2 :("
	exit
fi
echo "You have the right version to go :)"

# get cmake sox
sudo apt install -y cmake sox libsox-dev

# first install llvm
sudo apt-get install -y llvm-8 llvm-8-dev
cd /usr/bin
if [ -L "llvm-config" ]; then
	sudo rm "llvm-config"
fi
sudo ln -s llvm-config-8 llvm-config

# download pytorch wheel
pytorch_file='torch-1.4.0-cp36-cp36m-linux_aarch64.whl'
if [ ! -f $pytorch_file ]; then
	wget https://nvidia.box.com/shared/static/ncgzus5o23uck9i5oth2n8n06k340l6k.whl -O $pytorch_file
fi

# then you can install other dependencies for transformers via pip
curl https://sh.rustup.rs -sSf | sh
export PATH=$PATH:~/.cargo/bin
python3 -m pip install -r requirements.txt

# delete pytorch_file
if [ -f $pytorch_file ]; then
rm $pytorch_file
fi

# and jetsonUtilities
if [ -d "jetsonUtilities" ]; then
rm "jetsonUtilities"
fi

