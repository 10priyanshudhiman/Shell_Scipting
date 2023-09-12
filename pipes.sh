#! /bin/bash

# if [[ $# == 2 ]]
# then
#     echo "args equal to 2"
# else
#     echo "not equal"
# fi

# a=1
# b=2
# if [ $a -le $b ]
# then
#     echo "$a < $b"
# else 
#     echo "a > b"
# fi

# echo $((2+3))
# a=2
# b=6
# c=$(($b/$a))
# echo $c

# my_arr=(1 2 "dsad" 5)
# echo ${my_arr[@]}
#  my_arr+=7
#  my_arr+="6dsadasdsa";

# echo ${my_arr[@]};

# for i in ${my_arr[@]}; do
#     echo $i
# done

#Assignment

echo "Choose"
echo -n "Enter \"y\" for yes, \"n\" for no :"
read response 

if [ "$response" == "y" ]
then
    echo "yay"
elif [ "$response" == "n" ]
then
    echo "nooo"
else
    echo "lost"
fi

csv_file="./arrays_table.csv"
# parse table columns into 3 arrays
column_0=($(cut -d "," -f 1 $csv_file))
column_1=($(cut -d "," -f 2 $csv_file))
column_2=($(cut -d "," -f 3 $csv_file))
# print first array
echo "Displaying the first column:"
echo "${column_0[@]}"

column_3=("coulumn_3")

nlines=$(cat $csv_file | wc -l)

echo "lines are $nlines"

for ((i=1; i<$nlines; i++)); do
    column_3[$i]=$((column_2[$i] - column_1[$i]))
done
echo "${column_3[@]}"

## Combine the new array with the csv file
# first write the new array to file
# initialize the file with a header
echo "${column_3[0]}" > column_3.txt
for ((i=1; i<nlines; i++)); do
  echo "${column_3[$i]}" >> column_3.txt
done
paste -d "," $csv_file column_3.txt > report.csv




