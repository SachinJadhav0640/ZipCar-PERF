@echo off
REM -------------------------------------------------------------------
REM Set JMeter home directory (adjust as needed)
set "JMETER_HOME=D:\Software\apache-jmeter-5.4.3"

REM Set full path to JMX test plan
set "TEST_PLAN=E:\SachinRJ\Projects\ZipCar-InitialDays\ZipCar-PERF\Scripts\Serverside\JMeter\ZipCar-PERF.jmx"

REM Set path for results log file
set "RESULT_LOG=E:\SachinRJ\Projects\ZipCar-InitialDays\ZipCar-PERF\Scripts\Serverside\JMeter\results.jtl"

REM Define workload parameter (example: 1X)
set "workload=Smoke"

REM Set parameters based on workload
if /I "%workload%"=="Smoke" (
    set threads=1
    set rampup=6
    set duration=60
) else if /I "%workload%"=="1X" (
    set threads=6
    set rampup=60
    set duration=120
) else if /I "%workload%"=="2X" (
    set threads=12
    set rampup=120
    set duration=300
) else (
    echo Error: Unsupported workload '%workload%'. Supported values are Smoke, 1X, 2X.
    exit /b 1
)

REM Display environment and parameters used
echo ===========================================
echo JMeter Test Execution Details
echo -------------------------------------------
echo JMETER_HOME  : %JMETER_HOME%
echo Workload     : %workload%
echo Threads      : %threads%
echo Ramp-up Time : %rampup% seconds
echo Duration     : %duration% seconds
echo Test Plan    : %TEST_PLAN%
echo Result Log   : %RESULT_LOG%
echo ===========================================

REM Add JMeter bin directory to PATH
set "PATH=%JMETER_HOME%\bin;%PATH%"

REM Run JMeter in non-GUI mode with parameters
jmeter -n -t "%TEST_PLAN%" -l "%RESULT_LOG%" -Jthreads=%threads% -Jrampup=%rampup% -Jduration=%duration%

REM Check if execution was successful
if %ERRORLEVEL% EQU 0 (
    echo JMeter test ZipCar-PERF.jmx executed successfully with workload %workload%.
) else (
    echo JMeter test execution failed.
    exit /b 1
)
