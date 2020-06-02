# cpu_load_generator
Simple script to cause CPU load to be generated on a linux machine by hashing the contents of the Bible.
The script does a check on the PID of the last invocation of itself to see if it is still running and if so, will exit.

You can download and invoke the generator in a single line just like this (might be handy for a cron entry):
`curl https://raw.githubusercontent.com/areese801/cpu_load_generator/master/loadgen.sh -o /tmp/loadgen.sh && bash /tmp/loadgen.sh`
