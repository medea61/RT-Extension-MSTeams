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
    my $Subject = $Transaction->Subject || 'no subject given';
    my $Requestor = $Ticket->RequestorAddresses || 'unknown';

    RT::Extension::MSTeams::Notify(id => $TicketId, requestor => $Requestor, subject => $Subject);

    return 1;
}

sub Commit {

    return 1;
}

1;