[![Actions Status](https://github.com/tbrowder/Bin-Utils/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/Bin-Utils/actions) [![Actions Status](https://github.com/tbrowder/Bin-Utils/actions/workflows/macos.yml/badge.svg)](https://github.com/tbrowder/Bin-Utils/actions) [![Actions Status](https://github.com/tbrowder/Bin-Utils/actions/workflows/windows.yml/badge.svg)](https://github.com/tbrowder/Bin-Utils/actions)

NAME
====

**Bin::Utils** - Provides routines to handle 'slurp/spurt' for any file type in read/write directories

SYNOPSIS
========

```raku
use Bin::Utils;
# Get contents of a file of unknown encoding
my $from-path = "some-dir/file";
my $contents = slurp-file $from-path;
# Put contents of 'file' somewhere else
# We don't usually change the basename,
#   but we could at this point
my $basename = $from-path.IO.basename
my $dir = "another-dir/subdir";
spurt-file $contents, :$basename, :$dir";
```

DESCRIPTION
===========

**Bin::Utils** should be used by any module author who wants to provide the contents of the module's /resources directory to its users. It provides the following routines:

### slurp-file

    #| Assumes file is binary,
    sub slurp-file(
         $path
        ) is export {...}

### spurt-file

    #| Assumes file is binary
    #| Returns the new path
    sub spurt-file(
        $contents,
        :$basename!,
        :$dir is copy     #= the desired output directory
                          #= default: $*CWD ('.')
        --> IO::Path
        ) is export {...}

### bin-cmp

    #| Compares two files' binary contents
    #| using the GNU system utility 'cmp'
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
        ) is export {...}

Note the Raku 'slurp' and 'spurt' routines have many other options that a normal user of this simplified library would not need. The treatment of all files as binary blobs has been shown to be usable for files of three different encodings, including 'Str'.

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

© 2024 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.

