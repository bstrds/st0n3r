#!/usr/bin/perl

#in this file lie the functions that implement st0n3r's pitiful brain activity

use String::Similarity;

#sub that accesses the answer database(brainz) and tries to answer
sub trytoanswer {
	
	#just open the DATABASE
	dbmopen(%brn, "testbrain", 0666); 

	#flag
	my $flog = 0;
	
	

	#various statements that check the text to see if it, or some 
	#substring of it, or something similar to it is defined in the database
	if (defined $brn{$text}) {
		if ( $channel =~ 'st0n3r') {
		print $con "PRIVMSG $nick :$brn{$text}\r\n";
		print "\n*\n*     we have an answer for that  \n*\n*";
		} else {
		print $con "PRIVMSG $channel :$brn{$text}\r\n";
		print "\n*\n*     we have an answer for that  \n*\n*";
		}
		$flog = 1;	      
	} else {
		my %lal;
		while ( ($key33, $value33) = each %brn ) {
  		$similarity = similarity $text, $key33;
			if ($similarity > 0.85){
			$lal{$key33} = $similarity;
			}
		$similarity = 0;	
		}
		$maxx = 0;
		$_ > $maxx and $maxx = $_ for values %lal;
		print "$maxx\n";
		while ( ($key44, $value44) = each %lal) {
			if ( $maxx == $value44) {
			if ( $channel =~ 'st0n3r') {
			print $con "PRIVMSG $nick :$brn{$key44}\r\n";
			print "\n*\n*     we have an answer for that \n*\n*";
			} else {
			print $con "PRIVMSG $channel :$brn{$key44}\r\n";
			print "\n*\n*     we have an answer for that \n*\n*";
			}
			$flog = 1;
			last;
			}
		}
	}	
	my $hit;
	if ($flog == 0) {
		my @stupidity = split(' ',$text);
		foreach (@stupidity) {
			$hit = substr $text, index($text, $_);
			if (defined $brn{$hit}) {
				if ( $channel =~ 'st0n3r') {
				print $con "PRIVMSG $nick :$brn{$hit}\r\n";
				print "\n*\n*     we have an answer for that \n*\n*";
				} else {
				print $con "PRIVMSG $channel :$brn{$hit}\r\n";
				print "\n*\n*     we have an answer for that \n*\n*";
				}
			$flog = 1;	
			last;
			}
			elsif (defined $brn{$_}) {
				if ( $channel =~ 'st0n3r') {
				print $con "PRIVMSG $nick :$brn{$_}\r\n";
				print "\n*\n*     we have an answer for that \n*\n*";
				} else {
				print $con "PRIVMSG $channel :$brn{$_}\r\n";
				print "\n*\n*     we have an answer for that \n*\n*";
				}
			$flog = 1;	
			last;
			}
		}
	}

	#closing the file
	dbmclose(%brn);

	#now for the fun part...(feel free to uncomment the addanswer sub...)
	if ($flog == 0) {
	#&addanswer;
	}
}

#this adds question:answer pairs into the db
sub addanswer {
	if ( $channel =~ 'st0n3r') {
	print $con "PRIVMSG $nick :I don't understand $text, your next message will be saved as my answer to it\r\n";
	} else {
	print $con "PRIVMSG $channel :I don't understand $text, your next message will be saved as my answer to it\r\n";
	}

	#i had to add another while, just to answer pings while they are deciding if they want to fucking help
	while ($answer = <$con>) {
		
		($command, $txt) = split(/ :/, $answer);
		($nick,$type,$channel) = split(/ /, $command);
		($nick,$hostname) = split(/!/, $nick);	
		$nick =~ s/://; 
		$txt =~ s/://;
		$/ = "\r\n";
		while($txt =~ m#$/$#){ chomp($txt); }

		#PING
		print $b_cyan;
		if($answer =~ m/^PING (.*?)$/gi) {
		print $b_blue;
		print $con "PONG ".$1."\r\n";
		print "\n*\n*\n*\n*	just answered another ping request, boss!\n*\n*\n*\n";
		}
		#END OF PING

		print $answer;
		
		if ($answer =~ 'PRIVMSG') {
			$similarity2 = similarity $text, $txt;
			
			if($similarity2 > 0.5) {
				dbmopen(%brn, "brainz", 0666); 
				$brn{$text} = $txt;
				dbmclose(%brn);
				if ( $channel =~ 'st0n3r') {
				print $con "PRIVMSG $nick :your answer has been taken into consideration, $nick\r\n";
				} else {
				print $con "PRIVMSG $channel :your answer has been taken into consideration, $nick\r\n";
				}
			} else {
				if ( $channel =~ 'st0n3r') {
				print $con "PRIVMSG $nick :your asnwer is not similar enough to the question, $nick\r\n";
				} else {
				print $con "PRIVMSG $channel : your asnwer is not similar enough to the question, $nick\r\n";
				}
			}
		$similarity2 = 0;
		return;
		}			
	
			
	}
	

}

1;
