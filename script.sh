#!/bin/bash
clear

if [[ -e output ]]; then
  rm -R output
  echo "Removed output folder"
  sleep 1
  clear
fi

mkdir output
echo "Output folder created"
echo""
sleep 1

exec < input/Students.txt
while read LINE; do
    STUDENTINFO=( $LINE )
    mkdir output/${STUDENTINFO[0]}
      printf "Surname : ${STUDENTINFO[1]}\nName : ${STUDENTINFO[2]}\nDate of Birth : ${STUDENTINFO[3]}\nAddress : ${STUDENTINFO[4]} ${STUDENTINFO[5]} ${STUDENTINFO[6]} ${STUDENTINFO[7]} ${STUDENTINFO[8]} ${STUDENTINFO[9]} " > output/${STUDENTINFO[0]}/Details.txt
done
echo "Read contents of input/Students.txt"
echo""
sleep 1
echo "Created Details.txt"
echo""
sleep 1

for blockno in $(ls input); do
  if [[ -d "input/$blockno" ]]; then
    for M in $( ls input/$blockno ); do
      MODULE="${M%.txt}"
      exec < input/$blockno/$M
      while read CONTENTS; do
        MARKSARRAY=( $CONTENTS )
        echo "Student no: ${MARKSARRAY[0]} | Module : $MODULE | Mark : ${MARKSARRAY[1]}%">> output/${MARKSARRAY[0]}/$blockno.txt
        if [[ ${MARKSARRAY[1]} -lt 40 ]]; then
          RESULTS="Module $MODULE : FAILED! Obtained ${MARKSARRAY[1]}% (less than 40%)"
        else
          RESULTS="Module $MODULE : PASSED! Obtained ${MARKSARRAY[1]}% (greater than 40%)"
        fi
        echo $RESULTS >> output/${MARKSARRAY[0]}/notes.txt
      done
    done
  fi
done
echo "Created student reports"
echo ""
sleep 1

for folder in $(ls output); do
  if [[ $(grep -c "M12" output/$folder/notes.txt) != 1 ]]; then
    echo "M12 detected twice in folder $folder"
    echo "Note: Student $folder repeated module M12 and passed" >> output/$folder/notes.txt
    echo "$(tail -n +2 "output/$folder/notes.txt")" > output/$folder/notes.txt
    echo "Removed duplicate modules from $folder/notes.txt"
    echo""
    sleep 1
  fi
  exec < output/$folder/notes.txt
  while read NOTECONTENTS; do
    NOTESARRAY=($NOTECONTENTS)
    if [[ ${NOTESARRAY[1]} == "M12" ]]; then
      echo "student $folder ${NOTESARRAY[1]} got ${NOTESARRAY[5]}" >> output/repeats.txt
    fi
  done
done

echo""
echo "Program Completed"
echo""
echo""
