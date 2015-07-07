#!/bin/sh
git config core.sparseCheckout true
if [ ! -f $GIT_DIR/info/sparse-checkout ]; then
  cat >> $GIT_DIR/info/sparse-checkout << EOF
*
!.gitignore
!.travis.yml
!LICENSE*
!README*
!Vagrantfile
!docs
EOF
fi
