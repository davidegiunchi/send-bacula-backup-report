#!/usr/bin/perl

# Send Bacula Backup Report - version 0.6 - by Davide Giunchi, davide@giunchi.net
# Send a report of the Bacula backup jobs run in the last X days

# LICENSE:
#
# Copyright (c) 2011 Davide Giunchi
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

# get actual date
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;
$mon += 1;
%minimum_size;

# acquire the conf
require '/etc/bacula/send_bacula_backup_report.conf';

use DBI;
use HTML::Template;
use MIME::Lite;

my $template = HTML::Template->new(filename => $template_file);

# get the days since you want the report, calculate the seconds
$jobs_since_hours=$ARGV[0];
$template->param(JOBS_SINCE_DAYS => $jobs_since_hours);
$jobs_since_seconds = $jobs_since_hours * 86400;



$dbh = DBI->connect("DBI:$db_type:database=$db_name;host=$db_host", "$db_username", "$db_password") || die "Could not connect to database: $DBI::errstr";

# get the jobs in the time requested. starttime = '0000-00-00 00:00:00' or null is for waiting jobs.

if ($db_type eq 'mysql') {
        $sth_list_jobs = $dbh->prepare("SELECT Job.JobId AS jobid, Client.Name AS client, FileSet.FileSet AS fileset, Job.Name AS jobname, Level AS level, StartTime AS starttime, EndTime AS endtime, JobFiles AS jobfiles, JobBytes AS jobbytes, JobStatus AS jobstatus,  SEC_TO_TIME(UNIX_TIMESTAMP(EndTime) - UNIX_TIMESTAMP(StartTime)) AS duration, JobErrors AS joberrors  FROM Client, Job  LEFT JOIN FileSet  ON (Job.FileSetId = FileSet.FileSetId) WHERE Client.ClientId=Job.ClientId AND ( UNIX_TIMESTAMP(starttime) > ( UNIX_TIMESTAMP(NOW()) - ($jobs_since_seconds)  ) OR starttime = '0000-00-00 00:00:00' ) ORDER BY JobStatus, JobErrors DESC ");
} else {
        $sth_list_jobs = $dbh->prepare("SELECT Job.JobId AS jobid, Client.Name AS client, FileSet.FileSet AS fileset, Job.Name AS jobname, Level AS level, StartTime AS starttime, EndTime AS endtime, JobFiles AS jobfiles, JobBytes AS jobbytes, JobStatus AS jobstatus,  ((EndTime) - (StartTime)) AS duration, JobErrors AS joberrors  FROM Client, Job  LEFT JOIN FileSet  ON (Job.FileSetId = FileSet.FileSetId) WHERE Client.ClientId=Job.ClientId AND ( UNIX_TIMESTAMP(starttime) > ( UNIX_TIMESTAMP(NOW()) - ($jobs_since_seconds)  ) OR endtime is null ) ORDER BY JobStatus, JobErrors DESC ");

}
$sth_list_jobs->execute();

my @righe;
$swap_color=0;

while (my $ref = $sth_list_jobs->fetchrow_hashref()) {


        # display Mb/Gb/Kb
        $jobbytes_human = human_size( $ref->{'jobbytes'} );
        my $jobname = $ref->{'jobname'};

        # color list for various job status
        # if job is OK and there's no error AND ( it's not defined a minimum size for this job OR the size of this job is bigger than the minimum required size)
        if  ( ($ref->{'jobstatus'} =~ 'T') && ($ref->{'joberrors'} == 0) && (  !defined($minimum_size{"$jobname"}) || ($ref->{'jobbytes'} > $minimum_size{"$jobname"} )   )   ) {
                $status = '<font color="green">OK</font>';
                $status_ok++;
        # if job is OK and there's no error AND the size of this job is minor than the minimum required size
        } elsif ( ($ref->{'jobstatus'} =~ 'T') && ($ref->{'joberrors'} == 0) && (  $ref->{'jobbytes'} < $minimum_size{"$jobname"}    )   ) {
                $status = '<font color="purple">ATTENTION</font>';
                $status_attention++;
        # if job is OK but there's some errors
        } elsif ( ($ref->{'jobstatus'} =~ 'T') && ($ref->{'joberrors'} != 0) ) {
                $status = '<font color="purple">WARNING</font>';
                $status_warn++;
        } elsif ( ($ref->{'jobstatus'} =~ 'R') ) {
                $status = '<font color="blue">RUNNING</font>';
                $status_run++;
        } elsif ( ($ref->{'jobstatus'} =~ 'C') ) {
                $status = '<font color="blue">WAITING</font>';
                $status_wait++;
        } else  {
                $status = '<font color="red">ERROR</font>';
                $status_error++;
        }
        
        my %riga = (
                          SWAP_COLOR =>  $swap_color,
                          Bweb_Path =>  $bweb_path,
                          JobId =>  $ref->{'jobid'},
                          Client =>  $ref->{'client'},
                          JobName =>  $ref->{'jobname'},
                          FileSet =>  $ref->{'fileset'},
                          Level =>  $ref->{'level'},
                          StartTime =>  $ref->{'starttime'},
                          Duration =>  $ref->{'duration'},
                          JobFiles =>  $ref->{'jobfiles'},
                          JobBytes =>  $jobbytes_human,
                          Errors =>  $ref->{'joberrors'},
                          Status =>  $status
        );
        push (@righe, \%riga);

        # change colors from line to line
        if ( $swap_color == 0) {
                $swap_color=1;
        } else  {
                $swap_color=0;
        }
}

$template->param(JOBS => \@righe);


$email_body = $template->output;

# Compose the subject: if something (exept for OK) is at zero value, don't print it. Ideal for mail filtering and subject shortening for mobile read
$subject = "$email_subject - OK:$status_ok";
if ( $status_error > 0) { $subject .= " ERROR:$status_error"; }
if ( $status_warn > 0) { $subject .= " WARN:$status_warn"; }
if ( $status_attention > 0) { $subject .= " ATTN:$status_attention"; }
if ( $status_run > 0) { $subject .= " RUN:$status_run"; }
if ( $status_wait > 0) { $subject .= " WAIT:$status_wait"; }

my $msg = MIME::Lite->new
(
Subject => $subject,
From    => $email_from,
To      => $email_to,
Type    => 'text/html',
Data    => $email_body
);

$msg->send();

# display Mb/Gb/Kb
sub human_size
{
    my @unit = qw(B KB MB GB TB);
    my $val = shift || 0;
    my $i=0;
    my $format = '%i %s';
    while ($val / 1024 > 1) {
        $i++;
        $val /= 1024;
    }
    $format = ($i>0)?'%0.1f %s':'%i %s';
    return sprintf($format, $val, $unit[$i]);
}


$sth_list_jobs->finish();
$dbh->disconnect();
