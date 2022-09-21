def starship_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

# The prompt indicators are environmental variables that represent
# the state of the prompt
export-env {
    load-env {
        STARSHIP_SHELL: "nu"
        STARSHIP_CONFIG: ($env.CONFIG_ROOT | path join 'starship/config.toml')
        PROMPT_COMMAND: { starship_left_prompt }
        PROMPT_COMMAND_RIGHT: ""
        PROMPT_INDICATOR: ""
        PROMPT_INDICATOR_VI_INSERT: ": "
        PROMPT_INDICATOR_VI_NORMAL: "〉"
        PROMPT_MULTILINE_INDICATOR: "::: "
    }
}