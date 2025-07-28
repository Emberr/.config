#!/usr/bin/env bash

# A simple wrapper around wofi to show the application launcher.  You
# can customise arguments here (for example, to sort alphabetically or
# include files).  See `man wofi` for more options.

wofi --show drun --prompt "Run:" --allow-images --sort-order alphabetical --cache-file "$XDG_CACHE_HOME/wofi-run.cache"