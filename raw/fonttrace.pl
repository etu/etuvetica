#!/run/current-system/sw/bin/perl -w
# fonttrace.pl - start autotracing fonts
# created by scruss on 02010/05/07
# RCS/CVS: $Id: fonttrace.pl,v 1.4 2010/05/09 21:54:40 scruss Exp $

use strict;

use constant ROWS        => 12;          # number of rows in array
use constant COLS        => 8;           # number of columns
use constant STARTCHAR   => ' ';         # UL character in array
use constant BORDERWIDTH => 5 / 483;     # border of cell is so many pix
use constant HEADER      => 80 / 483;    # proportion of cell taken up by header
use constant BORDERCLIP  => 4;           # number of multiples of border to clip

my $infile = $ARGV[0];
die "Usage: $0 infile.pbm\n" unless defined($infile);

my @info;
open( PNMFILE, "pnmfile $infile |" ) or die "$!";
while (<PNMFILE>) {
    chomp;
    push @info, $_;
}
close(PNMFILE);
die "Infile is not PBM\n" unless ( $info[0] =~ /PBM/ );
die "Infile is not PNM\n" unless ( $info[0] =~ /\d+ by \d+/ );
my ( $width, $height ) = $info[0] =~ /, (\d+) by (\d+)/;

# x position of cell is (n-1) * WIDTH + n * BORDERWIDTH
# pnmcut left top width height

my $cellwidth    = int( $width / COLS );
my $cellheight   = int( $height / ROWS );
my $headerheight = int( $cellheight * HEADER );
my $borderpx     = int( $cellheight * BORDERWIDTH );

my $char = ord(STARTCHAR);
for ( my $rows = 1 ; $rows <= ROWS ; $rows++ ) {
    for ( my $cols = 1 ; $cols <= COLS ; $cols++ ) {
        my $left = ( $cols - 1 ) * $cellwidth + BORDERCLIP * $borderpx;
        my $top =
          ( $rows - 1 ) * $cellheight + $headerheight + BORDERCLIP * $borderpx;

        my $xwidth  = $cellwidth - 2 * BORDERCLIP * $borderpx;
        my $xheight = $cellheight - $headerheight - 2 * BORDERCLIP * $borderpx;
        printf( "pnmcut %d %d %d %d %s | pnmtopng > uni%04x.png\n",
            $left, $top, $xwidth, $xheight, $infile, $char );
        $char++;
    }
}

exit;
