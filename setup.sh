#!/bin/sh

# Function returns the full path to the current script.
# Example:
# tmp=`currentscriptpath`
# echo "path to current script is: "$tmp
currentScriptPath()
{
  local fullpath=`echo "$(readlink -f $0)"`
  local fullpath_length=`echo ${#fullpath}`
  local scriptname="$(basename $0)"
  local scriptname_length=`echo ${#scriptname}`
  local result_length=`echo $fullpath_length - $scriptname_length - 1 | bc`
  local result=`echo $fullpath | head -c $result_length`
  echo $result
}
# function to make symbolic link
# asks if file/directory exists
makeLink()
{
  local target=$1
  local destination=$2
  local filename=`basename $1`
  
  if [ ! -e "$target" ]
  then 
    echo "error: $target does not exist!"
    return
  fi

  if [ -e "$destination/$filename" ] 
  then
    echo "$destination/$filename file already exist!"
    echo "unlink and make new link? y/n"

    read answer
    case $answer in
      n*|N*) return ;;
          *) unlink $destination/$filename;;
    esac
  fi
 
  ln -s $target $destination/$filename
  echo "linked: $destination/$filename -> $target"
}

checkInstall()
{
  local program=$1
  if type $program > /dev/null
  then
    echo "$program found"
    return
  else 
    echo "$program not found! install? y/n"

    read answer
    case $answer in
      n*|N*) return ;;
          *) sudo apt-get install $program;;
    esac
  fi
}

checkProgram()
{
local prog=$1
local regex=$2
if (type $prog | grep $regex)
then
 echo "found $1:$2"
 return 0
else 
 echo "$1:$2 not found"
 return -1
fi
}



CONFIG_PATH=`currentScriptPath`

# echo $CONFIG_PATH
echo "make links?"
read answer
case $answer in
  n*|N*) ;;
      *) makeLink $CONFIG_PATH/home/.vimrc $HOME
         makeLink $CONFIG_PATH/home/.bashrc $HOME
         makeLink $CONFIG_PATH/home/.vim $HOME
         makeLink $CONFIG_PATH/home/.bash_aliases $HOME
      	 makeLink $CONFIG_PATH/home/.bin $HOME
      	 makeLink $CONFIG_PATH/home/ros_workspace $HOME
      	 makeLink $CONFIG_PATH/home/ros_eclipse $HOME
         ;;
esac


# installs 
#vim $CONFIG_PATH/home/.vim/plugin/clang_complete.vmb -c 'so %' -c 'q'
#vim $CONFIG_PATH/home/.vim/plugin/supertab.vmb -c 'so %' -c 'q'
checkInstall clang # for vim clang complete
checkInstall ctags # for vim taglist plugin
checkInstall pyflakes # python support for syntastic
#checkInstall mc # filemanager toggle with <C-o>
checkInstall curl # 
#checkInstall svn subversion
#checkInstall preload # preload programs
checkInstall ant # 

  # ubuntu
#checkInstall indicator-multiload # sysmonitor indicator for unity 

 #ros
#if (#TODO apt-cache policy bla |grep bla)
# then checkInstall ros-electric-joystick-drivers
#fi
#if (checkProgram roscore fuerte)
# then checkInstall ros-fuerte-joystick-drivers
#fi

# install gtest under 12.04
#checkInstall cmake
#checkInstall libgtest-dev
#cd /usr/src/gtest/
#sudo cmake .
#sudo make
#sudo mv libg* /usr/lib/

# java + ant
#checkInstall ant # 
#sudo apt-get install "openjdk-6-jdk"
#sudo apt-get install "openjdk-7-jdk openjdk-7-source openjdk-7-demo openjdk-7-doc openjdk-7-jre-headless openjdk-7-jre-lib"



