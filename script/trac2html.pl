use strict;
use warnings;
use Text::Trac ();
use Getopt::Long qw(GetOptions);
use Path::Tiny qw(path);

my ($infile, $outfile);
my $url = '';

GetOptions(
	'infile=s'  => \$infile,
	'outfile=s' => \$outfile,
	'url=s'     => \$url,
) or usage();
usage() if not $infile or not $outfile;
die "Infile '$infile' does not exist.\n" if not -e $infile;
die "Outfile '$outfile' already exists.\n" if -e $outfile;

main();
exit;


sub main {
	my $parser = Text::Trac->new(
		trac_url      => $url,
	#	disable_links => [ qw( changeset ticket ) ],
	);
	$parser->parse( path($infile)->slurp_utf8 );
	path($outfile)->spew_utf8( $parser->html );
}


sub usage {
	print <<"END_USAGE";
Usage: $0
    --infile filename     (File in Trac wiki format)
    --outfile filename    (The html file to generate)

    --url http://...      ()
END_USAGE
	exit;
}

