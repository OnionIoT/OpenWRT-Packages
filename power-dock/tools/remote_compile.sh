#!/bin/sh

## define the remote server and package
server="lazar@build.onion.io"
remotePath="/home/lazar/OpenWRT-Buildroot/openwrt/dl"
package="power-dock"
localPath="../$package"


cmd="rsync -va --progress $localPath $server:$remotePath"
echo "$cmd"
eval "$cmd"


## create a tar from the file, run the compile
cmd="ssh $server \"cd $remotePath && tar -zcvf $package.tar.gz $package && cd .. && make package/feeds/onion/$package/compile V=99\""
echo "$cmd"
eval "$cmd"

