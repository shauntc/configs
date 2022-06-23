def command_exists [name: string] {
    which $name
}

let-env HELIX_CONFIG = ($env.CONFIG_ROOT | path join "helix")
let-env EDITOR = "hx"