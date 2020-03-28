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

# Include user@host:path even into screen's windows' titles
case $TERM in
xterm*|vte*)
  PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007%s" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}" "$(print_exit_code)"'
  ;;
screen*)
  PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\%s" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}" "$(print_exit_code)"'
  ;;
esac


if [ $(uname) = 'Linux' ]; then
  export PATH=/local/bin:$PATH:$HOME/bin:$HOME/local/bin
#  if [ $(which perlbrew 2>/dev/null) ]; then
#    PB="\$(perlbrew_perl) "
#  else
#    PB=
#  fi
  alias ls="ls --color=auto"
  export PS1="\e[0m\e]0;\h\007\D{%y-%m-%d %T} \u \e[35m\$(git_branch)\e[0m \e[34m\w\e[0m\n\$"
else
  : # MinGW will take care of prompt
fi


alias g=git
alias grepr='grep -r -n --color=auto'
alias ip2number="perl -le 'print unpack \"N\", pack \"C4\", split /\./, shift'"
alias ls='ls -FG'
alias number2ip="perl -le 'print join \".\", unpack \"C4\", pack \"N\", shift'"
alias qdiff="diff -r -q -x '.*' -x tags"
alias vim="vim -p"
alias vimdiffi="vimdiff -c 'set diffopt+=iwhite' -c 'set diffexpr=\"\"' -c 'windo set wrap' -c 'colorscheme evening'"
alias git_refs="git for-each-ref --format='%(refname:short)|%(upstream:short)' refs/heads | column -t -s '|'|grep '\\s'"

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

#if [ -f ~/perl5/perlbrew/etc/bashrc ]; then
#  . ~/perl5/perlbrew/etc/bashrc
#fi

if [ -f /etc/bash_completion.d/git ]; then
  . /etc/bash_completion.d/git
fi

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

