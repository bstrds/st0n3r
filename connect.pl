#!/usr/bin/perl

#the basic connection stuff..

use IO::Socket;

sub connect {
	#connection to the server
	$con = IO::Socket::INET->new(PeerAddr=>'irc.freenode.net',
			     PeerPort=>'6667',
			     Proto=>'tcp',
			     Timeout=>'30') || print "Error! $!\n";

	#identification and first channel join
	
	print $con "USER r2d2 make bots not war \r\n";
	sleep(10);
	print $con "NICK st0n3r \r\n";
	#$chan = '#foss-aueb';


	#loop to answer replies from the server or send new ones.(never ends unless !fuckoff is issued)
	while($answer = <$con>) {
	
		#SERVER ANSWER PARSING

		#splitting the input into commands and text
		($command, $text) = split(/ :/, $answer);
		#splitting the commands by spaces
		($nick,$type,$channel) = split(/ /, $command);
		#splitting by '!' to get nick and hostname
		($nick,$hostname) = split(/!/, $nick);
		#remove :’s		
		$nick =~ s/://; 
		$text =~ s/://;
		#get rid of all line breaks.  Again, many different way of doing this.
	        $/ = "\r\n";
		while($text =~ m#$/$#){ chomp($text); }
		#END OF PARSING
		
		#PING AND AUTHENTICATION SECTION (change server answers to fit your case)
		print $b_cyan;
		if($answer =~ m/^PING (.*?)$/gi) {
		print $b_blue;
		print $con "PONG ".$1."\r\n";
		print "\n*\n*\n*\n*	just answered another ping request, boss!\n*\n*\n*\n";
		}
		if ($answer =~ 'IDENTIFY') {  
		print $b_magenta;
		print $con "PRIVMSG nickserv :identify folamolasola \r\n";
		print "\n*\n*\n*\n*	identifying nick, master!\n*\n*\n*\n";
		$flag = 1;
		}
		if ($flag==1) {
		print $b_magenta;
		print $con "MODE st0n3r :+iB \r\n";
		print "\n*\n*\n*\n*	setting mode, master!\n*\n*\n*\n";
		$flag = 2;
		}
		if ($answer =~ '900') { 
		print $b_red;
		print $con "JOIN $chan \r\n"; 
		print "\n*\n*\n*\n*	joining channel $chan, sir!\n*\n*\n*\n";
		}
		#somehow below not working..
		if ($answer =~ 'already in use') { 
		print $b_white;
		print $con "PRIVMSG nickserv :ghost st0n3r folamolasola \r\n"; 
		print "\n*\n*\n*\n* ghost in the shell!\n*\n*\n*\n";
		}
		#END OF PING AND AUTHENTICATION

		#This makes st0n3r greet the chan it joins, pretty useless so i commented it out.. 
		#
		#if ($answer =~ '366') {
		#splitting the special channel join line so that we can msg the channel we joined
		#($temp1, $temp2, $temp3, $temp4) = split(/ /, $command);
		#print $con "PRIVMSG $temp4 :hello!\r\n";
		#$flag = 1;
		#}
		
		#prints the server answer line to our terminal
		print $answer;

		#puts all the words from the text section of the server's answer to an array 
		@texts = split(/ /, $text);

		#calls the evenst subroutine
		&events;

		#calls the sub that updates the seen database
		&updateseendb;

	}

}

#a termination function, called bu the '!fuckoff' command
sub quitt {
print $con "QUIT :Leaving.!\r\n";
print "exit ...\n";
}
					
1;
