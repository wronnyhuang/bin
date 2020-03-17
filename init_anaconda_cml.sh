#!/usr/bin/env bash

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/cmlscratch/`whoami`/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/cmlscratch/`whoami`/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/cmlscratch/`whoami`/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/cmlscratch/`whoami`/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="/cmlscratch/`whoami`/anaconda3/bin:$PATH"
conda activate tf114
cd /cmlscratch/`whoami`/metapoison
