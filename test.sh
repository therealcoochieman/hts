#!/bin/sh
# Goal is to test the which.sh script with the real command which
run_test() {
    local description="Running: which $1"
    local command_to_test=$1
    # Get the output and return code of which.sh
    if [ "$#" -eq 0 ]
    then
        # Case to test which withou argument
        $(sh which.sh > /tmp/stdout_from_script 2> /tmp/stderr_from_script )
    else
        $(sh which.sh $command_to_test > /tmp/stdout_from_script 2> /tmp/stderr_from_script )
    fi
    return_code_from_script="$?"
    # Get the output and return code of the real which command
    $(which $command_to_test > /tmp/stdout_from_which 2> /tmp/stderr_from_which )
    return_code_from_which="$?"
    stdout_from_script=$(cat /tmp/stdout_from_script )
    stderr_from_script=$(cat /tmp/stderr_from_script )
    stdout_from_which=$(cat /tmp/stdout_from_which )
    stderr_from_which=$(cat /tmp/stderr_from_which )
    # Compare the outputs
    if
        [ "$stdout_from_script" = "$stdout_from_which" ] &&
        [ "$stderr_from_script" = "$stderr_from_which" ] &&
        [ $return_code_from_script -eq $return_code_from_which ]; then
        echo "\033[32mTest passed: $description\033[0m"
    else
        echo "\033[31mTest failed: $description\033[0m"
        #echo "Output of which.sh: $output_from_script (Return Code: $return_code_from_script)"
        #echo "Output of 'which': $output_from_which (Return Code: $return_code_from_which)"
        echo "Stdout comparaison"
        diff /tmp/stdout_from_script /tmp/stdout_from_which
        echo "Stderr comparaison"
        diff /tmp/stderr_from_script /tmp/stderr_from_which
        echo "Got Return Code from script : $return_code_from_script"
        echo "Got Return Code from which : $return_code_from_which"
    fi
    echo "\n"
}
# Test Case 1 : Running which.sh without argument
run_test
# Test Case 2: Running which.sh with -a option without the next argument
run_test "-a"
# Test Case 3: Running which -a command
run_test "-a ls"
run_test "notexist"
run_test "notexist ioio"
run_test "ls notexist"
run_test "-a ls touch cat"
run_test "-f ls"
run_test "-a ls cat -bouteille touch"
run_test "-a ls -a"
run_test "-a -a -a -a"
run_test "-a -a -a -a ls"
run_test "-a -a -a -a ls -bouteille"
run_test "-a -a -a -a -bouteille"
run_test "/bin/ls"
run_test "/bin/ls /bin/cat"
run_test "ls /bin/man /bin/touch"
run_test "/bin/notexist"
run_test "-a ls -fifo /noexist /bin/ls"
run_test "-a ls ls man /bin/ls"
