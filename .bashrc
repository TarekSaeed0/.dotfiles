case $- in
*i*) ;;
*) return ;;
esac

for component in multiplexer prompt fetch functions aliases; do
	if [ -r "$XDG_CONFIG_HOME/bash/$component.sh" ]; then
		. "$XDG_CONFIG_HOME/bash/$component.sh"
	fi
done

tabs -4
