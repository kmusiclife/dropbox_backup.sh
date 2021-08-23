#!/bin/bash
# ------------------------------------------------------------------
# [Author] dropbox_backup
#          Description
# ------------------------------------------------------------------
#
# ~/.dbaccess.cnf file example
#
# [client]
# user = root
# password = yourpassword
# host = 127.0.0.1
# 
# ------------------------------------------------------------------
#
# [ Dropbox Uploader ]
# 
# require to install Dropbox uploader to /bin/dropbox_uploader.sh
# 
# https://github.com/andreafabrizi/Dropbox-Uploader
#
# ------------------------------------------------------------------

SUBJECT=dropbox_backup
VERSION=0.1.1
USAGE="Usage: dropbox_backup db_name dirname"

dropbox_uploader=/bin/dropbox_uploader.sh
dbaccess="${HOME}/.dbaccess.cnf"
www_root="/var/www"
mysql="/usr/bin/mysql"

dbname=$1
dirname=$2

if [ ! $dbname ]; then
  echo ${USAGE};
  exit 1;
fi

if [ ! $dirname ]; then
  echo ${USAGE};
  exit 1;
fi

if [ ! $dropbox_uploader ]; then
  echo "ERROR: ${dropbox_uploader} does not exist."
  exit 1;
fi

if [ ! -e "$www_root" ]; then
  echo "ERROR: ${www_root} does not exist."
  exit 1;
fi

if [ ! -e $dbaccess ]; then
  echo "ERROR: ${dbaccess} does not exist."
  exit 1;
fi

if ! ${mysql} --defaults-extra-file=${dbaccess} -e "use ${dbname}" ; then
  echo "ERROR: database ${dbname} does not exist.";
  ${mysql} --defaults-extra-file=${dbaccess} -e "show databases;"
  exit 1;
fi

if [ ! -e $dropbox_uploader ]; then
  echo "ERROR: ${dropbox_uploader} does not exist."
  exit 1;
fi

if [ ! -e "${www_root}/${dirname}" ]; then
  echo "ERROR: ${www_root}/${dirname} does not exist."
  ls ${www_root}
  exit 1;
fi

echo "START: creating archives ${www_root}/${dirname} and ${dbname} on mysql";
/bin/tar zcf /tmp/"${dirname}".data.tar.gz -C "${www_root}" ${dirname}
/usr/bin/mysqldump --defaults-extra-file="${dbaccess}" "${dbname}" > /tmp/"${dirname}".sql
/bin/tar zcf /tmp/"${dirname}".sql.tar.gz -C /tmp "${dirname}".sql
/bin/tar zcf /tmp/"${dirname}".tar.gz -C /tmp "${dirname}".data.tar.gz "${dirname}".sql.tar.gz
/bin/rm /tmp/"${dirname}".sql /tmp/"${dirname}".sql.tar.gz /tmp/"${dirname}".data.tar.gz
${dropbox_uploader} -q upload /tmp/"${dirname}".tar.gz /
echo "SUCCESS: done";
