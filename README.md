WebCalendar README
------------------

Project Home Page: https://www.k5n.us/webcalendar/
Project Owner: Craig Knudsen, &#99;&#114;&#97;&#105;&#103;&#64;&#107;&#53;&#110;&#46;&#117;&#115;  
Documentation:
- [System Administrator's Guide](http://htmlpreview.github.io/?https://github.com/craigk5n/webcalendar/blob/master/docs/WebCalendar-SysAdmin.html) (Installation instructions, FAQ)
- [Upgrading Instructions](http://htmlpreview.github.io/?https://github.com/craigk5n/webcalendar/blob/master/UPGRADING.html)
- License: [GPLv2](https://github.com/craigk5n/webcalendar/blob/master/LICENSE)
- [Online Demo at SF](http://webcalendar.sourceforge.net/demo/)

Developer Resources:
- [WebCalendar-Database.html](http://htmlpreview.github.io/?https://github.com/craigk5n/webcalendar/blob/master/docs/WebCalendar-Database.html)
- [WebCalendar-DeveloperGuide.html](http://htmlpreview.github.io/?https://github.com/craigk5n/webcalendar/blob/master/docs/WebCalendar-DeveloperGuide.html)

## Installation Instructions

After unzipping your files (or transferring the files to your hosting
provider, you will need to go to the web-based install script.
If your files are installed in a "webcalendar" folder under your parent
web server document root, you can access the script by going to:

    https://yourserverhere/webcalendar/

(Obviously, put the correct server name in above.)  The toplevel URL will
automatically redirect to the installation wizard.

## Setting Up a Docker Dev Environment

You can setup a docker environment with PHP 7.4 and MariaDb with a few
steps.

- Build the docker container with `docker-compose build`
- Start the containers with `docker-compose up`
- In order to grant the proper permissions inside of MariaDb, you
  will need to run a few MySQL commands.  First shell into the mariadb
  container: `docker-compose exec db /bin/sh`
- Start up the db client: `/bin/mariadb -p` (the password will be
  "Webcalendar.1" as specified in the `docker-compose.yml' file.  You
  can change it to make your dev environment more secure (before you
  build the containers in step above).
- Run the following db commands:
  ```
  GRANT ALL PRIVILEGES ON *.* TO webcalendar@localhost IDENTIFIED BY 'Webcalendar.1'  WITH GRANT OPTION; 
  FLUSH PRIVILEGES;
  QUIT
  ```
- Start up your web browser and go to:
  [http://localhost:8080/](http://localhost:8080/).
- Follow the guided web-based setup and choose "mysqli" as the database
  type.


