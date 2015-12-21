#!/bin/sh
####################################################################
# Setup launcher of ServerView Resource Orchestrator.
# Icehouse
#
# Usage:
#   unsetup.sh { -s "configuration name" {"node name"}}
#
# Return:
#   0 Succeeded
#   1 Failed
####################################################################
# Definition
PATH_DIR=$(dirname $(readlink -f $0))
. $PATH_DIR/../OpenStack/script/unsetup_functions
. $PATH_DIR/../msg/UNINSTALLMSG

#---------------
# Display title.
#---------------
display_title()
{
  # display title.
  clear
  echo "$DSPMSG_TITLE_001"
  echo "$DSPMSG_TITLE_002"
  echo ""
  echo "$DSPMSG_TITLE_003"
  echo "$DSPMSG_TITLE_004"
}

#--------------------
# Termination forced.
#--------------------
termination_forced()
{
  # ctrl+C
  trap 2
  exit 0
}

#-----------
# Save input
#-----------
save_input()
{
  INPUT_VALUE="$1"
}


#---------------------
# Select Uninstallation.
#---------------------
select_uninstallation()
{
  # select configuration.
  select_configuration
  UNINSTALL_CODE=$INPUT_VALUE
  case "${UNINSTALL_CODE}" in
  "1")
    echo unsetup all-in-one configuration
    exec sh "${PATH_DIR}/../OpenStack/unsetup/allinone" $MODE
    ;;
  "21")
    echo unsetup Controller Component of n-Compute configuration
    exec sh "${PATH_DIR}/../OpenStack/unsetup/controller" $MODE
    ;;
  "22")
    echo unsetup Compute Node Component of n-Compute configuration
    exec sh "${PATH_DIR}/../OpenStack/unsetup/computenode" $MODE
    ;;
  "23")
    echo unsetup Network Node Component of n-Compute configuration
    exec sh "${PATH_DIR}/../OpenStack/unsetup/networknode" $MODE
    ;;

  esac

  return 0
}

#----------------------
# Select Configuration.
#----------------------
select_configuration()
{
  while :
  do
    # display title message
    display_title
    # display select message.
    echo "$DSPMSG_MENU_001"
    echo ""
    # display edition select massage.
    echo "$DSPMSG_CONFIGURATION_ALLINONE"
    echo "$DSPMSG_CONFIGURATION_NCOMPUTE"

    echo ""

    echo "$DSPMSG_MENU_002"
    echo "$DSPMSG_MENU_003"

    echo -n "=> "
    read ANS
    case $ANS in
    "q")
      termination_forced
      ;;
    "?")
      # display help message.
      echo "$DSPMSG_HELP_CONF"
      read
      ;;
    "1")
      save_input ${ANS}
      break
      ;;
    "2")
      select_component ${ANS}
      if [ $? -eq 0 ]; then
      break;
      fi
      ;;

    *)
      # display invalid message.
      echo "$DSPMSG_INVALID"
      read
      ;;
    esac
  done
}

#-----------------
# Select Component
#-----------------
select_component()
{
  VALUE=""
  while :
  do
    # display title message.
    display_title
    # display select message.
    echo "$DSPMSG_MENU_001"
    echo ""
    # display select massage.
    echo "$DSPMSG_COMP_CONTROLLER"
    echo "$DSPMSG_COMP_COMPUTE"
    echo "$DSPMSG_COMP_NEWTORK"
    echo ""

    echo "$DSPMSG_MENU_002"
    echo "$DSPMSG_MENU_004"

    echo -n "=> "
    read ANS
    case $ANS in
    "q")
      termination_forced
      ;;
    "b")
      return 1
      ;;
    "?")
      # display help message.
      echo "$DSPMSG_HELP_FUNC"
      read
      ;;
    [1-3])
      VALUE="${ANS}"
      break;
      ;;
    *)
      # display invalid message.
      echo "$DSPMSG_INVALID"
      read
      ;;
    esac
  done

  save_input "$1${VALUE}"

  return 0
}


#=============
# Main process
#=============
# Get uninstallation mode
MODE=`get_uninstall_mode $1`
case "${MODE}" in
"interactive")
  # interactive uninstall
  # select uninstallation
  select_uninstallation
  ;;
"silent")
  # silent uninstall
  case "$2" in
  "allinone")
    exec sh "${PATH_DIR}/../OpenStack/unsetup/allinone" $MODE
    ;;
  "ncompute")
    case "$3" in
    "controller")
      exec sh "${PATH_DIR}/../OpenStack/unsetup/controller" $MODE
      ;;
    "compute")
      exec sh "${PATH_DIR}/../OpenStack/unsetup/computenode" $MODE
      ;;
    "network")
      exec sh "${PATH_DIR}/../OpenStack/unsetup/networknode" $MODE
      ;;
    *)
      # error
      echo $OS_ERROR_EXEC_ARG
      exit 1
      ;;
    esac
    ;;
  *)
    # error
    echo $OS_ERROR_EXEC_ARG
    exit 1
    ;;
  esac
  ;;
*)
  # error
  echo $OS_ERROR_EXEC_ARG
    exit 1
  ;;
esac
