#!/bin/bash

# @MODIFIED 2025 - MIT License - for https://github.com/attogram/bash-screensavers
# @ORIGINAL - MIT License - https://github.com/kestraI/cutesaver

# Here we go, then - an ASCII screensaver of cuteness. It's a bit rudimentary,
# but hey... It was made with love in about 45 minutes whilst waiting for a flight.

# A huge shoutout to some of the most wonderful cuties I know:
# Mispy, Catherine, Ninji, Fiora, __builtin_trap, Gewt, Hachidorii, Kwanre, Talen, Whitequark, Louise, Emma, Chris, Katnarine, Dirt, Nimby, Hoodie, Simon...
# The list goes on. I love you all.

# Anyway, on with the cuteness. Let's load some title art.

cd "$( dirname "${BASH_SOURCE[0]}" )"

clear
file1="./art/title.art"
while IFS= read -r line
do
	echo "$line"
done <"$file1"

# Echo out a simple introduction, spaced with sleeps for readability...

echo
echo
echo "Cuteness for your screen, cuteness for your soul."
echo
sleep '0.5'
echo "You deserve something cute to look at. A mirror would help"
echo "with that, but I'm just a lowly command line application..."
echo
sleep '0.5'
echo "ASCII to the rescue!"
sleep '0.5'
echo
echo "You're about to get put into an infinite loop of cuteness."
sleep '0.5'
echo
echo "Leave it running for as long as you like. To exit, just press"
echo "CTRL+C at any time and you'll drop back to the shell."
echo
sleep 2
# read -p "Press [ENTER] to start..."

# Now we'll simply load the ever-looping cuteness file.
./rollthecute.sh

# Et Voila!
exit
