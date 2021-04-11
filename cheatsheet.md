tmux (Ctrl + b)
    split vertical: %
    split horizontal: "
    pane numbers: q
    detach session: d
    window next/prev: n/p
    move pane in direction: arrow keys

wezterm:
    resize pane: ctrl+alt+shift + (up/down/left/right)

nvim ([mode] keys)
    repeat .
        repeates the entire last command (including your insertion)
    sections (nav via or apply command to):
        w word
        )/}/] brackets
        s sentance
        % bracket matching the one under the cursor
        /search_term select till the the next instance of search_term (n to go to next)
    modifiers (used after a command or mode, ex d or v):
        i inside (ex. di] delete inside sq brackets)
        a all (all, usually inclusive of the section boundary version of i)
        t till (until the next occurance)
        f inclusive until (until the next occurance and the occurance)
    commands (can be used as (command-in/all-section)
        d delete (actually cut) dd applys it to a line
        y yank (copy) yy does the whole line
        c change (delete and insert)
    Uppercase/lowercase selected [v] u/U
