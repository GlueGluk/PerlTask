use strict;
use warnings;

use DBI;
use Getopt::Long;

my $Database = "maillog";
my $User = "task";
my $Password = "task_password";
my $File = "out";

GetOptions(
    "database=s" => \$Database,
    "user=s"     => \$User,
    "password=s" => \$Password,
    "file=s"     => \$File,
);

my $DBH = DBI->connect("DBI:mysql:$Database", $User, $Password);
open my $FH, "<", $File or die "Can't open log file $File!";

while (my $Line = <$FH>)  {
    chomp($Line);
    my $IsIncoming = 0;
    if ($Line =~ /^(.*?) (.*?) (.*?) (.*)$/) {
        my ($Date, $Time, $MesId, $Rest) = ($1, $2, $3, $4);
        my ($Flag, $Addr, $Info) = ("", "", "");

        my $Str = "$MesId $Rest";
        $Str = $DBH->quote($Str);
        if ($Rest =~ /^(.*?) (.*?) (.*)$/) {
            ($Flag, $Addr, $Info) = ($1, $2, $3);
            if ($Flag eq "<=") { # прибытие сообщения
                $IsIncoming = 1;
                my $Id;
                if ($Info =~ /\bid=(.*?)(\s+|$)/) {
                    $Id = $1;
                } else {
                    print "No id in string $Line, skipping\n";
                    next;
                }

                my $SQL = qq[
                    INSERT INTO `message` (`created`, `id`, `int_id`, `str`)
                    VALUES ("$Date $Time", "$Id", "$MesId", "$Str")
                ];
                $DBH->do($SQL);
            }
        }
        unless ($IsIncoming) {
            my $SQL = qq[
                INSERT INTO `log` (`created`, `int_id`, `str`, `address`)
                VALUES ("$Date $Time", "$MesId", "$Str", "$Addr")
            ];
            $DBH->do($SQL);
        }
    } else {
        print "Line $Line doesn't fit the regex\n";
    }
}

