#!/usr/bin/env bash
set -euo pipefail

# Absolute paths
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$REPO_DIR/src"

# Walk every file under src and hardlink it into $HOME preserving subpaths
find "$SRC_DIR" -type f | while IFS= read -r src_file; do
	# Path inside src (e.g. ".zshrc", ".config/kitty/kitty.conf")
	rel_path="${src_file#$SRC_DIR/}"

	# Destination in $HOME
	dest="$HOME/$rel_path"

	# Safety check: dest MUST live under $HOME
	case "$dest" in
		"$HOME"/*) ;;  # ok
		"$HOME") ;;    # also ok if it's exactly $HOME
		*)
			echo "ERROR: refusing to link outside \$HOME: $dest"
			exit 1
		;;
	esac

	echo "Linking: $src_file -> $dest"

	# Ensure parent dir exists
	mkdir -p "$(dirname "$dest")"

	# Replace whatever is there with a hardlink to the repo file
	rm -f "$dest"
	ln "$src_file" "$dest"
done
