#Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | path expand | str collect (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | path expand | str collect (char esep) }
  }
}

let-env CONFIG_GENERATED = ($env.CONFIG_ROOT | path join '__generated__')

let-env NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts'),
    ($env.CONFIG_ROOT | path join 'nu'),
    ($env.CONFIG_GENERATED)
]


# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

let-env HELIX_CONFIG = ($env.CONFIG_ROOT | path join "helix")
let-env EDITOR = "hx"

# TODO: Make this conditional
let-env RUSTC_WRAPPER = (which sccache | get 0.path)