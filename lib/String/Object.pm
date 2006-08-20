package String::Object;

use Lingua::EN::Inflect qw(PL);

our $VERSION = '0.01';

use overload
    '""'  => \&value,
    'lt'  => \&value,
    'le'  => \&value,
    'gt'  => \&value,
    'ge'  => \&value,
    'cmp' => \&value,
    'ne'  => \&value,
    'eq'  => \&value,
    '='   => \&assign,
    '.'   => \&concat,
    '.='  => \&cassign,
    fallback => 1;


sub new {
    my $class = shift;
    return bless { _value => \shift || \'' }, $class;
}

sub value { ${ $_[0]->{_value} } }

sub eq { return shift->value eq shift }
sub ne { return shift->value ne shift }
sub lt { return shift->value lt shift }
sub le { return shift->value le shift }
sub gt { return shift->value gt shift }
sub ge { return shift->value ge shift }

sub cmp { return shift->value cmp shift }

sub pluralize { __PACKAGE__->new( PL( shift->value ) ) }

sub humanize {
    __PACKAGE__->new(
        ucfirst( join(' ', split(/_|[:]{2}/, lc( shift->value ) ) ) )
    );
}

sub computerize {
    __PACKAGE__->new(
        join('_', split(/ /, lc( shift->value ) ) )
    );
}

sub camelize {
    __PACKAGE__->new(
        join('', map { ucfirst } split(/ /, lc( shift->value ) ) )
    );
}

sub as_namespace {
    __PACKAGE__->new(
        join('::', map { ucfirst } split(/ |_/, lc( shift->value ) ) )
    );
}

sub length  { CORE::length( shift->value )  }
sub chomp   { CORE::chomp( ${ $_[0]->{_value} } ); $_[0]->value }
sub copy    { __PACKAGE__->new( shift->value ) }
sub concat  { __PACKAGE__->new( "${ $_[0]->{_value} }".$_[1] ) }
sub assign  { warn "@@@@@@@@ HERE"; ${ shift->{_value} }  = shift }
sub cassign { ${ shift->{_value} } .= shift }

1;

__END__

=head1 NAME

String::Object - A String Object

=head1 SYNOPSIS

 my $str0 = String::Object->new('Cheese');
 $str0->{foo} = 'bar';              # Decorate!
 $str0 eq 'Cheese';                 # string operators overloaded

 my $str1 = String::Object->new('Mouse');
 $str1->pluralize;                  # 'Mice'
 $str1->pluralize eq 'Mice';        # TRUE
 
 my $str2 = String::Object->new('my_string');
 $str2->humanize;                   # 'My string'
 $str2->length;                     # 8
 
 my $str3 = String::Object->new('My string');
 $str3->computerize;                # 'my_string'
 $str3->as_namespace;               # 'My::String'
 
 # can be chained:
 $str->humanize->length;
  
 # comparison operators as methods
 $str->eq('equal');
 $str->ne('not equal');
 $str->gt('greater');
 $str->ge('greater or equal');
 $str->lt('less');
 $str->le('less or equal');
 $str->cmp('compares');
 
 # additional methods
 $str->chomp;                       # in place!
 $str->copy;                        # new String::Object
 $str->concat ( $other );           # new String::Object same as `.'
 $str->cassign( $other );           # new String::Object same as `.='
 $str->assign ( $other );           # same as `=' ( but see Assignment GOTCHA ) 

=head1 DESCRIPTION

This module implements very simple Strings-as-Objects, as seen in languages
such as Ruby or JavaScript. The main reason for creating is was the need
for strings which behaved as objects which could be decorated. As such
instances are simply blessed Hash references which use L<overload> heavily
and implement an OO interface.

Added to this are a few methods for manipulating the string value for
inflection (assuming the string is English), and a few simple transformations
for camelizing, concatenating with underscore `_' and creating Perl namespaces.

=head1 METHODS

See L<SYNOPSIS>.

=head2 Assignment GOTCHA

Assignment overloading may not do what you expect. In particular, you cannot
assign a literal string to a String::Object instance. The following B<DOES NOT WORK>:

 my $str = String::Object->new('Foo');
 $str = 'Bar';      # $str is now the literal 'Bar' and not a String::Object instance

However, either of these will work:

 my $str = String::Object->new('Foo');
 $str->assign( 'Bar' );
 
 # OR the more verbose:
 my $str = String::Object->new('Foo');
 $str = String::Object->new('Bar');

However, the `.=' operator does what you'd expect.

=head1 AUTHOR

Richard Hundt

=head1 LICENSE

This library is free software and may be used under the same terms as Perl
itself.

=cut
