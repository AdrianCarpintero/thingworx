#! /bin/bash
server="localhost"
port=8086
adminusername="twadmin"

while [ "$1" != "" ]; do
	case $1 in
		-h | -H )	shift
					server=$1
					;;
		-p | -P )	shift
					port=$1
					;;
		-a | -A )	shift
					adminusername=$1
					;;
		--help )	shift
					echo "usage: thingworxInfluxdbDBCleanup.sh [-h <server>] [-p <port>] [-a <database-admin-user-name]"
					exit 1
					;;
		* )
					echo Unknown Option $1
					exit 1
					;;
	esac
	shift
done

echo Server=$server
echo Port=$port
echo Admin User=$adminusername


echo Start


influx -host $server -port $port -import -path=influxDbCleanup.sql
echo End Execution