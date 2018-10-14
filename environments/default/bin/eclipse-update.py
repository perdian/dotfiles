#!/usr/bin/python
import os
import subprocess
import sys

# Download Release "Eclipse IDE for Java EE Developers" from
# http://www.eclipse.org/downloads/packages/
#
# Note: jeeeyul themes do not seem to work right now (in 2018-09)

p2repositoryLocations = [
    "http://download.eclipse.org/releases/2018-09",
    "http://download.eclipse.org/eclipse/updates/4.9",
    "http://eclipse.jeeeyul.net/update/",
    "http://andrei.gmxhome.de/eclipse/",
    "http://plantuml.sourceforge.net/updatesitejuno/",
    "http://download.springsource.com/release/TOOLS/update/e4.9/"
]

p2features = [

    # Feature groups
    "org.eclipse.fx.ide.feature" + ".feature.group",
    "org.eclipse.linuxtools.changelog" + ".feature.group",
    "org.eclipse.linuxtools.docker.feature" + ".feature.group",
    "org.springframework.ide.eclipse.autowire.feature" + ".feature.group",
    "org.springframework.ide.eclipse.boot.dash.feature" + ".feature.group",
    "org.springframework.ide.eclipse.boot.feature" + ".feature.group",
    "org.springframework.ide.eclipse.feature" + ".feature.group",
    "org.springframework.ide.eclipse.maven.feature" + ".feature.group",
    "org.springframework.ide.eclipse.webflow.feature" + ".feature.group",
    "net.jeeeyul.eclipse.themes.feature" + ".feature.group",
    "AnyEditTools" + ".feature.group",

    # Direct plugins
    "net.sourceforge.plantuml.eclipse",

]

if len(sys.argv) < 2:
    sys.exit("Location of eclipse installation must be passed as first parameter!")
else:

    eclipseApplicationDirectory = os.path.abspath(sys.argv[1])
    eclipseBinaryCommandFile = os.path.join(eclipseApplicationDirectory, "Contents/MacOS/eclipse");

    subprocess.call([
        eclipseBinaryCommandFile,
        "-profile", "SDKProfile",
        "-noSplash", "-consolelog",
        "-application", "org.eclipse.equinox.p2.director",
        "-repository", ",".join(p2repositoryLocations),
        "-installIU", ",".join(p2features),
        "-destination", eclipseApplicationDirectory
])