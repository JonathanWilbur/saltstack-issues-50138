#!/bin/sh

# This entry defines the variable BEFORE the crontab entry
# This *should* output 'foo' to /tmp/result1.txt.
echo 'TEST1=foo' >> /etc/crontab
echo '* * * * * root echo $TEST1 > /tmp/result1.txt' >> /etc/crontab

# This entry defines the variable AFTER the crontab entry
# This *should not* output 'bar' to /tmp/result2.txt, which would legitimize
# my bug report: https://github.com/saltstack/salt/issues/50138
echo '* * * * * root echo $TEST2 > /tmp/result2.txt' >> /etc/crontab
echo 'TEST2=bar' >> /etc/crontab