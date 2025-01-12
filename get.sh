
export ELASTIC_PASSWORD=1password12
curl --cacert ca.crt -u elastic:$ELASTIC_PASSWORD https://localhost:9200
