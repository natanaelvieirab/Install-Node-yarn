#!/bin/bash

# ATENÇÃO: Este script poderá ser executado somente nas distros Linux mint e Ubuntu
# -----------------------------------------------------------------------------------------------------------------------------------------
# Author: Natanael Vieira
# github: https://github.com/natanaelvieirab
# Description:  Este script tem como finalidade automatizar a instalação do NODE.JS e do gerenciador de pacotes 'yarn'.
# -----------------------------------------------------------------------------------------------------------------------------------------
# Para execultar este script digite no diretorio onde se encontra o arquivo
# Comando: sudo bash install-nodejs-yarn.sh
# -----------------------------------------------------------------------------------------------------------------------------------------
# Font: instruções retiradas de https://www.notion.so/Instala-o-das-ferramentas-1c09af201b4b49c5bf1678842a96d9ab#4804c3e0ecd14951819e1222827106df

function main() {
    COLOR_FONT=34

    if [ -n "$(checking_Installation "curl")" ] && curl --version; then
        message_Success "Curl already installed!"
    else
        message_Error "Curl not installed! Start installation ..."
        install_Curl
    fi

    if [ -n "$(checking_Installation "node")" ]; then
        message_Success "Node already installed!"
    else
        message_Error "Node not installed! Start installation ..."
        install_Node
    fi

    echo -e "\e[1;36m What to install the package manager 'yarn'?(Y/N)>  \e[0m"
    read answer

    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        if [ -n "$(checking_Installation "yarn")" ]; then
            message_Success "Yarn already installed!"
        else
            message_Error "Yarn not installed! Start installation ..."
            install_Yarn
        fi
    fi

    if [ -n "$(checking_Installation "zsh")" ]; then
        echo -e "Hi! You have installed \e[1;"$COLOR_FONT"m 'zsh' \e[0m."
        echo -e "Add the following code to the \e[1;"$COLOR_FONT"m '~/zshrc' \e[0m file:"
        echo -e "\e[1;"$COLOR_FONT"m export PATH="\$PATH:\`yarn global bin\`" \e[0m"

    else
        echo -e "Add the following code to the \e[1;"$COLOR_FONT"m '~/bashrc' \e[0m file:"
        echo -e "\e[1;"$COLOR_FONT"m export PATH="\$PATH:\`yarn global bin\`" \e[0m"
    fi
}

function install_Curl() {

    if sudo apt install curl; then
        message_Success "Curl successfully installed!"
    else
        message_Error "Error when installing the Curl!"
    fi
}

function install_Node() {
    URL_NODESOURCE="https://deb.nodesource.com/setup_lts.x"

    curl -sL $URL_NODESOURCE | sudo -E bash -

    if sudo apt-get install -y nodejs; then
        if node --version; then
            message_Success "Node successfully installed !"
        else
            message_Error "Error when installing the nodeJS!"
        fi
    else
        message_Error "Error when installing the nodeJS!"
    fi
}

function install_Yarn() {
    URL_PUBKEY="https://dl.yarnpkg.com/debian/pubkey.gpg"
    URL_YARNPKG="https://dl.yarnpkg.com/debian/ stable main"
    PATH_LIST="/etc/apt/sources.list.d/yarn.list"

    curl -sS "$URL_PUBKEY" | sudo apt-key add -

    if echo "deb "$URL_YARNPKG"" | sudo tee "$PATH_LIST"; then
        if sudo apt update && sudo apt install --no-install-recommends yarn; then
            message_Success "Yarn successfully installed !"
        else
            message_Error "Error when installing the Yarn!"
        fi
    fi
}

function checking_Installation() {
    checking=$(dpkg --get-selections | grep $1)
    echo $checking
}
function message_Error() {
    COLOR_FONT_ATENTION=31
    echo -e "\e[1;"$COLOR_FONT_ATENTION"m $1 \e[0m"
}
function message_Success() {
    COLOR_FONT_ATENTION=32
    echo -e "\e[1;"$COLOR_FONT_ATENTION"m $1 \e[0m"
}

main

echo ""
echo ""
echo -e "\e[1;36m Run the commands below to check the installed versions: \e[0m"
echo "   node --version"
echo "   yarn --version"
