# This file reads from 12 art files and then loops.
# Each is displayed for 10 seconds. To alter that time, change the sleep value after each art file.

clear
file1="./art/1.art"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
sleep 10

clear
file1="./art/2.art"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
sleep 10

clear
file1="./art/3.art"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
sleep 10

clear
file1="./art/4.art"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
sleep 10

clear
file1="./art/5.art"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
sleep 10

clear
file1="./art/12.art"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
sleep 10

clear
file1="./art/7.art"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
sleep 10

clear
file1="./art/11.art"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
sleep 10

clear
file1="./art/9.art"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
sleep 10

clear
file1="./art/10.art"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
sleep 10

clear
file1="./art/8.art"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
sleep 10

clear
file1="./art/6.art"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
sleep 10

# Lather, Rinse, Repeat...

./rollthecute.sh