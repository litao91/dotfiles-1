
function __hostname
  echo (hostname|cut -d . -f 1)
end

function __add_to_path
    if test (count $argv) = 1
        set -gx PATH $argv[1] $PATH
    else
        echo "Usage: __add_to_path <path>"
    end
end

function __reload_config
    source ~/.config/fish/config.fish
end

function __make_completion --argument alias command
  complete -c $alias -xa "(
    set -l cmd (commandline -pc | sed -e 's/^ *\S\+ *//' );
    complete -C\"$command \$cmd\";
  )"
end

function __elenore
  test (__hostname) = "elenore"
end

function __layla
  test (__hostname) = "layla"
end

set -gx LC_ALL "en_US.UTF-8"
set -gx LANG "en_US.UTF-8"
set -gx EDITOR "vim"
set -gx GIT_EDITOR "vim"
set -gx GREP_OPTIONS "--color=auto"
set -gx CDPATH . "$HOME/Workspace"
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_NO_GITHUB_API 1
set -gx BREW_CELLAR "/usr/local/Cellar"

set -gx TOMCATS $HOME/Workspace/tomcats
set -gx CATALINA_HOME $TOMCATS/apache-tomcat-8.0.29

if __elenore
  set -gx ANDROID_HOME /Volumes/SD/android-sdk
  __add_to_path $ANDROID_HOME/platform-tools
end

if test -e $HOME/.jenv
  set -gx JENV_ROOT $HOME/.jenv
  __add_to_path $JENV_ROOT/bin
  __add_to_path $JENV_ROOT/shims
end

if test -e $HOME/.rbenv
  set -gx RBENV_ROOT $HOME/.rbenv
  __add_to_path $RBENV_ROOT/bin
  status --is-interactive; and source (rbenv init -|psub)
end

if test -e $HOME/.luaenv
  set -gx LUAENV_ROOT $HOME/.luaenv
  __add_to_path $LUAENV_ROOT/bin
  status --is-interactive; and source (luaenv init -|psub)
end


if test -e $HOME/.ndenv
  set -gx NDENV_ROOT $HOME/.ndenv
  __add_to_path $NDENV_ROOT/bin
  __add_to_path $NDENV_ROOT/shims
  ndenv rehash
end

if test -e $HOME/.exenv
  set -gx EXENV_ROOT $HOME/.exenv
  __add_to_path $EXENV_ROOT/bin
  __add_to_path $EXENV_ROOT/shims
  exenv rehash
end

if test -e $HOME/.pyenv
  set -gx PYENV_ROOT $HOME/.pyenv
  __add_to_path $PYENV_ROOT/bin
  status --is-interactive; and source (pyenv init -|psub)
  status --is-interactive; and source (pyenv virtualenv-init -|psub)
end


if test -e $HOME/.trabe
  set -gx TRABE_ROOT $HOME/.trabe/trabe
  __add_to_path $TRABE_ROOT/bin
  status --is-interactive; and trabe init - | source
end

set -gx GOPATH $HOME/Workspace
__add_to_path $GOPATH/bin

#set -x TEXPATH /usr/texbin
#__add_to_path $TEXPATH

eval (direnv hook fish)

set fish_greeting ""
set fish_color_command "green"

function __user_host
  set -l content
  echo -n (set_color --bold yellow)
  echo -n $USER@(hostname|cut -d . -f 1) (set color normal)
end

function __prompt_pwd
  echo -n ' '(set_color green)(echo $PWD | sed -e "s|^$GHQ_ROOT\/github\.com|gh|" | sed -e "s|^$GHQ_ROOT\/bitbucket\.org|bb|" | sed -e "s|^$HOME|~|")(set_color normal)
end

function __prompt_char
  set_color white
  if [ $TMUX ]
    printf '\n> '
  else
    printf '\n~ '
  end
  set_color normal
end

function __rb_prompt
  echo -n (set_color red)''(rbenv version | awk '{print $1}')(set_color normal)
end

set __fish_git_prompt_color 'magenta'
set __fish_git_prompt_show_informative_status 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_char_stateseparator ' '
set __fish_git_prompt_char_stagedstate '+'
set __fish_git_prompt_color_stagedstate 'green'
set __fish_git_prompt_char_dirtystate 'x'
set __fish_git_prompt_color_dirtystate 'red'
set __fish_git_prompt_char_cleanstate \u2713
set __fish_git_prompt_color_cleanstate 'green'

function fish_prompt
    set -l last_status $status

  echo -ne (tput el)
  __user_host
  __prompt_pwd

  if test $last_status -ne 0
    set_color red
    printf ' [%d]' $last_status
    set_color normal
  end

  __fish_git_prompt " "
  __prompt_char
end

function v
    echo -e (set_color green) "node\t" (set_color normal) (ndenv version | awk '{print $1}'); and \
    echo -e (set_color red) "ruby\t" (set_color normal) (rbenv version | awk '{print $1}'); and \
    echo -e (set_color magenta) "elixir\t" (set_color normal) (exenv version | awk '{print $1}'); and \
    echo -e (set_color yellow) "python\t" (set_color normal) (pyenv version | awk '{print $1}'); and \
    echo -e (set_color blue) "lua\t" (set_color normal) (luaenv version | awk '{print $1}')
end

function fish_user_key_bindings
    bind \eb 'prevd; commandline -f repaint'
    bind \eu 'cd ..; commandline -f repaint'
    bind \cr 'ihistory; commandline -f repaint'
    bind \eo 'ips; commandline -f repaint'
    bind \ep 'ifind; commandline -f repaint'
    bind \ec 'ircd; commandline -f repaint'
    bind \ew 'ighq; commandline -f repaint'
end

alias vim   "nvim"
alias vlc   "/opt/homebrew-cask/Caskroom/vlc/2.2.1/VLC.app/Contents/MacOS/VLC"
alias wtr   "curl -4 wttr.in"
alias atmux "tmux -L atom"
alias tx "tmuxinator"
alias bb "cd $GHQ_ROOT/bitbucket.org/rcoedo"
alias gh "cd $GHQ_ROOT/github.com/rcoedo"
alias miex "iex -S mix"

function ranger-cd
    set tempfile '/tmp/ranger-cd'
    ranger --choosedir=$tempfile (pwd)

    if test -f $tempfile
        if test (cat $tempfile) != (pwd)
            cd (cat $tempfile)
        end
    end
    rm -f $tempfile
end

alias r     "ranger"
alias rr    "ranger-cd"

function igitbranch
    git branch | __fuzzy_find | xargs git checkout
end

function igitbranch
    git branch | __fuzzy_find | xargs git checkout
end

alias g "git"

set -x GHQ_ROOT "$HOME/Workspace/src"

function ighq
    ghq list | __fuzzy_find | read tempvar
    if test (count $tempvar) -gt 0
        cd (ghq root)/$tempvar
    end
end

function gg
    if test (count $argv) = 1
      if test (echo $argv[1] | grep -o "/" | wc -l | tr -d " ") = "2"
            set -l __repository (echo $argv[1] | cut -d"/" -f 2-)
            set -l __hub (echo $argv[1] | cut -d"/" -f 1)
            if test $__hub = "bb"
                  ghq get git@bitbucket.org:$__repository.git
            end
      else
            ghq get -p $argv[1]
      end
   end
end

function dr
    if test (count $argv) = 2
        docker run --rm -t -i -v (bash -c "echo \$(cd $argv[2] && pwd)"):/volume -w /volume $argv[1] /bin/bash
    else
        echo "Usage: dr <image> <directory>"
    end
end

alias dc "docker-compose"
alias kb "kubectl"
alias d  "docker"
alias mk "mkdir -p"
alias ta "tmux attach-session"