#! /bin/bash

# Copyright (c) 2015, PTC Inc.  All rights reserved
# RDS PostgreSQL server psql runner script for Linux

server="rds-host"
port=5432
database="thingworx"
adminusername="pgadmin"
thingworxusername="twadmin"

while [ "$1" != "" ]; do
	case $1 in
		-h | -H )	shift
					server=$1
					;;
		-p | -P )	shift
					port=$1
					;;
		-d | -D )	shift
					database=$1
					;;
		-a | -A )	shift
					adminusername=$1
					;;
		-u | -U )	shift
					thingworxusername=$1
					;;
		--help )	shift
					echo "usage: thingworxPostgresDBSetup.sh [-h <server>] [-p <port>] [-d <thingworx-database-name>] [-a <database-admin-user-name>] [-u <thingworx-user-name>]"
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
echo Database=$database
echo Admin User=$adminusername
echo Thingworx User=$thingworxusername


echo Start
psql -q -h $server -U $adminusername -p $port -d postgres -v adminusername=$adminusername -v database=$database -v username=$thingworxusername<< EOF
SET client_min_messages TO ERROR;
\i ./thingworx-rds-database-setup.sql
EOF
echo End Execution
