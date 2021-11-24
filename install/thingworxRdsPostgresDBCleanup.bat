@echo off

REM Copyright (c) 2015, PTC Inc.  All rights reserved
REM RDS PostgreSQL server psql runner script for Windows

SET server=rds-host
SET port=5432
SET database=thingworx
SET tablespace=thingworx
SET adminusername=pgadmin
SET admindatabase=postgres
SET thingworxusername=twadmin
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
	IF "%1"=="-u" (
		SET thingworxusername=%2
		SHIFT
	)
	IF "%1"=="-U" (
		SET thingworxusername=%2
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
		echo usage: thingworxPostgresDBCleanup.bat [-h ^<server^>] [-p ^<port^>] [-d ^<thingworx-database-name^>] [-t ^<tablespace-name^>] [-a ^<database-admin-user-name^>] [-u ^<thingworx-user-name^>] [-b ^<admin-database^>]
		SHIFT
		GOTO :END
	)
	SHIFT
	GOTO :LOOP
)

echo Server=%server%
echo Port=%port%
echo Database=%database%
echo Admin User=%adminusername%
echo Admin DB=%admindatabase%
echo Thingworx User=%thingworxusername%

echo Start Execution

REM Run psql
psql.exe -q -h %server% -U %adminusername% -p %port% -d %admindatabase% -v username=%thingworxusername% -v database=%database% -v adminusername=%adminusername% -f ./thingworx-rds-database-cleanup.sql
pause

echo End Execution
:END
