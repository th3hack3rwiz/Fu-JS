![](https://th3hack3rwiz.github.io/images/Fu-JS/banner.png)
## Fu-JS

This tool aims at accumulating javascript files from a given set of subdomains to discover hidden endpoints. It swims through JS files to find more JS files. It also creates a target-specific wordlist from the JS-files for further content discovery, appends new subdomains discovered from the JS files to the user specified subdomain file, and dumps all the discovered JS files neatly in a folder for static analysis.

### Installation

```bash
git clone https://github.com/th3hack3rwiz/Fu-JS.git
cd  Fu-JS
chmod +x setup.sh
./setup.sh	#This will install all requirements and configure the tool.
```



## Requirements

- unfurl: https://github.com/tomnomnom/unfurl
- anew: https://github.com/tomnomnom/anew
- gau: https://github.com/lc/gau
- waybackurls: https://github.com/tomnomnom/waybackurls
- hakrawler: https://github.com/hakluke/hakrawler
- subjs: https://github.com/lc/subjs
- linkfinder: https://github.com/GerbenJavado/LinkFinder
- secretfinder: https://github.com/m4ll0k/SecretFinder
- ffuf: https://github.com/ffuf/ffuf
- qsreplace: https://github.com/tomnomnom/qsreplace
- httprobe: https://github.com/tomnomnom/httprobe
- fff: https://github.com/tomnomnom/fff
- gf: https://github.com/tomnomnom/gf
- python3, pip , pip3, golang



### Features

- Gathers javascript files using a given set of subdomains supplied by the user. How? -
  1. It crawls the subdomains using hakrawler
  2. Queries the wayback machine with tools like waybackurls + gau
  3. Subjs
- Runs linkfinder.py and secretfinder.py on all those alive JS files that have either been fetched from tools like (waybackurls/gau/hakrawler/subjs)  OR  fed by the user (For eg: list of JS-files obtained from burp suite) to find endpoints and to grab any sensitive/hard coded secrets in those JS file. Stores the results for both in respective text files. 
  - It will then fuzz for all those endpoints on the domain of the js-file from which they were discovered.
  - It will dump all the JS files neatly in a directory for static analysis.
- For eg: If it runs linkfinder.py on https://test.example.com/justajs.js and finds 3 endpoints (a,b,c), it will fuzz for https://test.example.com/a, https://test.example.com/b and https://test.example.com/c to see if those endpoints are alive on that domain. The positive results are stored neatly in a text file.  
- Fu-JS runs the above processes recursively on newly discovered JS files found via linkfinder.py/secretfinder.py --> until no more new javascript files are discoverable.
- It also creates a wordlist from the discovered paths using linkfinder + api words extracted from the static JS files which is very useful for target-specific content discovery. 
- It also appends new subdomains that are discovered from the JS files, to the subdomain file provided by the user.

### Usage

![](https://th3hack3rwiz.github.io/images/Fu-JS/usage.png)

### Sample Usage

##### Different use case scenarios: 

1. In the following example Fu-JS gathers JS files from subdomains and performs its operations.

![](https://th3hack3rwiz.github.io/images/Fu-JS/usage-case1-1.png)
![](https://th3hack3rwiz.github.io/images/Fu-JS/usage-case1-2.png)

2. In the following example Fu-JS uses the JS files supplied by the user and perform it's operations.

![](https://th3hack3rwiz.github.io/images/Fu-JS/usage-case2.png)

3. In the following example Fu-JS gathers JS files from subdomains + crawls them with a depth of 2 + uses the JS files supplied by the use and performs its operations.

![](https://th3hack3rwiz.github.io/images/Fu-JS/usage-case3-1.png)
![](https://th3hack3rwiz.github.io/images/Fu-JS/usage-case3-2.png)

### Explained Output

The following files are generated:-

![](https://th3hack3rwiz.github.io/images/Fu-JS/Output-1.png)

Let's look at the major outout:-

![](https://th3hack3rwiz.github.io/images/Fu-JS/Output-2.png)

Hidden alive endpoints discovered from the Js files:-

![](https://th3hack3rwiz.github.io/images/Fu-JS/Output-3.png)

All the javascript files are fetched and stored neatly in js-dump directory:-

![](https://th3hack3rwiz.github.io/images/Fu-JS/Output-4.png)

All the secrets gathered from js files:-
![](https://th3hack3rwiz.github.io/images/Fu-JS/Output-5.png)

Target specific wordlist formed:- 

![](https://th3hack3rwiz.github.io/images/Fu-JS/Output-6.png)

Linkfinder output of each and every js file:-

![](https://th3hack3rwiz.github.io/images/Fu-JS/Output-7.png)

  
