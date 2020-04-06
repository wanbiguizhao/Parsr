#!/bin/bash 

ERROR='\033[0;31m'
OK='\033[32m'
INFO='\033[34m'
NO_COLOR='\033[0m'

check_brew() {
    echo -e "\n${INFO}=> Checking brew installation...${NO_COLOR}"
    which -s brew
    if [[ $? != 0 ]] ; then
        echo -e "Brew is not installed. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    else
        brew update
    fi
}

check_python3() {
    echo -e "\n${INFO}=> Checking python3 installation...${NO_COLOR}"
    which python3
    if [[ $? != 0 ]] ; then
        while true; do
            read -p "Python 3 is not installed. Do you want to install it via homebrew (y/n)? " yn
            case $yn in
                [Yy]* ) brew install python; break;;
                [Nn]* ) echo -e "${ERROR}Please install python3 and run the script again${NO_COLOR}"; exit 1;;
                * ) echo "Please answer yes or no.";;
            esac
        done
    else
        echo "Python 3 is installed. Updating..."
        brew upgrade python
    fi
}

check_pip3() {
    echo -e "\n${INFO}=> Checking pip3 installation...${NO_COLOR}"
    which pip3
    if [[ $? != 0 ]] ; then
        echo -e "Pip 3 is not installed. Installing..."
        python3 get-pip.py    
    fi
}

# Check that brew, python3 and pip3 are installed
check_brew
check_python3
check_pip3

# Install brew dependencies
echo -e "\n${INFO}=> Installing dependencies via brew...${NO_COLOR}"
brew install node qpdf imagemagick tesseract tesseract-lang tcl-tk ghostscript pandoc

# Install python3 dependencies
echo -e "\n${INFO}=> Installing python3 dependencies...${NO_COLOR}"
pip3 install numpy pillow scikit-image
pip3 install pdfminer.six
pip3 install camelot-py[cv]

# Install python2 dependencies
echo -e "\n${INFO}=> Installing python2 dependencies...${NO_COLOR}"
python2.7 -m pip install PyPDF2