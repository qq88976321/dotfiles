# Custom mise prompt segment: powerlevel10k has no builtin one yet.
# ref:
#  - https://github.com/2KAbhishek/dots2k/blob/b8e0cec77e4a8dac1d57198dbb25e2df1ba8b72d/config/zsh/prompt/p10k.mise.zsh
#  - https://github.com/romkatv/powerlevel10k/issues/2212#issuecomment-2504197398
#
# `mise ls --current` costs ~40ms, which is too slow to pay on every prompt,
# so its output is cached and only refreshed when the prompt renders in a new
# $PWD. After changing tool versions in place (e.g. `mise use`), run `cd .`
# to refresh the segment.

() {
  typeset -g _p10k_mise_cached_pwd=''
  typeset -ga _p10k_mise_cached_tools=()

  function prompt_mise() {
    if [[ $PWD != $_p10k_mise_cached_pwd ]]; then
      _p10k_mise_cached_pwd=$PWD
      _p10k_mise_cached_tools=("${(@f)$(mise ls --current --offline 2>/dev/null | awk '!/\(symlink\)/ && $3!="~/.tool-versions" && $3!="~/.config/mise/config.toml" && $3!="(missing)" {if ($1) print $1, $2}')}")
    fi
    local tool_version
    for tool_version in $_p10k_mise_cached_tools; do
      local parts=("${(@s/ /)tool_version}")
      [[ -n "$parts[1]" && -n "$parts[2]" ]] || continue
      local tool=${(U)parts[1]}
      p10k segment -r -i "${tool}_ICON" -s $tool -t "$parts[2]"
    done
  }

  # Colors
  typeset -g POWERLEVEL9K_MISE_BACKGROUND=1

  typeset -g POWERLEVEL9K_MISE_DOTNET_CORE_BACKGROUND=93
  typeset -g POWERLEVEL9K_MISE_ELIXIR_BACKGROUND=129
  typeset -g POWERLEVEL9K_MISE_ERLANG_BACKGROUND=160
  typeset -g POWERLEVEL9K_MISE_FLUTTER_BACKGROUND=33
  typeset -g POWERLEVEL9K_MISE_GO_BACKGROUND=81
  typeset -g POWERLEVEL9K_MISE_HASKELL_BACKGROUND=99
  typeset -g POWERLEVEL9K_MISE_JAVA_BACKGROUND=196
  typeset -g POWERLEVEL9K_MISE_JULIA_BACKGROUND=34
  typeset -g POWERLEVEL9K_MISE_LUA_BACKGROUND=33
  typeset -g POWERLEVEL9K_MISE_NODE_BACKGROUND=34
  typeset -g POWERLEVEL9K_MISE_PERL_BACKGROUND=33
  typeset -g POWERLEVEL9K_MISE_PHP_BACKGROUND=93
  typeset -g POWERLEVEL9K_MISE_POSTGRES_BACKGROUND=33
  typeset -g POWERLEVEL9K_MISE_PYTHON_BACKGROUND=33
  typeset -g POWERLEVEL9K_MISE_RUBY_BACKGROUND=196
  typeset -g POWERLEVEL9K_MISE_RUST_BACKGROUND=208

  # Substitute the default asdf prompt element
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=("${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]/asdf/mise}")
}
