@echo off
REM -------------------------------------------------------------------
REM Debug: Log received environment variables
echo DEBUG: WORKLOAD=%WORKLOAD%
echo DEBUG: ENV=%ENV%

REM Set JMeter home directory
set "JMETER_HOME=D:\Software\apache-jmeter-5.4.3"

REM Set paths relative to current directory (cloned repository)
set "TEST_PLAN=%CD%\Scripts\Serverside\JMeter\ZipCar-PERF.jmx"
set "RESULT_LOG=%CD%\results.jtl"

REM Validate WORKLOAD
if not defined WORKLOAD (
    echo ERROR: WORKLOAD environment variable not set.
    exit /b 1
)

REM Set parameters based on workload
if /I "%WORKLOAD%"=="Smoke" (
    set threads=1
    set rampup=6
    set duration=60
) else if /I "%WORKLOAD%"=="1X" (
    set threads=6
    set rampup=60
    set duration=120
) else if /I "%WORKLOAD%"=="2X" (
    set threads=12
    set rampup=120
    set duration=300
) else (
    echo ERROR: Unsupported workload '%WORKLOAD%'. Supported values are Smoke, 1X, 2X.
    exit /b 1
)

REM Validate ENV
if not defined ENV (
    echo WARNING: ENV not set, using default 'PERF'.
    set ENV=PERF
)

REM Display execution details
echo ===========================================
echo JMeter Test Execution Details
echo -------------------------------------------
echo JMETER_HOME  : %JMETER_HOME%
echo WORKLOAD     : %WORKLOAD%
echo ENV          : %ENV%
echo Threads      : %threads%
echo Ramp-up Time : %rampup% seconds
echo Duration     : %duration% seconds
echo Test Plan    : %TEST_PLAN%
echo Result Log   : %RESULT_LOG%
echo ===========================================

REM Add JMeter bin to PATH
set "PATH=%JMETER_HOME%\bin;%PATH%"

REM Run JMeter with parameters
jmeter -n -t "%TEST_PLAN%" -l "%RESULT_LOG%" -Jthreads=%threads% -Jrampup=%rampup% -Jduration=%duration% -JENV=%ENV%

REM Check execution result
if %ERRORLEVEL% EQU 0 (
    echo JMeter test ZipCar-PERF.jmx executed successfully with WORKLOAD=%WORKLOAD%, ENV=%ENV%.
) else (
    echo JMeter test execution failed.
    exit /b 1
)