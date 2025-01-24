#!/bin/bash

OPTION="${1}"
IP="${2}"
PORTS="${3}"

GREEN='\033[0;32m'
NC='\033[0m'

VERSION='1.0'



_Clear_(){
        rm -rf /tmp/knock &>/dev/null
}

_Banner_(){
        echo -e "
        #################################################
        #                                               #
        #               Porting Knocking                #
        #                 ZTM   Security                #
        #               Version ${VERSION}                      #
        #                                               #
        #################################################
        Usage   : [IP Knocking] [PORTS]
        Example : ${0} -s 10.10.10.10 \"35 47 30000 3000\"
        "
}


_Help_(){

        echo -e "
        Knocking-Port ${VERSION}, send a packet SYN for Port Knocking or send a Port Knocking SYN range IP

        Usage: ${0} [OPTION] [IP] [PORT] 

        Example: ${0} -r 10.10.10 \"33 65 1000 2228\"

        Example: ${0} -s 192.168.1.20 \"33 65 1000 2228\"

        OPTIONS

                -h, --help
                        Show Help Menu

                -v, --version
                        Show the version

                -s, --single
                        Send SYN Packets for a single IP

                -r, --range
                        Send SYN Packets for a range IP

        "
}

_Verified_(){
        if ! [[ -e /usr/bin/nc ]]; then
                echo -e "\nThe NC program not found.\n"
                exit 1
        fi
        if [[ "${OPTION}" == "" ]]; then
                _Banner_
                exit 1
        fi
}

_Sweep_(){

        mkdir /tmp/knock && cd /tmp/knock

        echo -e "Sweep IPS Verification";
        for i in {1..254}
                do (ping -c 1 ${IP}.$i | grep "bytes from" | cut -d ":" -f1 | cut -d " " -f4 &) >> ips;
        done
        echo -e "IPS Sweep Virified";

}

_Knock_(){

        echo -e "
                #################################################
                #               IP Send Ports SYN               #
                #################################################
        "

        for port in $PORTS;do
                nc -w1 -z -v -n $IP $port &>/dev/null
                sleep .5
                echo -e "Send SYN Packets Port: ${port}\n"
        done

        if [ $? -eq 0 ]; then
                echo -e "${GREEN}Port knocking successful!${NC}"
        else
                echo "Port knocking failed."
        fi
}

_KnockSweep_(){

        _Sweep_

        echo -e "
                #################################################
                #               Range Send SYN Ports            #
                #################################################
        "
        for hosts in $(cat ips);do
                for port in $PORTS
                do
                        nc -w1 -z -v -n $hosts $port &>/dev/null
                        sleep .5
                        echo -e "Send Packet SYN $hosts:$port\n"
                done
        if [ $? -eq 0 ]; then
                echo -e "${GREEN}Port Knocking sucessfuly!${NC}\n"
        else
                echo -e "Port Knocking Failed.\n"
        fi
        done
        _Clear_
}

_Main_(){

        _Verified_

        case "${OPTION}" in
                "-v"|"--version")
                        echo -e "\nVersion: ${VERSION}\n"
                        exit 0
                ;;
                "-h"|"--help")
                        _Help_
                        exit 0
                ;;
                "-r"|"--range")
                        _KnockSweep_
                        _Clear_
                ;;

                "-s"|"--single")
                        _Knock_
                ;;
        esac
}

_Main_
