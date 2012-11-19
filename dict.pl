#!/usr/bin/perl

#
#This is by the guy who made potbot, so credit goes where credit is deserved
#

use IO::Socket;              


## sub to handle dict querys

sub dquer {
$nick = lc($_[0]);
$chan = $_[1];
$msg = lc($_[2]);
$nick =~ s/\r//;
$nick =~ s/\n//;
#$nick =~ s/\?//;
$msg =~ s/\r//;
$msg =~ s/\n//;
$msg =~ s/\?//;
$chan =~ s/\r//;
$chan =~ s/\n//;
@niqor = split('dict',$msg,2);
$snoq=$niqor[1];
$snoq = substr($snoq,1,length($snoq)-1);
$defin = '';
print $green."\n*\n*\n*\n*	fetching your definition for <$snoq> like a good little bitch!\n*\n*\n*\n";

return $defin = &Dict($snoq);

}


############## use this:

sub Dict {

  my $server    = "dict.org";
  my $port      = 2628;
  my $proto     = getprotobyname('tcp');
  $query = '';
  $query = $_[0];
  $result = '';
  my $socket    = gensym;
  my $wordtype  = "";
  my @results;

  socket($socket, PF_INET, SOCK_STREAM, $proto) or return "error: socket:
$!";
  eval {
    alarm 15;
    connect($socket, sockaddr_in($port, inet_aton($server))) or return
"error: connect: $!";
    alarm 0;
  };


  if ($@ && $@ ne "alarm\n") {
    return "i could not get info from dict.org";
  }

  $socket->autoflush(1);        # required.

  print $socket "DEFINE wn \"$query\"\n";
  print $socket "QUIT\n";

  while (<$socket>) {
    chop;       # remove \n
    chop;       # remove \r

    if ($_ eq ".") {
        # end of def.
        push(@results, $def);
    } elsif (/^(150|151|220|221|250) /) {
        # hrm...
    } elsif (/^552 no match/) {
        # no match.
    } elsif (/^\s+(\S+ )?(\d+)?: (.*)/) {
        # start of sub def.
        push(@results, $def)            if ($def ne "");

        $wordtype = substr($1,0,-1)     if ($1 ne "");
        $def = "\002$query\002 \037$wordtype\037: $3";
    } elsif (/^\s+(.*)/) {
        s/^\s{2,}/ /;
        $def    .= $_;
    }
  }
  close $socket;

  if (!scalar @results) {
    return "could not find definition for \002$query\002";
    $result='';
  }

  srand();
  my $result = $results[int(rand(scalar @results))];

  $result =~ s/\s+$//;          # trailing spaces... need to fix.

  return $result;
}

1;
