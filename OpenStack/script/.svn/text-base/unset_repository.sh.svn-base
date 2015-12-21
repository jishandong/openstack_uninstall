#!/bin/sh
#===========
# Definision
#===========
ROLE=$1
ROLE_HOST=$2
ROLE_PASS=$3
REPO_DIR="/etc/yum.repos.d"
REPO_TEMP_DIR="${REPO_DIR}/temp"
FJSVRORWOIS_REPO="${REPO_DIR}/FJSVrorwois.repo"
# Source
. `dirname $(readlink -f $0)`/functions

#==========
# Functions
#==========

revert_repository()
{
    if [ "${ROLE}" = "allinone" -o "${ROLE}" = "controller" ];then
        # revert the repo file
        cp -f ${REPO_TEMP_DIR}/* ${REPO_DIR}
        [ $? -ne 0 ] && { write_log "ERROR: Revert repository file failed."; return 1; }
        
        rm -f ${FJSVRORWOIS_REPO}
        [ $? -ne 0 ] && { write_log "ERROR: Delete FJSVrorwois repository file failed."; return 1; }
    else
        sshpass -p $ROLE_PASS ssh -n -o StrictHostKeyChecking=no root@$ROLE_HOST \
        "cp -f ${REPO_TEMP_DIR}/* ${REPO_DIR}"
        [ $? -ne 0 ] && { write_log "ERROR: Revert repository file failed."; return 1; }
        
        sshpass -p $ROLE_PASS ssh -o StrictHostKeyChecking=no root@$ROLE_HOST \
        "rm -f ${FJSVRORWOIS_REPO}"
        [ $? -ne 0 ] && { write_log "ERROR: Delete FJSVrorwois repository file failed."; return 1; }
        
    fi
    return 0
}

#=============
# Main Process
#=============
revert_repository
[ $? -ne 0 ] && exit 1
exit 0
