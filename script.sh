#!/usr/bin/env bash

# Compile our demo program which will crash if
# the CRASH_PLEASE environment variable is set (to anything)
g++ -o test might_crash.cpp -g -O0 -DDEBUG

# Run the program to prompt a crash
RESULT=0
./test || RESULT=$?

if [[ ${RESULT} == 0 ]]; then
    echo "\\o/ our test worked without problems"
else
    echo "ruhroh test returned an errorcode of ${RESULT}"
fi

# If the program returned an error code, now we check for a
# core file in the current working directory and dump the backtrace out
for i in $(find ./ -maxdepth 1 -name 'core*' -print); do
    gdb $(pwd) core* -ex "thread apply all bt" -ex "set pagination 0" -batch;
done

# now we should present travis with the original
# error code so the run cleanly stops
if [[ ${RESULT} != 0 ]]; then
    exit ${RESULT}
fi
