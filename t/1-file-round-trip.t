use Test;

use File::Temp;
use File::Find;

use Bin::Utils;

my $debug = 0;

my @fils = find :dir("resources"), :type<file>;
my $zfil = "t/data/zcmp";
@fils.push: $zfil;

my %bad;
my %good;
for @fils.kv -> $i, $path {
    my ($content, $copy, @res, $err, $basename, $dir);

    $basename = $path.IO.basename;
    say "Processing file '$basename' at index $i" if $debug;
    next if %good{$i}:exists;

    # local slurp/spurt ($*CWD)
    $dir = '.';
    $content = slurp-file $path, :$debug;
    $copy    = spurt-file $content, :$basename, :$dir, :$debug;
    @res     = bin-cmp $path, $copy, :l(True), :$debug;
    $err     = @res.shift;
    is $err, 0, "bin file '$path' round trips okay";
    if $err == 0 {
        say "DEBUG: file $path roundtrips ok" if $debug;
        %good{$i} = $path;
    }
    else {
        say "File '$path' does not roundtrip";
        say "  $%_" for @res;
        %bad{$i} = $path;
    }

    # use a temp dir
    $dir    = tempdir;
    $copy   = spurt-file $content, :$basename, :$dir, :$debug;
    @res    = bin-cmp $path, $copy, :l(True), :$debug;
    $err    = @res.shift;
    is $err, 0, "bin file '$path' round trips okay";
    if $err == 0 {
        say "DEBUG: file $path roundtrips ok" if $debug;
        %good{$i} = $path;
    }
    else {
        say "File '$path' does not roundtrip";
        say "  $%_" for @res;
        %bad{$i} = $path;
    }

    if not $debug {
        unlink $basename if $basename.IO.e;
    }
}

done-testing;

=finish
my $orig-text = "some text";
my $tfil = "text.txt";

my $tmpdir = tempdir;

spurt-file  $orig-text, :basename($tfil), :dir($tmpdir);
my $copy-text = slurp-file "$tmpdir/$tfil";
is $copy-text, $orig-text;

done-testing;
