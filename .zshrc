# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -------------------------------------------------
# Set temporary variables (from .extra <- created from .extra.template)
# -------------------------------------------------
#echo "Exporting env vars for per-machine config"
source "$HOME/dotfiles/scripts/.extra.sh"

#-------------------------------------------------------------------------------
# Shell prompt + theme setting
#
# Set name of the theme to load
#-------------------------------------------------------------------------------
# source kube-ps1 for Kubernetes prompts
source "$BREW_PREFIX/opt/kube-ps1/share/kube-ps1.sh"

#-------------------------------------------------------------------------------
# Uncomment the following line to use case-sensitive completion.
#-------------------------------------------------------------------------------

# CASE_SENSITIVE="true"

#-------------------------------------------------------------------------------
# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
#-------------------------------------------------------------------------------

# HYPHEN_INSENSITIVE="true"

#-------------------------------------------------------------------------------
# Uncomment the following line to disable bi-weekly auto-update checks.
#-------------------------------------------------------------------------------

# DISABLE_AUTO_UPDATE="true"

#-------------------------------------------------------------------------------
# Uncomment the following line to change how often to auto-update (in days).
#-------------------------------------------------------------------------------

export UPDATE_ZSH_DAYS=7

#-------------------------------------------------------------------------------
# Uncomment the following line to disable colors in ls.
#-------------------------------------------------------------------------------

DISABLE_LS_COLORS="true"

#-------------------------------------------------------------------------------
# Uncomment the following line to disable auto-setting terminal title.
#-------------------------------------------------------------------------------

# DISABLE_AUTO_TITLE="true"

#-------------------------------------------------------------------------------
# Uncomment the following line to enable command auto-correction.
#-------------------------------------------------------------------------------

# ENABLE_CORRECTION="true"

#-------------------------------------------------------------------------------
# Uncomment the following line to display red dots whilst waiting for completion.
#-------------------------------------------------------------------------------

COMPLETION_WAITING_DOTS="true"

#-------------------------------------------------------------------------------
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
#-------------------------------------------------------------------------------

# DISABLE_UNTRACKED_FILES_DIRTY="true"

#-------------------------------------------------------------------------------
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
#-------------------------------------------------------------------------------

HIST_STAMPS="yyyy-mm-dd"
#-------------------------------------------------------------------------------
# Would you like to use another custom folder than $ZSH/custom?
#-------------------------------------------------------------------------------

# ZSH_CUSTOM=$DOTFILES

#-------------------------------------------------------------------------------
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#-------------------------------------------------------------------------------

plugins=(
    kube-ps1
    # zoxide
    )

#-------------------------------------------------------------------------------
# Set working directories (for rg, fzf, fd searching)
#-------------------------------------------------------------------------------
WORKDIRS=(
  "dotfiles"
  "workspace"
  "Downloads"
);
# Join working dir strings for RipGrep file search (using conditional parameter expansion - https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)
WORKDIR_PATHS=""
for WORKDIR in "${WORKDIRS[@]}";
do
  WORKDIR_PATHS+="$HOME/${WORKDIR} "
done
# append fully formed paths
WORKDIR_PATHS+="$DROPBOX "

# echo "WORKDIR_PATHS: $WORKDIR_PATHS"

#-------------------------------------------------------------------------------
# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
#-------------------------------------------------------------------------------
files=(
    "$DOTFILES/scripts/.path.sh"
    "$DOTFILES/scripts/.export.sh"
    "$DOTFILES/scripts/.functions.sh"
    "$DOTFILES/scripts/.aliases.sh"
    "$DOTFILES/scripts/.extra.sh"
    "$DOTFILES/scripts/bitwarden.sh"
    "$DOTFILES/scripts/database_switcher.sh"
    "$DOTFILES/scripts/symlinks_config.sh"
    );
for file in "${files[@]}"; do
  [ -r "$file" ] && [ -f "$file" ] && 
#   echo "sourcing file $file in shell $SHELL" && 
  source "$file";
done;

unset files file;

# Set Vim editor mode in shell CLI (activate using ESC key)
set -o vi

#-------------------------------------------------------------------------------
# Add Pyenv functionality to ZSH shell + pyenv setup
# Also install pipsi, pipenv
#-------------------------------------------------------------------------------
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Set global python version
pyenv global 3.10.12
# Install global python binaries (do not install if not already installed)
# pip install --quiet --upgraade foobar

#-------------------------------------------------------------------------------
# Init fast filesystem navigation with smarter cd command (zoxide) 
# NOTE: For completions to work, the above line must be added after compinit is called. You may have to rebuild your completions cache by running rm ~/.zcompdump*; compinit.
#-------------------------------------------------------------------------------
eval "$(zoxide init zsh)"

#-------------------------------------------------------------------------------
# Init Terraform version manager (tfenv)
#-------------------------------------------------------------------------------
eval "$(tfenv init -)"

#-------------------------------------------------------------------------------
# Hook direnv binary to shell so it activates on each directory change
#-------------------------------------------------------------------------------
eval "$(direnv hook zsh)"

#-------------------------------------------------------------------------------
# Add Terragrunt switcher hook (tgswitch)
#-------------------------------------------------------------------------------
load-tgswitch() {
  local tgswitchrc_path=".tgswitchrc"
  local terragrunt_version_path=".terragrunt-version"

  if [ -f "$tgswitchrc_path" ] || [ -f "$terragrunt_version_path" ]; then
    tgswitch
  fi
}
add-zsh-hook chpwd load-tgswitch
load-tgswitch

#-------------------------------------------------------------------------------
# Activate dir colors
#-------------------------------------------------------------------------------
test -r "~/.dir_colors" && eval $(dircolors ~/.dir_colors)

#-------------------------------------------------------------------------------
# Homebrew fix for M1 apple silicon version
#-------------------------------------------------------------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"

#-------------------------------------------------------------------------------
# Activate secrets shell (should be empty on bootstrap)
#-------------------------------------------------------------------------------
# source $DOTFILES/scripts/secrets.sh

#-------------------------------------------------------------------------------
# Activate Oh-My-Zsh
#-------------------------------------------------------------------------------
source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#-------------------------------------------------------------------------------
# Nvm
#-------------------------------------------------------------------------------
# NVM setup (Node version manager) - installed via Homebrew
export NVM_DIR="$NVM_DIR"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# THIS IS NECESSARY (Jan 23, 2024)
# Remove PATH duplicates - https://unix.stackexchange.com/questions/40749/remove-duplicate-path-entries-with-awk-command/149054#149054
export PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"

###################
# Redocly CLI completion
###################
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source $BREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#compdef redocly
###-begin-redocly-completions-###
#
# yargs command completion script
#
# Installation: redocly completion >> ~/.zshrc
#    or redocly completion >> ~/.zsh_profile on OSX.
#
_redocly_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" redocly --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _redocly_yargs_completions redocly
###-end-redocly-completions-###

