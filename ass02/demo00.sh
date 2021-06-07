#!/bin/sh

echo "run test00.sh and store output into result1 ..."
chmod 755 test00.sh
./test00.sh > result1

echo "run sheeple with test00.sh store output into tmp.pl ..."
./sheeple.pl test00.sh > tmp.pl
chmod 755 tmp.pl
echo "run tmp.pl and store output into result2 ..."
./tmp.pl > result2

echo "compare result1 with result2 ..."
echo "if same should print nothing below"
diff "result1" "result2"

rm tmp.pl
rm result[0-9]