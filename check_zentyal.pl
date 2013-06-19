#!/usr/bin/perl
# Version 0.1


use strict;
use warnings;

use EBox;
use EBox::Util::Init;

EBox::init();

$SIG{PIPE} = 'IGNORE';


sub main
{
    my $global = EBox::Global->getInstance(1);
    my @mods = @{$global->modInstancesOfType('EBox::Module::Service')};
    my @names = map { $_->{name} } @mods;
    my $running_list = "";
    my $running_unmanaged_list = "";
    my $stopped_list = "";
    my $disabled_list = "";
    my $exit_number = 0;

    foreach (@names){
      my $mod = $global->modInstance($_);
      my $msg = "$_: ";
      my $enabled = $mod->isEnabled();
      my $running = $mod->isRunning();
      if ($enabled and $running) {
        $running_list .= $_ . " ";
      } elsif ($enabled and not $running) {
        $stopped_list .= $_ . " ";
      } elsif ((not $enabled) and $running) {
        $running_unmanaged_list .= $_ . " ";
      } else {
        $disabled_list .= $_ . " ";
      }
    }
    if ($stopped_list){

         print "Stopped: " . $stopped_list . "|" . "Running: " . $running_list . "Running but unmanaged: " . $running_unmanaged_list . "Disabled: " . $disabled_list;
         exit 2;
    }
    else {
        print "ok" . "|" . "Running: " . $running_list . "Running but unmanaged: " . $running_unmanaged_list . "Disabled: " . $disabled_list;
    }

}

main();

1;
