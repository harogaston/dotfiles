#
# ~/.bashrc
#

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[[ -f ~/.extend.bashrc ]] && . ~/.extend.bashrc

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

# PATH variable
export PATH=/home/gaston/bin:$PATH

# Color definitions 
# Normal Colors
Black='\e[38;5;256m'        # Black
Red='\e[38;5;202m'          # Red
Green='\e[38;5;82m'         # Green
Yellow='\e[38;5;226m'       # Yellow
Blue='\e[38;5;33m'          # Blue
Skyblue='\e[38;5;14m'       # Purple
Cyan='\e[38;5;13m'          # Cyan
White='\e[38;5;255m'        # White

# Bold
BBlack='\e[1;38;5;256m'        # Black
BGray='\e[1;38;5;250m'         # Gray
BRed='\e[1;38;5;202m'          # Red
BGreen='\e[1;38;5;82m'         # Green
BYellow='\e[1;38;5;226m'       # Yellow
BBlue='\e[1;38;5;33m'          # Blue
BSkyblue='\e[1;38;5;14m'       # Purple
BCyan='\e[1;38;5;13m'          # Cyan
BWhite='\e[1;38;5;255m'        # White

# Background
BG_Black='\e[48;5;256m'        # Black
BG_Red='\e[48;5;202m'          # Red
BG_Green='\e[48;5;82m'         # Green
BG_Yellow='\e[48;5;226m'       # Yellow
BG_Blue='\e[48;5;33m'          # Blue
BG_Skyblue='\e[48;5;14m'       # Purple
BG_Cyan='\e[48;5;13m'          # Cyan
BG_White='\e[48;5;255m'        # White

ALERT=${BWhite}${On_Red} # Bold White on red background

## Shell options
shopt -s dirspell
shopt -s direxpand
shopt -s cdspell
shopt -s dotglob

## Allows aliases recursive expansion after sudo ##
alias sudo='sudo '

## Prevents accidentally clobbering files ##
alias mkdir='mkdir -p'
alias rmdir='rm -r'
##alias rm='rm -i'
##alias cp='cp -i'
##alias mv='mv -i'

## get rid of command not found ##
alias cd..='cd ..'
alias home='cd ~'
 
## Frequent directories ##
alias ..='cd ..'
alias gaston='cd ~'
alias l.='ls -d .* --color=auto'

alias ls='ls --color=auto'

## Calculator
alias calc='bc -l'

## Clear screen
alias cls='clear'

alias vi='vim'

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

time='\['$BGray'\]'
color='\[\e[1;38;5;34m\]'
reset='\[\e[0m\]'

## The contents of PROMPT_COMMAND are executed as a regular Bash command just before Bash displays a prompt
PROMPT_COMMAND='p=${PWD};largo=${#p};if [ "$largo" -gt "60" ]; then prompt=${p::(10)}…${p:(-49)}; else prompt="${PWD/#$HOME/\~}"; fi'

#PS1='\A '$color\$prompt$reset'> '

# GBT configuration
export GBT_CARS='Status, Hostname, Dir, Git, Sign'
export GBT_CAR_DIR_DEPTH='3'
PS1='$(gbt $?)'

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

