Doing this install on Ubuntu 14.04 LTS.

Prepare DayLog user
======

- Log in as root
- Run apt-get update
- Run apt-get install curl git screen ruby-dev 
- Install nodejs
- Add the user daylog
- Run "adduser daylog sudo"
- Run dpkg-reconfigure tzdata and set the system time as appropriate.

Install RVM
======

- Log in as daylog
- Run "\curl -sSL https://get.rvm.io | bash -s stable --ruby"
- Log out and log back in to ensure rvm is sourced.
- Install the correct Ruby interpreter. As of this writing I'm using Ruby 2.3.3 for DayLog. So run "rvm install 2.3.3"

Clone and install DayLog
======

- git clone "https://github.com/PerryBhandal/DayLog.git"
- CD into DayLog and run "gem install bundle; bundle install"
- Run "rake secret" and replace the value in config/secrets.yml with the generated value for production mode.

Launching DayLog
======

CD into scripts and:

- Run migrateDatabase.sh
- Run compileAssets.sh
- Run launchSite.sh

Updating DayLog
======

- Close the site's screen instance
- Run backupDatabase.sh
- Run updateSite.sh
- Run migrateDatabase.sh (if db changes were made)
- Run compileAssets.sh
- Run launchSite.sh

