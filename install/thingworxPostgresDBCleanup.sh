#! /bin/bash
server="localhost"
port=5432
database="thingworx"
tablespace="thingworx"
adminusername="postgres"
managedinstancename=""

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
		-t | -T )	shift
					tablespace=$1
					;;
		-a | -A )	shift
					adminusername=$1
					;;
	    -m | -M )   shift
                    managedinstancename=$1
                    ;;
		--help )	shift
					echo "usage: thingworxPostgresDBCleanup.sh [-h <server>] [-p <port>] [-d <thingworx-database-name>] [-t <tablespace-name>] [-a <database-admin-user-name]  -m[azure-managed-instance-name]"
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
echo Tablespace=$tablespace
echo Admin User=$adminusername
echo Azure Managed Instance=$managedinstancename


echo Start
psql -q -h $server -d postgres -U $adminusername$managedinstancename -p $port -v database=$database -v tablespace=$tablespace<< EOF
SET client_min_messages TO ERROR;
\i ./thingworx-database-cleanup.sql
EOF

echo End Execution
