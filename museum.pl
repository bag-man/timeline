#!/usr/bin/perl
use warnings;
use strict;

#Testing git

#Load modules
use DBI;
use Email::MIME;
use POSIX qw/strftime/;
use Email::Sender::Simple qw(sendmail);
  
#Assign Vars
my @time = localtime; 
my $month = strftime "%m", @time;
$month++; #To look forward a month

#MySQL database settings
my $database = "dbi:mysql:timeline:squixy.co.uk";
my $tablename = "dates";
my $user = "*****";
my $pw = "******";

#Create anniversary array
my @anniversaries = (0 .. 12);
$anniversaries[0] = strftime "%Y,", @time; 
for my $i (1..$#anniversaries) { 
  $time[5]-=5; 
  $anniversaries[$i] = strftime "%Y,", @time;
}
$anniversaries[12] =~ s/,//;

#Connect to database
my $dbh = DBI->connect($database,$user,$pw) or 
die "Connection Error: $DBI::errstr\n";

#Query database
my $sql = "SELECT * FROM dates WHERE Date LIKE '%-$month-%' AND Year IN (@anniversaries);";
my $sth = $dbh->prepare($sql);
$sth->execute or die "SQL Error: $DBI::errstr\n";

#Remove comma from current year.
$anniversaries[0] =~ s/,//; 

#Craft message
my $message = "Next months anniversaries:\n\nEvent | Date | Anniversary\n==========================\n";

#Gather the results
while(my @data = $sth->fetchrow_array()){
  $message = $message . "$data[1] | $data[4] | " . 
  ($anniversaries[0] - $data[5]) . "th anniversary\n";
}

#Create email
my $email = Email::MIME->create( 
 header_str => [
    From    => 'test@squixy.com',
    To      => '******@tnmoc.org',
    Subject => 'Next months anniversaries',
  ],
  attributes => {
    encoding => 'quoted-printable',
    charset  => 'ISO-8859-1',
  },
  body_str => "$message\n",
);

#Send the email
sendmail($email);
