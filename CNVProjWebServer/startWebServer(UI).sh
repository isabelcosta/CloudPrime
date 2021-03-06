#!/bin/bash

# init
function pause(){
   read -p "$*"
}

isNotCompiled=true

# this function is called when Ctrl-C is sent
function trap_ctrlc ()
{
    # perform cleanup here
    echo  "  trapped...  WebServer stopped at user command!"

    # exit shell script with error code 2
    # if omitted, shell script will continue execution
    exit 2
}

echo "Do you wish to compile the web server source code? [Y/n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then

printf "This shell script compiles the Instrumentation Tool and Web Server code\nBefore proceding ensure the CLASSPATH variable is correctly set. \nYou can do this by issuing the command 'echo \$CLASSPATH' in your terminal \nIf it is not set, you can set it by issuing the following command 'export CLASSPATH='\$CLASSPATH:/path/to/dir:/path/to/dir/InstrumentationTool:./''\n"

	pause "Press [Enter] to continue or Ctrl-C to cancel"

	printf "Compiling...\n"

	export CLASSPATH=./WebServerCode/instrumented/instrumentedOutput:./awsJavaSDK/lib/aws-java-sdk-1.10.69.jar:./awsJavaSDK/third-party/lib/*:.



 	javac  -source 1.4 ./WebServerCode/instrumented/*.java -d ./WebServerCode/instrumented/output/

	javac  -source 1.4 ./InstrumentationTool/FactInstr.java -d  ./WebServerCode/instrumented/instrumentedOutput/
	#javac -source 1.4 ./WebServerCode/instrumented/WebServer.java ./WebServerCode/instrumented/FactorizeMain.java ./WebServerCode/instrumented/Factorize.java -d ./WebServerCode/instrumented/output/


	cd WebServerCode/instrumented/instrumentedOutput/

	java -cp ../../../:. FactInstr ../output/ ../instrumentedOutput 

	cd ../../../
	
	printf "Finished compiling project\n"

	isNotCompiled=false
else
	printf "The source code was not compiled\n"
fi 

if $isNotCompiled ; then
	
	printf "Before proceding ensure you compiled the source code at least once.\nOtherwise the Web Server WILL NOT start.\n"
fi

pause "Press [Enter] to start the web server or Ctrl-C to cancel"

printf "Starting WebServer...\n"

printf "WebServer started\n"

trap "trap_ctrlc" 2



java WebServer

