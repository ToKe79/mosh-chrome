#!/bin/bash -e

source build.sh dev
ret=$?

if [ $ret -eq 0 ] ; then
  origcwd=$(pwd)
  mosharch="${origcwd}/bazel-genfiles/mosh_chrome_dev.zip"
  if [ -r "${mosharch}" ] ; then
    tmpfolder="/tmp/`date +%Y%m%d%H%M%S`"
    webroot="/var/www/www.vudiq.sk"
    mkdir -p $tmpfolder
    cd $tmpfolder
    unzip $mosharch > /dev/null
    cp "${origcwd}/powerline-web-fonts/PowerlineFonts.css" ./
    cp -r "${origcwd}/powerline-web-fonts/fonts" ./
    sed -i manifest.json -e "s/\"Mosh (dev)\"/\"Mosh (vudiq)\"/"
    sed -i manifest.json -e "s/\"Mosh (mobile shell) for Chrome (dev track)\"/\"Mosh (mobile shell) for Chrome (custom build with Powerline Fonts)\"/"
    zip -r mosh_vudiq.zip * > /dev/null
    mv mosh_vudiq.zip "${webroot}/"
    cd "${origcwd}"
    rm -rf $tmpfolder
    echo "Mosh for Chrome enhanced with Powerline Fonts."
    echo "Download the ZIP from www.vudiq.sk/mosh_vudiq.zip"
    exit 0
  else
    echo "Sorry, file '${mosharch}' not found!" >&2
    exit 1
  fi
else
  echo "Sorry, the build exited with error '${ret}'!" >&2
  exit $ret
fi
