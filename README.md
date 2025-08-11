# Bash Screensavers

**Tired of your boring old terminal? Wish you could spice up your command line with some animated ASCII art? Well, you've come to the right place!**

Welcome to **Bash Screensavers**, a collection of screensavers written entirely in bash. Because who needs fancy graphics cards and complex rendering engines when you have `echo`, `sleep`, and a little bit of `tput` magic?

## What is this madness?

This project is a celebration of what you can do with the humble command line. It's a bit of fun, a bit of nostalgia, and a whole lot of ASCII. We provide a main script to run the screensavers and a few examples to get you started.

## How to Use

It's as easy as pie (or, in our case, as easy as running a shell script).

1.  **Clone the repo:**
    ```bash
    git clone https://github.com/attogram/bash-screensavers.git
    cd bash-screensavers
    ```

2.  **Run the main script:**
    ```bash
    ./screensaver.sh
    ```

3.  **Choose your screensaver:**
    The script will present you with a list of available screensavers. Just type the number of the one you want to see and press Enter.

4.  **Enjoy the show!**
    To exit the screensaver, just press `Ctrl+C`.

## Create Your Own Screensaver

Got an idea for a cool ASCII animation? Want to contribute to the collection? It's easy!

1.  **Create a new directory** for your screensaver inside the `screensavers` directory. For example, `screensavers/my-awesome-screensaver`.
2.  **Create a shell script** inside your new directory with the same name as the directory, ending in `.sh`. For example, `screensavers/my-awesome-screensaver/my-awesome-screensaver.sh`.
3.  **Write your masterpiece!** Your script should:
    - Be executable (`chmod +x your-script.sh`).
    - Handle cleanup gracefully. Use `trap` to catch `SIGINT` (`Ctrl+C`) and restore the terminal to its normal state.
    - Be awesome.

That's it! The main `screensaver.sh` script will automatically detect your new creation.

## Contributing

We welcome contributions! Feel free to fork the repo, create a new screensaver, and submit a pull request. Let's make the command line a more colorful place, one ASCII character at a time.

## Join the Community

Have questions, ideas, or just want to chat? Join our Discord server!

[**Join our Discord!**](https://discord.gg/BGQJCbYVBa)

---

*Made with ❤️ and a whole lot of bash.*
