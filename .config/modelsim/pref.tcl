proc external_editor {filename linenumber} {
 exec "env" LD_LIBRARY_PATH=/usr/lib:/usr/lib64:/usr/lib32 konsole -e nvr $filename +$linenumber &
	# exec "env" LD_LIBRARY_PATH=/usr/lib:/usr/lib64:/usr/lib32 code --reuse-window --goto $filename:$linenumber &
}
set PrefSource(altEditor) external_editor
