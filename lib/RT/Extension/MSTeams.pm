use strict;
use warnings;
use HTTP::Request::Common qw(POST);
use LWP::UserAgent; 
use JSON; 
package RT::Extension::MSTeams;

our $VERSION = '1.1';

=head1 NAME

RT-Extension-MSTeams - Integration with Microsoft Teams webhooks

=head1 DESCRIPTION

This module is designed for *Request Tracker 4* integrating with *Microsoft Teams* webhooks. Shamelessly ripped off from RT-Extension-Slack by Andrew Wippler.

=head1 RT VERSION

Works with RT 4.2.0

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

If you are using RT 4.2 or greater, add this line:

    Plugin('RT::Extension::MSTeams');

For RT 4.0, add this line:

    Set(@Plugins, qw(RT::Extension::MSTeams));

or add C<RT::Extension::MSTeams> to your existing C<@Plugins> line.

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 AUTHOR

Roman Hochuli E<lt>roman@hochu.liE<gt>

=head1 BUGS

All bugs should be reported via email to

    L<bug-RT-Extension-MSTeams@rt.cpan.org|mailto:bug-RT-Extension-MSTeams@rt.cpan.org>

or via the web at

    L<rt.cpan.org|http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-MSTeams>.

=head1 LICENSE AND COPYRIGHT

The MIT License (MIT)

Copyright (c) 2015 Roman Hochuli

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.



=cut
sub Notify {
	my %args = @_;
	my $payload = {
		title => 'New Ticket',
		text => 'I have forgotten to say something!',
		themeColor => 'EA4300',
		potentialAction => [{
			'@context' => 'http://schema.org',
			'@type' => "ViewAction",
			name => "View in RT",
			target => ["I missed the URL! :-O"]
		}]
	};
	my $service_webhook;
	
	$RT::Logger->debug('Entering RT::Extension::MSTeams::Notify');
	$RT::Logger->debug('Text: '. $args{'text'});
	$RT::Logger->debug('URL: '. $args{'url'});
	
	$payload->{'text'} = $args{'text'};
	$payload->{'potentialAction'}->[0]->{'target'}->[0] = $args{'url'};
	
	if (!$payload->{text}) {
		return;
	}
	my $payload_json = JSON::encode_json($payload);

	$service_webhook = RT->Config->Get('MSTeamsWebhookURL');
	if (!$service_webhook) {
		return;
	}

	my $ua = LWP::UserAgent->new();
	# errors at the API take its time. do not go under 30s!
	$ua->timeout(30);

	$RT::Logger->info('Pushing notification to Microsoft Teams.');
	$RT::Logger->debug('Webhook URL: '. $service_webhook);
	$RT::Logger->debug('Push content: '. $payload_json);

	my $response = $ua->post($service_webhook, Content_Type => 'application/json', Content => $payload_json);
	if ($response->is_success) {
		return;
	} else {
		$RT::Logger->error('Failed to push notification to Microsoft Teams ('.
		$response->status_line . ' - ' . $response->decoded_content. ')');
	}
	
	$RT::Logger->debug('Leaving RT::Extension::MSTeams::Notify');
}

1;
