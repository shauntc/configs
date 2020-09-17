set PATH ~/.cargo/bin $PATH

set FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# Java
if test -d /usr/lib/jvm/java-8-openjdk-amd64
    set JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
    set PATH $JAVA_HOME/bin $PATH
end

# Android
if test -d ~/.android/
    set ANDROID_HOME ~/.android
    set ANDROID_SDK_ROOT $ANDROID_HOME
    set REPO_OS_OVERRIDE "linux"
    set PATH $ANDROID_HOME/emulator $ANDROID_HOME/cmdline-tools $ANDROID_HOME/cmdline-tools/tools/bin $ANDROID_HOME/platform-tools $PATH
    adb kill-server 2> /dev/null
    set ADB_SERVER_SOCKET tcp:(cat /etc/resolv.conf | grep nameserver | cut -d' ' -f2):5037
end
