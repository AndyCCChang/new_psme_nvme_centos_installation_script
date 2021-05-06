#!/bin/bash -e
#create-upstart-psme-nvme-centos


SRC_FOLDER=/etc/systemd/system/
PSME_NVME_SERV=psme-nvme.service
PSME_BIN_PATH=/usr/local/bin/
PSME_NVME_BIN_PATH=/usr/local/bin/psme-nvme
PSME_NVME_CONF_PATH=/usr/local/etc/psme-config/nvme_configuration.json

echo "[Unit]" > $SRC_FOLDER/$PSME_NVME_SERV
echo "Description=psme rest service" >> $SRC_FOLDER/$PSME_NVME_SERV
echo "" >> $SRC_FOLDER/$PSME_NVME_SERV
echo "[Service]" >> $SRC_FOLDER/$PSME_NVME_SERV
echo "Environment=\"LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64/\"" >>$SRC_FOLDER/$PSME_NVME_SERV
echo "ExecStart=/usr/local/bin/psme-nvme /usr/local/etc/psme-config/nvme_configuration.json" >> $SRC_FOLDER/$PSME_NVME_SERV
echo "" >> $SRC_FOLDER/$PSME_NVME_SERV
echo "[Install]" >> $SRC_FOLDER/$PSME_NVME_SERV
echo " WantedBy=default.target" >> $SRC_FOLDER/$PSME_NVME_SERV

systemctl daemon-reload
systemctl enable psme-nvme.service
systemctl restart psme-nvme
