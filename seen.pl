#!/usr/bin/perl
#
#This is written by the guy who made potbot
#


# openseendb sub.. called by init like &openseendb();

sub openseendb {
	dbmopen(%seendb,"seendb",0644) || die "Couldn't open seen db!\n";	
}


# updateseendb sub.. 


sub updateseendb {

($csecond,$cminute,$chour,$cday,$cmonth) = localtime(time);
$ctime[0] = $cmonth;
$ctime[1] = $cday;  
$ctime[2] = $chour; 
$ctime[3] = $cminute;
$ctime[4] = $csecond;
$date = join(';', @ctime);
$date =~ s/\n//;
$date =~ s/\r//;
$arrey[0] = $date;
$arrey[1] = $channel;
$arrey[2] = $text;
$arrey[3] = $hostname;
$arrey[4] = $hostname;
$fff = join('.:.', @arrey);
$seendb{"$nick"} = "$fff"; 
}


# doseen sub.. 

sub doseen {
$snick = lc($_[0]);
$schan = lc($_[1]);
$smsg = lc($_[2]);
$text =~ s/ //g;
@niqar = split('seen',$text,2);
$sniq=$niqar[1];
print "\n*\n*\n*\n*	carrying out the seen req on <$sniq> dutifully, boss!\n*\n*\n*\n \n";
print "$seendb{$sniq}\n";
@sprotn = split('.:.', $seendb{$sniq});
$odate=$sprotn[0];
$ochan=$sprotn[1];
$omsg=$sprotn[2]; 
$ohost=$sprotn[3];
$oident=$sprotn[4];
($omonth,$oday,$ohour,$ominute,$osecond) = split(';', $odate);
($nsecond,$nminute,$nhour,$nday,$nmonth) = localtime(time);   
$fsecond = $nsecond - $osecond;
$fminute = $nminute - $ominute;
$fhour = $nhour - $ohour;
$fday = $nday - $oday;   
$fmonth = $nmonth - $omonth;

if ($fsecond < 0) {
        $fsecond = ($fsecond + 60);
        $fminute--;
}
 
if ($fminute < 0) {
        $fminute = ($fminute +60);
        $fhour--;
}
 
if ($fhour < 0) {
        $fhour = ($fhour + 24);
        $fday--;
}
 
if ($fday < 0) {
        $fday = ($fday + 30);
        $fmonth--;
}
 
if ($fmonth < 0) {
        $fmonth = ($fmonth +12);
}

        if ($omsg eq '') {
                $utmsg = "$snick, I have not seen \002$sniq\002, sorry";
		if ( $channel =~ 'st0n3r') {
			print $con "PRIVMSG $nick :$utmsg\n";
			} else { 	
			print $con "PRIVMSG $channel :$utmsg\n";
			}
        } else {
		
		if ($fminute eq '0') {
                        $utmsg = "\002$sniq\002 was last seen on $ochan less than a minute ago.";
                        if ( $channel =~ 'st0n3r') {
			print $con "PRIVMSG $nick :$utmsg\n";
			} else { 	
			print $con "PRIVMSG $channel :$utmsg\n";
			}
			return;
                }
                if ($fhour eq '0') {
                        $utmsg = "\002$sniq\002 was last seen on $ochan \002".$fminute."\002m \002".$fsecond."\002s ago saying\002:\002 '$omsg'\n\r";
                        if ( $channel =~ 'st0n3r') {
			print $con "PRIVMSG $nick :$utmsg\n";
			} else { 	
			print $con "PRIVMSG $channel :$utmsg\n";
			}
			return;
                }
                if ($fday eq '0') {
                        $utmsg = "\002$sniq\002 was last seen on $ochan \002".$fhour."\002h \002".$fminute."\002m \002".$fsecond."\002s ago saying\002:\002 '$omsg'\n\r";
                        if ( $channel =~ 'st0n3r') {
			print $con "PRIVMSG $nick :$utmsg\n";
			} else { 	
			print $con "PRIVMSG $channel :$utmsg\n";
			}
			return;
                }
                if ($fmonth eq '0') {
                        $utmsg = "\002$sniq\002 was last seen on $ochan \002".$fday."\002d \002".$fhour."\002h \002".$fminute."\002m \002".$fsecond."\002s ago saying\002:\002 '$omsg'\n\r";
                        if ( $channel =~ 'st0n3r') {
			print $con "PRIVMSG $nick :$utmsg\n";
			} else { 	
			print $con "PRIVMSG $channel :$utmsg\n";
			}
			return;
                }


	}


}




1;
