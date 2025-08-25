# Contributing to Bash Screensavers

First off, thank you for considering contributing to Bash Screensavers! It’s people like you that make this project so much fun. We're excited to see what you'll bring to our collection of ASCII art animations.

## Why Contribute?

Contributing to Bash Screensavers is a great way to show off your creativity and practice your shell scripting skills. This project is all about having fun and making the command line a more exciting place. Whether you're a seasoned developer or just starting out, we welcome your ideas and contributions.

Here are a few reasons why you might want to contribute:

*   **Have fun!** This project is all about creativity and making cool things.
*   **Learn and practice.** Sharpen your `bash` scripting skills and learn how to create animations in the terminal.
*   **Be part of a community.** Join a group of like-minded people who love to tinker with the command line.
*   **Make your mark.** Create a screensaver that will be used by people all over the world.

We welcome contributions of all kinds, from new screensavers to bug fixes and documentation improvements. If you have an idea, we'd love to hear it!

### Create Your Own Screensaver

Got an idea for a cool ASCII animation? Want to contribute to the collection? It's easy!

#### The Easy Way (Generator)

You can use the built-in generator to create a new screensaver with all the boilerplate code you need. Just run:

```bash
./screensaver.sh --new my-awesome-screensaver
```
(You can also use `-n` instead of `--new`)

This will create a new directory `gallery/my-awesome-screensaver` with a starter `my-awesome-screensaver.sh` script and a `config.sh` file. All you have to do is edit the `.sh` file to add your animation logic!

#### The Hard Way (Manual)

1.  **Create a new directory** for your screensaver inside the `gallery` directory. For example, `gallery/my-awesome-screensaver`.
2.  **Create a shell script** inside your new directory with the same name as the directory, ending in `.sh`. For example, `gallery/my-awesome-screensaver/my-awesome-screensaver.sh`.
3.  **Write your masterpiece!** Your script should:
    - Be executable (`chmod +x your-script.sh`).
    - Handle cleanup gracefully. Use `trap` to catch `SIGINT` (`Ctrl+C`) and restore the terminal to its normal state.
    - Be awesome.

That's it! The main `screensaver.sh` script will automatically detect your new creation.

### Project Overview

* `./screensaver.sh` is the main menu script
    * it shows a list of available screensavers
    * and prompts user to pick one to run.
* `./gallery` is the gallery directory, where all screensavers are stored.
    * Each screensaver has its own directory inside `./gallery`
        * The name of the directory is the name of the screensaver.
        * example: screensaver named 'foo' is in: `./gallery/foo`
    * Each screensaver has a run script in format 'name.sh'
        * example: `./gallery/foo/foo.sh`
    * Each screensaver has a config file with name, tagline, etc
        * example: `./gallery/foo/config.sh`
* `./tests` directory is the BATS test suite for this project
* `./.github` directory is for GitHub Workflows for this project.

### Project Structure

```
.
├─ screensaver.sh    # Where the ASCII magic begins
├─ LICENSE           # MIT Licensed, because all the cool kids are doing it
├─ README.md         # This file, isn't it pretty?
├─ CONTRIBUTING.md   # help us out
├─ AGENTS.md         # Vibe Vibe Vibe!
├─ gallery           # Welcome to the Gallery of Terminal Visualizations
│   ├─ name          # I'm a screensaver, and I have my own directory!
│   │   └─ name.sh   # I'm a screensaver, and I can run, run, run!
│   │   └─ config.sh # Psst... want some free metadata?
├─ jury              # I gotta BATSy idea, we should test this stuff
│   └─ tests.bats    # It can't be that bad, can it?
├─ spotlight         # Tools for curators
└─ .github           # GitHub magic lives here
    └─ workflows
        └─ create.release.for.tag.yml
```

### Style Suggestions

* Indents **SHOULD** be whatever works for you
* Functions and variables **SHOULD** be in `snake_case`
* Super-duper important variables **SHOULD** be in `SCREAMING_SNAKE_CASE`
* You **MUST** have fun
    * Why use boring function names like `main()`
      when `start_the_visual_pleasure()` is just a few more characters

### Requirements

* Bash v3.2 for `./screensaver.sh`
* Individual screensavers may use any Bash version that makes them happy
* All screensavers must die with honor
  * Gracefully handle `^C` to clean up the terminal and `exit 0`
* All shell scripts must have execute permission: `chmod +x *.sh`

### Codespaces

* whip up a [Codespace from attogram/bash-screensavers](https://codespaces.new/attogram/bash-screensavers) for fun!
