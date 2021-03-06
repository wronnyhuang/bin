# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
		xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
		PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;90m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi
#. /opt/conda/etc/profile.d/conda.sh
#conda activate base

# locale update
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

# screen autocomplete
complete -C "perl -e '@w=split(/ /,\$ENV{COMP_LINE},-1);\$w=pop(@w);for(qx(screen -ls)){print qq/\$1\n/ if (/^\s*\$w/&&/(\d+\.\w+)/||/\d+\.(\$w\w*)/)}'" screen

# aliases
alias psaux="ps aux | grep"
alias noh="tail -f nohup.out"
alias pk="pkill -f"
alias pkr="pkill -f runscript && pkill -f python"
alias smi='nvidia-smi'
alias mpi="mpirun --allow-run-as-root -bind-to none -map-by slot -x NCCL_DEBUG=INFO -x LD_LIBRARY_PATH -x PATH -mca pml ob1 -mca btl ^openib -mca btl_tcp_if_exclude lo,docker0 -x NCCL_SOCKET_IFNAME=^lo,docker0 --oversubscribe"

alias mpic="mpirun -bind-to none -map-by slot -mca pml ob1 -mca btl ^openib --oversubscribe"
alias sq="squeue"    # display the entire SLURM queue of submitted jobs
alias gpu1="srun --pty --gres=gpu:1 --mem=16G --qos=default --time=01:00:00 bash"  # launch a VM with a single GPU for 1 hour
alias gpu4="srun --pty --gres=gpu:4 --mem=64G --qos=default --time=23:59:00 bash"  # launch a VM with a 4 GPU for 24 hour
alias install="srun --pty --mem=32G --cpus-per-task=8 --qos=medium --time=08:00:00 bash"
alias dis="python dispatch.py"
alias sc="scancel"
alias sm="sq | grep `whoami`"
alias wats="watch -n .1 squeue"
alias pull="git pull"

alias dockrun="docker run --runtime=nvidia -it \
--privileged \
-v ~/bin:/root/bin \
-v ~/ckpt:/root/ckpt \
-v ~/datasets:/root/datasets \
-v ~/repo:/root/repo \
-v ~/misc:/root/misc \
-v /datasets:/root/datasets_root \
-d \
--shm-size 120G"


function pretty_csv {
    column -t -s, -n "$@" | less -F -S -X -K
}

# allow mpi run as root
OMPI_ALLOW_RUN_AS_ROOT=1
OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
nh() { nohup $@ & }
npirun() { nohup mpirun --allow-run-as-root -bind-to none -map-by slot -x NCCL_DEBUG=INFO -x LD_LIBRARY_PATH -x PATH -mca pml ob1 -mca btl ^openib -mca btl_tcp_if_exclude lo,docker0 -x NCCL_SOCKET_IFNAME=^lo,docker0 --oversubscribe $@ & }

# setup path and terminal colors
export PATH=/root/bin:$PATH
LS_COLORS=$LS_COLORS:'di=1;31:ln=34' ; export LS_COLORS;
echo Welcome to wrhuang/default docker container - `cat ~/misc/hostname.log`

if [ `hostname` = cmlsub00.umiacs.umd.edu ]
then
    echo `hostname`
    # >>> conda initialize >>>
    user=`whoami`
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/cmlscratch/$user/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/cmlscratch/$user/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/cmlscratch/$user/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="/cmlscratch/$user/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<

    echo hi
    export PATH="/cmlscratch/$user/anaconda3/bin:$PATH"
    conda activate tf114
    cd /cmlscratch/$user/metapoison_dev
fi
