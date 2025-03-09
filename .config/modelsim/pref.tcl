proc external_editor {filename linenumber} {
 exec "konsole" -e nvim $filename +$linenumber &
}
set PrefSource(altEditor) external_editor
