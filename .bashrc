case $- in
*i*) ;;
*) return ;;
esac

for component in multiplexer prompt fetch functions aliases; do
	if [ -r "$XDG_CONFIG_HOME/bash/$component.sh" ]; then
		. "$XDG_CONFIG_HOME/bash/$component.sh"
	fi
done

if [ -r "/usr/share/doc/pkgfile/command-not-found.bash" ]; then
	. "/usr/share/doc/pkgfile/command-not-found.bash"
fi
