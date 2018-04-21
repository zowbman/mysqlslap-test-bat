@echo off

SET test_sql=%1
SET test_clientCount=%2
SET test_numberOfQueries=%3

:: 压测sql时间限制为如10秒
Wscript vbs\timeoutSql_sleep.vbs

tasklist|find "mysqlslap.exe">nul

if errorlevel 0 (
	echo mysqlslap Is Timeout, Will Killing...,sql - clientCount,numberOfQueries    %test_sql% - %test_clientCount%,%test_numberOfQueries%>>result\error-%test_sql%.log
    taskkill /f /im "mysqlslap.exe"
)

exit