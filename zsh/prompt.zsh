autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

git_branch() {
  echo $(/usr/bin/git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  st=$(/usr/bin/git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
    echo ""
  else
    if [[ $st == "nothing to commit (working directory clean)" ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
 ref=$(/usr/bin/git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

project_name () {
  name=$(pwd | awk -F'Development/' '{print $2}' | awk -F/ '{print $1}')
  echo $name
}

project_name_color () {
#  name=$(project_name)
  echo "%{\e[0;35m%}${name}%{\e[0m%}"
}

unpushed () {
  /usr/bin/git cherry -v origin/$(git_branch) 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo "with %{$fg_bold[magenta]%}unpushed%{$reset_color%}"
  fi
}

rvm_prompt(){
  if $(which rvm &> /dev/null)
  then
	  echo "%{$fg_bold[yellow]%}$(rvm tools identifier)%{$reset_color%}"
	else
	  echo ""
  fi
}

directory_name(){
  echo "%{$fg_bold[cyan]%}%1/%{$reset_color%}"
}

host_name(){
  host_short=$(echo $HOST | cut -d"." -f1)
  echo "%{$fg_bold[yellow]%}$host_short%{$reset_color%}"
}

user_at(){
  user=$(echo $USER)
  echo "%{$fg[yellow]%}$user@%{$reset_color%}"
}

export PROMPT=$'\n$(user_at)$(host_name) : $(directory_name) $(project_name_color)$(git_dirty) $(need_push)\n› '
set_prompt () {
  export RPROMPT=""
}

precmd() {
  set_prompt
}
