#! /bin/bash -e
npm install
# mocha -u tdd -R spec || rm -rf ../deploy && exit 1
cd ..
rm -rf old
if [ -d current ]; then
	mv current old
fi
mv deploy current
mkdir deploy
cd current
mkdir temp
mkdir temp/tokens
mkdir temp/failed_emails
mkdir logs
echo "Starting the script"
forever stop src/app.coffee
forever start -c coffee src/app.coffee -l logs/forever.log -o logs/console.log -e logs/error.log