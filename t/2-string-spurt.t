use Test;

use File::Temp;
use File::Find;

use Bin::Utils;

my $debug = 0;

my $string = q:to/HERE/;
Hoo, B<boy>!
HERE

my %bad;
my %good;
my ($path, $content, $copy, @res, $err, $basename, $dir);
$content = $string;
$basename = "my-string.txt";
# use a temp dir
$dir    = tempdir;
my $i = 0;
$path = $content;
$copy   = spurt-file $content, :$basename, :$dir, :$debug;
@res    = bin-cmp $copy, $copy, :l(True), :$debug;
$err    = @res.shift;
is $err, 0, "bin file '$copy' round trips okay";
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

done-testing;

=finish
my $orig-text = "some text";
my $tfil = "text.txt";

my $tmpdir = tempdir;

spurt-file  $orig-text, :basename($tfil), :dir($tmpdir);
my $copy-text = slurp-file "$tmpdir/$tfil";
is $copy-text, $orig-text;

done-testing;
