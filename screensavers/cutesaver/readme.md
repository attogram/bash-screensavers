@MODIFIED 2025 - MIT License - for https://github.com/attogram/bash-screensavers

@ORIGINAL - MIT License - https://github.com/kestraI/cutesaver


CuteSaver
=========

A simple ASCII screensaver in Bash Script.


Introduction
------------

Cuteness, cuteness everywhere! Something I threw together whilst waiting for a flight - this simple set of scripts loops through a few pre-defined ASCII images.

To run the app, simply execute the script in this repo's root folder as follows:

```bash:
./cute
```


The Logic (a.k.a. The Heart)
----------------------------

I use the word 'logic' quite ironically - this is a pretty simple set of scripts. The 'cute' script enters the /heart directory and executes the 'main.sh' - this file gives the user an introduction and in turn executes the art display script.

Parameters for all can be changed easily. The files are all commented... go nuts!

### Having issues getting it working? Getting weird errors?

Check the permissions on the 'cute' file, and the files within the /heart folder. If you need to, chmod +x to make the files executable.


The Artwork (a.k.a. The Art)
----------------------------

To get around special character issues (e.g. artwork containing ./ which the script would try to execute), all of the ASCII art is stored in indivudual .art files in the /art folder.

You can add any number of files to that folder - you just need to add the relevant lines in /heart/rollthecute.sh.

Try to keep in mind that many people will use this in a terminal window rather than full screen - smaller art is better... just as long as it's cute!


Contributing & License
--------------

This code is relased under the MIT License. Please see the LICENSE file for more information on what this means and how to make attributions.

Acknowledgements
----------------

My friends are my life. I love you all. Thanks for inspiring me every single day.

Comments, questions, suggestions? [Get in touch.](mailto:kes@kesgai.com).

[Kes](http://www.kesgai.com)