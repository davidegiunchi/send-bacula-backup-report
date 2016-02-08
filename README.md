  
# Send Bacula Backup Report  
#### version 0.6 by Davide Giunchi (davide@giunchi.net)  
#### https://giunchi.net/send-bacula-backup-report  
  
  
1. Topic and feature of Send Bacula Backup Report  
2. Various  
3. Bugs
4. GitHub
5. Thanks  
6. License  
  

1 - Topic and feature of Send Bacula Backup Report
-----------
 

The standard "Messages" Bacula function send a separate email for every backup job, when
you manage a network full of servers this will increase the number of daily emails, and a single "daily digest"
will be much better.  
This is a perl program that works with Bacula, it send a digest of the backup jobs run in the last
X days, you can run it every morning to notify about the state of every job run in the night,
or every monday to get the state of the week-end backups.  
You need to install the program in the Bacula (community or Enterprise) Director server that use MySQL or PostgreSQL.
All the parameters are configurable on the config file /etc/bacula/send_bacula_backup_report.conf , the email
report use the "HTML::Template" template engine, so you can customize the email layout as you want.
The default email layout is the same of the Bweb html interface, so, if you are confident with
bweb, you will immediately understand the output.  
You will fast and easly understand every the Backup job result by take a look at the "Status" field, you will
get one the following states:  
  
OK: all right  
ERROR: fatal error  
WARNING: job ok but maybe some files are in use, some directory are missing ecc...  
RUNNING: job is still running when Send Bacula Backup Report has been run  
WAITING: job queued and waiting for start  
ATTENTION: job is ok but size is smaller than what did you expect (optional)  
  
In every case where the status is not OK, click on the job status to connect to the bacula's web interface (if you configured it) and view more details.  
Even if all jobs are OK, please remember to do some restore tests on a regular basis to check that you save all
the needed directory/files and the data are correct restored.  
  
In Send Bacula Backup Report version 0.6 you can define the "minimum expected job size":  
$minimum_size{'my-job'} = '4000000000';  
if "my-job" is ok and its size is less than 4Gb, mark the job as "ATTENTION". This is expecially useful for jobs with pre-script that dump a database: the
script may return with ok value (0) but it didn't dump the databases. This feature will make easier to detect this dangerous behaviour.  

To install this program read the INSTALL file.  


2 - Various  
-----------
   

You are encourage to contribute this program, if you have patch, suggestion or
critics please contact me.  
This program has been tested with Bacula community from version 5.0.3 to 7.0.5 and Bacula Enterprise from 4.0.7 to 8.0.9.  

Latest Send Bacula Backup Report version can be found at:  

https://giunchi.net/send-bacula-backup-report

3 - GitHub  
-----------

https://github.com/davidegiunchi/send-bacula-backup-report


4 - Bugs  
-----------


If you find a bug, send me the original mail(s) that give problem and i will analize it.  
You can contribute via github on https://github.com/davidegiunchi/send-bacula-backup-report 


4 - Thanks  
-----------
 

Kern Sibbald for Bacula  
Eric Bollengier for Bweb  
Willy Morin for template css  
Victor Hugo dos Santos for jobs overview directly in the subject  
Marcin Haba for baculum fix  
Every Bacula contributor  


5 - License  
-----------
   

This program is Copyright(C) 2011 Davide Giunchi, and may be copied according to
the GNU GENERAL PUBLIC LICENSE (GPL) Version 2 or a later version.  A copy of
this license is included with this package.  This package comes with no warranty
of any kind.
