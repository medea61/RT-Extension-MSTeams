package RT::Action::PostToMSTeams;

use strict;
use warnings;

use base 'RT::Action';

sub Describe {
    my $self = shift;
    return ( ref $self );
}

sub Prepare {
    my $self = shift;
    my $Ticket = $self->TicketObj;
    my $TicketId = $Ticket->Id;
    my $Transaction = $self->TransactionObj;
    my $Subject = $Transaction->Subject;
    my $Requestor = $Ticket->RequestorAddresses || 'unknown';

    my $text = "";

	my $queue = $Ticket->QueueObj;
	my $url = join '',
    	RT->Config->Get('WebPort') == 443 ? 'https' : 'http',
    	'://',
    	RT->Config->Get('WebDomain'),
	    RT->Config->Get('WebPath'),
    	'/Ticket/Display.html?id=',
    	$TicketId;

    $text = sprintf('[&#35;%d](%s) by %s: %s', $TicketId, $url, $Requestor, $Subject);

	RT::Extension::MSTeams::Notify(text => $text, id => $TicketId, url => $url);

    return 1;
}

sub Commit {

    return 1;
}

1;