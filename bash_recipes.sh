* bash profile order
~/.bash_profile -> ~/.bash_login -> ~/.profile

PATH="${PATH}:$HOME/bin"

also /etc/profile, /etc/bashrc, /etc/rc, /etc/default/login, ~/.ssh/environment, /etc/environment

# grep -l PATH ~/.[^.]*

merge
# cat content-1 content-2 > content-all

all files in one line
# ls -C > /tmp/save.out

standard output and error output to a separate file
# myapp 1> std.out 2> err.out

error output
# gcc myapp.c 2> error.out

* output std output & error to the same file
# try > output 2>&1

skip the first line
# tail -n +2 top.out

* do not show any in output
# myscript > /dev/null 2>&1

all command output to the same file
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

check success or failure of a previous command run
# echo $?

# cd mydir
# if (( $? == 0 )); then ls -l ; fi

nohup
# nohup myscript.sh &

rename many files
for FN in *.bad
do
    mv "${FN}" "${FN%bad}bash"
done

unzip many zip files
# unzip '*.zip'
=
for x in /tmp/*.zip; do unzip "$x"; done
=
for x in $(ls /tmp/*.zip 2>/dev/null); do unzip $x; done

* diff
# diff -y -W 60 left.out right.out
# diff -y -W 60 --suppress-common-lines left.out right.out
only show lines in the left file
# comm -23 left right
only show lines in the right file
# comm -13 left right
only show lines common to both files
# comm -12 left right

* view
# view filename
:set nu!

stack
# pushd /tmp
# dirs -v
# popd
# dirs -v