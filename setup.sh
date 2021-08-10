#!/bin/bash
sudo apt install figlet
BOLD='\e[1m'
GOLD='\e[38;5;226m'
GREY='\033[0;37m'
GREEN='\e[38;5;149m'
echo -e "${GREY}${BOLD}$(figlet -t -f slant Welcome to)" ; echo -e "${GOLD}${BOLD}$(figlet -f slant Fu-JS!)"
echo -e "\033[0;37m\e[1m\t\t\t\t\t\t  ${GREY}${BOLD}© Created By: th3hack3rwiz\n"
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
        test='export PATH="$PATH:/home'
	test1=${user}/go/bin/
	echo $test/$test1\">> ~/.zshrc
        
	test='export GOPATH="/home'
	test1=${user}/go/
	echo $test/$test1\">> ~/.zshrc
        source ~/.zshrc 
	else
	
        test='export PATH="$PATH:/home'
	test1=${user}/go/bin/
	echo $test/$test1\">> ~/.bashrc
        
	test='export GOPATH="/home'
	test1=${user}/go/
	echo $test/$test1\">> ~/.bashrc
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
echo "[+] Installing gf"
lol=$(pwd)
cd ~
mkdir .gf
go get -u github.com/tomnomnom/gf
cp $GOPATH/src/github.com/tomnomnom/gf/examples/* ~/.gf
if [[ -f ~/.zshrc ]]; then 
        echo 'source $GOPATH/src/github.com/tomnomnom/gf/gf-completion.bash' >> ~/.zshrc
	echo "autoload -U compaudit && compinit\nsource /home/kali/go/src/github.com/tomnomnom/gf/gf-completion.zsh" >> ~/.zshrc
	source ~/.zshrc
else
	echo 'source $GOPATH/src/github.com/tomnomnom/gf/gf-completion.bash' >> ~/.bashrc
	echo "autoload -U compaudit && compinit\nsource /home/kali/go/src/github.com/tomnomnom/gf/gf-completion.zsh" >> ~/.bashrc
	source ~/.bashrc

fi
cd $lol
echo "[+] Installing anew"
go get -u github.com/tomnomnom/anew
echo "[+] Installing fff"
go get -u github.com/tomnomnom/fff
echo "[+] Installing unfurl"
go get -u github.com/tomnomnom/unfurl
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
echo "[+] Installing hakcheckurl"
go get github.com/hakluke/hakcheckurl
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
sudo ln -s $(pwd)/Fu-JS.sh /usr/bin/Fu-JS
