# Timeline
A script to find computing anniversaires from a MySQL database and email the TNMoC mailing list.


## Introduction

This is a small script written for [The National Museum of Computing](http://www.tnmoc.org/), designed to be ran each month alerting them of any upcomming anniversaries. [The code accesses this database.](http://wiki.tnmoc.org/timeline/)

The script only needs perl and a few modules from CPAN to run:

- DBI
- POSIX
- Email::MIME
- Email::Sender::Simple
