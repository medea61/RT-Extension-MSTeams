# RT-Extension-MSTeams
Integration with Microsoft Teams webhooks

# DESCRIPTION
This module is designed for *Request Tracker 4* integrating with *Microsoft Teams* webhooks. Shamelessly ripped of from RT-Extension-Slack
 by Andrew Wippler.

# RT VERSION
Works with RT 4.4.2

# INSTALLATION
    perl Makefile.PL
    make
    make install
    make initdb

May need root permissions

Edit your /opt/rt4/etc/RT_SiteConfig.pm
If you are using RT 4.2 or greater, add this line:

	Plugin('RT::Extension::MSTeams');

For RT 4.0, add this line:

	Set(@Plugins, qw(RT::Extension::MSTeams));

Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj


Restart your webserver

# CONFIGURATION
Edit your /opt/rt4/etc/RT_SiteConfig.pm to include the webhook-url. Make sure to single-quote the string!

    Set($MSTeamsWebhookURL, 'MSTeams-webhook-url');

# USE
This extension at installation creates automatically a global script
which you may choose to enable. Otherwise you may also choose to 
create your own scrip with these settings:

* Condition 'On Create'
* Action 'Post to MS Teams'
* Template 'Blank'

# AUTHORS
Roman Hochuli

## Inspired by
- Andrew Wippler
- [Maciek] (http://www.gossamer-threads.com/lists/rt/users/128413#128413)

# LICENSE AND COPYRIGHT
The MIT License (MIT)

Copyright (c) 2017 Roman Hochuli

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

