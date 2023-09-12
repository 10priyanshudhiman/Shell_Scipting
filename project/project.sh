#! /bin/bash

header=$(echo -e "year\tmonth\tday\tobs_tmp\tfc_temp")
echo $header>rx_poc.log

# Create the filename for today's wttr.in weather report

today=$(date +%Y%m%d)
weather_report=raw_data_$today

# Download the wttr.in weather report for Casablanca and save it with the filename you created
city=Casablanca
curl wttr.in/$city --output $weather_report


grep °C $weather_report > temperatures.txt

# extract the current temperature
obs_tmp=$(cat -A temperatures.txt | head -1 | cut -d "+" -f2 | cut -d "m" -f5 | cut -d "^" -f1 )
echo "observed temperature = $obs_tmp"

# extract the forecast for noon tomorrow
fc_temp=$(cat -A temperatures.txt | head -3 | tail -1 | cut -d "+" -f2 | cut -d "(" -f1 | cut -d "^" -f1 )

hour=$(TZ='Morocco/Casablanca' date -u +%H) 
day=$(TZ='Morocco/Casablanca' date -u +%d) 
month=$(TZ='Morocco/Casablanca' date +%m)
year=$(TZ='Morocco/Casablanca' date +%Y)

record=$(echo -e "$year\t$month\t$day\t$obs_tmp\t$fc_temp")
echo $record>>rx_poc.log

# Create a script to report historical forecasting accuracy

echo -e "year\tmonth\tday\tobs_tmp\tfc_temp\taccuracy\taccuracy_range" > historical_fc_accuracy.tsv

#Extract the forecasted and observed temperatures for today and store them in variables

#yesterday_fc=$(tail -2 rx_poc.log | head -1 | cut -d " " -f5)
# if [[ $yesterday_fc == $ ]]
# then
#     yesterday_fc=30
# fi
# echo $yesterday_fc
#Calculate the forecast accuracy
#today_temp=$(tail -1 rx_poc.log | cut -d " " -f4)
#echo $today_temp
yesterday_fc=100
today_temp=40
accuracy=$(($yesterday_fc - $today_temp))


if [ -1 -le $accuracy ] && [ $accuracy -le 1 ]
then
   accuracy_range=excellent
elif [ -2 -le $accuracy ] && [ $accuracy -le 2 ]
then
    accuracy_range=good
elif [ -3 -le $accuracy ] && [ $accuracy -le 3 ]
then
    accuracy_range=fair
else
    accuracy_range=poor
fi
echo "Forecast accuracy is $accuracy"

#Append a record to your historical forecast accuracy file.

row=$(tail -1 rx_poc.log)
year=$( echo $row | cut -d " " -f1)
month=$( echo $row | cut -d " " -f2)
day=$( echo $row | cut -d " " -f3)
echo -e "$year\t$month\t$day\t$today_temp\t$yesterday_fc\t$accuracy\t$accuracy_range" >> historical_fc_accuracy.tsv

#Load the historical accuracies into an array covering the last week of data

echo $(tail -7 synthetic_historical_fc_accuracy.tsv  | cut -f6) > scratch.txt
week_fc=($(echo $(cat scratch.txt)))
# validate result:
for i in {0..6}; do
    echo ${week_fc[$i]}
done

#Display the minimum and maximum absolute forecasting errors for the week

for i in {0..6}; do
  if [[ ${week_fc[$i]} < 0 ]]
  then
    week_fc[$i]=$(((-1)*week_fc[$i]))
  fi
  # validate result:
  echo ${week_fc[$i]}
done
minimum=${week_fc[1]}
maximum=${week_fc[1]}
for item in ${week_fc[@]}; do
   if [[ $minimum > $item ]]
   then
     minimum=$item
   fi
   if [[ $maximum < $item ]]
   then
     maximum=$item
   fi
done
echo "minimum ebsolute error = $minimum"
echo "maximum absolute error = $maximum"
