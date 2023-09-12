#! /bin/bash
# This script accepts the user\'s name and prints 
# a message greeting the user

# Print the prompt message on screen
echo -n "Enter your firstname :"	  	

# Wait for user to enter a name, and save the entered name into the variable \'name\'
read firstname				

echo -n "Enter your last name :"
read lastname

# Print the welcome message followed by the name	
echo "Welcome $firstname $lastname"

# The following message should print on a single line. Hence the usage of \'-n\'
echo -n "Congratulations! You just created and ran your first shell script "
echo "using Bash on IBM Skills Network"