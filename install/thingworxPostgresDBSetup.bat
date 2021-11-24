@echo off
REM Copyright (c) 2015, PTC Inc.  All rights reserved

REM PostgreSQL server psql runner script for Windows

SET server=localhost
SET port=5432
SET database=thingworx
SET tablespace=thingworx
SET tablespace_location=/ThingworxPostgresqlStorage
SET adminusername=postgres
SET thingworxusername=twadmin
SET managedinstancename=""

for /f "delims=" %%a in ('chcp ^|find /c "932"') do @ SET CLIENTENCODING_JP=%%a
if "%CLIENTENCODING_JP%"=="1" SET PGCLIENTENCODING=SJIS
if "%CLIENTENCODING_JP%"=="1" SET /P PGCLIENTENCODING="Client Encoding [%PGCLIENTENCODING%]: "

:LOOP
IF NOT "%1"=="" (
	IF "%1"=="-h" (
		SET server=%2
		SHIFT
	)
	IF "%1"=="-H" (
		SET server=%2
		SHIFT
	)
	IF "%1"=="-p" (
		SET port=%2
		SHIFT
	)
	IF "%1"=="-P" (
		SET port=%2
		SHIFT
	)
	IF "%1"=="-d" (
		SET database=%2
		SHIFT
	)
	IF "%1"=="-D" (
		SET database=%2
		SHIFT
	)
	IF "%1"=="-t" (
		SET tablespace=%2
		SHIFT
	)
	IF "%1"=="-T" (
		SET tablespace=%2
		SHIFT
	)
	IF "%1"=="-l" (
		SET tablespace_location=%2
		SHIFT
	)
	IF "%1"=="-L" (
		SET tablespace_location=%2
		SHIFT
	)
	IF "%1"=="-a" (
		SET adminusername=%2
		SHIFT
	)
	IF "%1"=="-A" (
		SET adminusername=%2
		SHIFT
	)
	IF "%1"=="-u" (
		SET thingworxusername=%2
		SHIFT
	)
	IF "%1"=="-U" (
		SET thingworxusername=%2
		SHIFT
	)
	IF "%1"=="-m" (
		SET managedinstancename=%2
		SHIFT
	)
	IF "%1"=="-M" (
		SET managedinstancename=%2
		SHIFT
	)
	IF "%1"=="--help" (
		echo usage: thingworxPostgresDBSetup.bat [-h ^<server^>] [-p ^<port^>] [-d ^<thingworx-database-name^>] [-t ^<tablespace-name^>] [-l ^<tablespace-location^>] [-a ^<database-admin-user-name^>] [-u ^<thingworx-user-name^>] [-m ^<azure-managed-instance-name^>]
		GOTO :END
	)
	SHIFT
	GOTO :LOOP
)

echo Server=%server%
echo Port=%port%
echo Database=%database%
echo Tablespace=%tablespace%
echo Tablespace Location=%tablespace_location%
echo Admin User=%adminusername%
echo Thingworx User=%thingworxusername%
echo Azure Managed Instance=%managedinstancename%

echo Start Execution

REM Run psql
IF %managedinstancename%=="" (
	psql.exe -q -h %server% -d postgres -U %adminusername% -p %port% -v database=%database% -v tablespace=%tablespace% -v username=%thingworxusername% -v tablespace_location=%tablespace_location% -f ./thingworx-database-setup.sql
	pause
) else (
	psql.exe -q -h %server% -d postgres -U %adminusername%%managedinstancename% -p %port% -v database=%database% -v tablespace=%tablespace% -v username=%thingworxusername% -v tablespace_location=%tablespace_location% -f ./thingworx-database-setup-managed.sql
	pause
)
echo End Execution
:END
