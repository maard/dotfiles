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

print_exit_code() {
  local e=$?
  if [ $e -ne 0 ]; then
    echo -ne "\e[1;91m$e\e[0m "
  fi
}
export PROMPT_COMMAND=print_exit_code


if [ $(uname) = 'Linux' ]; then
  export PATH=~/perl5/perlbrew/bin:~/local/bin:$PATH:$HOME/bin:$HOME/local/bin:/usr/local/bin
#  if [ $(which perlbrew 2>/dev/null) ]; then
#    PB="\$(perlbrew_perl) "
#  else
#    PB=
#  fi
  alias ls="ls --color=auto"
fi

export PS1="\e[0m\e]0;\h\007\D{%y-%m-%d %T} \u \e[35m\$(git_branch)\e[0m \e[34m\w\e[0m\n\$"

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

