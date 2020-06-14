#! /bin/bash
#: Title       : ksession
#: Date Created: Sun Aug 26 17:55:55 PDT 2012 
#: Last Edit   : Sun Aug 26 23:02:18 PDT 2012
#: Author      : Agnelo de la Crotche (please_try_again)
#: Version     : 1.0
#: Description : save/restore 'named' KDE sessions
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#

ksmserver=~/.kde4/share/config/ksmserverrc
declare -a sessions
ver=1.0
prg=$(basename $0)


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# functions
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# use the popup library if found
which popup &>/dev/null && source $(which popup)

# use popup functions if available
function Error { 
	declare -F | grep -q 'error$' || msg Error $* 
	error "$*" || msg Error $* 
}

function Warn  { declare -F | grep -q 'warn$' && warn  "$*" || msg Warning $* ;}

function Choose { declare -F | grep -q 'choose$' || Error "function choose not available. Please install the popup library" ;}

# otherwise use this function:
function msg {
	Error=1 ; Warning=2 
	T=$1 ; shift
	cat << EOFMSG
$(tput setaf ${!T})
$T: $* 
$(tput sgr0)
EOFMSG
	[ "$T" == "Error" ] && exit
}

function syntax {

cat << EOFHELP
	
$prg $ver - Agnelo de la Crotche - 2012

usage:
	$prg option [session]

options:
	-c --clear            : clear all sessions
	-s --save <name>      : save current session as "name"
	-r --restore [<name>] : restore session "name" at next login
	-p --previous         : restore previous session
	-e --empty            : start with an empty session
	-h --help             : display this help
EOFHELP
exit
}

function sessionsClearConfirm {
	declare -F | grep -q 'ask$' && D=yes 
	case $DIALOG in
		ZENITY|KDIALOG|DIALOG) D=${D:+yes} ;;
		*) unset D ;;
	esac
	if [ "$D" ] ; then
		ask "Do you want to clear all saved sessions?"
	else
		declare -l yesno
		while [ "$yesno" != "y" -a "$yesno" != "n" ] ; do
			read -p "$(tput setaf 3)Do you want to clear all saved sessions? (y|n) $(tput sgr0)$(tput bold)" -N 1 yesno
			echo
			[ "$yesno" == "n" ] && return 1
			[ "$yesno" == "y" ] && return 0
			printf "%sPlease answer with n or y.%s\n" "$(tput setaf 1)" "$(tput sgr0)"
		done
	fi	
}

function sessionsClear {
	if ( sessionsClearConfirm ) ; then
		rm ~/.kde4/share/config/ksmserverrc
		rm -r ~/.kde4/share/config/session/*
	fi
	exit
}


function sessionSave {
	kwriteconfig --file ksmserverrc --group General  --key loginMode --type string "restoreSavedSession"
	qdbus org.kde.ksmserver /KSMServer saveCurrentSessionAs "$1"
	exit
}

function sessionDefault {
	case $1 in
		restorePreviousLogout|default) kwriteconfig --file ksmserverrc --group General  --key loginMode --type string "$1" ;;
		*) Error "Script internal error: Invalid value"
	esac
	exit
}

function sessionRestore {
	sessions=($(qdbus org.kde.ksmserver /KSMServer sessionList | sed '/default/d;/saved by user/d'))
	[ ${#sessions[*]} -eq 0 ] && Error "No session saved"
	if [ "$1" ] ; then
		SESSION=$1
	else
		if ( declare -F | grep -q ' choose$'); then
			SESSION=$(choose radio $(echo ${sessions[*]} | tr " " ",")) 
		else
			i=0
			while [ $i -le 0 -o $i -gt ${#sessions[*]} ] ; do
				echo ${sessions[*]}	| tr " " "\n" | awk '{ printf "%s) %s\n", NR, $1 }; END { printf "Select a session (1-%s): ", NR}'
				read i ; i=$(($i*1)) ; SESSION=${sessions[$(($i-1))]} 
			done
		fi
	fi
	SESSION=${SESSION% *}
	echo ${sessions[*]} | tr " " "\n" | grep -q "^$SESSION$" || Error "Session not found"
	cp $ksmserver{,.old}
	sed '/^\[LegacySession: saved by user\]/,/^ *$/d;/^\[Session: saved by user\]/,/^ *$/d' $ksmserver.old > $ksmserver
	[ $(tail -1 $ksmserver | wc -w) -gt 0 ] || echo >> $ksmserver	
	sed -n "/^\[LegacySession: $SESSION/,/^ *$/p" $ksmserver.old | sed "s|\(LegacySession: \)$SESSION|\1saved by user|" >> $ksmserver
	sed -n "/^\[Session: $SESSION/,/^ *$/p" $ksmserver.old | sed "s|\(Session: \)$SESSION|\1saved by user|" >> $ksmserver
	kwriteconfig --file ksmserverrc --group General  --key loginMode --type string "restoreSavedSession"
	exit
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[ $# -eq 0 ] && syntax

args=`getopt -q -u -o hcpes:r:: -l help,clear,previous,empty,save:,restore:: -- "$@"`
set -- $args

for i; do
	case "$i" in
	-h|--help)   syntax ;;
	-c|--clear)  sessionsClear ;;
	-s|--save)   shift ; sessionSave $1 ;;
	-r|--restore) shift ; shift ; sessionRestore $1 ;;
	-p|--previous)  sessionDefault restorePreviousLogout ;;
	-e|--empty)     sessionDefault default ;;
	*) Error "invalid argument" ;;
	esac
done