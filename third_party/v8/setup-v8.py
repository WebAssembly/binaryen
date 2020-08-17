#!/usr/bin/env python3
#
# Copyright 2020 WebAssembly Community Group participants
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import json
import io
import os
import sys
import urllib.request
import zipfile

# Binaries provided by jsvu
# see: https://github.com/GoogleChromeLabs/jsvu/tree/main/engines/v8
#
# Format is:
# https://storage.googleapis.com/chromium-v8/official/canary/v8-ARCH-rel-latest.json
# https://storage.googleapis.com/chromium-v8/official/canary/v8-ARCH-rel-VERSION.zip

v8_bin = os.path.dirname(os.path.realpath(__file__))


def determine_platform():
    is_64bits = sys.maxsize > 2**32
    if sys.platform == "linux" or sys.platform == "linux2":
        return "linux64" if is_64bits else "linux32"
    if sys.platform == "darwin":
        return "mac64"
    if sys.platform == "win32":
        return "win64" if is_64bits else "win32"
    print("Cannot determine platform, assuming 'linux64'")
    return "linux64"


def determine_version(platform):
    with urllib.request.urlopen("https://storage.googleapis.com/chromium-v8/official/canary/v8-" + platform + "-rel-latest.json") as url:
        data = json.loads(url.read().decode())
        return data["version"]


def download(platform, version):
    with urllib.request.urlopen("https://storage.googleapis.com/chromium-v8/official/canary/v8-" + platform + "-rel-" + version + ".zip") as url:
        data = io.BytesIO(url.read())
        archive = zipfile.ZipFile(data)
        for name in archive.namelist():
            file = archive.open(name)
            with open(os.path.join(v8_bin, name), "wb") as output:
                output.write(file.read())
        if sys.platform != "win32":
            os.chmod(os.path.join(v8_bin, "d8"), 0o755)


def is_installed():
    return os.path.exists(os.path.join(v8_bin, "d8.exe" if sys.platform == "win32" else "d8"))


def main():
    platform = determine_platform()
    print("Platform: " + platform)
    version = determine_version(platform)
    print("Latest version: " + version)
    print("Downloading to '" + v8_bin + "'")
    download(platform, version)
    if is_installed():
        print("Complete - consider adding the download directory to path!")
    else:
        print("Something went wrong :(")


if __name__ == "__main__":
    sys.exit(main())
