#!/bin/sh
{{ if eq .Values.bashDebug true }}
echo "debug is true"
set -x
{{ end }}

chmod 600 $QUORUM_HOME/tm/tm.key;
echo DDIR is $DDIR;
printenv;

TESSERA_VERSION=$(unzip -p /tessera/tessera-app.jar META-INF/MANIFEST.MF | grep Tessera-Version | cut -d" " -f2);
echo "Tessera version (extracted from manifest file): ${TESSERA_VERSION}";

TESSERA_VERSION="${TESSERA_VERSION}-suffix";
Tess_Ver_First=$(echo ${TESSERA_VERSION} | awk -F. '{print $1}');
Tess_Ver_Second=$(echo ${TESSERA_VERSION} | awk -F. '{print $2}');
Tess_Ver_Third=$(echo ${TESSERA_VERSION} | awk -F. '{print $3}');
echo "version: first [$Tess_Ver_First], second [$Tess_Ver_Second], third [$Tess_Ver_Third]";
echo "Tessera version - suffix ${TESSERA_VERSION}";
TESSERA_CONFIG_TYPE=;

if [ "${Tess_Ver_Second}" -ge "8" ]; then TESSERA_CONFIG_TYPE="-enhanced"; fi;
if [[ "${Tess_Ver_Second}" -ge "9" ]]; then TESSERA_CONFIG_TYPE="-9.0"; fi;

echo Config type ${TESSERA_CONFIG_TYPE};

CONFIG_TMPL=$(cat ${DDIR}/tessera-config${TESSERA_CONFIG_TYPE}.json.tmpl);
CONFIG_WITH_OTHER_HOSTS=$(echo $CONFIG_TMPL |  sed "s/%QUORUM-{{ include "quorum.name" . | upper }}_SERVICE_HOST%/$QUORUM_{{ include "quorum.name" . | upper }}_SERVICE_HOST/g" );

CONFIG_WITH_ALL_HOSTS=$(echo $CONFIG_WITH_OTHER_HOSTS | sed "s/%THIS_SERVICE_HOST%/$QUORUM_{{ include "quorum.name" . | upper }}_SERVICE_HOST/g");
PRIV_KEY=$(cat $DDIR/tm.key)
PUB_KEY=$(cat $DDIR/tm.pub)
CONFIG_FINAL=$(echo $CONFIG_WITH_ALL_HOSTS | sed "s-%THIS_PRIV_KEY%-${PRIV_KEY}-g" |  sed "s-%THIS_PUB_KEY%-${PUB_KEY}-g");
CONFIG_FINAL_9_0=$(echo $CONFIG_WITH_ALL_HOSTS | sed "s-%THIS_PRIV_KEY%-${DDIR}/tm.key-g" |  sed "s-%THIS_PUB_KEY%-${DDIR}/tm.pub-g");
if [[ "${Tess_Ver_Second}" -ge "9" ]]; then CONFIG_FINAL=${CONFIG_FINAL_9_0}; fi;
echo $CONFIG_FINAL >  ${DDIR}/tessera-config-with-hosts.json;
cat  ${DDIR}/tessera-config-with-hosts.json;
java -Xms128M -Xmx128M -jar /tessera/tessera-app.jar -configfile ${DDIR}/tessera-config-with-hosts.json | tee -a ${QHOME}/logs/tessera.log;