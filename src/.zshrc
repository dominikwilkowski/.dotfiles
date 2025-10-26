source ~/.zprofile

# subl command
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"

###############################################| PROMPT |###############################################

# PROMPT to run functions
setopt prompt_subst

POWERLINE_LEFT_SEPARATOR=$'\ue0b0' # 
BRANCH=$'\ue0a0' # 
CROSS=$'\u2718' # ✘

parse_git_branch() {
	# Are we in a git repo?
	git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

	# Branch name or short SHA for detached HEAD
	local branch
	branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

	# Dirty marker (* if there are staged or unstaged changes)
	local dirty=""
	if ! git diff --quiet --ignore-submodules --cached 2>/dev/null ||
		! git diff --quiet --ignore-submodules 2>/dev/null; then
		dirty="*"
	fi

	echo "$BRANCH $branch$dirty"
}

# Segment builder
# Arguments: background color, foreground color, text, and separator into the next bg.
prompt_segment() {
	local bg fg text next_bg sep
	bg="$1"
	fg="$2"
	text="$3"
	next_bg="$4"
	sep="$POWERLINE_LEFT_SEPARATOR"

	# %K{color} = background, %F{color} = foreground
	# %k / %f reset bg/fg
	# We print the block [ text ] with bg, then we print the triangle using next_bg as bg color to "blend"
	if [[ -n "$text" ]]; then
		if [[ -n "$next_bg" ]]; then
			# normal segment with colored separator
			printf "%%K{%s}%%F{%s} %s %%K{%s}%%F{%s}%s" "$bg" "$fg" "$text" "$next_bg" "$bg" "$sep"
		else
			# last segment, separator goes back to default background
			printf "%%K{%s}%%F{%s} %s %%k%%F{%s}%s%%f" "$bg" "$fg" "$text" "$bg" "$sep"
		fi
	fi
}

# Build the prompt
build_prompt() {
	local exit_code=$?

	# our cwd
	local dir="%~"

	# git branch info if we're in a repo, "" otherwise
	local branch
	branch=$(parse_git_branch)

	local show_git=""
	local show_err=""

	if [[ -n "$branch" ]]; then
		show_git="yes"
	fi

	# only show error segment if exit code is non-zero
	if [[ $exit_code -ne 0 ]]; then
		show_err="yes"
	fi

	# Figure out what background comes AFTER each segment
	# Order is always: cwd(blue) -> git(green) -> err(red)

	# after cwd:
	local cwd_next_bg=""
	if [[ -n "$show_git" ]]; then
		cwd_next_bg="green"
	elif [[ -n "$show_err" ]]; then
		cwd_next_bg="red"
	else
		cwd_next_bg=""
	fi

	# after git:
	local git_next_bg=""
	if [[ -n "$show_err" ]]; then
		git_next_bg="red"
	else
		git_next_bg=""
	fi

	# err is always last if it exists
	local err_next_bg=""

	# Build visible segments
	local cwd_seg git_seg err_seg

	cwd_seg=$(prompt_segment blue white "$dir" "$cwd_next_bg")

	if [[ -n "$show_git" ]]; then
		git_seg=$(prompt_segment green black "$branch" "$git_next_bg")
	fi

	if [[ -n "$show_err" ]]; then
		err_seg=$(prompt_segment red white "$CROSS $exit_code" "$err_next_bg")
	fi

	# prompt char on second line
	local final_arrow
	if [[ $EUID -eq 0 ]]; then
		final_arrow="%F{red}#%f"
	else
		final_arrow="%F{yellow}λ%f"
	fi

	# final render
	print -P -- "${cwd_seg}${git_seg}${err_seg} ${final_arrow} "
}


# Tell zsh to use it
PROMPT='$(build_prompt)'
RPROMPT=''	# nothing on the right for now

###############################################| PROMPT |###############################################

# ls alias for color-mode
alias ll='ls -lhaG $@'
# unalias ls

# cd up
alias ..='cd ..'

# get ip
alias ip='ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d \	-f 2'

# more details
alias ip2="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# refresh shell
alias reload='source ~/.zshrc'
alias refresh='source ~/.zshrc'

# open current folder in Finder
alias f='open -a Finder ./'

# recursive dir listing
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/	 /'\'' -e '\''s/-/|/'\'' | less'

# start apache
alias astart='sudo apachectl start'

# start server from current dir
alias serve='python -m SimpleHTTPServer 8000'

# kill video
alias killVideo='sudo killall VDCAssistant'

# upgrade
alias upgrade='echo "\x1B[43m\x1B[30m $(date +"%Y-%B-%d %H:%M:%S") \x1B[0m" && rustup update && brew upgrade'
