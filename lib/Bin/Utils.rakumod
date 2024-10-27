unit module Bin::Utils;

#| Assumes file is binary 
sub slurp-file(
     $path,
     :$debug,
    ) is export {
    # Returns file contents
    $path.IO.slurp(:bin);
} # sub slurp-file

#| Assumes file is binary
#| Returns the new path
sub spurt-file(
    $content,
    :$basename!,
    :$dir is copy,    #= the desired output directory
                      #= default: $*CWD ('.')
    :$debug,
    --> IO::Path
    ) is export {

    unless $dir.defined and $dir.IO.d {
        $dir = $*CWD;
    }
    my $o    = IO::Path.new: :$basename, :$dir;
    my $ofil = "$dir/$o";
    if $debug {
        say "DEBUG file to be spurted is '$ofil'";
    }
    
    $ofil.IO.spurt: $content, :bin;

    # return path name
    $ofil.IO

} # sub spurt-file

#| Compares two files' binary contents
#| using the GNU system binary 'cmp'
sub bin-cmp(
    $file1, 
    $file2, 
    # cmp options
    :$s = True,  # silent
    :$l = False, # list bytes differing and their values
    :$b = False, # list bytes differing
    :$n = 0,     # list first n bytes (default: 0 - list all)
    :$debug, 
    --> List
    ) is export {

    # Runs Gnu 'cmp' and compares the two inputs byte by byte
    # Returns a List whose first value is the error code
    #   and the rest are any data from :out and :err

    # build the command
    my $cmd = "cmp";
     
    if $l {
        $cmd ~= " -l";
    }
    elsif $b {
        $cmd ~= " -b";
    }
    else{
        $cmd ~= " -s";
    }

    # modifiers
    if $n {
        $cmd ~= " -n$n";
    }
    $cmd ~= " $file1 $file2";
    my $proc = run($cmd.words, :out, :err);
    my $err = $proc.exitcode; 

    my @lines  = $proc.out.slurp(:close).lines;
    my @lines2 = $proc.err.slurp(:close).lines;
    if 0 and $debug {
        if $err == 0 {
            say "DEBUG: no diffs found";
        }
        else {
            say "  DEBUG: byte differences:";
            for @lines {
                say "    $_";
            }
            for @lines2 {
                say "    $_";
            }
        }
    }
    $err, |@lines, |@lines2
} # sub bin-cmp

sub check-repo($*ARGS) is export {
    my $repo  = $*CWD;
    my $debug = 0;

    for @*ARGS {
        when /^ 'repo=' (\S+) $/ {
            $repo = ~$0;
        }
        when /^ d / {
            ++$debug;
        }
        default {
            die "FATAL: Unknown arg '$_'";
        }
    }

    if not $repo.IO.d {
        die "FATAL: path '$repo' is not a directory";
    }
    my @errs;

    my $resdir = "$repo/resources";
    my $meta   = "$repo/META6.json";
    # get the META6.json "resources": listing
    #   in a hash keyed by basename
    # get the /resources file list
    #   in a hash keyed by basename

    # compare the two
    # report

    # SEE CURRENT WORK IN Mi6::Helper

} # sub check-repo

