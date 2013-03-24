#!/usr/bin/perl -wT
###############################################################################
#
package TestTavernGenerator;

use strict;
use warnings;
use Test::More;
use TavernGenerator;
use GenericGenerator qw( set_seed );

use Data::Dumper;
use XML::Simple;
use vars qw(@ISA @EXPORT_OK $VERSION $XS_VERSION $TESTING_PERL_ONLY);
require Exporter;

@ISA       = qw(Exporter);
@EXPORT_OK = qw( );


subtest 'test create_tavern' => sub {
    my $tavern;
    set_seed(1);
    $tavern=TavernGenerator::create_tavern();
    is($tavern->{'seed'},41630);
    is($tavern->{'name'},'Hungry Bag Roadhouse');

    $tavern=TavernGenerator::create_tavern({'seed'=>12345});
    is($tavern->{'seed'},12345);
    is($tavern->{'name'},'Black Urchin Alehouse');

    $tavern=TavernGenerator::create_tavern({'seed'=>12345, 'name'=>'test'  });
    is($tavern->{'seed'},12345);
    is($tavern->{'name'},'test');

    done_testing();
};

subtest 'test generate_size' => sub {
    my $tavern;
    set_seed(1);
    $tavern=TavernGenerator::create_tavern();
    TavernGenerator::generate_size($tavern);
    is($tavern->{'seed'},41630);
    is($tavern->{'name'},'Hungry Bag Roadhouse');
    is($tavern->{'size'},'average');
    is($tavern->{'cost_mod'}->{'size'}, '0');
    is($tavern->{'size_cost_mod'},'0');
    is($tavern->{'pop_mod'}->{'size'}, '2');
    is($tavern->{'size_pop_mod'},'2');

    set_seed(1);
    $tavern=TavernGenerator::create_tavern({'seed'=>22});
    TavernGenerator::generate_size($tavern);
    is($tavern->{'seed'},22);
    is($tavern->{'name'},'White Urchin Bar');
    is($tavern->{'size'},'large');
    is($tavern->{'cost_mod'}->{'size'}, '-2');
    is($tavern->{'size_cost_mod'},'-2');
    is($tavern->{'pop_mod'}->{'size'}, '4');
    is($tavern->{'size_pop_mod'},'4');

    set_seed(1);
    $tavern=TavernGenerator::create_tavern({'seed'=>22, 'size'=>'small'});
    TavernGenerator::generate_size($tavern);
    is($tavern->{'seed'},22);
    is($tavern->{'name'},'White Urchin Bar');
    is($tavern->{'size'},'small');
    is($tavern->{'cost_mod'}->{'size'}, '2');
    is($tavern->{'size_cost_mod'},'2');
    is($tavern->{'pop_mod'}->{'size'}, '1');
    is($tavern->{'size_pop_mod'},'1');

    set_seed(1);
    $tavern=TavernGenerator::create_tavern({'seed'=>22, 'size'=>'small', 'size_cost_mod'=>'6','size_pop_mod'=>5, 'cost_mod'=>{'size'=>'foo'}, 'pop_mod'=>{'size'=>'bar'},    });
    TavernGenerator::generate_size($tavern);
    is($tavern->{'seed'},22);
    is($tavern->{'name'},'White Urchin Bar');
    is($tavern->{'size'},'small');
    is($tavern->{'cost_mod'}->{'size'}, 'foo');
    is($tavern->{'size_cost_mod'},'6');
    is($tavern->{'pop_mod'}->{'size'}, 'bar');
    is($tavern->{'size_pop_mod'},'5');






    done_testing();
};




1;

