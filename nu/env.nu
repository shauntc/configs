#Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
}

$env.CONFIG_GENERATED = ($env.CONFIG_ROOT | path join '__generated__')

$env.NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts'),
    ($env.CONFIG_ROOT | path join 'nu'),
    ($env.CONFIG_GENERATED)
]


# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
$env.NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

$env.HELIX_CONFIG = ($env.CONFIG_ROOT | path join "helix")
$env.EDITOR = "hx"

def command_exists [name: string] {
  which $name | is-empty | not $in
}

if $nu.os-info.name == 'windows' {
    $env.Path = if (command_exists yarn) {
      ($env.Path | append (yarn global bin))
    } else {
      $env.Path
    }
  } else {
    $env.PATH = if (command_exists yarn) {
      ($env.PATH | append (yarn global bin))
    } else {
      $env.PATH
    }
}

if (command_exists sccache) {
  $env.RUSTC_WRAPPER = (which sccache | get 0.path)  
}