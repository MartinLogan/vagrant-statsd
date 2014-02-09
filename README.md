# statsd on ubuntu 12.04 virtualbox provisioned by vagrant

## Introduction
I have been playing woth [Phantomas](https://github.com/macbre/phantomas) and was really interested in being able to track the stats via [statsd](https://github.com/etsy/statsd/) and [Graphite](http://graphite.wikidot.com/). Beacause I have also been playing with [vagrant](http://vagrantup.com) I thought it would be useful to get this up and running on vagrant.

My intent was to set up a vagrant box to just do the monitoring, so it will just be a pre-configured box with statsd and Graphie with some basic settings. Theere were some older boxes available but they did not seem as straight forward as I wanted.

## Requirements
1. [Vagrant](http://vagrantup.com)
1. [Virtualbox](https://www.virtualbox.org)

## Instructions
1. Clone the repository
1. cd into the statsd sirectory
1. Run

~~~~
  vagrant up
~~~~

## Viewing and sending data to the virtualbox
1. Point your brower to http://localhost:18080 - You should see the Grapite welcome screen
1. Run phantomas with the appropriate settings (See below)
1. On Graphite add data to the graph - the timings from the example below will be under Graphite stata.timings.google.home

~~~~
  phantomas --no-externals --url http://google.com --format statsd --statsd-host localhost --statsd-port 18125 --statsd-prefix "google.home."
~~~~

You could optionally install phantomas on the virtual box but I prefer to manage this on my main system - I have soem basic auth unformation in mine for some testing that I am doing.

To run phantomas in debug mode, just prefix the command with DEBUG=*

~~~~
  DEBUG=* phantomas --no-externals --url http://google.com --format statsd --statsd-host localhost --statsd-port 18125 --statsd-prefix "google.home."
~~~~

## Thanks
Thanks to [This article on elao.com](http://www.elao.com/blog/linux/install-stats-d-graphite-on-a-debian-server-to-monitor-a-symfony2-application-12.html) and [Nam Nguyen's script](https://github.com/gdbtek/setup-graphite)