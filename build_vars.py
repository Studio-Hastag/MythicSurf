import os
import sys
import platform

curdir = sys.argv[1]
version = sys.argv[2]

if "+" in version:
    release = version.split("+")[0]

if "~" in version:
    release = version.split("~")[0]

SOURCE_TARNAME = "chromium-%s" % release
SOURCE_URL = "https://commondatastorage.googleapis.com/chromium-browser-official/%s.tar.xz" % SOURCE_TARNAME

CHROME_SOURCE_DIR = os.path.join(curdir, SOURCE_TARNAME)

BUILD_OUTPUT_DIR = "%s/debian/build" % curdir
STAGING_DIR = "%s/debian/tmp" % curdir
IMAGE_CODENAME = os.environ["MYTHIC_CODENAME"]
IMAGE_32BIT = platform.architecture()[0] == "32bit"
