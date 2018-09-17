# run the following in Vim:
mkdir -p ~/.vim/pack/tpope/start
cd ~/.vim/pack/tpope/start
git clone https://tpope.io/vim/commentary.git
vim -u NONE -c "helptags commentary/doc" -c q

# then type this into vim command line
#:PluginInstall
