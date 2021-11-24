@echo off
REM Copyright (c) 2015, PTC Inc.  All rights reserved

REM PostgreSQL server psql runner script for Windows

SET server=localhost
SET port=5432
SET database=thingworx
SET tablespace=thingworx
SET adminusername=postgres
SET admindatabase=postgres
SET managedinstancename=""

for /f "delims=" %%a in ('chcp ^|find /c "932"') do @ SET CLIENTENCODING_JP=%%a
if "%CLIENTENCODING_JP%"=="1" SET PGCLIENTENCODING=SJIS
if "%CLIENTENCODING_JP%"=="1" SET /P PGCLIENTENCODING="Client Encoding [%PGCLIENTENCODING%]: "
:LOOP
IF NOT "%1"==""  (
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
	IF "%1"=="-a" (
		SET adminusername=%2
		SHIFT
	)
	IF "%1"=="-A" (
		SET adminusername=%2
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
	IF "%1"=="-b" (
    		SET admindatabase=%2
    		SHIFT
    	)
    	IF "%1"=="-B" (
    		SET admindatabase=%2
    		SHIFT
    	)
	IF "%1"=="--help" (
		echo usage: thingworxPostgresDBCleanup.bat [-h ^<server^>] [-p ^<port^>] [-d ^<thingworx-database-name^>] [-t ^<tablespace-name^>] [-a ^<database-admin-user-name^>] [-b ^<admin-database^>] [-m ^<azure-managed-instance-name^>]
		SHIFT
		GOTO :END
	)
	SHIFT
	GOTO :LOOP
)

echo Server=%server%
echo Port=%port%
echo Database=%database%
echo Tablespace=%tablespace%
echo Admin User=%adminusername%
echo Admin DB=%admindatabase%
echo Azure Managed Instance=%managedinstancename%

echo Start Execution

REM Run psql
psql.exe -q -h %server% -U %adminusername%%managedinstancename% -p %port% -d %admindatabase% -v database=%database% -v tablespace=%tablespace% -f ./thingworx-database-cleanup.sql
pause

echo End Execution
:END
