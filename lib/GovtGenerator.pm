#!/usr/bin/perl -wT
###############################################################################

package GovtGenerator;

use strict;
use warnings;
use vars qw(@ISA @EXPORT_OK $VERSION $XS_VERSION $TESTING_PERL_ONLY);
use base qw(Exporter);
#FIXME TODO add a stat for Government Size
###############################################################################

=head1 NAME

    GovtGenerator - used to generate Governments

=head1 SYNOPSIS

    use GovtGenerator;
    my $govt=GovtGenerator::create();

=cut

###############################################################################


use Carp;
use CGI;
use Data::Dumper;
use Exporter;
use GenericGenerator qw(rand_from_array roll_from_array d parse_object);
use NPCGenerator;
use POSIX;
use version;
use XML::Simple;

my $xml = XML::Simple->new();
local $ENV{XML_SIMPLE_PREFERRED_PARSER} = 'XML::Parser';

###############################################################################

=head1 CONFIGURATION AND ENVIRONMENT

=head2 Data files

The following datafiles are used by GovtGenerator.pm:

=over

=item F<xml/data.xml>

=item F<xml/govts.xml>

=back

=head1 INTERFACE 


=cut

###############################################################################
# FIXME This needs to stop using our
my $xml_data  = $xml->XMLin( "xml/data.xml",  ForceContent => 1, ForceArray => ['option'] );
my $govt_data = $xml->XMLin( "xml/govts.xml", ForceContent => 1, ForceArray => ['option'] );

###############################################################################

=head2 Core Methods

The following methods are used to create the core of the govt structure.


=head3 create()

This method is used to create a simple govt with nothing more than:

=over

=item * a seed

=item * a name

=back

=cut

###############################################################################
sub create {
    my ($params) = @_;
    my $govt = {};

    if ( ref $params eq 'HASH' ) {
        foreach my $key ( sort keys %$params ) {
            $govt->{$key} = $params->{$key};
        }
    }

    if ( !defined $govt->{'seed'} ) {
        $govt->{'seed'} = GenericGenerator::set_seed();
    }
    GenericGenerator::set_seed( $govt->{'seed'} );

    GenericGenerator::generate_stats($govt, $govt_data);
    GenericGenerator::select_features($govt, $govt_data);

    set_govt_type($govt);
    generate_leader($govt);

    #    set_secondary_power($govt);
    #    set_reputation($govt);
    return $govt;
} ## end sub create


###############################################################################


=head3 generate_leader()

This method is used to generate a leader for the government

=cut

###############################################################################
sub generate_leader {
    my ($govt) = @_;

    $govt->{'leader'} = NPCGenerator::create( { 'seed' => $govt->{'seed'} } ) if (!defined $govt->{'leader'});


    $govt->{'leader'}->{'title'} = $govt->{'title'}->{'male'};
    #FIXME this should handle female titles as well
    

    return $govt;
} ## end sub create

###############################################################################


=head3 set_govt_type()

This method is used to create a simple govt with nothing more than:

=cut

###############################################################################
sub set_govt_type {
    my ($govt) = @_;

    my $govtype = rand_from_array( $govt_data->{'govtypes'}->{'option'} );

    $govt->{'description'} = $govtype->{'description'}                           if ( !defined $govt->{'description'} );
    $govt->{'type'}        = $govtype->{'type'}                                  if ( !defined $govt->{'type'} );
    $govt->{'title'}       = rand_from_array( $govtype->{'titles'}->{'option'} ) if ( !defined $govt->{'title'} );


    return $govt;
} ## end sub create


1;

__END__


=head1 AUTHOR

Jesse Morgan (morgajel)  C<< <morgajel@gmail.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2013, Jesse Morgan (morgajel) C<< <morgajel@gmail.com> >>. All rights reserved.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation version 2
of the License.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

=head1 DISCLAIMER OF WARRANTY

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

=cut
