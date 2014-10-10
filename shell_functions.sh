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
    return -1
  fi
  if [ -L "$destination/$filename" ]; then 
      echo "unlinking $destination/$filename"
      unlink $destination/$filename
  fi
  if [ -e "$destination/$filename" ]; then
      echo "$destination/$filename : file already exist!"
      echo "delete and make link? Y/n"
      read -n 1 answer
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
  if yaourt -Q $program > /dev/null 2>&1
  then
    echo "$program found"
    return 0
  else
    echo "$program not found! install? Y/n"
    read -n 1 answer
    case $answer in
      n*|N*) return -1;;
          *) yaourt -S $program
             return 0;;
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

function exesudo ()
{
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ##
    #
    # LOCAL VARIABLES:
    #
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ##

    #
    # I use underscores to remember it's been passed
    local _funcname_="$1"

    local params=( "$@" )               ## array containing all params passed here
    local tmpfile="/dev/shm/$RANDOM"    ## temporary file
    local filecontent                   ## content of the temporary file
    local regex                         ## regular expression
    local func                          ## function source


    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ##
    #
    # MAIN CODE:
    #
    ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ##

    #
    # WORKING ON PARAMS:
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    #
    # Shift the first param (which is the name of the function)
    unset params[0]              ## remove first element
    # params=( "${params[@]}" )     ## repack array


    #
    # WORKING ON THE TEMPORARY FILE:
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    content="#!/bin/bash\n\n"

    #
    # Write the params array
    content="${content}params=(\n"

    regex="\s+"
    for param in "${params[@]}"
    do
        if [[ "$param" =~ $regex ]]
            then
                content="${content}\t\"${param}\"\n"
            else
                content="${content}\t${param}\n"
        fi
    done

    content="$content)\n"
    echo -e "$content" > "$tmpfile"

    #
    # Append the function source
    echo "#$( type "$_funcname_" )" >> "$tmpfile"

    #
    # Append the call to the function
    echo -e "\n$_funcname_ \"\${params[@]}\"\n" >> "$tmpfile"


    #
    # DONE: EXECUTE THE TEMPORARY FILE WITH SUDO
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    sudo bash "$tmpfile"
    rm "$tmpfile"
}
