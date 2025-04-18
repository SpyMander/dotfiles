if status is-interactive
    # Commands to run in interactive sessions can go here
    #alias fuz='bash ~/shl.d/fuz.sh'
end

function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s%s %s%s%s \n> ' (set_color red) $USER \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color blue)
end

function fish_greeting
date
end
