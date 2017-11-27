#!/usr/bin/python
import os
import sys
import json
import codecs

if len(sys.argv) < 3:
    print "Usage: backup-tampermonkey <firefox profile directory> <target directory>"
elif not os.path.isdir(sys.argv[1]):
    print "Given  parameter is not an existing firefox profile directory: " + sys.argv[1]
elif not os.path.isdir(sys.argv[2]):
    print "Given parameter is not an existing target directory: " + sys.argv[2]
else:
    tampermonkeyStorageFile = os.path.join(sys.argv[1], "browser-extension-data/firefox@tampermonkey.net/storage.js")
    if not os.path.isfile(tampermonkeyStorageFile):
        print "No tampermonkey storage file found at: " + tampermonkeyStorageFile
    else:

        jsonData = json.load(open(tampermonkeyStorageFile))

        backupData = {}
        for k, v in jsonData.iteritems():
            if k.startswith("@uid#"):
                backupData.setdefault(k[len("@uid#"):], {})['title'] = v['value']
            elif k.startswith("@source"):
                backupData.setdefault(k[len("@source#"):], {})['content'] = v['value']

        for k2, v2 in backupData.iteritems():
             print "Backing up script: " + str(v2['title'])
             targetFileName = os.path.join(sys.argv[2], str(v2['title']) + ".user.js")
             targetFile = codecs.open(targetFileName, "w", "utf-8")
             targetFile.write(v2['content'])
             targetFile.close();