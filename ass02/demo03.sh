#!/bin/sh

echo "run test03.sh and store output into result1 ..."
chmod 755 test03.sh
touch 1
touch 5
./test03.sh 1 5 > result1

echo "run sheeple with test03.sh store output into tmp.pl ..."
./sheeple.pl test03.sh > tmp.pl
chmod 755 tmp.pl
echo "run tmp.pl and store output into result2 ..."
./tmp.pl 1 5 > result2

echo "compare result1 with result2 ..."
echo "if same should print nothing below"
diff "result1" "result2"

rm tmp.pl
rm result[0-9]
rm 1
rm 5