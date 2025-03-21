#!/usr/bin/env bash

user=`whoami`

# >>> conda initialize >>>
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
cd /cmlscratch/$user/metapoison
