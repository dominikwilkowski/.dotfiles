source ~/.profile

# default editor
export EDITOR=vim

# homebrew PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# path for pyenv (python version manager)
eval "$(pyenv init --path)"

export PATH=/usr/local/bin:$PATH
export PATH=/Users/dominik/.local/bin:$PATH

# https://blog.akatz.org/fixing-macos-zsh-terminal-history-settings/
alias history="history 1"
HISTSIZE=99999
HISTFILESIZE=99999
SAVEHIST=$HISTSIZE

# NVM globals
export NVM_DIR="$HOME/.nvm"
    [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh" # This loads nvm
    [ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# MacPorts Installer addition on 2022-05-30_at_12:22:27: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

# MacPorts Installer addition on 2022-05-30_at_12:22:27: adding an appropriate MANPATH variable for use with MacPorts.
export MANPATH="/opt/local/share/man:$MANPATH"

# postgres psql
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# ruby
source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
source $(brew --prefix)/opt/chruby/share/chruby/auto.sh
chruby ruby-3.3.5
