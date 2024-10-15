use Test;

my @modules = <
    Bin::Utils
>;

plan @modules.elems;

for @modules {
    use-ok $_, "Module $_ used okay";
}

