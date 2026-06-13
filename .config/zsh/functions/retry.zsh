# retry command until it succeeds

function retry() {
	while :; do
		"$@"
		local status=$?
		if [[ $status -eq 0 || $status -eq 130 ]]; then
			break
		fi
	done
}

function _retry() {
	_arguments '*::commands: _normal'
}

compdef _retry retry
