function fuz
    # If an argument is provided, use it as the filepath
    if test (count $argv) -gt 1
       echo "only -h or filepath"
    else if test (count $argv) -gt 0
    	 if test $argv[1] = -h
    	      set filepath $HOME
    	 else if test (count $argv) -eq 1
              set filepath $argv[1]
	 end
    else
        # If no argument is provided, use the current directory
        set filepath (pwd)
    end

    # Function to run fzf and handle selection
    function fzf_select
        # Use `find` to get files and directories, then run `fzf`
        #set selection (find $argv[1] -mindepth 1 | fzf --preview "ls -l {}" --preview-window=up:30%
        set selection (find . -mindepth 1 |
	fzf --ansi --preview \
	"if [ -f {} ]; then cat {}; else ls -ls {}; fi"\
	--preview-window=top:30%)
        # If `fzf` returns an empty selection, exit gracefully
        if test -z "$selection"
            return 0
        end

        # If a directory is selected, change the directory and call fzf again in that directory
	set emacs_open (emacsclient -e "(print (server-running-p))")

        if test -d $selection
            cd $selection
            fzf_select (pwd)  # Continue browsing in the new directory
        # If a file is selected, open it in Emacs
        else if test -f $selection
	    if string match -r ".*\.pdf" "$selection" 
	        nohup firefox $selection &>/dev/null & disown
	    else if string match -r ".*\.png" "$selection" 
	        open $selection &>/dev/null & disown
	    else if string match -r ".*\.jpeg" "$selection" 
	        nohup open $selection &>/dev/null & disown
	    else if string match -r ".*\.svg" "$selection" 
	        nohup open $selection &>/dev/null & disown
	    else if string match -r ".*\.mkv" "$selection" 
	        nohup mpv $selection &>/dev/null & disown
	    else if string match -r ".*\.mp4" "$selection" 
	        nohup mpv $selection &>/dev/null & disown
	    else if string match -r ".*\.mov" "$selection" 
	        nohup mpv $selection &>/dev/null & disown
	    else if test "$emacs_open" = t
	       emacsclient -n -e "(tab-new)" & 
	       emacsclient -n -e "(find-file \"$selection\")"
	    else
	       nohup emacs $selection &>/dev/null & disown
	    end
        end
    end

    # Call the function with the initial filepath
    fzf_select $filepath
end