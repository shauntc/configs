if status is-login
    set PATH $PATH /opt/homebrew/bin $HOME/.cargo/bin /opt/homebrew/bin/brew
    set -Ux CONFIG_ROOT $HOME/.config
    set -Ux XDG_CONFIG_ROOT $CONFIG_ROOT
    set -Ux XDG_DATA_HOME $HOME/.local/share

    set -Ux STARSHIP_CONFIG $CONFIG_ROOT/starship/config.toml

    # zellij is a window manager like tmux, start zellij if not already within zellij
    zellij
end

# use ripgrep in fzf if available
if type -q rg
    set FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'
end

source $XDG_CONFIG_ROOT/fish/alias.fish

# setup starship prompt
if type -q starship
    starship init fish | source
end

# Java
if test -d /usr/lib/jvm/java-8-openjdk-amd64
    set JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
    set PATH $JAVA_HOME/bin $PATH
end

# Android
if test -d ~/Library/Android/sdk
    set ANDROID_HOME ~/Library/Android/sdk
    set ANDROID_SDK_ROOT $ANDROID_HOME
    set PATH $PATH $ANDROID_HOME/emulator $ANDROID_HOME/cmdline-tools $ANDROID_HOME/cmdline-tools/tools/bin $ANDROID_HOME/platform-tools
    # set REPO_OS_OVERRIDE linux
    # adb kill-server 2>/dev/null
    # set ADB_SERVER_SOCKET tcp:(cat /etc/resolv.conf | grep nameserver | cut -d' ' -f2):5037
end
