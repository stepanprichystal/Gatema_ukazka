
#-------------------------------------------------------------------------------------------#
# Description: Structure, whic contain optimiyed score lines
# Author:SPR
#-------------------------------------------------------------------------------------------#
package Packages::Scoring::ScoreOptimize::ScoreLayer::ScoreLayer;

#3th party library
use strict;
use warnings;

#local library
use aliased 'Packages::Scoring::ScoreChecker::Enums';
use aliased 'Packages::Scoring::ScoreChecker::Enums' => "ScoEnums";


#-------------------------------------------------------------------------------------------#
#  Package methods
#-------------------------------------------------------------------------------------------#

sub new {

	my $class = shift;

	my $self = {};
	bless $self;

	my @sets = ();
	$self->{"scoreSets"} = \@sets;

	$self->{"setOrigin"} = undef;    # save new origin, for later reset origin to 0,0

	return $self;
}

sub GetSets {
	my $self = shift;
	my $dir  = shift;

	my @sets = @{ $self->{"scoreSets"} };

	if ($dir) {

		@sets = grep { $_->GetDirection() eq $dir } @sets;
	}

	# sort sets by points Desc
	@sets = sort { $b->GetPoint() <=> $a->GetPoint() } @sets;

	return @sets;
}

sub ExistVScore {
	my $self = shift;

	my @sets = $self->GetSets( ScoEnums->Dir_VSCORE );

	if ( scalar(@sets) ) {

		return 1;
	}
	else {
		return 0;
	}
}

sub ExistHScore {
	my $self = shift;

	my @sets = $self->GetSets( ScoEnums->Dir_HSCORE );

	if ( scalar(@sets) ) {

		return 1;
	}
	else {
		return 0;
	}
}

sub AddScoreSet {
	my $self = shift;
	my $set  = shift;

	push( @{ $self->{"scoreSets"} }, $set );

}

# use again old origin
sub ResetOrigin {
	my $self = shift;

	my %newOrigin = ( "x" => -$self->{"setOrigin"}->{"x"}, "y" => -$self->{"setOrigin"}->{"y"} );

	$self->SetNewOrigin( \%newOrigin );

}

# convert all points in strucuture,  to new origin
sub SetNewOrigin {
	my $self   = shift;
	my $origin = shift;

	$self->{"setOrigin"} = $origin;

	my %newOrigin = ( "x" => $origin->{"x"} * 1000, "y" => $origin->{"y"} * 1000 );

	foreach my $set ( @{ $self->{"scoreSets"} } ) {

		my $dir = $set->GetDirection();

		# set set point
		my $point = $set->GetPoint();

		if ( $dir eq ScoEnums->Dir_HSCORE ) {

			$point -= $newOrigin{"y"}

		}
		elsif ( $dir eq ScoEnums->Dir_VSCORE ) {
			$point -= $newOrigin{"x"};
		}

		$set->SetPoint($point);

		# set set score lines
		foreach my $line ( $set->GetLines() ) {

			my $s = $line->GetStartP();
			my $e = $line->GetEndP();

			$s->{"x"} -= $newOrigin{"x"};
			$s->{"y"} -= $newOrigin{"y"};

			$e->{"x"} -= $newOrigin{"x"};
			$e->{"y"} -= $newOrigin{"y"};
		}
	}
}


#-------------------------------------------------------------------------------------------#
#  Place for testing..
#-------------------------------------------------------------------------------------------#
my ( $package, $filename, $line ) = caller;
if ( $filename =~ /DEBUG_FILE.pl/ ) {

 

}

1;

