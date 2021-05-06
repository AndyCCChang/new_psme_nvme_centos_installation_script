#!/bin/bash -e
#create-upstart-psme-service-centos


SRC_FOLDER=/etc/systemd/system/
PSME_REST_SERV=psme-rest.service
PSME_BIN_PATH=/usr/local/bin/
PSME_REST_BIN_PATH=/usr/local/bin/psme-rest-server
PSME_REST_CONF_PATH=/usr/local/etc/psme-config/server.json

echo "[Unit]" > $SRC_FOLDER/$PSME_REST_SERV
echo "Description=psme rest service" >> $SRC_FOLDER/$PSME_REST_SERV
echo "" >> $SRC_FOLDER/$PSME_REST_SERV
echo "[Service]" >> $SRC_FOLDER/$PSME_REST_SERV
echo "Environment=\"LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64/\"" >>$SRC_FOLDER/$PSME_REST_SERV
echo "ExecStart=/usr/local/bin/psme-rest-server /usr/local/etc/psme-config/server.json" >> $SRC_FOLDER/$PSME_REST_SERV
echo "" >> $SRC_FOLDER/$PSME_REST_SERV
echo "[Install]" >> $SRC_FOLDER/$PSME_REST_SERV
echo " WantedBy=default.target" >> $SRC_FOLDER/$PSME_REST_SERV


systemctl daemon-reload
systemctl enable psme-rest.service
systemctl restart psme-rest
