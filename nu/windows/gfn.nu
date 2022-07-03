def template [
    name: string
    params: string
    command: string
    --escape(-e)
    ] {
        let esc = (if $escape { "\\" } else { "" })
        $"export def ($name) ($esc)[($params)] ($esc){\n\t($command)\n}\n"
}

export def-env gfn [
    name?: string
    command?: string
    --list(-l)
    ] {
    let generated = ($env.CONFIG_GENERATED | path join "generated.nu")
    let current = (open $generated | parse -r (template -e '(?P<name>\w+)' '(?P<params>[^\]]*)' '(?P<command>[^}]+)') | str trim | to-df)
    echo $current
    if ($list) {
        $current | get name
    } else {
        if (help commands | any? $it.name == $name) {
            echo "Command ($name) already exists"
            which $name
        } else {
            let newcmd = ([[name params command]; [$name, "", $command]] | to-df)
            echo $newcmd
            $current | append -c $newcmd | with-column (template (col name) (col params) (col command))
        }
    }
}