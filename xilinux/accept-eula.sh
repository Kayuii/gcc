#!/usr/bin/expect
set timeout -1
set install_dir [lindex $argv 1]
set installer [lindex $argv 0]

spawn $installer
set timeout 3
expect {
    -re "PRESS <ENTER> TO CONTINUE:" {
        send "\r"; exp_continue
    }
    -re "PRESS <ENTER> TO INSTALL:" {
        send "\r"; exp_continue
    }
    -re "DO YOU ACCEPT THE TERMS OF THIS LICENSE AGREEMENT*" {
        send "y\r"; exp_continue
    }
    -re "->1- Typical" {
        sleep 1; send "2\r"; exp_continue
    }
    -re "Where would you like to install" {
        sleep 1; send "${install_dir}\r";sleep 2; send "y\r"; exp_continue;
    }
    -re "4- Don't create links" {
        sleep 1; send "4\r"; exp_continue;
    }
    -re "PRESS <ENTER> TO EXIT THE INSTALLER:" {
        send "\r"; exp_continue
    }

    timeout { send "q"; sleep 1; exp_continue;}
    eof { exit }
}


set timeout -1
expect "INFO: Checking PetaLinux installer integrity..."
expect "INFO: PetaLinux SDK has been installed"
#interact
