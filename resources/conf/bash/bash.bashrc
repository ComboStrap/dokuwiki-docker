# The env set in Dockerfile are only for root
# With this file we can set the same env for all users

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022
USER_UID=$(id -u)
USER_NAME=$(whoami 2> /dev/null || echo 'noname')
echo "User: $USER_NAME, UID: $USER_UID, GID: $(id -g)"
if [ "$HOME" == '/' ] && [ "$USER_UID" != '0' ]; then
  # to avoid error with the HOME directory
  # such as `error: could not lock config file //.gitconfig: Permission denied`
  # Issue: https://gitlab.com/gitlab-org/gitlab-runner/-/issues/37408
  export HOME=/home/$USER_NAME
  echo "HOME: $HOME"
  if [ -f $HOME ]; then
      echo "Creating HOME=$HOME"
      mkdir -p "$HOME"
  fi
fi

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
# eval "$(dircolors)"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

# Dokuwiki
# Where Dokuwiki is installed
export DOKUWIKI_HOME='/var/www/html'

# Php
export PHP_UPLOAD_MAX_FILESIZE=${PHP_UPLOAD_MAX_FILESIZE:-128M}
export PHP_POST_MAX_SIZE=${PHP_POST_MAX_SIZE:-$PHP_UPLOAD_MAX_FILESIZE}
export PHP_MEMORY_LIMIT=${PHP_UPLOAD_LIMIT:-256M}
export PHP_DATE_TIMEZONE=${PHP_DATE_TIMEZONE:-UTC}

# Add all script in the path
export PATH="/opt/dokuwiki-docker/bin:${PATH}"
export PATH="/opt/dokuwiki-installer/bin:${PATH}"
export PATH="/opt/phpctl/bin:${PATH}"
export PATH="/opt/comboctl/bin:${PATH}"
