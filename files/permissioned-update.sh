#!/bin/bash


PERM_NODE_TMPL=$(cat $QHOME/permission-nodes/permissioned-nodes.json.tmpl);
PERM_NODE_JSON=$(echo $PERM_NODE_TMPL |  sed "s/%QUORUM-NODE1_SERVICE_HOST%/$QUORUM_NODE1_SERVICE_HOST/g" |  sed "s/%QUORUM-NODE2_SERVICE_HOST%/$QUORUM_NODE2_SERVICE_HOST/g" |  sed "s/%QUORUM-NODE3_SERVICE_HOST%/$QUORUM_NODE3_SERVICE_HOST/g" |  sed "s/%QUORUM-NODE4_SERVICE_HOST%/$QUORUM_NODE4_SERVICE_HOST/g" |  sed "s/%QUORUM-NODE5_SERVICE_HOST%/$QUORUM_NODE5_SERVICE_HOST/g" |  sed "s/%QUORUM-NODE6_SERVICE_HOST%/$QUORUM_NODE6_SERVICE_HOST/g" |  sed "s/%QUORUM-NODE7_SERVICE_HOST%/$QUORUM_NODE7_SERVICE_HOST/g" );
echo $PERM_NODE_JSON >  $QUORUM_DATA_DIR/permissioned-nodes.json;
cp $QUORUM_DATA_DIR/permissioned-nodes.json $QUORUM_DATA_DIR/static-nodes.json;