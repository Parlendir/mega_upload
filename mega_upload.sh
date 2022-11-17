#!/bin/bash

## - Script to upload files to MEGA account
## - Walkthrough
##      - For each FILE included in a SOURCE folder
##      - uploads (megaput) if the remaining space is over a fixed LIMIT
##      - deletes the uploaded FILE in the SOURCE folder

## Important : megatools must be installed
## man page : https://manpages.ubuntu.com/manpages/jammy/man1/megaput.1.html#megatools

## VARIABLES

## source folder
SOURCE=/home/desk/syno_media/tampon/MEGA_upload

## Limit for a new upload : min space available on the account (mb)
LIMIT=100

## MEGA account credentials
EMAIL="email@example.com"
PASSWORD="suchastrongpassword"

## Log file path
LOG=/home/desk/syno_musique/Scripts/mega_upload/MEGA_log.md

## START OF THE SCRIPT

## Start the log trace
echo "## UPLOAD du $(date)" >> ${LOG}
echo "" >> ${LOG}


## Loop to iterate on each FILE included in the SOURCE folder
for FILE in $SOURCE/* ; do

##  Get the free space available in the account (Mb)
size_free="$(megadf -u ${EMAIL} -p ${PASSWORD} --free --mb)"

        ## test the available free space in the account
        if [[ ${size_free} > ${LIMIT} ]]; then

                # if the available space is over the LIMIT, proceed (upload to the /ROOT/ folder)
                megaput --no-progress --disable-previews -u ${EMAIL} -p ${PASSWORD} "$FILE"

                # verbosity
                echo "Uploaded : ${FILE:41:40}" >> ${LOG}

                # delete the uploaded FILE for SOURCE
                rm "$FILE" && echo "Deleted  : ${FILE:41:40}" >> ${LOG}

        else

                # else break
                break

        fi

done


# in the end, put more verbosity into the LOG

size_free="$(megadf -u ${EMAIL} -p ${PASSWORD} --free --mb)"

echo "" >> ${LOG}
echo "Free space left =" ${size_free} "Mb." >> ${LOG}

## Endtime to the log
echo "Upload end : $(date)" >> ${LOG}
echo "" >> ${LOG}
echo "" >> ${LOG}

# exit code
exit 0
