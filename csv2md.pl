#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use Text::CSV;

sub csv2md {
    my ($input_file, $output_file) = @_;

    open my $in_fh, "<", $input_file or die "Could not open $input_file: $!";
    my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });

    my $out_fh;
    if ($output_file) {
        open $out_fh, ">", $output_file or die "Could not open $output_file for writing: $!";
    } else {
        $out_fh = *STDOUT;
    }

    while (my $row = $csv->getline($in_fh)) {
        print $out_fh "| ", join(" | ", @$row), " |\n";

        # Print the separator line only after the header
        if ($. == 1) {
            my @seps = map { '-' x length($_) } @$row;
            print $out_fh "|", join("|", @seps), "|\n";
        }
    }

    close $in_fh;
    close $out_fh if $output_file;
}

sub main {
    my $input_file;
    my $output_file;
    GetOptions(
        "input|i=s" => \$input_file,
        "output|o=s" => \$output_file
    );

    unless ($input_file) {
        die "Usage: $0 --input <path_to_csv> [--output <path_to_md>]\n";
    }

    csv2md($input_file, $output_file);
}

main();

