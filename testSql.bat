:: name mysqlslap压测脚本
:: parameter %1 <sql-name> in sql file folder
:: parameter %2 Average number of queries per client
:: success-log result\result-<sql-name>.log
:: error-log result\error-<sql-name>.log
:: author wileycheung
:: date 2018/04/21

@echo off

setlocal ENABLEDELAYEDEXPANSION

SET test_sql=%1
SET test_sql_path=sql\%test_sql%

if "%test_sql%" == "" (
	echo TEST SQL IS NULL,WILL EXIT...
	pause
	exit
)

SET avgNumOfQueriesPerClient=%2

if "%avgNumOfQueriesPerClient%" == "" (
	SET avgNumOfQueriesPerClient=5
)

echo Starting Test SQL 

:: mysqlslap路径
SET mysqlslap=

:: db相关信息
SET db_host=
SET db_username=
SET db_pwd=

:: 测试信息
SET test_count=
SET test_db=

:: 输出日志
SET resultLog=result\result-%test_sql%.log

echo -----------------------------TEST START-----------------------------

echo Starting Test SQL -- xx_member_select1>>%resultLog%

:: 循环数组值为并发客户端，如20,50,75,100
for /d %%i in (20,50,75,100) do (
	SET test_clientCount=%%i
	SET /a test_numberOfQueries=%%i*%avgNumOfQueriesPerClient%

	echo %test_sql% Test Starting... clientCount:!test_clientCount!,numberOfQueries:!test_numberOfQueries!
	echo.

	echo.>>%resultLog%
	echo %test_sql% TEST... clientCount:!test_clientCount!,numberOfQueries:!test_numberOfQueries!>>%resultLog%
	echo.>>%resultLog%

	:: 对mysqlap压测时间超时监听，超时时间在timeoutSql_sleep.vbs中设置
	start "Test SQL Timeout" timeoutSql.bat %test_sql% !test_clientCount! !test_numberOfQueries!

	:: mysqlslap
	"%mysqlslap%" -h%db_host% -u%db_username% -p%db_pwd% --create-schema=%test_db% -q %test_sql_path% -c !test_clientCount! --number-of-queries=!test_numberOfQueries! -i %test_count% ?§Cdelimiter=";">>%resultLog%
	
	:: 结束对mysqlap压测时间超时监听的进程
	taskkill /f /fi "windowtitle eq Test SQL Timeout - timeoutSql.bat*">nul

	echo.
	echo %test_sql% Test finishing... clientCount:!test_clientCount!,numberOfQueries:!test_numberOfQueries!

	:: mysqlap压测后，睡眠如5秒用来等待db释放进程，再继续压测下一次指标
	Wscript vbs\testSql_sleep.vbs
)

echo finishing Test SQL -- xx_member_select1>>%resultLog%
echo.>>%resultLog%

echo -----------------------------TEST END-----------------------------

pause

::Can Play
::░▄█▀▀▄▓█▓▓▓▓▓▓▓▓▓▓▓▓▀░▓▌█ LET DOGES TAKE OVER THE WORKSHOP
::░░█▀▄▓▓▓███▓▓▓███▓▓▓▄░░▄▓▐█▌ 
::░█▌▓▓▓▀▀▓▓▓▓███▓▓▓▓▓▓▓▄▀▓▓▐█ 
::▐█▐██▐░▄▓▓▓▓▓▀▄░▀▓▓▓▓▓▓▓▓▓▌█▌
::█▌███▓▓▓▓▓▓▓▓▐░░▄▓▓███▓▓▓▄▀▐█ 
::█▐█▓▀░░▀▓▓▓▓▓▓▓▓▓██████▓▓▓▓▐█ COPY AND PASTE AND LET THE DOGES RULE
::▌▓▄▌▀░▀░▐▀█▄▓▓██████████▓▓▓▌█▌ 
::▌▓▓▓▄▄▀▀▓▓▓▀▓▓▓▓▓▓▓▓█▓█▓█▓▓▌█▌ 
::█▐▓▓▓▓▓▓▄▄▄▓▓▓▓▓▓████████████
::Can Play