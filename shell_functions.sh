# Function returns the full path to the current script.
# Example:
# tmp=`currentscriptpath`
# echo "path to current script is: "$tmp
currentScriptPath()
{
  #local fullpath=`echo "$(readlink -f $0)"`
  #local fullpath_length=`echo ${#fullpath}`
  #local scriptname="$(basename $0)"
  #local scriptname_length=`echo ${#scriptname}`
  #local result_length=`echo $fullpath_length - $scriptname_length - 1 | bc`
  #local result=`echo $fullpath | head -c $result_length`
  local result=$(dirname $(readlink -f $0))
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
    echo "$destination/$filename : file already exist!"
    echo "unlink/delete and make new link? y/n"

    read answer
    case $answer in
      n*|N*) return ;;
          *) rm -r $destination/$filename;;
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
