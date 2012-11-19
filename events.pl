#!/usr/bin/perl

use IO::Socket; 

#events function, this is called every time the main loop loops.
sub events {

	#change the bot controller nick to suit your case
	if($nick =~ 'bstrds') {

		#reply to 'hi' from his admin
		if($text =~ 'hi st0n3r') {
			if ( $channel =~ 'st0n3r') {
			print $con "PRIVMSG $nick :hi Master!\r\n";
			} else { 	
			print $con "PRIVMSG $channel :hi Master!\r\n";
			}
		}
		
		#shuts down
		if($text =~ "\!fuckoff") {

			if ( $channel =~ 'st0n3r') {
			print $con "PRIVMSG $nick :yes MASTER..\r\n";
			} else { 	
			print $con "PRIVMSG $channel :okay..\r\n";
			}
		&quitt;
		}

		#prints a dictionary definition of the argument
		if ($text =~ "\!dict") {
		$dix = &dquer($nick, $channel, $text);
		if ( $channel =~ 'st0n3r') {
			print $con "PRIVMSG $nick :$dix\r\n";
			} else { 	
			print $con "PRIVMSG $channel :$dix\r\n";
			}
		}

		#joins specified channel
		if ($text =~ "\!join") {
		($order, $chann) = split(/ /, $text);
		print $con "JOIN $chann \r\n";
		print $con "PRIVMSG $nick :joining channel $chann, master $nick!\r\n";
		}

		#parts specified channel
		if ($text =~ "\!part") {
		($order, $chann) = split(/ /, $text);
		print $con "PART $chann :aw noooo!\r\n";
		print $con "PRIVMSG $nick :parting channel $chann, master $nick!\r\n";
		}

		#performs a seen operation on specified nick
		if ($text =~ "\!seen") {
		&doseen;
		}

		#returns a random fortune
		if ($text =~ "\!fortune") {
		my $lol = `/usr/games/fortune`;
		$lol =~ s/\s*\n\s*/ /g;
		if ( $channel =~ 'st0n3r') {
			print $con "PRIVMSG $nick :$lol\r\n";
			} else { 	
			print $con "PRIVMSG $channel :$lol\r\n";
			}		
		}	
		
		
	} else { 

		#public 'hi' operation
		if($text =~ 'hi st0n3r') {
			if ( $channel =~ 'st0n3r') {
			print $con "PRIVMSG $nick :hi $nick!\r\n";
			} else { 	
			print $con "PRIVMSG $channel :hi $nick\r\n";
			}
		}

		#returns a random fortune
		if ($text =~ "\!fortune") {
		my $lol = `/usr/games/fortune`;
		$lol =~ s/\s*\n\s*/ /g;
		if ( $channel =~ 'st0n3r') {
			print $con "PRIVMSG $nick :$lol\r\n";
			} else { 	
			print $con "PRIVMSG $channel :$lol\r\n";
			}		
		}
		
		#performs a seen operation on specified nick
		if ($text =~ "\!seen") {
		&doseen;
		}
		
		#prints a dictionary definition of the argument
		if ($text =~ "\!dict") {
		$dix = &dquer($nick, $channel, $text);
		if ( $channel =~ 'st0n3r') {
			print $con "PRIVMSG $nick :$dix\r\n";
			} else { 	
			print $con "PRIVMSG $channel :$dix\r\n";
			}
		}	

		#check if someone is trying to execute an admin command :P
		@wordlist2 = qw(!fortune !seen !join !part !dict !fuckoff); 
		foreach (@texts) {
			if($_ ~~ @wordlist2) {
			print "\n*\n*\n*         sumeone's tryin to execute commands on my ass boss\n*\n*\n*";
			}
		}
	}

		#command list to ignore(if the message doesnt have any of these words, the trytoanswer sub is called)
	        my @commandlist = qw(!part !random !join !seen !dict !fuckoff hi !help st0n3r !fortune nigger bastard chicken sissy fag); 
		if ($answer =~ 'PRIVMSG') {			
			if($texts[0] ~~ @commandlist) {
			print "a command is being executed\r\n";
			} else {
			&trytoanswer;
			}	
		}

	
		#prints help text
	if ($text =~ "\!help") {
		$helpzor = "commands \n
\!fortune (prints a random fortune-cookie like piece of advice)
\!seen    (prints the channel the specified nick was last seen in, plus his last quote)
\!join    (st0n3r joins the specified channel)
\!part    (st0n3r leaves the specified channel)
\!dict    (prints the dictionary definition of the specified word, if there is one)
\!fuckoff (st0n3r disconnects from the server)
\!help    (displays this text)";
		$helpzor =~ s/\s*\n\s*/-->/g;
			if ( $channel =~ 'st0n3r') {
				print $con "PRIVMSG $nick :$helpzor\r\n";
			} else { 	
				print $con "PRIVMSG $channel :$helpzor\r\n";
			}	
	}

	return;
	#more cool stuff to come here..
}



1;
