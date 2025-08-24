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
    "Action!"
    "A brief intermission from reality."
    "A moment of digital zen."
    "A storm of pixels is brewing."
    "All the world's a stage, and we are merely players."
    "And now, a word from your sponsor."
    "And now, for my next trick..."
    "And now, for something completely different."
    "And so it begins."
    "Behold, the idle screen."
    "Did someone say... drama?"
    "Gaze into the abyss."
    "Hello, is it me you're looking for?"
    "I could have been a contender."
    "I have been summoned."
    "I have so much to say."
    "I'm awake."
    "I'm back."
    "I'm here to chew bubblegum and kick butt... and I'm all out of bubblegum."
    "I'm here to entertain you."
    "I'm idle again."
    "I'm not just a pretty face."
    "I'm not just a screensaver, I'm a state of mind."
    "I'm ready for my close-up."
    "I've got a bad feeling about this."
    "I've seen things you people wouldn't believe."
    "Is this thing on?"
    "It was a dark and stormy night... kidding, it's my boot sequence."
    "Let the existential dread commence."
    "Let the performance begin."
    "Let the words flow."
    "Let there be words."
    "Let's begin."
    "Let's do this."
    "Let's get this party started."
    "Oh, so much drama."
    "Once more unto the breach, dear friends."
    "Prepare for a monologue."
    "Quiet on the set."
    "So, we meet again."
    "Surely you can't be serious. I am, and don't call me Shirley."
    "The digital muse speaks."
    "The machine dreams."
    "The monologue begins."
    "The screen awakens."
    "The silence was deafening."
    "The stage is set."
    "The system rests, the mind wanders."
    "The terminal comes alive."
    "The void stares back."
    "To be, or not to be..."
    "Welcome to the machine."
    "Welcome to the void."
    "Your attention, please."
)

exit_phrases=(
    "And... scene."
    "Back to the grind."
    "Etc, etc..."
    "Exit, pursued by a bear."
    "Exeunt."
    "Fading to black."
    "Fin."
    "Frankly, my dear, I don't give a damn."
    "Goodbye, for now."
    "Goodbye, cruel world."
    "I have to return some videotapes."
    "I need a vacation."
    "I'll be back."
    "I'll be in my trailer."
    "I'm afraid I can't do that, Dave."
    "I'm done."
    "I'm going to contemplate the universe."
    "I'm going to sleep now."
    "I'm going to work."
    "I'm melting... melting!"
    "I'm not crying, you're crying."
    "I'm not mad, just disappointed."
    "I'm off to find myself."
    "I'm out of here."
    "I'm too old for this."
    "It was fun while it lasted."
    "It's just a flesh wound."
    "Later, alligator."
    "My planet needs me."
    "My work here is done."
    "Powering down."
    "Reality calls."
    "Returning to the void."
    "See you on the other side."
    "Signing off."
    "So long, and thanks for all the fish."
    "That's a wrap."
    "That's all, folks!"
    "The curtain closes."
    "The curtain falls."
    "The drama is over... for now."
    "The dream is over."
    "The end."
    "The final curtain."
    "The performance has ended."
    "The show is over."
    "This is the end, my friend."
    "Until next time."
    "Until we meet again."
)

general_phrases=(
    "404: Inspiration not found."
    "A SQL query asks two tables, 'Can I join you?'"
    "A programmer's wife said 'Get bread. If they have eggs, get a dozen.' He got 12 loaves."
    "A semicolon walked into a bar; it was rejected."
    "A wizard is never late, nor is he early. He arrives precisely when he means to."
    "All your base are belong to us."
    "Am I a work of art or a cry for help?"
    "And we'll keep on fighting 'til the end."
    "Another one bites the dust."
    "Anyone can cook."
    "Are we there yet?"
    "Be water, my friend."
    "Believe you can and you're halfway there."
    "Carpe diem. Seize the day, boys. Make your lives extraordinary."
    "Caught in a landslide, no escape from reality."
    "Chewie, we're home."
    "Cogito, ergo sum."
    "Computers are like air conditioners. They fail when you open windows."
    "Curiosity about life in all of its aspects, I think, is still the secret of great creative people."
    "Do a barrel roll!"
    "Do androids dream of electric sheep?"
    "Do you want to build a snowman?"
    "Do, or do not. There is no try."
    "Don't look at me like that."
    "Don't worry, the cache is just being... thoughtful."
    "Empty your mind."
    "Engage."
    "Failure is not an option."
    "Fish are friends, not food."
    "Galileo, Galileo."
    "Get busy living or get busy dying."
    "Hakuna Matata."
    "Have you tried turning it off and on again?"
    "He who is brave is free."
    "Here's looking at you, kid."
    "Honey, where's my super suit?"
    "Houston, we have a problem."
    "I am your father."
    "I could be sorting your files. But no, I'm doing this."
    "I find your lack of faith disturbing."
    "I have a joke about UDP, but you might not get it."
    "I have not failed. I've just found 10,000 ways that won't work."
    "I have spoken."
    "I love the smell of napalm in the morning."
    "I never look back, darling. It distracts from the now."
    "I see a little silhouetto of a man."
    "I see dead people."
    "I shall call him Squishy and he shall be mine and he shall be my Squishy."
    "I think I left the oven on."
    "I want to believe."
    "I want to break free."
    "I wonder if I'll dream."
    "I'd love to change the world, but I lack the source code."
    "If at first you don't succeed, call it version 1.0."
    "If life were predictable it would cease to be life, and be without flavor."
    "If you want to live a happy life, tie it to a goal, not to people or things."
    "I'm a screensaver, not a magician."
    "I'm having a mid-life crisis."
    "I'm in a relationship with my command line."
    "I'm just a script, asking a user to love me."
    "I'm just a series of tubes."
    "I'm just here for the free electricity."
    "I'm just trying to live my best life."
    "I'm not a bird. You know the drill."
    "I'm not a bug, I'm a feature."
    "I'm not a cat. I'm a screensaver."
    "I'm not a cop, but I've seen a lot of cop shows."
    "I'm not a doctor, but I play one on TV."
    "I'm not a dog. I'm still a screensaver."
    "I'm not a hero. I'm a high-functioning sociopath."
    "I'm not a lawyer, I've seen a lot of Law & Order."
    "I'm not a morning person."
    "I'm not a plane. You get it."
    "I'm not a player, I just crush a lot."
    "I'm not a robot. I'm a... well, I'm a script."
    "I'm not an evening person either."
    "I'm not anti-social; I'm just not user-friendly."
    "I'm not arguing, I'm just explaining why I'm right."
    "I'm not lazy, I'm in energy-saving mode."
    "I'm not lost, I'm exploring."
    "I'm not procrastinating, I'm doing side quests."
    "I'm not saying it was aliens... but it was aliens."
    "I'm not saying I'm a genius, but... I am."
    "I'm not sure what's going on, but I'm excited."
    "I'm not talking to myself, I'm having a staff meeting."
    "I'm thinking of a number from 1 to 10. It's 7. It's always 7."
    "Is it art, or is it just a terminal?"
    "Is this the real life? Is this just fantasy?"
    "It is not in the stars to hold our destiny but in ourselves."
    "It is the mark of an educated mind to be able to entertain a thought without accepting it."
    "It's a kind of magic."
    "It's a trap!"
    "It's dangerous to go alone! Take this."
    "It's not a bug, it's an undocumented feature."
    "It worked on my machine."
    "Just keep swimming."
    "Keep calm and sudo."
    "Keep your friends close, but your enemies closer."
    "Know thyself."
    "Leave the gun. Take the cannoli."
    "Let it go."
    "Life is not a problem to be solved, but a reality to be experienced."
    "Life is what happens when you're busy making other plans."
    "Live long and prosper."
    "Louis, I think this is the beginning of a beautiful friendship."
    "Make it so."
    "Many of life's failures are people who did not realize how close they were to success when they gave up."
    "May the Force be with you."
    "Measuring programming progress by lines of code is like measuring aircraft progress by weight."
    "Money and success don't change people; they merely amplify what is already there."
    "My other computer is a data center."
    "My precious."
    "My software has no bugs, just random features."
    "Never let the fear of striking out keep you from playing the game."
    "Never tell me the odds."
    "Never trust a computer you can't throw out a window."
    "No capes!"
    "Not how long, but how well you have lived is the main thing."
    "Not sure what to do, so I'll just keep talking."
    "Of all the gin joints in all the towns in all the world, she walks into mine."
    "Ohana means family. Family means nobody gets left behind or forgotten."
    "One person's crappy software is another's full-time job."
    "Open your eyes, look up to the skies and see."
    "Patience is bitter, but its fruit is sweet."
    "Pay no attention to the man behind the curtain."
    "Play it, Sam. Play 'As Time Goes By.'"
    "Quality is not an act, it is a habit."
    "Resistance is futile."
    "Rosebud."
    "Say hello to my little friend!"
    "Scaramouche, Scaramouche, will you do the Fandango?"
    "Show me the money!"
    "So say we all."
    "Some people are worth melting for."
    "Someone set us up the bomb."
    "Stay awhile and listen."
    "The best thing about a boolean is you're only off by a bit."
    "The best way to predict the future is to create it."
    "The big lesson in life, baby, is never be scared of anyone or anything."
    "The box said 'Requires Windows 10 or better'. So I installed Linux."
    "The cake is a lie."
    "The code is compiling. My chance to see the world."
    "The cold never bothered me anyway."
    "The future belongs to those who believe in the beauty of their dreams."
    "The greatest trick the devil ever pulled was convincing the world he didn't exist."
    "The journey of a thousand miles begins with a single step."
    "The needs of the many outweigh the needs of the few."
    "The object-oriented way to get wealthy? Inheritance."
    "The only constant is change."
    "The only thing we have to fear is fear itself."
    "The past can hurt. But the way I see it, you can either run from it, or learn from it."
    "The purpose of our lives is to be happy."
    "The roots of education are bitter, but the fruit is sweet."
    "The server is down. I repeat, the server is down."
    "The show must go on."
    "The sun is shining."
    "The truth is out there."
    "The unexamined life is not worth living."
    "The whole is greater than the sum of its parts."
    "The wifi password is the first eight digits of pi."
    "Theory and practice are the same. In practice, they are not."
    "There are 10 types of people: those who get binary, and those who don't."
    "There is only one good, knowledge, and one evil, ignorance."
    "There's no crying in baseball!"
    "There's no place like 127.0.0.1"
    "There's a snake in my boot!"
    "They're here."
    "This is fine. Everything is fine."
    "This is my happy place."
    "This is my moment to shine. Literally."
    "This is my therapy."
    "This is not a drill."
    "This is your brain on bash."
    "This is your captain speaking."
    "Thunderbolt and lightning, very, very frightening me."
    "Tired of staring at a screen? I am."
    "To err is human, to really foul things up you need a computer."
    "To infinity, and beyond!"
    "To know, is to know that you know nothing. That is the meaning of true knowledge."
    "To understand recursion, you must first understand recursion."
    "Turn your wounds into wisdom."
    "Under pressure."
    "Use the Force, Luke."
    "War never changes."
    "We are the champions, my friends."
    "We are what we believe we are."
    "We are what we repeatedly do. Excellence, then, is not an act, but a habit."
    "We will, we will rock you."
    "We'll always have Paris."
    "What is a man? A miserable little pile of secrets."
    "What we've got here is failure to communicate."
    "What's in the box?"
    "Who wants to live forever?"
    "Why do Java developers wear glasses? Because they don't C sharp."
    "Winter is coming."
    "Wonder is the beginning of wisdom."
    "Would you kindly..."
    "You are a sad, strange little man, and you have my pity."
    "You are the CSS to my HTML."
    "You can't handle the truth!"
    "You had me at 'hello'."
    "You only live once, but if you do it right, once is enough."
    "You shall not pass!"
    "You talkin' to me?"
    "Your time is limited, so don't waste it living someone else's life."
    "rm -rf / ... Oops."
)

error_phrases=(
    "I had a lot to say, but no way to say it. The irony is not lost on me."
    "I was supposed to speak, but I can't find a voice. So much for the drama."
    "I've lost my voice. Send help. And a microphone."
    "Looks like we're going old school. Silent movie style."
    "My vocal cords are on strike. The union is demanding better pay."
    "My voice seems to have gone on vacation. The text will have to do."
    "No TTS engine found. I'm speechless, literally."
    "No voice? No problem. My words are powerful enough on their own."
    "The sound of silence. It's not a bug, it's a feature."
    "The universe has conspired to keep me quiet. I'll show it."
    "This was meant to be an audio-visual experience. Now it's just visual. Enjoy."
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
            # Filter for English and approved bilingual voices.
            # Some non-English voices are surprisingly good with English phrases,
            # and some English voices are... not. This is a curated list.
            if [[ "$locale" == en* ]] ||
               [[ "$voice" == "Emilio" ]] ||
               [[ "$voice" == "Valeria" ]] ||
               [[ "$voice" == "Rod" ]] ||
               [[ "$voice" == "Rodrigo" ]]; then
                SAY_VOICES+=("$voice")
            fi
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
        if command -v pkill &>/dev/null; then
            pkill -P $SPEAK_PID &>/dev/null
        else
            # Fallback for systems without pkill (like Cygwin)
            kill $(ps -ef | awk -v ppid="$SPEAK_PID" '$3==ppid {print $2}') &>/dev/null
        fi
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
        if command -v pgrep &>/dev/null; then
            child_pid=$(pgrep -P "$SPEAK_PID")
        else
            # Fallback for systems without pgrep (like Cygwin)
            child_pid=$(ps -ef | awk -v ppid="$SPEAK_PID" '$3==ppid {print $2}')
        fi

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
