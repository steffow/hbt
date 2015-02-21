#!/bin/bash

#
# Usage
#    ./meteorMongoImport.sh goto
#


METEOR_DOMAIN="$1"

if [[ "$METEOR_DOMAIN" == "" ]]
then
	echo "You need to supply your meteor app name"
	echo "e.g. ./meteorMongoImport.sh app"
	exit 1
fi

# REGEX ALL THE THINGS.
# Chomps the goodness flakes out of urls like "mongodb://client:pass-word@skybreak.member0.mongolayer.com:27017/goto_meteor_com"
MONGO_URL_REGEX="mongodb:\/\/(.*):(.*)@(.*)\/(.*)"

# stupid tmp file as meteor may want to prompt for a password
TMP_FILE="/tmp/meteor-dump.tmp"

# Get the mongo url for your meteor app
meteor mongo $METEOR_DOMAIN --url | tee "${TMP_FILE}"

MONGO_URL=$(sed '/Password:/d' "${TMP_FILE}")

# clean up the temp file
if [[ -f "${TMP_FILE}" ]]
then
	rm "${TMP_FILE}"
fi

if [[ $MONGO_URL =~ $MONGO_URL_REGEX ]] 
then
	MONGO_USER="${BASH_REMATCH[1]}"
	MONGO_PASSWORD="${BASH_REMATCH[2]}"
	MONGO_DOMAIN="${BASH_REMATCH[3]}"
	MONGO_DB="${BASH_REMATCH[4]}"
    
    echo "MONGO_USER $MONGO_USER"
	echo "MONGO_PASSWORD $MONGO_PASSWORD"
	echo "MONGO_DOMAIN $MONGO_DOMAIN"
	echo "MONGO_DB $MONGO_DB"

	
	mongoimport -u $MONGO_USER -h $MONGO_DOMAIN -d $MONGO_DB -p "${MONGO_PASSWORD}" --collection books --type json --file ~/CodeWarrior/Meteor/hbt/books.json --jsonArray
else
	echo "Sorry. Couldn't import data; your details from the url: ${MONGO_URL}"
	exit 1
fi
