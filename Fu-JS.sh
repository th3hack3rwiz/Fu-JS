#!/bin/bash
BOLD='\e[1m'
GOLD='\e[38;5;226m'
GREY='\033[0;37m'
echo -e "${GOLD}${BOLD}$(figlet -f slant  Fu-JS)"
echo -e "\033[0;37m\e[1m\n\t\t\t  ${GREY}${BOLD}© Created By: th3hack3rwiz"
CYAN='\033[0;36m'
PEACH='\e[38;5;216m'
GREEN='\e[38;5;149m'
ORANGE='\e[38;5;202m'
MAGENTA='\033[0;95m'
PINK='\e[38;5;204m'
YELLOW='\e[38;5;227m'
OFFWHITE='\e[38;5;157m'
RED='\e[38;5;196m'

function jsReconStart(){
	echo -e "\n[+] Total JS files loaded: $(cat ../$1 | wc -l)" #| notify -silent
	count=0
	jsfiles=$(cat ../$1 | wc -l)
	echo -e  "${OFFWHITE}[+] Let's gather some juicy endpoints and unveil the darkest secrets... "
	printf "\n" 
	while read line ; do
		url=$(echo $line | sed "s#$domain.*#$domain\/#g")	#fetching base URL
		echo -e "${GREEN}[+] Running on $line " >> $domain.linkfinder-output.txt
		echo -ne "[+] Finding endpoints on $line\n\tTotal potential endpoints found: $count\t JS Files remaining: $jsfiles \\r" 
		jsfiles=$(($jsfiles - 1))
		python3 YYYY -i $line -o cli >> $domain.js-secrets
		printf "\n"  >> $domain.linkfinder-output.txt
		python3 XXXX -o cli -i $line > temp 2>&1  #storing endpoints
		cat temp | grep -E "SSL error|DH_KEY_TOO_SMALL" >/dev/null
		if [ $? -eq 0 ]; then
			truncate -s0 temp
		else 
			cat temp >> $domain.linkfinder-output.txt
			for j in $(cat temp | grep -vE "^/$|%|\-\-|[[:lower:]]+-[[:lower:]]+-[[:lower:]]+|^[[:digit:]]+|^-|^_|^-[[:digit:]]|^[[:lower:]]+[[:upper:]]|.*,.*|[[:upper:]]+[[:lower:]]+[[:upper:]]+|_|[[:upper:]]+[[:digit:]]+|[[:lower:]]+[[:digit:]][[:digit:]]+[[:lower:]]*|[[:upper:]]+[[:digit:]][[:digit:]]+[[:lower:]]*|[[:alpha:]]+-[[:alpha:]]+-|@|^[[:digit:]]+|\.html$|==$|\.png$|\.jpg$|\.css$|\.gif$|\.pdf$|\.jpeg$|\.png$|\.tif$|\.tiff$|\.ttf$|\.woff$|\.woff2$|\.ico$|\.svg$") ; do
				echo $j | grep http > /dev/null 
				if [ $? -eq 1 ] ; then
					echo $j |xargs --max-args=1 --replace="{}" echo "$url{}" 2>&1 | grep $domain | sed "s#$domain\/*#$domain\/#g" | grep $tar |  anew $domain.jsEndpointsx | wc -l >add
					count=$(($count + $(cat add)))
					rm add
				else
					echo $j | grep $domain | anew -q $domain.jsEndpointsx | wc -l >add
					count=$(($count + $(cat add)))
					rm add
				fi 
			done
			rm temp
		fi
	done < ../$1
	if [ -s $domain.jsEndpointsx ] ; then 
		echo -e "\n\n${PEACH}[+] Finding alive endpoints extracted from JS files. ~_~"
		num=$(ffuf -s -u FUZZ -w $domain.jsEndpointsx -t 200 -mc 200,301,302,403,401 -sa -fs 0 -fr "Not Found" -of csv -o testx | anew endpoints | wc -l)
		if [ $num -eq 0 ] ; then echo -e "${RED}[+] Hmm, no endpoints discovered this time. :|"
		else 
		echo -e "[+] $num alive endpoints found! :D"
		rm $domain.jsEndpointsx
		cat endpoints | grep -E ".js$" | sed 's/.*http/http/g' | fff > freshJs
		rm endpoints
		cat freshJs | grep -E "200$" | tr -d '200' | xargs -n1 > temp
		cat testx | sed s/'^.*http'/http/g | sed 's/\,\,/ /g' | qsreplace -a | sed 's/%20/ /g' | sed 's/ [[:digit:]]*,/                    /g' | sed 's/,$//g' | grep http | sort -u | sed 's/.*http/http/g' | anew -q js-active-endpoints > /dev/null 2>&1 
		fi
		rm testx

	fi
	cat $domain.js-secrets | gf urls | grep $tar | grep -E "\.js$" >> temp
	cat temp > freshJs
	#cat freshJs
	rm temp
	rm newJs >/dev/null 2>&1
	cat freshJs | xargs -n1 | anew ../$file > ../newJs
	rm freshJs
	
	cat ../newJs | grep -E "\.js$" >/dev/null
	if [ $? -eq 1 ] ; then
		echo -e "\n${RED}[-] No new JS files found!\n" ; rm ../newJs ; 
	else
		echo -e "[+] $(cat ../newJs | wc -l) New JS Files found! :O Gotta repeat this sequence to extract more endpoints!" #| notify
		jsReconStart "newJs"
	fi 
}

function jsGrab {
echo -e "[+] Total JS files loaded: $(cat ../$1 | wc -l)" #| notify -silent
mkdir js-dump 2>&1 > /dev/null
echo -e  "${GREEN}[+] Fetching all JS files for manual static recon...\n"
for i in $(cat ../$1 | sed 's/^[[:space:]]*//g' | uniq | grep $domain) 
do 
name=$(echo -e  $i | md5sum | awk '{print $1}')
ls js-dump/ | grep $name >/dev/null
if [ $? -ne 0   ]; then
echo -e  "${GREY}[+] Fetching $i" | tee -a js-dump/$name
curl -L --connect-timeout 10 --max-time 10 --insecure --silent $i | js-beautify -i 2> /dev/null >> js-dump/$name 
if [ $(cat js-dump/$name | wc -l) -lt 4 ] ; then rm js-dump/$name ; fi 
fi
done
#creating wordlists
cd js-dump
for i in $(grep -rioP "(?<=(\"|\'|\`))\/[a-zA-Z0-9_?&=\/\-\#\.]*(?=(\"|\'|\`))" | grep /api/ ) ; do for j in `seq 1 8` ; do echo $i |  cut -d "/" -f $j | grep -vE ":|^$" ; done ; done | anew -q ../$domain.js-wordlist
cd ..
for i in `seq 1 8` ; do cat $domain.linkfinder-output.txt | grep "^/" | cut -d "/" -f $i | sort -u | grep -Ev "%|\-\-|[[:lower:]]+-[[:lower:]]+-[[:lower:]]+|^[[:digit:]]+|^-|^_|^-[[:digit:]]|^[[:lower:]]+[[:upper:]]|.*,.*|[[:upper:]]+[[:lower:]]+[[:upper:]]+|_|[[:upper:]]+[[:digit:]]+|[[:lower:]]+[[:digit:]][[:digit:]]+[[:lower:]]*|[[:upper:]]+[[:digit:]][[:digit:]]+[[:lower:]]*|[[:alpha:]]+-[[:alpha:]]+-|^[[:digit:]]+|\.html$|==$|\.png$|\.jpg$|\.css$|\.gif$|\.pdf$|\.js$|\.jpeg$|\.tif$|\.tiff$|\.ttf$|\.woff$|\.woff2$|\.ico$|\.svg$|\.txt$" | grep -v ^$ | sed 's/://g' | sort -u | anew -q $domain.linkfinderWordlist.txt ; done
cat $domain.linkfinderWordlist.txt | anew -q $domain.js-wordlist
rm $domain.linkfinderWordlist.txt
if [ ! -s $domain.js-wordlist ]; then rm $domain.js-wordlist ; else echo -e "\n${OFFWHITE}[+] Wordlist Generated!\n"
fi
}

function usage {
echo -e "${PINK}\n[+] Usage:\n\t./jsSwimmer.sh -j <js-file-list> -s <subdomain-list> target.com"
echo -e "\n${GREEN} -j : to use your own list of js files"
echo -e "${GREEN}  Eg: ./jsSwimmer.sh -j <js-file-list> target.com\n"
echo -e "\n${GREEN} -s : to use a file containing subdomains of target to gather JS files linked to those subdomains."
echo -e "${GREEN}  Eg: ./jsSwimmer.sh -s <subdomain-list> target.com"
echo -e "\n${GREEN} -d : to define depth while crawling subdomais (By default 1)."
echo -e "${GREEN}  Eg: ./jsSwimmer.sh -s <subdomain-list> -j <js-file-list> -d 2 target.com"
}

function gatherJS {
	cd Fu-js.$domain
	cat ../$1 | httprobe --prefer-https | anew -q https-subdomains
	echo -e  "${GREEN}[+] Crawling subdomains to gather JS Files... ~_~"
	#hakrawler js
	
	cat https-subdomains | hakrawler -subs -u -insecure -t 50 $i -d $depth -h "User-Agent: testing" | grep -E "\.js$"| grep $tar | anew -q $domain.crawlledEndpoints

	# Gathering JS Links from subdomains

	cat $domain.crawlledEndpoints | grep $domain | anew -q ../$2 	# Saving live JS links
	
	#subjs

	cat https-subdomains | subjs | grep $tar | anew -q ../$2

	#wayback + gau
	
	#echo -e  "${GREEN}[+] Starting waybackurls + gau to get potentially vulnerable URLs and useful JS files... "
	printf "\n"
	echo -e  "${GREEN}[+] Let's go wayback on the subdomains and gather all urls to potentially find some alive js files. This can take a while. Have patience. \n\tPerhaps time for a coffee break?\n"
	echo -e  $domain | waybackurls| anew -q $domain.urls & gau -subs $domain | anew -q $domain.urls ; wait ; cat $domain.urls | sort -u > buff ; cat buff > $domain.urls ; rm buff 
	for line in $(cat https-subdomains  | grep $domain | awk -F "/" '{print $3}') ; do echo -e  "${GREEN}[+] Running on $line" ; waybackurls $line | anew -q $domain.urls ; done
	echo -e "\n[+] $(cat $domain.urls | grep -E "\.js" | wc -l ) Potential JS files found! Let's find out how many of them are alive..."
	cat $domain.urls | grep -E "\.js" | uniq | sort | hakcheckurl -t 50 | grep "200" | awk '{print $2}' | grep $tar | anew -q ../$2
	rm $domain.urls
	rm $domain.crawlledEndpoints 
	printf "\n"
	echo -e  "[+] $(cat ../$2 | wc -l ) JS files are alive! :D"
	file="$2"
	jsReconStart "$file"
	#rm freshJs
	jsGrab "$file"
	cd js-dump
	gf urls | unfurl domains | sort -u | grep $domain | xargs -n1 | anew -q ../../$1 #| notify
	cd ..
}

while getopts :s:j:hd: fuzz_args; do 
	case $fuzz_args in
		s)
			#echo -e "\n\n[+]Enabling JS files recon for target subdomains..." #provide subdomain list
			sF=1
			subs=$OPTARG
			;;
		d)
			#echo -e "\n\n[+]Crawling depth 1-5..." 
			dF=1
			depth=$OPTARG
			;;

		j)
			#echo -e "\n[+]JS Files List..."
			jsF=1
			file=$OPTARG
			;;
		h)	usage
			exit 1
			;;
		*)
			usage
			echo "Invalid flag usage!"
			exit 1
			;;
	esac
done
shift $((OPTIND-1))
domain=$1
mkdir Fu-js.$domain >/dev/null 2>&1
tar=$(echo $domain | sed 's/\..*//g')
if [[ $# -ne 1 ]] ; then
	usage
	echo -e "\n[-] Something went wrong! Check usage. (above)"
else
	if [[ $dF -ne 1 ]] ; then
		depth=1
	fi
	
	if [[ $jsF -eq 1 && $sF -ne 1 ]] ; then
	cd Fu-js.$domain
	jsReconStart "$file"
	jsGrab "$file"		
	
	elif [[ $jsF -eq 1 && $sF -eq 1 ]] ; then
	gatherJS "$subs" "$file"		

	elif [[ $sF -eq 1 ]] ; then
	gatherJS "$subs" "$domain.js.txt"
else 
	echo "[~] Please use -j or -s flag"
fi
rm https-subdomains >/dev/null 2>&1
echo -e "${GOLD}\n[^_^] Thank you for using Fu-JS! [^_^]"
fi
