#!/bin/sh
set -e

SELF=$(basename 0)

fatal () {
  echo "$SELF: fatal $1" >&2
  exit $2
}

[ -z "$HOME" ] && fatal '$HOME not set; exiting' 1

[ ! -d $HOME/tmp ] && mkdir $HOME/tmp
cd $HOME/tmp

[ -z "$HTTP_GET" ] && command -v wget >/dev/null && HTTP_GET='wget -nv'
[ -z "$HTTP_GET" ] && command -c curl >/dev/null && HTTP_GET='curl -s -S -O'
[ -z "$HTTP_GET" ] && fatal 'Unable to find wget or curl'

echo "$SELF: bootstrapping vcsh and mr with '$HTTP_GET'"

vcsh_root='https://raw.github.com/jwhitley/vcsh-root/master'

$HTTP_GET $vcsh_root/local/bin/vcsh
$HTTP_GET $vcsh_root/local/bin/mr

chmod 755 mr vcsh

cd $HOME

export PATH=$HOME/tmp:$PATH

# Clone the bootstrap repo, containing the mr configuration
[ ! -d ~/.config/vcsh/repo.d/mr.git ] && vcsh clone git@github.com:jwhitley/vcsh-root.git mr

# Fixup mr's working tree for the sparse checkout settings
vcsh mr read-tree -mu HEAD

mr update

rm -rf $HOME/tmp
