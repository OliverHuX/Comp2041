#!/bin/dash

wget -q -O- http://www.timetable.unsw.edu.au/current/$1KENS.html |egrep ".*$1[0-9]{4}.*"|sed 's/<tdclass="data"><ahref="//g'|sed 's/.html//g'|egrep -v ".*$1[0-9]{4}.*$1[0-9]{4}.*"|sed 's/^ *//g'|sed 's/<td class="data"><a href="//'|sed 's/">/ /'|sed 's/<\/a><\/td>//'|sort|uniq
