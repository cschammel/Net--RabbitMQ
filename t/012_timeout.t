use Test::More tests => 6;
use strict;
use Time::HiRes qw/gettimeofday tv_interval/;

my $host = '199.15.224.0'; # This OmniTI IP will hang
$SIG{'PIPE'} = 'IGNORE';
use_ok('Net::RabbitMQ');

my $mq = Net::RabbitMQ->new();
ok($mq);

my $start = [gettimeofday];
my $attempt = 0.6;
eval { $mq->connect($host, { user => "guest", password => "guest", timeout => $attempt }); };
my $duration = tv_interval($start);
isnt($@, '', "connect");
# 50ms tolerance should work with most operating systems
cmp_ok(abs($duration-$attempt), '<', 0.05, 'timeout');
my $start2 = [gettimeofday];
my $attempt2 = 0.2;
eval { $mq->connect($host, { user => "guest", password => "guest", timeout => $attempt2 }); };
my $duration2 = tv_interval($start2);
isnt($@, '', "connect");
print abs($duration2-$attempt2)."\n";
cmp_ok(abs($duration2-$attempt2), '<', 0.05, 'timeout_change');
