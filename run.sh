CURRENT_DIR="$( cd "$(dirname "$0")" ; pwd -P )" 
HOST_PORT=3690
DOCKER_NAME=Subversion
LOCAL_ROOT=/mnt/user/docker/subversion
LOCAL_SVN_ROOT=/svn
. env.sh

set +ex 
docker rm -f $DOCKER_NAME
set -ex 

# -v $LOCAL_ROOT/host:/host

docker run -d --name $DOCKER_NAME -p $HOST_PORT:3690 -v $LOCAL_SVN_ROOT:/svn -v $LOCAL_ROOT/etc/svn_sasldb:/etc/svn_sasldb -v $LOCAL_ROOT/etc/sasl2:/etc/sasl2 -v "/etc/timezone:/etc/timezone:ro" -v "/etc/localtime:/etc/localtime:ro" $USERNAME/$IMAGE
