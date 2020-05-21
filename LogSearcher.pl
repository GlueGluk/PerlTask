#!/usr/bin/env perl
use strict;
use warnings;

use Dancer2;
use Template;
use DBI;
use Getopt::Long;

my $Database = "maillog";
my $User = "task";
my $Password = "task_password";

GetOptions(
    "database=s" => \$Database,
    "user=s"     => \$User,
    "password=s" => \$Password,
);
 
get '/' => sub {
    my $Msg;
    my $Warn = 0;
    my $Addr = params->{'address'} || "";

    if ($Addr) {
        my $DBH = DBI->connect("DBI:mysql:$Database", $User, $Password);
        my $Addr = $DBH->quote($Addr);
        $Addr =~ s/\'//g;
        my $SQL = qq[
            SELECT `created`, `int_id`, `str` FROM `message` WHERE `str` LIKE "% $Addr %"
            UNION ALL
            SELECT `created`, `int_id`, `str` FROM `log` WHERE `address` = "$Addr"
            ORDER BY `int_id`, `created` ASC
        ];
        my $STH = $DBH->prepare($SQL);
        $STH->execute or die "Не удалось выполнить: $STH->errstr";
        my $Count = 0;
        $Msg = "<table>";
        $Msg .= "<tr><th class=\"timestamp\">Timestamp</th><th class=\"log-str\">Строка лога</th></tr>";
        while ($Count < 100 && (my @Row = $STH->fetchrow_array)) {
            $Count++;
            $Msg .= "<tr><td>$Row[0]</td><td>$Row[2]</td></tr>";
        }
        $Msg .= "</table>";
        if ($Count == 100 && (my @Row = $STH->fetchrow_array)) {
            $Warn = 1;
        }
    }

    template 'page.tt', {
        address => $Addr,
        msg     => $Msg,
        warning => $Warn,
    };
};
 
start;
