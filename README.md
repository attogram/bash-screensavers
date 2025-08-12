# Bash Screensavers

Tired of your boring old terminal?
Wish you could spice up your command line with some animated ASCII art?
Well, you've come to the right place!

Welcome to **Bash Screensavers**,
a collection of screensavers written entirely in `bash`.

Because who needs fancy graphics cards and complex rendering engines
when you have `echo`, `sleep`, and a little bit of `tput` magic?

![License](https://img.shields.io/github/license/attogram/bash-screensavers?style=flat)
![Bash ≥3.2](https://img.shields.io/badge/bash-%3E=3.2-blue?logo=gnu-bash)
![GitHub stars](https://img.shields.io/github/stars/attogram/bash-screensavers?style=flat)

## Get the party started

```bash
git clone https://github.com/attogram/bash-screensavers.git
cd bash-screensavers
./screensaver.sh
```
```
Bash Screensavers v0.0.6

  1. alpha
  2. bouncing
  3. cutesaver
  4. fireworks
  5. matrix
  6. pipes
  7. rain
  8. speaky
  9. stars
  10. tunnel

(Press ^C to exit)

Choose your screensaver:
```

## Create Your Own Screensaver

Got an idea for a cool ASCII animation? Want to contribute to the collection? It's easy!

1.  **Create a new directory** for your screensaver inside the `gallery` directory. For example, `gallery/my-awesome-screensaver`.
2.  **Create a shell script** inside your new directory with the same name as the directory, ending in `.sh`. For example, `gallery/my-awesome-screensaver/my-awesome-screensaver.sh`.
3.  **Write your masterpiece!** Your script should:
    - Be executable (`chmod +x your-script.sh`).
    - Handle cleanup gracefully. Use `trap` to catch `SIGINT` (`Ctrl+C`) and restore the terminal to its normal state.
    - Be awesome.

That's it! The main `screensaver.sh` script will automatically detect your new creation.

## Guide for Developers and AI agents

### Project Overview

* `./screensaver.sh` is the main menu script
    * it shows a list of available screensavers
    * and prompts user to pick one to run.
* `./gallery` is the gallery directory, where all screensavers are stored.
    * Each screensaver has its own directory inside `./gallery`
        * The name of the directory is the name of the screensaver.
        * example: screensaver named 'foo' is in: `./gallery/foo`
    * Each screensaver must have a run script in format 'name.sh'
        * example: `./gallery/foo/foo.sh`
* `./tests` directory is the BATS test suite for this project
* `./.github` directory is for GitHub Workflows for this project.

### Project Structure

```
.
├─ screensaver.sh    # Where all the visual pleasuring starts
├─ LICENSE           # MIT Licensed, because all the cool kids are doing it
├─ README.md         # This file, isn't it pretty?
├─ gallery           # Welcome to the Gallery of Terminal Visualizations
│   ├─ name          # I'm a screensaver, and I have my own directory!
│   │   └─ name.sh   # I'm a screensaver, and I can run, run, run!
├─ tests             # I gotta BATSy idea, we should test this stuff
│   └─ tests.sh      # It can't be that bad, can it?
└─ .github           # GitHub magic lives here
    └─ workflows
        └─ create.release.for.tag.yml
```

### Requirements

* Bash v3.2 for `./screensaver.sh`
* Individual screensavers may use any Bash version that makes them happy
* All screensavers must die with honor
  * Gracefully handle `^C` to clean up the terminal and `exit 0`
* All shell scripts must have execute permission: `chmod +x *.sh`

### Style Suggestions

* Indents **SHOULD** be 2 spaces, but whatever works for you
* `snake_case` for function names and variables
* `SCREAMING_SNAKE_CASE` for super-duper important variables
* You **MUST** have fun!
    * Don't use boring function names like `main()`
    * More fun are function names like `start_the_visual_pleasure()`

## Contributing

We welcome contributions!

Feel free to fork the repo, create a new screensaver, and submit a pull request.

Let's make the command line a more colorful place, one ASCII character at a time.

## Join the Community

Have questions, ideas, or just want to chat? Join our Discord server!

[**Join our Discord!**](https://discord.gg/BGQJCbYVBa)

---

*Made with ❤️ and a whole lot of bash.*
