# vim: ft=perl:

use lib './lib';
use Test::More qw(no_plan);

use String::Object;

my $str1 = String::Object->new('foo');
ok($str1->value eq 'foo');
ok($str1 eq 'foo');

my $str2 = String::Object->new('Foo::Bar');
ok($str2->humanize eq 'Foo bar');
my $tmp = $str2->humanize;
$tmp .= ' baz';
ok($tmp eq 'Foo bar baz');

my $str3 = String::Object->new('Mouse');
ok($str3->length == 5);
ok($str3->pluralize eq 'Mice');
ok($str3->pluralize->length == 4);

ok($str3->pluralize->eq('Mice'));
$str3->concat( ' lives', ' in a', ' house' );
ok( $str3 eq 'Mouse lives in a house' );

my $str4 = String::Object->new('Baz');
my $str5 = String::Object->new('Quux');
my $str6 = $str4 . $str5;
ok($str4 eq 'Baz');
ok($str5 eq 'Quux');
ok($str6 eq 'BazQuux');
