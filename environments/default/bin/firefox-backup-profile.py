#!/usr/bin/python
import os
import sys
import shutil

if len(sys.argv) < 3:
    print "Usage: firefox-backup-profile <source directory> <backup directory>"
elif not os.path.isdir(sys.argv[1]):
    print "Given source is not am existing directory: " + sys.argv[1]
elif not os.path.isdir(sys.argv[2]):
    print "Given target is not am existing directory: " + sys.argv[2]
else:
    shutil.copy(os.path.join(sys.argv[1], "places.sqlite"), sys.argv[2]) # Bookmarks, Downloads, Histoy
    shutil.copy(os.path.join(sys.argv[1], "cookies.sqlite"), sys.argv[2]) # Cookies
    shutil.copy(os.path.join(sys.argv[1], "key3.db"), sys.argv[2]) # Passwords
    shutil.copy(os.path.join(sys.argv[1], "logins.json"), sys.argv[2]) # Passwords
    shutil.copy(os.path.join(sys.argv[1], "formhistory.sqlite"), sys.argv[2]) # Autocomplete history
    shutil.copy(os.path.join(sys.argv[1], "cert8.db"), sys.argv[2]) # Certificates
    shutil.copy(os.path.join(sys.argv[1], "handlers.json"), sys.argv[2]) # Download settings
    shutil.copy(os.path.join(sys.argv[1], "prefs.js"), sys.argv[2]) # Preferences
