# https://superuser.com/questions/544989/does-tmux-sort-the-path-variable/583502#583502
# Empty PATH setting for tmux MacOS users (tmux auto-prepends useless stuff)
if [ -f /etc/profile ]; then
    PATH=""
    source /etc/profile
fi
