# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#export TERM=xterm
export EDITOR=vim

git_branch() {
  br=$(git branch 2>/dev/null|grep '^ *'|awk '{ print $2 }')
  echo ${br:-'-'}
}

perlbrew_perl () {
  curr=$(perlbrew list 2>/dev/null|grep '^*'|awk '{ print $2 }')
  echo ${curr:-system}
}

now () {
  date +"%Y%m%d_%H%M%S"
}


# Add last command's error code to $PS1 if it's not 0
print_exit_code() {
  local e=$?
  if [ $e -ne 0 ]; then
    echo -ne "\e[0;91m$e\e[0m "
  else
    echo -n ""
  fi
}

export BASH_PID=$$
first_child_cmd() {
  ps --ppid $BASH_PID -o cmd | sed -n 2p | awk '{ print $1 }'
}

# Include user@host:path even into screen's windows' titles
case $TERM in
xterm*|vte*)
  PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007%s" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}" "$(print_exit_code)"'
  ;;
screen*)
  PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\%s" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}" "$(print_exit_code)"'
  ;;
esac


export PATH=/local/bin:$PATH:$HOME/bin:$HOME/local/bin
#  if [ $(which perlbrew 2>/dev/null) ]; then
#    PB="\$(perlbrew_perl) "
#  else
#    PB=
#  fi
alias ls="ls --color=auto"
export PS1="\e[0m\e]0;\h$(first_child_cmd \$\$)\a\D{%y-%m-%d %T} \h \u \e[35m\$(git_branch)\e[0m \e[34m\w\e[0m\n\$"


alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias g=git
alias grepr='grep -r -n --color=auto'
alias ip2number="perl -le 'print unpack \"N\", pack \"C4\", split /\./, shift'"
alias ls='ls --color=auto'
alias number2ip="perl -le 'print join \".\", unpack \"C4\", pack \"N\", shift'"
alias qdiff="diff -r -q -x '.*' -x tags"
alias vim="vim -p"
alias vimdiffi="vimdiff -c 'set diffopt+=iwhite' -c 'set diffexpr=\"\"' -c 'windo set wrap' -c 'colorscheme evening'"
alias git_refs="git for-each-ref --format='%(refname:short)|%(upstream:short)' refs/heads | column -t -s '|'|grep '\\s'"

# Prefix-search history using up/down keys
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

#if [ -f ~/perl5/perlbrew/etc/bashrc ]; then
#  . ~/perl5/perlbrew/etc/bashrc
#fi

[ -f /etc/bash_completion.d/git ] && . /etc/bash_completion.d/git

screenenv() {
  if [ -e ~/.env ]; then
    . ~/.env
  fi
}

# export current session and load it in new screen sessions
if [ "$TERM" = "screen" ]; then
  screenenv
else
  echo "export DISPLAY=$DISPLAY" > ~/.env
fi

vim_swp () {
  find . -name '*.swp'|perl -pe 's!/\.([^/]+)\.swp$!/$1!'
}

vim_recover () {
  local list=$(find . -name '*.swp'|perl -pe 's!/\.([^/]+)\.swp$!/$1!')
  vim -r $list
}

PATH="/home/$USER/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/$USER/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/$USER/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/$USER/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/$USER/perl5"; export PERL_MM_OPT;

# Forward my ssh key
if [ -x /usr/bin/keychain ]; then
  /usr/bin/keychain --nogui $HOME/.ssh/id_rsa
  source $HOME/.keychain/$HOSTNAME-sh
fi

# Per-machine settings
[ -f ~/.bashrc.local ] && . ~/.bashrc.local

