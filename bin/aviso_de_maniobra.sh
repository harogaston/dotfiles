#!/bin/sh

testmessage() {
    lazy=`cat /tmp/email_input.tmp | grep '<message>'`
    if [ -n "$lazy" ]; then
        echo "Indique los cambios realizados"
        read -rsn1 -p"Presione cualquier tecla para continuar...";echo
        prompt
        testmessage
    fi
}

prompt() {
    vi /tmp/email_input.tmp

    if [ $? != 0 ]; then
      printf "Te agarré"
      exit $ERROR_CODE
    fi

    modified_content="`cat /tmp/email_input.tmp`"
}

loadtemplate() {
    original_content=\
$'From: <from>
To: <to>, <cc>
Subject: Aviso de maniobra
MIME-Version: 1.0
Date: <date>
Content-Type: text/plain; charset="UTF-8"
Message-Id: <uuid>
*Maniobra*\n
    Instalación de versión <version>\n
\n
*Ambientes Afectados*\n
    <envs>\n
\n
*Detalles*\n
    <message>\n
\n
Hora de Comienzo: <start>\n
Tiempo estimado: <duration> minutos.
\n
--
<signature>'

    echo "$original_content" > /tmp/email_input.tmp
	echo "$UUID" > /tmp/email_messageID.tmp
}

substitute() {
	now=`date -R`
	sed -i "s/<from>/$from/g" /tmp/email_input.tmp
	sed -i "s/<to>/$to/g" /tmp/email_input.tmp
	sed -i "s/<cc>/$cc/g" /tmp/email_input.tmp
	sed -i "s/<date>/$now/g" /tmp/email_input.tmp
	sed -i "s/<uuid>/$UUID/g" /tmp/email_input.tmp

	sed -i "s/<envs>/$envs/g" /tmp/email_input.tmp
	sed -i "s/<start>/$start/g" /tmp/email_input.tmp
	sed -i "s/<duration>/$duration/g" /tmp/email_input.tmp
	sed -i "s/<version>/$version/g" /tmp/email_input.tmp
	sed -i "s/<message>/$message/g" /tmp/email_input.tmp

	sed -i "s/<signature>/$(echo $signature)/g" /tmp/email_input.tmp
}

usage() {
    lolban 'Aviso de maniobra'
    echo ""
    echo ""
	bold="\033[1m"
	normal="\033[0m"
	echo -e "${bold}USAGE${normal}:"
	echo -e "\t aviso_de_maniobra.sh -v <version> -e <ambiente/s> [-s comienzo] [-d duration] [-m detalles]\n"
	echo -e "${bold}PARAMS${normal}:"
	echo -e "\t${bold}-v${normal}\tIndica el número de versión de la liberación."
	echo -e "\t${bold}-e${normal}\tIndica el/los ambientes afectados."
	echo -e "\n${bold}OPTIONAL PARAMS${normal}:"
	echo -e "\t${bold}-s${normal}\tHora de comienzo de la maniobra."
	echo -e "\t\tValor por defecto: \$now"
	echo -e "\t${bold}-d${normal}\tTiempo estimado de la maniobra (en minutos)."
	echo -e "\t\tValor por defecto: 30."
	echo -e "\t${bold}-m${normal}\tMensaje para indicar los detalles de la maniobra"
	echo -e "\t\tNo es obligatorio como parámetro pero debe especificarse un mensaje antes de confirmar.\n"
	echo -e "${bold}Ejemplo${normal}:"
	echo -e "\t ./maniobra -v 2.1.5 -e Produccion -m 'Se liberó algo maravilloso'"
}

param_req() {
    param=
    case $1 in
        v)
            param="version"
            ;;
        e)
            param="ambientes"
            ;;
    esac
    echo "El parámetro -$1 ($param) es requerido"
}

save() {
	echo "$modified_content" > /tmp/email_output
}

sendemail() {
	echo "helo ideasoft.biz"
	sleep 1
	echo "mail from: $from"
	sleep 1
	echo "rcpt to: $to"
	sleep 1
	echo "rcpt to: $cc"
	sleep 1
	echo "data"
	sleep 1
	echo "$modified_content"
	sleep 1
	echo "."
	sleep 1
	echo "quit"
}

version=
start=`date +"%H:%M"`
duration="30"
envs=
message="<message>"
from="gharo@ideasoft.biz"
to="om-gestion@ideasoft.biz"
cc="Pogo-Desarrollo@mail.Antel.com.uy"
UUID="<$(cat /proc/sys/kernel/random/uuid)>"
signature='Gastón Haro\n\nSoftware Developer - Ideasoft\ngharo@ideasoft.biz\nwww.ideasoft.biz'

while getopts ":hv:e:s:d:m:" OPTION
do
	case $OPTION in
		h)
			usage
			exit
			;;
		v)
			version=$OPTARG
			;;
		s)
			start=$OPTARG
			;;
		d)
			duration=$OPTARG
			;;
		e)
			envs=$OPTARG
			;;
		m)
			message=$OPTARG
			;;
	esac
done

if [ -z "$version" ]; then
	param_req "v"
	exit 1;
elif [ -z "$envs" ]; then
	param_req "e"
	exit 1;
fi

main() {
	loadtemplate
	substitute
	prompt
	testmessage
	save
	sendemail | telnet smtp.ideasoft.biz 25
	echo "Enviado con éxito."
	exit 0;
}

main
