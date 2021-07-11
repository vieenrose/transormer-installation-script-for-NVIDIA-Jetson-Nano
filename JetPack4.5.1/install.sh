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

if [ $JetPackVersion != "4.5.1" ]; then
	echo "This scirpt is only comptible with Jetson Nano with JetPack 4.5.1 :("
	exit
fi
echo "You have the right version to go :)"

# get cmake sox
sudo apt install -y cmake sox libsox-dev curl python3-pip

# first install llvm
#sudo apt-get install -y llvm-10 llvm-10-dev
#cd /usr/bin
#if [ -L "llvm-config" ]; then
#	sudo rm "llvm-config"
#fi
#sudo ln -s llvm-config-10 llvm-config
#cd -

# install pytorch
pytorch_file='torch-1.9.0-cp36-cp36m-linux_aarch64.whl'
pytorch_fileUrl='https://nvidia.box.com/shared/static/2cqb9jwnncv9iii4u60vgd362x4rnkik.whl'
if [ ! -f $pytorch_file ]; then
	wget $pytorch_fileUrl -O $pytorch_file
fi
sudo apt install libopenblas-* -y
python3 -m pip install $pytorch_file

# delete pytorch_file
if [ -f $pytorch_file ]; then
rm $pytorch_file
fi

# then you can install other dependencies for transformers via pip

#curl https://sh.rustup.rs -sSf | sh
#export PATH=$PATH:~/.cargo/bin
sudo apt install libssl-dev -y
python3 -m pip install -r requirements.txt

# rm jetsonUtilities
if [ -d "jetsonUtilities" ]; then
rm -rf "jetsonUtilities"
fi

