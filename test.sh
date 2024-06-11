MASTER_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' redis-cluster-master-1)
SLAVE_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' redis-cluster-slave-1)
SENTINEL_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' redis-cluster-sentinel-1)

echo Redis master: $MASTER_IP
echo Redis Slave: $SLAVE_IP
echo ------------------------------------------------
echo Initial status of sentinel
echo ------------------------------------------------
docker exec redis-cluster_sentinel-1 redis-cli -p 26379 info Sentinel
echo Current master is
docker exec redis-cluster-sentinel-1 redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster
echo ------------------------------------------------

echo Stop redis master
docker pause redis-cluster-master-1
echo Wait for 10 seconds
sleep 10
echo Current infomation of sentinel
docker exec redis-cluster-sentinel-1 redis-cli -p 26379 info Sentinel
echo Current master is
docker exec redis-cluster-sentinel-1 redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster


echo ------------------------------------------------
echo Restart Redis master
docker unpause redis-cluster-master-1
sleep 5
echo Current infomation of sentinel
docker exec redis-cluster-sentinel-1 redis-cli -p 26379 info Sentinel
echo Current master is
docker exec redis-cluster-sentinel-1 redis-cli -p 26379 SENTINEL get-master-addr-by-name mymaster
