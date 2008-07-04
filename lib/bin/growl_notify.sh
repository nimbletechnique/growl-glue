#!/bin/bash
# growlnotify leopard bug workaround
list_args()
{
  for p in "$@"
  do
    if [ "${p:0:1}" == "-" ];then
      echo -n "$p "
    else
      echo -n "\"$p\" "
    fi
  done
}
argstr=$(list_args "${@:$?}")
echo "-H localhost $argstr" | xargs `which growlnotify`
