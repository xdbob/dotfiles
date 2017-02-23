autoload -U colors && colors
setopt auto_cd
setopt multios
setopt prompt_subst

# Candy theme from oh-my-zsh
PROMPT=$'%{$fg_bold[green]%}%n@%m %{$fg[blue]%}%D{[%T]} %{$reset_color%}%{$fg[white]%}[%~]%{$reset_color%} $(git_prompt_info)\
%{$fg[blue]%}->%{$fg_bold[blue]%} %#%{$reset_color%} '
GIT_PROMPT_PREFIX="%{$fg[green]%}["
GIT_PROMPT_SUFFIX="]%{$reset_color%}"
GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
GIT_PROMPT_CLEAN=""
