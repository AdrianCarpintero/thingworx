@echo off
REM Copyright (c) 2015, PTC Inc.  All rights reserved

REM PostgreSQL server psql runner script for Windows

SET server=localhost
SET port=5432
SET username=twadmin
SET database=thingworx
SET schema=public
SET option=all
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
	IF "%1"=="-u" (
		SET username=%2
		SHIFT
	)
	IF "%1"=="-U" (
		SET username=%2
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
	IF "%1"=="-s" (
		SET schema=%2
		SHIFT
	)
	IF "%1"=="-S" (
		SET schema=%2
		SHIFT
	)
	IF "%1"=="-o" (
		SET option=%2
		SHIFT
	)
	IF "%1"=="-O" (
		SET option=%2
		SHIFT
	)
	IF "%1"=="--help" (
		echo usage: thingworxPostgresSchemaSetup.bat [-h ^<server^>] [-p ^<port^>] [-d ^<thingworx-database-name^>] [-s ^<schema-name^>] [-u ^<thingworx-database-username^>] [-m ^<azure-managed-instance-name^>] [-o ^<option ^(all,model,data,property,enablesso,modelwithproperty^)^>]
		GOTO :END
	)
	SHIFT
	GOTO :LOOP
)

echo Server=%server%
echo Port=%port%
echo User=%username%
echo Database=%database%
echo Schema=%schema%
echo Option=%option%
echo Azure Managed Instance=%managedinstancename%

echo Start Execution

if "%option%" == "all" (
REM Run psql
psql.exe -q -h %server% -U %username%%managedinstancename% -d %database% -p %port% -v user_name=%username% -v searchPath=%schema% -f ./thingworx-model-schema.sql
psql.exe -q -h %server% -U %username%%managedinstancename% -d %database% -p %port% -v user_name=%username% -v searchPath=%schema% -f ./thingworx-property-schema.sql
psql.exe -q -h %server% -U %username%%managedinstancename% -d %database% -p %port% -v user_name=%username% -v searchPath=%schema% -f ./thingworx-data-schema.sql
psql.exe -q -h %server% -U %username%%managedinstancename% -d %database% -p %port% -v user_name=%username% -v searchPath=%schema% -f ./thingworx-grants-schema.sql
pause
)

if "%option%" == "enablesso" (
REM Run psql
psql.exe -q -h %server% -U %username%%managedinstancename% -d %database% -p %port% -v user_name=%username% -v searchPath=%schema% -f ./thingworx-grants-schema.sql
pause
)

if "%option%" == "model" (
REM Run psql
psql.exe -q -h %server% -U %username%%managedinstancename% -d %database% -p %port% -v user_name=%username% -v searchPath=%schema% -f ./thingworx-model-schema.sql
pause
)

if "%option%" == "property" (
REM Run psql
psql.exe -q -h %server% -U %username%%managedinstancename% -d %database% -p %port% -v user_name=%username% -v searchPath=%schema% -f ./thingworx-property-schema.sql
pause
)

if "%option%" == "data" (
REM Run psql
psql.exe -q -h %server% -U %username%%managedinstancename% -d %database% -p %port% -v user_name=%username% -v searchPath=%schema% -f ./thingworx-data-schema.sql
pause
)

if "%option%" == "modelwithproperty" (
REM Run psql
psql.exe -q -h %server% -U %username%%managedinstancename% -d %database% -p %port% -v user_name=%username% -v searchPath=%schema% -f ./thingworx-model-schema.sql
psql.exe -q -h %server% -U %username%%managedinstancename% -d %database% -p %port% -v user_name=%username% -v searchPath=%schema% -f ./thingworx-property-schema.sql
pause
)

echo End Execution
:END
