# list explicitly installed packages and their sizes, sorted by size

if (( $+commands[pacman] )); then
	function list-package-sizes() {
		pacman -Qi $(pacman -Qqe) \
				| awk '/^Name/{name=$3} /^Installed Size/{print name, $4$5}' \
				| sort -k2 -h \
				| sed 's/\([0-9.]*\)\([A-Za-z]*\)$/\1 \2/' \
				| column -t
	}
fi
