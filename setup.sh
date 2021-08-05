#!/bin/bash
user=$(whoami)

if [[ "$user" = "root" ]]; then
echo "[!] Do not run as root!"
exit 1
fi
sudo apt-get install python3-pip
sudo apt install pip
read -p "Do you have golang installed and GOPATH set?(y/n):"
if [[ "$REPLY" != "y" ]]; then echo "Ok, installing golang!"
	sudo apt install golang
	 if [[ -f ~/.zshrc ]]; then 
        echo 'export PATH="$PATH:/home/${user}/go/bin/"'>> ~/.zshrc
        echo 'export GOPATH="/home/${user}/go"' >> ~/.zshrc
        source ~/.zshrc 
	else
        echo 'export PATH="$PATH:/home/${user}/go/bin/"'>> ~/.bashrc
        echo 'export GOPATH="/home/${user}/go"' >> ~/.bashrc
        source ~/.bashrc
	fi

else
	echo $GOPATH | grep "go" >/dev/null 
	if [[ $? -eq 0 ]]
	then 
		echo "[+] You're all set!"
	else 
		echo "[!] Something is not right, kindly install golang manually and set the GOPATH. Then run this script again."
		exit 1
	fi
echo "OK, installing necessary tools now."
fi
echo "[+] Installing anew"
go get -u github.com/tomnomnom/anew
echo "[+] Installing gau"
GO111MODULE=on go get -u -v github.com/lc/gau
echo "[+] Installing waybackurls"
go get github.com/tomnomnom/waybackurls
echo "[+] Installing subjs"
GO111MODULE=on go get -u -v github.com/lc/subjs
echo "[+] Installing ffuf"
go get -u github.com/ffuf/ffuf
echo "[+] Installing hakrawler"
go get github.com/hakluke/hakrawler
echo "[+] Installing qsreplace"
go get -u github.com/tomnomnom/qsreplace
echo "[+] Installing httprobe"
go get -u github.com/tomnomnom/httprobe
echo "[+] Installing linkfinder"
git clone https://github.com/GerbenJavado/LinkFinder.git
cd LinkFinder
sudo python3 setup.py install
chmod +x linkfinder.py
temp=$(pwd)/linkfinder.py
cd ../
sed -i "s#XXXX#$temp#g" Fu-JS.sh
echo "[+] Installing secretfinder"
git clone https://github.com/m4ll0k/SecretFinder.git secretfinder
pip3 install jsbeautifier
cd secretfinder
sudo pip install -r requirements.txt
chmod +x SecretFinder.py
temp=$(pwd)/SecretFinder.py
cd ..
sed -i "s#YYYY#$temp#g" Fu-JS.sh
chmod +x Fu-JS.sh
