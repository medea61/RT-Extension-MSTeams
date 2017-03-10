use inc::Module::Install;

RTx     'RT-Extension-MSTeams';
license 'MIT';
repository 'https://github.com/andrewwippler/RT-Extension-MSTeams';

requires_rt '4.0.0';
rt_too_new '4.4.2';

sign;
WriteAll;
