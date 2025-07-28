#!/usr/bin/env bash

# Application run menu using Wofi.  This wrapper passes a few useful
# arguments: it sets a custom prompt, enables icons, sorts items
# alphabetically and caches results to improve launch time.

wofi --show drun \
     --prompt "Run:" \
     --allow-images \
     --sort-order alphabetical \
     --cache-file "$XDG_CACHE_HOME/wofi-run.cache"