case $- in
    *i*) ;;
      *) return;;
esac

for script in $XDG_CONFIG_HOME/bash/*; do
	if [ -r "$script" ]; then
		. "$script"
	fi
done

if [ -r "/usr/share/doc/pkgfile/command-not-found.bash" ]; then
  . "/usr/share/doc/pkgfile/command-not-found.bash"
fi
