#!/usr/bin/python
import os
import subprocess
import sys

p2repositoryLocations = [
    "http://download.eclipse.org/eclipse/updates/4.8",
    "http://download.eclipse.org/releases/photon",
    "http://download.eclipse.org/egit/updates",
    "http://jeeeyul.github.io/update/",
    "http://andrei.gmxhome.de/eclipse/",
    "http://www.nodeclipse.org/updates/markdown/",
    "http://files.idi.ntnu.no/publish/plantuml/repository/",
    "http://winterwell.com/software/updatesite/",
    "https://raw.githubusercontent.com/satyagraha/gfm_viewer/master/p2-composite/",
    "http://dist.springsource.com/release/TOOLS/update/e4.7/"
]

p2features = [

    # Feature groups
    "org.eclipse.egit" + ".feature.group",
    "org.eclipse.jgit" + ".feature.group",
    "org.eclipse.epp.mpc" + ".feature.group",
    "org.eclipse.wst.common.fproj" + ".feature.group",
    "org.eclipse.jst.common.fproj.enablement.jdt" + ".feature.group",
    "org.eclipse.jst.enterprise_ui.feature" + ".feature.group",
    "org.eclipse.wst.jsdt.feature" + ".feature.group",
    "org.eclipse.wst.json_ui.feature" + ".feature.group",
    "org.eclipse.wst.web_ui.feature" + ".feature.group",
    "org.eclipse.wst.xml_ui.feature" + ".feature.group",
    "org.eclipse.wst.xml.xpath2.processor.feature" + ".feature.group",
    "org.eclipse.wst.xsl.feature" + ".feature.group",
    "org.eclipse.fx.ide.css.feature" + ".feature.group",
    "org.eclipse.m2e.logback.feature" + ".feature.group",
    "org.eclipse.m2e.feature" + ".feature.group",
    "org.eclipse.m2e.wtp.feature" + ".feature.group",
    "org.eclipse.m2e.wtp.jaxrs.feature" + ".feature.group",
    "org.eclipse.m2e.wtp.jpa.feature" + ".feature.group",
    "org.sonatype.m2e.mavenarchiver.feature" + ".feature.group",
    "AnyEditTools" + ".feature.group",

    # Direct plugins
    "net.jeeeyul.eclipse.themes.ui",
    "net.jeeeyul.eclipse.themes",
    "net.sourceforge.plantuml.eclipse",
    "winterwell.markdown",
    "code.satyagraha.gfm.viewer.plugin"

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
