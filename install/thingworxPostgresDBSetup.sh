#! /bin/bash
server="localhost"
port=5432
database="thingworx"
tablespace="thingworx"
tablespace_location="/ThingworxPostgresqlStorage"
adminusername="postgres"
thingworxusername="twadmin"
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
		-l | -L )	shift
					tablespace_location=$1
					;;
		-a | -A )	shift
					adminusername=$1
					;;
		-u | -U )	shift
					thingworxusername=$1
					;;
        -m | -M )   shift
                    managedinstancename=$1
                    ;;
		--help )	shift
					echo "usage: thingworxPostgresDBSetup.sh [-h <server>] [-p <port>] [-d <thingworx-database-name>] [-t <tablespace-name>] [-l <tablespace-location>] [-a <database-admin-user-name>] [-u <thingworx-user-name>] -m[azure-managed-instance-name]"
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
echo Tablespace Location=$tablespace_location
echo Admin User=$adminusername
echo Thingworx User=$thingworxusername
echo Azure Managed Instance=$managedinstancename


echo Start
if [ "$managedinstancename" = "" ]; then
psql -q -h $server -d postgres -U $adminusername -p $port -v database=$database -v tablespace=$tablespace -v tablespace_location=$tablespace_location -v username=$thingworxusername<< EOF
SET client_min_messages TO ERROR;
\i ./thingworx-database-setup.sql
EOF
else
psql -q -h $server -d postgres -U $adminusername$managedinstancename -p $port -v database=$database -v tablespace=$tablespace -v tablespace_location=$tablespace_location -v username=$thingworxusername<< EOF
SET client_min_messages TO ERROR;
\i ./thingworx-database-setup-managed.sql
EOF
fi
echo End Execution