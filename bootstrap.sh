#!/bin/sh
set -e

SELF=$(basename 0)

fatal () {
  echo "$SELF: fatal $1" >&2
  exit $2
}

[ -z "$HOME" ] && fatal '$HOME not set; exiting' 1

mkdir $HOME/tmp
cd $HOME/tmp

[ -z "$HTTP_GET" ] && command -v wget >/dev/null && HTTP_GET='wget'
[ -z "$HTTP_GET" ] && command -c curl >/dev/null && HTTP_GET='curl -O'
[ -z "$HTTP_GET" ] && fatal 'Unable to find curl or wget'

vcsh_root='https://raw.github.com/jwhitley/vcsh-root/master'

$HTTP_GET $vcsh_root/local/bin/vcsh
$HTTP_GET $vcsh_root/local/bin/mr

chmod 755 mr vcsh

cd $HOME

export PATH=$HOME/tmp:$PATH

vcsh clone git@github.com:jwhitley/vcsh-root.git mr

mr update

rm -rf $HOME/tmp
