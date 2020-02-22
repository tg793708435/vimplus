#!/bin/bash

# 获取平台类型，mac还是linux平台
function get_platform_type()
{
    echo $(uname)
}

# 获取linux发行版名称
function get_linux_distro()
{
    if grep -Eq "Ubuntu" /etc/*-release; then
        echo "Ubuntu"
    elif grep -Eq "Deepin" /etc/*-release; then
        echo "Deepin"
    elif grep -Eq "LinuxMint" /etc/*-release; then
        echo "LinuxMint"
    elif grep -Eq "elementary" /etc/*-release; then
        echo "elementaryOS"
    elif grep -Eq "Debian" /etc/*-release; then
        echo "Debian"
    elif grep -Eq "Kali" /etc/*-release; then
        echo "Kali"
    elif grep -Eq "CentOS" /etc/*-release; then
        echo "CentOS"
    elif grep -Eq "fedora" /etc/*-release; then
        echo "fedora"
    elif grep -Eq "openSUSE" /etc/*-release; then
        echo "openSUSE"
    elif grep -Eq "Arch Linux" /etc/*-release; then
        echo "ArchLinux"
    elif grep -Eq "ManjaroLinux" /etc/*-release; then
        echo "ManjaroLinux"
    else
        echo "Unknow"
    fi
}

# 获取日期
function get_datetime()
{
    time=$(date "+%Y%m%d%H%M%S")
    echo $time
}

# 判断文件是否存在
function is_exist_file()
{
    filename=$1
    if [ -f $filename ]; then
        echo 1
    else
        echo 0
    fi
}

# 判断目录是否存在
function is_exist_dir()
{
    dir=$1
    if [ -d $dir ]; then
        echo 1
    else
        echo 0
    fi
}

#备份原有的.vimrc文件
function backup_vimrc_file()
{
    old_vimrc=$HOME"/.vimrc"
    is_exist=$(is_exist_file $old_vimrc)
    if [ $is_exist == 1 ]; then
        time=$(get_datetime)
        backup_vimrc=$old_vimrc"_bak_"$time
        read -p "Find "$old_vimrc" already exists,backup "$old_vimrc" to "$backup_vimrc"? [Y/N] " ch
        if [[ $ch == "Y" ]] || [[ $ch == "y" ]]; then
            cp $old_vimrc $backup_vimrc
        fi
    fi
}

#备份原有的.vimrc.custom.plugins文件
function backup_vimrc_custom_plugins_file()
{
    old_vimrc_plugins=$HOME"/.vimrc.custom.plugins"
    is_exist=$(is_exist_file $old_vimrc_plugins)
    if [ $is_exist == 1 ]; then
        time=$(get_datetime)
        backup_vimrc_plugins=$old_vimrc_plugins"_bak_"$time
        read -p "Find "$old_vimrc_plugins" already exists,backup "$old_vimrc_plugins" to "$backup_vimrc_plugins"? [Y/N] " ch
        if [[ $ch == "Y" ]] || [[ $ch == "y" ]]; then
            cp $old_vimrc_plugins $backup_vimrc_plugins
        fi
    fi
}

#备份原有的.vimrc.custom.config文件
function backup_vimrc_custom_config_file()
{
    old_vimrc_config=$HOME"/.vimrc.custom.config"
    is_exist=$(is_exist_file $old_vimrc_config)
    if [ $is_exist == 1 ]; then
        time=$(get_datetime)
        backup_vimrc_config=$old_vimrc_config"_bak_"$time
        read -p "Find "$old_vimrc_config" already exists,backup "$old_vimrc_config" to "$backup_vimrc_config"? [Y/N] " ch
        if [[ $ch == "Y" ]] || [[ $ch == "y" ]]; then
            cp $old_vimrc_config $backup_vimrc_config
        fi
    fi
}

#备份原有的.vim目录
function backup_vim_dir()
{
    old_vim=$HOME"/.vim"
    is_exist=$(is_exist_dir $old_vim)
    if [ $is_exist == 1 ]; then
        time=$(get_datetime)
        backup_vim=$old_vim"_bak_"$time
        read -p "Find "$old_vim" already exists,backup "$old_vim" to "$backup_vim"? [Y/N] " ch
        if [[ $ch == "Y" ]] || [[ $ch == "y" ]]; then
            cp -R $old_vim $backup_vim
        fi
    fi
}

# 备份原有的.vimrc和.vim
function backup_vimrc_and_vim()
{
    backup_vimrc_file
    backup_vimrc_custom_plugins_file
    backup_vimrc_custom_config_file
    backup_vim_dir
}

# 获取ubuntu版本
function get_ubuntu_version()
{
    line=$(cat /etc/lsb-release | grep "DISTRIB_RELEASE")
    arr=(${line//=/ })
    version=(${arr[1]//./ })

    echo ${version[0]}
}

# 获取centos版本
function get_centos_version()
{
    version=`cat /etc/redhat-release | awk '{print $4}' | awk -F . '{printf "%s",$1}'`
    echo $version
}

# 判断是否是macos10.14版本
function is_macos1014()
{
    product_version=$(sw_vers | grep ProductVersion)
    if [[ $product_version =~ "10.14" ]]; then
        echo 1
    else
        echo 0
    fi
}

# 在ubuntu上源代码安装vim
function compile_vim_on_ubuntu()
{
    sudo apt-get remove -y vim vim-runtime gvim
    sudo apt-get remove -y vim-tiny vim-common vim-gui-common vim-nox
    sudo rm -rf /usr/bin/vim*
    sudo rm -rf /usr/local/bin/vim*
    sudo rm -rf /usr/share/vim/vim*
    sudo rm -rf /usr/local/share/vim/vim*
    rm -rf ~/vim81

    sudo apt-get install -y libncurses5-dev libncurses5 libgnome2-dev libgnomeui-dev \
        libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
        libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev python3-dev ruby-dev lua5.1 lua5.1-dev

    git clone https://gitee.com/chxuan/vim81.git ~/vim81
    cd ~/vim81
    ./configure --with-features=huge \
        --enable-multibyte \
        --enable-rubyinterp \
        --enable-pythoninterp \
        --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
        --enable-perlinterp \
        --enable-luainterp \
        --enable-gui=gtk2 \
        --enable-cscope \
        --prefix=/usr
    make
    sudo make install
    cd -
}

# 在debian上源代码安装vim
function compile_vim_on_debian()
{
    sudo apt-get remove -y vim vim-runtime gvim
    sudo apt-get remove -y vim-tiny vim-common vim-gui-common vim-nox
    sudo rm -rf /usr/bin/vim*
    sudo rm -rf /usr/local/bin/vim*
    sudo rm -rf /usr/share/vim/vim*
    sudo rm -rf /usr/local/share/vim/vim*
    rm -rf ~/vim81

    sudo apt-get install -y libncurses5-dev libncurses5 libgtk2.0-dev libatk1.0-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev python3-dev ruby-dev lua5.1 lua5.1-dev

    git clone https://gitee.com/chxuan/vim81.git ~/vim81
    cd ~/vim81
    ./configure --with-features=huge \
        --enable-multibyte \
        --enable-rubyinterp \
        --enable-pythoninterp \
        --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
        --enable-perlinterp \
        --enable-luainterp \
        --enable-gui=gtk2 \
        --enable-cscope \
        --prefix=/usr
    make
    sudo make install
    cd -
}

# 在centos上源代码安装vim
function compile_vim_on_centos()
{
    rm -rf ~/vim81

    sudo yum install -y ruby ruby-devel lua lua-devel luajit \
        luajit-devel ctags git python python-devel \
        python34 python34-devel tcl-devel \
        perl perl-devel perl-ExtUtils-ParseXS \
        perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
        perl-ExtUtils-Embed libX11-devel ncurses-devel
    
    git clone https://gitee.com/chxuan/vim81.git ~/vim81
    cd ~/vim81
    ./configure --with-features=huge \
        --enable-multibyte \
        --with-tlib=tinfo \
        --enable-rubyinterp=yes \
        --enable-pythoninterp=yes \
        --with-python-config-dir=/lib64/python2.7/config \
        --enable-perlinterp=yes \
        --enable-luainterp=yes \
        --enable-gui=gtk2 \
        --enable-cscope \
        --prefix=/usr
    make
    sudo make install
    cd -
}

# 安装mac平台必备软件
function install_prepare_software_on_mac()
{
    xcode-select --install

    brew install vim gcc cmake ctags-exuberant ack

    macos1014=$(is_macos1014)
    if [ $macos1014 == 1 ]; then
        open /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg
    fi
}

# 安装ubuntu必备软件
function install_prepare_software_on_ubuntu()
{
    sudo apt-get update

    version=$(get_ubuntu_version)
    if [ $version -eq 14 ];then
        sudo apt-get install -y cmake3
    else
        sudo apt-get install -y cmake
    fi

    sudo apt-get install -y exuberant-ctags build-essential python python-dev python3-dev fontconfig libfile-next-perl ack-grep git

    if [ $version -ge 18 ];then
        sudo apt-get install -y vim
    else
        compile_vim_on_ubuntu
    fi
}

# 安装ubuntu系必备软件
function install_prepare_software_on_ubuntu_like()
{
    sudo apt-get update
    sudo apt-get install -y cmake exuberant-ctags build-essential python python-dev python3-dev fontconfig libfile-next-perl ack-grep git
    compile_vim_on_ubuntu
}

# 安装debian必备软件
function install_prepare_software_on_debian()
{
    sudo apt-get update
    sudo apt-get install -y cmake exuberant-ctags build-essential python python-dev python3-dev fontconfig libfile-next-perl ack git
    compile_vim_on_debian
}

# 安装centos必备软件
function install_prepare_software_on_centos()
{
    version=$(get_centos_version)
    if [ $version -ge 8 ];then
        sudo dnf install -y epel-release
        sudo dnf install -y vim ctags automake gcc gcc-c++ kernel-devel make cmake python2 python2-devel python3-devel fontconfig ack git
    else
        sudo yum install -y ctags automake gcc gcc-c++ kernel-devel cmake python-devel python3-devel fontconfig ack git
        compile_vim_on_centos
    fi
}

# 安装fedora必备软件
function install_prepare_software_on_fedora()
{
    sudo dnf install -y vim ctags automake gcc gcc-c++ kernel-devel cmake python-devel python3-devel fontconfig ack git
}

# 安装archlinux必备软件
function install_prepare_software_on_archlinux()
{
    sudo pacman -S --noconfirm vim ctags automake gcc cmake python3 python2 ack git fontconfig
    sudo ln -s /usr/lib/libtinfo.so.6 /usr/lib/libtinfo.so.5
}

# 安装opensuse必备软件
function install_prepare_software_on_opensuse()
{
    sudo zypper install -y vim ctags gcc gcc-c++ cmake python-devel python3-devel ack fontconfig git ncurses5-devel
}

# 拷贝文件
function copy_files()
{
    rm -rf ~/.vimrc
    ln -s ${PWD}/.vimrc ~

    rm -rf ~/.vimrc.custom.plugins
    cp ${PWD}/.vimrc.custom.plugins ~

    rm -rf ~/.vimrc.custom.config
    cp ${PWD}/.vimrc.custom.config ~

    rm -rf ~/.ycm_extra_conf.py
    ln -s ${PWD}/.ycm_extra_conf.py ~

    mkdir ~/.vim
    rm -rf ~/.vim/colors
    ln -s ${PWD}/colors ~/.vim

    rm -rf ~/.vim/ftplugin
    ln -s ${PWD}/ftplugin ~/.vim

    rm -rf ~/.vim/autoload
    ln -s ${PWD}/autoload ~/.vim
}

# 安装mac平台字体
function install_fonts_on_mac()
{
    rm -rf ~/Library/Fonts/Droid\ Sans\ Mono\ Nerd\ Font\ Complete.otf
    cp ./fonts/Droid\ Sans\ Mono\ Nerd\ Font\ Complete.otf ~/Library/Fonts
}

# 安装linux平台字体
function install_fonts_on_linux()
{
    mkdir -p ~/.local/share/fonts
    rm -rf ~/.local/share/fonts/Droid\ Sans\ Mono\ Nerd\ Font\ Complete.otf
    cp ./fonts/Droid\ Sans\ Mono\ Nerd\ Font\ Complete.otf ~/.local/share/fonts

    fc-cache -vf ~/.local/share/fonts
}

# 安装vim插件
function install_vim_plugin()
{
    vim -c "PlugInstall" -c "q" -c "q"
}

# 安装ycm插件
function install_ycm()
{
    git clone https://gitee.com/chxuan/YouCompleteMe-clang.git ~/.vim/plugged/YouCompleteMe

    cd ~/.vim/plugged/YouCompleteMe

    read -p "Please choose to compile ycm with python2 or python3, if there is a problem with the current selection, please choose another one. [2/3] " version
    if [[ $version == "2" ]]; then
        echo "Compile ycm with python2."
        python2.7 ./install.py --clang-completer
    else
        echo "Compile ycm with python3."
        python3 ./install.py --clang-completer
    fi
}

# 打印logo
function print_logo()
{
    color="$(tput setaf 6)"
    normal="$(tput sgr0)"
    printf "${color}"
    echo '        __                __           '
    echo '__   __/_/___ ___  ____  / /_  _______ '
    echo '\ \ / / / __ `__ \/ __ \/ / / / / ___/ '
    echo ' \ V / / / / / / / /_/ / / /_/ (__  )  '
    echo '  \_/_/_/ /_/ /_/ ,___/_/\____/____/   '
    echo '               /_/                     ...is now installed!'
    echo ''
    echo ''
    echo 'Just enjoy it!'
    echo 'p.s. Follow me at https://github.com/chxuan.'
    echo ''
    printf "${normal}"
}

# 在mac平台安装vimplus
function install_vimplus_on_mac()
{
    backup_vimrc_and_vim
    install_prepare_software_on_mac
    copy_files
    install_fonts_on_mac
    install_ycm
    install_vim_plugin
    print_logo
}

# 开始安装vimplus
function begin_install_vimplus()
{
    copy_files
    install_fonts_on_linux
    install_ycm
    install_vim_plugin
    print_logo
}

# 在ubuntu上安装vimplus
function install_vimplus_on_ubuntu()
{
    backup_vimrc_and_vim
    install_prepare_software_on_ubuntu
    begin_install_vimplus
}

# 在ubuntu系上安装vimplus
function install_vimplus_on_ubuntu_like()
{
    backup_vimrc_and_vim
    install_prepare_software_on_ubuntu_like
    begin_install_vimplus
}

# 在debian上安装vimplus
function install_vimplus_on_debian()
{
    backup_vimrc_and_vim
    install_prepare_software_on_debian
    begin_install_vimplus
}

# 在centos上安装vimplus
function install_vimplus_on_centos()
{
    backup_vimrc_and_vim
    install_prepare_software_on_centos
    begin_install_vimplus
}

# 在fedora上安装vimplus
function install_vimplus_on_fedora()
{
    backup_vimrc_and_vim
    install_prepare_software_on_fedora
    begin_install_vimplus
}

# 在archlinux上安装vimplus
function install_vimplus_on_archlinux()
{
    backup_vimrc_and_vim
    install_prepare_software_on_archlinux
    begin_install_vimplus
}

# 在opensuse上安装vimplus
function install_vimplus_on_opensuse()
{
    backup_vimrc_and_vim
    install_prepare_software_on_opensuse
    begin_install_vimplus
}

# 在linux平上台安装vimplus
function install_vimplus_on_linux()
{
    distro=`get_linux_distro`
    echo "Linux distro: "${distro}

    if [ ${distro} == "Ubuntu" ]; then
        install_vimplus_on_ubuntu
    elif [ ${distro} == "Deepin" ]; then
        install_vimplus_on_ubuntu_like
    elif [ ${distro} == "LinuxMint" ]; then
        install_vimplus_on_ubuntu_like
    elif [ ${distro} == "elementaryOS" ]; then
        install_vimplus_on_ubuntu_like
    elif [ ${distro} == "Debian" ]; then
        install_vimplus_on_debian
    elif [ ${distro} == "Kali" ]; then
        install_vimplus_on_debian
    elif [ ${distro} == "CentOS" ]; then
        install_vimplus_on_centos
    elif [ ${distro} == "fedora" ]; then
        install_vimplus_on_fedora
    elif [ ${distro} == "openSUSE" ]; then
        install_vimplus_on_opensuse
    elif [ ${distro} == "ArchLinux" ]; then
        install_vimplus_on_archlinux
    elif [ ${distro} == "ManjaroLinux" ]; then
        install_vimplus_on_archlinux
    else
        echo "Not support linux distro: "${distro}
    fi
}

# 获取当前时间戳
function get_now_timestamp()
{
    cur_sec_and_ns=`date '+%s-%N'`
    echo ${cur_sec_and_ns%-*}
}

# main函数
function main()
{
    begin=`get_now_timestamp`

    type=`get_platform_type`
    echo "Platform type: "${type}

    if [ ${type} == "Darwin" ]; then
        install_vimplus_on_mac
    elif [ ${type} == "Linux" ]; then
        install_vimplus_on_linux
    else
        echo "Not support platform type: "${type}
    fi

    end=`get_now_timestamp`
    second=`expr ${end} - ${begin}`
    min=`expr ${second} / 60`
    echo "It takes "${min}" minutes."
}

# 调用main函数
main
