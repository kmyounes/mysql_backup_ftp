#!/bin/bash
set -xe

############### Infos - Edit them accordingly  ########################

DATE=`date +%Y-%m-%d_%H%M`
LOCAL_BACKUP_DIR="/tmp/"
DB_NAME="all"
DB_USER="root"
DB_PASSWORD="P@ssw0rd!"

FTP_SERVER="ftp.domain.com"
FTP_USERNAME="user"
FTP_PASSWORD="P@ssw0rd!""
FTP_UPLOAD_DIR="/Backups/"


HOST=$(hostname)

TODAY=$(date --iso)
RMDATE=$(date --iso -d '6 days ago')


############### Local Backup  ########################
mysqldump -u $DB_USER  -p$DB_PASSWORD --all-databases | gzip  > $LOCAL_BACKUP_DIR/$DATE-$DB_NAME.sql.gz
cd $LOCAL_BACKUP_DIR

########  Export #########


lftp << EOF
open ${FTP_USERNAME}:${FTP_PASSWORD}@${FTP_SERVER}
cd Backups/${HOST}
mkdir -f ${TODAY}
cd ${TODAY}
put  "$DATE-$DB_NAME.sql.gz"
cd ..
rm -rf ${RMDATE}
bye
EOF

