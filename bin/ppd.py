#!/usr/bin/env python

import re
import sys
import time
import urllib

profile_url = 'http://bbs.archlinux.org/profile.php?id=' + sys.argv[1]

date_format = '%Y-%m-%d'

next_is_posts = False
next_is_registered = False

posts = None
registered = None

f = urllib.urlopen(profile_url)
for line in f.readlines():

  if next_is_posts:
    next_is_posts = False
    m = re.search(r'^\s*<dd>(\d+)\s', line)
    if m:
      posts = m.group(1)
