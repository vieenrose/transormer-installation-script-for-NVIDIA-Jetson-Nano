#! /bin/sh

#set -vx

sudo apt clean
#python3 -m pip cache purge

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
cd -
# install pytorch
pytorch_file='torch-1.2.0a0+8554416-cp27-cp27mu-linux_aarch64.whl'
pytorch_fileUrl='https://nvidia.box.com/shared/static/06vlvedmqpqstu1dym49fo7aapgfyyu9.whl'
if [ ! -f $pytorch_file ]; then
	wget $pytorch_fileUrl -O $pytorch_file
fi
python3 -m pip install $pytorch_file

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
rm -rf "jetsonUtilities"
fi

