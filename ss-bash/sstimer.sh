#!/bin/bash

# Copyright (c) 2014 hellofwy
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do 
      DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
      SOURCE="$(readlink "$SOURCE")"
      [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" 
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

. $DIR/sslib.sh
PORT_TIMER_CONFIG=$DIR"/port.timer"
TLOG=$DIR"/tmp/timer.log"
echo "start running at $(date +"%Y-%m-%d %T")" >> $TLOG
SLEEP_TIME=86400;

TODAY=`date +"%Y-%m-%d"`
TODAY_S=`date -d "$TODAY" +%s`
echo $TODAY
echo $TODAY_S



port_kill () {
    PORT=$1
    time=$2
    echo "$(date +"%Y-%m-%d %T") kill port:${PORT} time:$2" >> $TLOG
}


while true; do
    echo "check time"
    sleep $SLEEP_TIME
    LINE=0

    cat $PORT_TIMER_CONFIG | while read line
     do
         IFS=" "
         arr=($line)
         echo ${arr[0]}
         echo ${arr[1]}

         PORT=${arr[0]}
         PORT_TIMER=${arr[1]}

         PORT_TIMER_S=`date -d "$PORT_TIMER" +%s`

         echo $PORT_TIMER_S
         echo "l${LINE}:${line}"

         if [ $PORT_TIMER_S -lt $TODAY_S ];then
         port_kill $PORT $PORT_TIMER
         fi

         let LINE++
     done

done
