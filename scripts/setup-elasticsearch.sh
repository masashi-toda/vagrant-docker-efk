#!/bin/sh

#elasticsearch
ES_URL="0.0.0.0:9200"
ES_INGEST_NODE_DIR=/vagrant/docker/elasticsearch/init
ES_TEMPLATE_DIR=/vagrant/docker/elasticsearch/init

awaitEsServer() {
    echo "Await elasticsearch-server..."
    STATUS=""

    for i in `seq 60`
    do
        STATUS=$(curl -s -XGET ${ES_URL}/_cluster/health | jq ".status" | sed "s/\"//g")

        case "$STATUS" in
        "green")  break;;
        "*"   ) ;;
        esac

        sleep 1s
    done

    if [ "$STATUS" = "" ]; then
        echo "ERROR: elasticsearch-server is down or unreachable"
        exit 1
    fi
}

setupIngestNode() {
    echo "Setup elasticsearch ingest-node"

    for file in ${ES_INGEST_NODE_DIR}/ingest*.json
    do
        NAME=`basename ${file} .json`
        URL=${ES_URL}/_ingest/pipeline/${NAME}
        echo -n "> Loading ${NAME}: \t"
        curl -XPUT ${URL} \
                -H 'Content-Type: application/json' \
                -d @${file} || exit 1
        echo
    done
}

setupTemplate() {
    echo "Setup elasticsearch index-template"

    for file in ${ES_TEMPLATE_DIR}/template_*.json
    do
        NAME=`basename ${file} .json`
        URL=${ES_URL}/_template/${NAME}
        echo -n "> Loading ${NAME}: \t"
        curl -XPUT ${URL} \
                -H 'Content-Type: application/json' \
                -d @${file} || exit 1
        echo
    done
}

cat << 'EOS'
###############################################
##  setup elasticsearch                      ##
###############################################
EOS

awaitEsServer \
&& setupIngestNode \
&& setupTemplate
