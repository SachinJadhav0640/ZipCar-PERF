#!/bin/bash

# Usage: ./run_jmeter.sh <JMETER_HOME> <WORKLOAD_JMX> <RESULTS_LOG> <JAVA_HEAP_SIZE> <ENV_VARS_FILE>

# Parameters
JMETER_HOME=$1           # JMeter installation directory (passed from Jenkins)
WORKLOAD_JMX=$2          # Path to JMeter test plan (.jmx file)
RESULTS_LOG=$3           # Path to results log file (.jtl)
JAVA_HEAP_SIZE=$4        # Java heap size, e.g. 2g, 4g
ENV_VARS_FILE=$5         # File containing environment variables to source

# 1. Set JAVA_HEAP (heap size for JVM running JMeter)
export HEAP="-Xms$JAVA_HEAP_SIZE -Xmx$JAVA_HEAP_SIZE"

# 2. Source environment variables if provided
if [ -f "$ENV_VARS_FILE" ]; then
  source "$ENV_VARS_FILE"
fi

# 3. Set JMETER_HOME and update PATH
export JMETER_HOME
export PATH=$JMETER_HOME/bin:$PATH

# 4. Run JMeter in non-GUI mode with specified workload and log file
# Use the HEAP settings for Java options
export JVM_ARGS="$HEAP"

# Execute JMeter non-GUI test
jmeter -n -t "$WORKLOAD_JMX" -l "$RESULTS_LOG"

# Check exit status
if [ $? -eq 0 ]; then
  echo "JMeter test executed successfully."
else
  echo "JMeter test execution failed."
  exit 1
fi