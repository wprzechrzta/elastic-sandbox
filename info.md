 # Elastic
 http://localhost:9200

# Kibana
 http://localhost:5601


http://localhost:5601/ - Kibana Web UI interface
http://localhost:9200/ - Elastic Search API

## logs
docker-compose logs elasticsearch
docker-compose logs kibana

 # password in .env

# workshop
https://github.com/LisaHJung/Part-1-Intro-to-Elasticsearch-and-Kibana


 # Running

 
 docker-compose up -d

docker compose logs
docker compose ps

 docker-compose down -v
 docker-compose down

 curl -v http://localhost:9200

GET _cluster/health


docker run --rm docker.elastic.co/elasticsearch/elasticsearch:8.17.0 /bin/bash -c 'ulimit -Hn && ulimit -Sn && ulimit -Hu && ulimit -Su'

-e "bootstrap.memory_lock=true" --ulimit memlock=-1:-1

## setting java options
docker run -e ES_JAVA_OPTS="-Xms1g -Xmx1g" -e ENROLLMENT_TOKEN="<token>" --name es01 -p 9200:9200 --net elastic -it docker.elastic.co/elasticsearch/elasticsearch:8.17.0



## Single docker

docker network create elastic
 
docker pull docker.elastic.co/elasticsearch/elasticsearch:8.17.0

docker run --name es01 --net elastic -p 9200:9200 -it -m 1GB docker.elastic.co/elasticsearch/elasticsearch:8.17.0


docker run --name es01 --net elastic -p 9200:9200 -it -m 6GB -e "xpack.ml.use_auto_machine_memory_percent=true" docker.elastic.co/elasticsearch/elasticsearch:8.17.0

## Credentials
docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic
docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana

export ELASTIC_PASSWORD="your_password"

### Configure certs
docker cp es01:/usr/share/elasticsearch/config/certs/http_ca.crt .

- on cluster mode
docker cp es01:/usr/share/elasticsearch/config/certs/es01/es01.crt .
export ELASTIC_PASSWORD=1password12
curl --cacert ca.crt -u elastic:$ELASTIC_PASSWORD https://localhost:9200