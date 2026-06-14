# create a project from a template using the CreateProject command defined in the neovim configuration

if (( $+commands[nvim] )); then
	function create-project() {
    nvim --headless +"CreateProject $*" +qa
  }

	function _create_project() {
    local templates_directory="$XDG_CONFIG_HOME/nvim/templates"
    local -a templates
    if [[ -d "$templates_directory" ]]; then
      templates=("$templates_directory"/*(N:t))
    fi

    if compset -P "template="; then
      _wanted templates expl 'project template' compadd -a templates
    elif ! (( ${words[(I)template=*]} && ${words[(I)template=*]} != CURRENT )); then
      _wanted values expl 'option' compadd -S "" "template="
    fi
  }

  compdef _create_project create-project
fi  
