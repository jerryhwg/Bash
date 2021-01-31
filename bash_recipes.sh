merge
# cat content-1 content-2 > content-all

all files in one line
# ls -C > /tmp/save.out

# myapp 1> std.out 2> err.out

error output
# gcc myapp.c 2> error.out

* output std output & error to the same file
# try > output 2>&1

skip the first line
# tail -n +2 top.out

* do not show any in output
# myscript > /dev/null 2>&1

# { pwd; ls -l; cd ~: ls -l; } > /tmp/all.out

saving output to a file while using it as input
# ls -l | tee /tmp/list.out | cat

= xargs
# rm $(find . -name '*.class')

input to a script but not want a separate file
myscript.sh 
grep $1 <<'EOF'
tom    marketing
jerry  sales
EOF
# myscript tom

prompting
# read -p "what is your name?"

# command_1; command_2; command_3
* only run the next command if the preceeding command worked
# command_1 && command_2 && command_3
all at once
# command 1 & command 2 & command 3

# echo $?

# cd mydir
# if (( $? == 0 )); then ls -l ; fi

# nohup myscript.sh &

