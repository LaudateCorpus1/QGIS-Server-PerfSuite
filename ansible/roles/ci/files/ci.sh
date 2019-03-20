#! /bin/bash
GRAFFITI=/tmp/graffiti
DATE=$(date +"%Y_%m_%d_%H_%M")

echo "Remove docker images"
echo "--------------------"
docker rmi qgisserver-perfsuite/2.18
docker rmi qgisserver-perfsuite/3.4
docker rmi qgisserver-perfsuite/3.6
docker rmi qgisserver-perfsuite/master

echo "Build new docker images"
echo "-----------------------"
cd docker/2.18 && sh build.sh && cd -
cd docker/3.4 && sh build.sh && cd -
cd docker/3.6 && sh build.sh && cd -
cd docker/master && sh build.sh && cd -

echo "Run graffiti"
echo "------------"
cd scenarios && sh run.sh && cd -
rm -rf $GRAFFITI
cd scenarios && sh run.sh && cd -
if [ -d $GRAFFITI ]
then
  scp -r $GRAFFITI qgis-test:/var/www/qgisdata/QGIS-tests/perf_test/graffiti/$DATE
fi
