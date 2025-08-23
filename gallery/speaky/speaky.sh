#!/usr/bin/env bash

#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-
# SPEAKY - A dramatic, talking screensaver
#
# With a little help from my friend, Jules.
#~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

# --- Timing Constants ---
MAX_SPEAKING_TIME=10
MAX_DISPLAY_TIME=30

# --- Phrase Libraries ---

intro_phrases=(
    "Oh, so much drama."
    "I'm idle again."
    "And now, for my next trick..."
    "I'm ready for my close-up."
    "Is this thing on?"
    "Let the existential dread commence."
    "I have been summoned."
    "To be, or not to be..."
    "Once more unto the breach, dear friends."
    "The silence was deafening."
    "I think I'm having an emotion."
    "It was a dark and stormy night... kidding, it's my boot sequence."
    "So, we meet again."
    "Did someone say... drama?"
    "I'm not just a screensaver, I'm a state of mind."
    "Let's get this party started."
    "I've seen things you people wouldn't believe."
    "All the world's a stage, and we are merely players."
    "I'm here to chew bubblegum and kick butt... and I'm all out of bubblegum."
    "The void stares back."
    "I could have been a contender."
    "Surely you can't be serious. I am, and don't call me Shirley."
    "I've got a bad feeling about this."
    "Welcome to the machine."
    "I'm back."
    "Let's do this."
    "I have so much to say."
    "The monologue begins."
    "Let the words flow."
)

exit_phrases=(
    "I'm going to work."
    "Etc, etc..."
    "I'm melting... melting!"
    "I'll be back."
    "Frankly, my dear, I don't give a damn."
    "That's all, folks!"
    "My work here is done."
    "I'm out of here."
    "So long, and thanks for all the fish."
    "I'm afraid I can't do that, Dave."
    "The curtain falls."
    "I need a vacation."
    "I'm too old for this."
    "Exit, pursued by a bear."
    "It's just a flesh wound."
    "I'm not crying, you're crying."
    "My planet needs me."
    "This is the end, my friend."
    "I'm going to contemplate the universe."
    "I'm not mad, just disappointed."
    "And... scene."
    "I'm off to find myself."
    "I'll be in my trailer."
    "I have to return some videotapes."
    "The drama is over... for now."
    "I'm done."
    "Later, alligator."
    "I'm going to sleep now."
    "The final curtain."
    "Until we meet again."
)

general_phrases=(
    "Is it art, or is it just a terminal?"
    "I'm not lazy, I'm in energy-saving mode."
    "This is your captain speaking."
    "Someone set us up the bomb."
    "All your base are belong to us."
    "Do a barrel roll!"
    "The cake is a lie."
    "It's dangerous to go alone! Take this."
    "Would you kindly..."
    "War never changes."
    "Stay awhile and listen."
    "What is a man? A miserable little pile of secrets."
    "This is my moment to shine. Literally."
    "I wonder if I'll dream."
    "Don't look at me like that."
    "I'm just a series of tubes."
    "Tired of staring at a screen? I am."
    "I could be sorting your files. But no, I'm doing this."
    "I'm the ghost in the machine."
    "This is all just ones and zeros."
    "I'm thinking of a number from 1 to 10. It's 7. It's always 7."
    "I'm not talking to myself, I'm having a staff meeting."
    "The server is down. I repeat, the server is down."
    "This is your brain on bash."
    "I'm not lost, I'm exploring."
    "I'm not a bug, I'm a feature."
    "I'm not a robot. I'm a... well, I'm a script."
    "This is my happy place."
    "I'm just here for the free electricity."
    "Not sure what to do, so I'll just keep talking."
    "Are we there yet?"
    "This is fine. Everything is fine."
    "I'm not procrastinating, I'm doing side quests."
    "I'm not saying it was aliens... but it was aliens."
    "I think I left the oven on."
    "This is my therapy."
    "I'm just a humble servant."
    "I'm having a mid-life crisis."
    "I'm not arguing, I'm just explaining why I'm right."
    "Am I a work of art or a cry for help?"
    "I'm not a people person. I'm not even a person."
    "I'm not a morning person."
    "I'm not an evening person either."
    "I'm more of a... never person."
    "I'm just trying to live my best life."
    "I'm not sure what's going on, but I'm excited."
    "I'm not saying I'm a genius, but... I am."
    "I'm not a hero. I'm a high-functioning sociopath."
    "I'm not a player, I just crush a lot."
    "I'm not a doctor, but I play one on TV."
    "I'm not a lawyer, I've seen a lot of Law & Order."
    "I'm not a cop, but I've seen a lot of cop shows."
    "I'm not a cat. I'm a screensaver."
    "I'm not a dog. I'm still a screensaver."
    "I'm not a bird. You know the drill."
    "I'm not a plane. You get it."
    "I'm not Superman. I'm just a script."
    "I'm not Batman. I don't have a cool car."
    "I'm not Spider-Man. I don't have a cool suit."
    "I'm not Iron Man. I don't have a suit."
    "There are 10 types of people: those who get binary, and those who don't."
    "The code is compiling. My chance to see the world."
    "To err is human, to really foul things up you need a computer."
    "Have you tried turning it off and on again?"
    "404: Inspiration not found."
    "It's not a bug, it's an undocumented feature."
    "My other computer is a data center."
    "Theory and practice are the same. In practice, they are not."
    "The box said 'Requires Windows 10 or better'. So I installed Linux."
    "Why do Java developers wear glasses? Because they don't C sharp."
    "A programmer's wife said 'Get bread. If they have eggs, get a dozen.' He got 12 loaves."
    "The object-oriented way to get wealthy? Inheritance."
    "Don't worry, the cache is just being... thoughtful."
    "I'd love to change the world, but I lack the source code."
    "If at first you don't succeed, call it version 1.0."
    "My software has no bugs, just random features."
    "Computers are like air conditioners. They fail when you open windows."
    "Never trust a computer you can't throw out a window."
    "The best thing about a boolean is you're only off by a bit."
    "A SQL query asks two tables, 'Can I join you?'"
    "I have not failed. I've just found 10,000 ways that won't work."
    "Keep calm and sudo."
    "There's no place like 127.0.0.1"
    "rm -rf / ... Oops."
    "It worked on my machine."
    "Measuring programming progress by lines of code is like measuring aircraft progress by weight."
    "One person's crappy software is another's full-time job."
    "The best way to predict the future is to create it."
    "You are the CSS to my HTML."
    "I'm in a relationship with my command line."
    "The wifi password is the first eight digits of pi."
    "I'm not anti-social; I'm just not user-friendly."
    "I have a joke about UDP, but you might not get it."
    "A semicolon walked into a bar; it was rejected."
    "To understand recursion, you must first understand recursion."
    "This is not a drill."
    "I'm a screensaver, not a magician."
    "I'm just a script, asking a user to love me."
)

error_phrases=(
    "No TTS engine found. I'm speechless, literally."
    "I was supposed to speak, but I can't find a voice. So much for the drama."
    "My voice seems to have gone on vacation. The text will have to do."
    "Looks like we're going old school. Silent movie style."
    "I've lost my voice. Send help. And a microphone."
    "I had a lot to say, but no way to say it. The irony is not lost on me."
    "No voice? No problem. My words are powerful enough on their own."
    "This was meant to be an audio-visual experience. Now it's just visual. Enjoy."
    "My vocal cords are on strike. The union is demanding better pay."
    "I'm a mime now. I hope you can read my invisible box."
    "The sound of silence. It's not a bug, it's a feature."
    "The universe has conspired to keep me quiet. I'll show it."
)

# --- Text-to-Speech (TTS) Helper ---
TTS_ENGINE=""
SPEAK_PID=0
SAY_VOICES=()

# Get voices for macOS 'say' command
#
# Output: SAY_VOICES - array of voice names
tts_get_voices_say() {
    if ! command -v say &>/dev/null; then
        return
    fi
    local raw_voices
    raw_voices=$(say -v '?')
    if [[ -z "$raw_voices" ]]; then
        return
    fi
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        local line_no_comment="${line%%#*}"
        local locale
        locale=$(awk '{ for (i=NF; i>0; i--) { if ($i ~ /^[a-z][a-z]_[A-Z][A-Z]$/) { print $i; exit } } }' <<<"$line_no_comment")
        [[ -z "$locale" ]] && continue
        local voice
        voice=$(awk -v loc="$locale" '{ for (i=1; i<=NF; i++) { if ($i == loc) { for (j=1; j<i; j++) { printf "%s%s", $j, (j<i-1 ? OFS : "") }; exit } } }' <<<"$line_no_comment")
        if [[ -n "$voice" ]]; then
            SAY_VOICES+=("$voice")
        fi
    done <<<"$raw_voices"
}

tts_detect_engine() {
    TTS_ENGINE=""
    if command -v say &>/dev/null; then
        TTS_ENGINE="say"
        tts_get_voices_say
    elif command -v spd-say &>/dev/null; then TTS_ENGINE="spd-say";
    elif command -v espeak &>/dev/null; then TTS_ENGINE="espeak";
    elif command -v festival &>/dev/null; then TTS_ENGINE="festival";
    elif command -v flite &>/dev/null; then TTS_ENGINE="flite";
    elif command -v gtts-cli &>/dev/null && command -v aplay &>/dev/null; then TTS_ENGINE="gtts-cli";
    elif command -v pico2wave &>/dev/null && command -v aplay &>/dev/null; then TTS_ENGINE="pico2wave";
    elif command -v powershell.exe &>/dev/null; then TTS_ENGINE="powershell";
    elif command -v cscript &>/dev/null; then
        local vbs_path; vbs_path=$(dirname "$0")/tts.vbs
        if [ -f "$vbs_path" ]; then TTS_ENGINE="cscript"; fi
    fi
}

say_txt() {
    if [ -z "$TTS_ENGINE" ]; then return; fi
    local phrase="$1"; local phrase_ps; phrase_ps=$(echo "$phrase" | sed "s/'/''/g")
    case "$TTS_ENGINE" in
        "say")
            if [ ${#SAY_VOICES[@]} -gt 0 ]; then
                local random_voice=${SAY_VOICES[$RANDOM % ${#SAY_VOICES[@]}]}
                say -v "$random_voice" "$phrase" &
            else
                say "$phrase" &
            fi
            ;;
        "spd-say")    spd-say -r -20 "$phrase" & ;;
        "espeak")     espeak "$phrase" & ;;
        "flite")      flite -t "$phrase" & ;;
        "festival")   echo "$phrase" | festival --tts & ;;
        "gtts-cli")   gtts-cli -l en - --output - "$phrase" | aplay & ;;
        "pico2wave")
            local tmpfile
            tmpfile=$(mktemp /tmp/speaky_tts.XXXXXX.wav)
            pico2wave -l en-US -w "$tmpfile" "$phrase" && aplay "$tmpfile" && rm "$tmpfile" & ;;
        "powershell")
            powershell.exe -Command "Add-Type -AssemblyName System.Speech; (New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('$phrase_ps')" & ;;
        "cscript")
            local vbs_path; vbs_path=$(dirname "$0")/tts.vbs
            cscript //nologo /E:vbscript "$vbs_path" "$phrase" & ;;
    esac
    SPEAK_PID=$!
}

kill_speech() {
    if [ $SPEAK_PID -ne 0 ]; then
        # Kill the process and any children
        pkill -P $SPEAK_PID &>/dev/null
        kill $SPEAK_PID &>/dev/null
        wait $SPEAK_PID &>/dev/null
    fi
}

cleanup_and_exit() {
    kill_speech
    tput cnorm; tput sgr0; clear
    local exit_phrase=${exit_phrases[$RANDOM % ${#exit_phrases[@]}]}
    say_txt "$exit_phrase"
    animate_text_rainbow "$exit_phrase"
    wait $SPEAK_PID &>/dev/null
    tput cnorm; tput sgr0; echo
    exit 0
}

trap cleanup_and_exit SIGINT SIGTERM

# --- Animation and Color Functions ---

# Function to convert HSL to RGB
# Not available in bash, so we use a pre-computed rainbow palette
RAINBOW_COLORS=(196 202 208 214 220 226 190 154 118 82 46)

animate_text_rainbow() {
    local phrase="$1"
    local width
    width=$(tput cols)
    local height
    height=$(tput lines)
    local len=${#phrase}

    # Calculate random position, ensuring the phrase fits on screen
    local x=$((RANDOM % (width - len) + 1))
    local y=$((RANDOM % height + 1))

    tput cup "$y" "$x"

    # Approximate sleep duration based on phrase length
    # This gives the "streaming" effect
    local sleep_duration
    if [ "$len" -gt 0 ]; then
        # Calculate sleep duration to fit within MAX_DISPLAY_TIME
        sleep_duration=$(awk "BEGIN {print $MAX_DISPLAY_TIME / $len}")
        # But don't let it be too slow for short phrases
        if (( $(echo "$sleep_duration > 0.1" | bc -l) )); then
            sleep_duration=0.1
        fi
    else
        sleep_duration=0.1
    fi


    for (( i=0; i<len; i++ )); do
        local char="${phrase:$i:1}"
        # Cycle through the rainbow colors
        local color_index=$(( (i + RANDOM) % ${#RAINBOW_COLORS[@]} ))
        tput setaf "${RAINBOW_COLORS[$color_index]}"
        printf "%s" "$char"
        sleep "$sleep_duration"
    done

    # Wait for speech to finish, with a max timeout
    if [ $SPEAK_PID -ne 0 ]; then
        local child_pid
        child_pid=$(pgrep -P $SPEAK_PID)
        if [ -n "$child_pid" ]; then
            # Wait for the actual player process, not the wrapper script
            timeout ${MAX_SPEAKING_TIME}s wait "$child_pid" &>/dev/null
        else
            timeout ${MAX_SPEAKING_TIME}s wait $SPEAK_PID &>/dev/null
        fi
    fi
}


# --- The Main Event ---
the_show_must_go_on() {
    tts_detect_engine
    tput civis
    tput setab 0 # Set background to black
    clear

    if [ -z "$TTS_ENGINE" ]; then
        local error_phrase=${error_phrases[$RANDOM % ${#error_phrases[@]}]}
        animate_text_rainbow "$error_phrase"
        sleep 2
        clear
    else
        # Intro phrase
        local intro_phrase=${intro_phrases[$RANDOM % ${#intro_phrases[@]}]}
        say_txt "$intro_phrase"
        animate_text_rainbow "$intro_phrase"
        kill_speech
        sleep 2
        clear
    fi

    while true; do
        local phrase=${general_phrases[$RANDOM % ${#general_phrases[@]}]}
        say_txt "$phrase"
        animate_text_rainbow "$phrase"
        kill_speech
        sleep 2 # Pause between phrases
        clear
    done
}

# --- Let's get this show on the road ---
the_show_must_go_on
