use inc::Module::Install;

name('String-Object');
author('Richard Hundt <richard NO SPAM AT protea-systems.com>');
abstract('String Object');
license('artistic');
version_from('lib/String/Object.pm');

build_requires('Lingua::EN::Inflect');
requires('Lingua::EN::Inflect');

check_nmake();
&WriteAll();
