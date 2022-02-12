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
	
	wget "https://go.dev/dl/go1.17.6.linux-amd64.tar.gz"
	sudo rm -rf /usr/local/go 
	tar -C $HOME -xzf go1.17.6.linux-amd64.tar.gz
if [[ -f ~/.zshrc ]]; then 
    test='export PATH=$PATH:'
	test1=$HOME/go/bin/
	echo $test$test1>> ~/.zshrc
        
	test='export GOPATH='
	test1=$HOME/go/
	echo $test$test1>> ~/.zshrc
        source ~/.zshrc 
	else
	test='export PATH=$PATH:'
	test1=$HOME/go/bin/
	echo $test$test1>> ~/.bashrc
        
	test='export GOPATH='
	test1=$HOME/go/
	echo $test$test1>> ~/.bashrc
        source ~/.zshrc 
	fi
rm go1.17.6.linux-amd64.tar.gz 
else
	echo $GOPATH | grep "go" >/dev/null 
	if [[ $? -eq 0 ]] ;	then 
		echo "[+] You're all set!"
	else 
		echo "[!] Something is not right, kindly install golang manually and set the GOPATH. Then run this script again."
		exit 1
	fi
fi

echo "OK, installing necessary tools now."
fi
echo "[+] Installing gf"
lol=$(pwd)
cd ~
mkdir .gf
go install -v github.com/tomnomnom/gf@latest
cp $GOPATH/src/github.com/tomnomnom/gf/examples/* ~/.gf
if [[ -f ~/.zshrc ]]; then 
        echo 'source $GOPATH/src/github.com/tomnomnom/gf/gf-completion.bash' >> ~/.zshrc
	echo "autoload -U compaudit && compinit\nsource $GOPATH/src/github.com/tomnomnom/gf/gf-completion.zsh" >> ~/.zshrc
	source ~/.zshrc
else
	echo 'source $GOPATH/src/github.com/tomnomnom/gf/gf-completion.bash' >> ~/.bashrc
	echo "autoload -U compaudit && compinit\nsource $GOPATH/src/github.com/tomnomnom/gf/gf-completion.zsh" >> ~/.bashrc
	source ~/.bashrc

fi
cd $lol
echo "[+] Installing anew"
go install -v github.com/tomnomnom/anew@latest
echo "[+] Installing fff"
go install -v github.com/tomnomnom/fff@latest
echo "[+] Installing unfurl"
go install -v github.com/tomnomnom/unfurl@latest
echo "[+] Installing gau"
GO111MODULE=on go install -v github.com/lc/gau@latest
echo "[+] Installing waybackurls"
go install -v github.com/tomnomnom/waybackurls@latest
echo "[+] Installing subjs"
GO111MODULE=on go install -v github.com/lc/subjs@latest
echo "[+] Installing ffuf"
go install -v github.com/ffuf/ffuf@latest
echo "[+] Installing hakrawler"
go install github.com/hakluke/hakrawler@latest
echo "[+] Installing hakcheckurl"
go install -v github.com/hakluke/hakcheckurl@latest
echo "[+] Installing qsreplace"
go install -v github.com/tomnomnom/qsreplace@latest
echo "[+] Installing httprobe"
go install -v github.com/tomnomnom/httprobe@latest
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
