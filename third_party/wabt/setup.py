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
import os
import re
import sys
import urllib.request
import tarfile

wabt_bin = os.path.dirname(os.path.realpath(__file__))


def determine_platform():
    if sys.platform == "linux" or sys.platform == "linux2":
        return "ubuntu"
    if sys.platform == "darwin":
        return "macos"
    if sys.platform == "win32":
        return "windows"
    print("Cannot determine platform, assuming 'ubuntu'")
    return "ubuntu"


def determine_release(platform):
    with urllib.request.urlopen("https://api.github.com/repos/WebAssembly/wabt/releases/latest") as url:
        data = json.loads(url.read().decode())
        for asset in data["assets"]:
            if asset["name"].endswith("-" + platform + ".tar.gz"):
                return asset["browser_download_url"]
    print("Cannot determine release")
    return ""


def download(release):
    tempfile = os.path.join(wabt_bin, "temp.tar.gz")
    with urllib.request.urlopen(release) as url:
        with open(tempfile, "wb") as temp:
            temp.write(url.read())
    with tarfile.open(tempfile, "r") as archive:
        for member in archive.getmembers():
            match = re.match("^wabt\-[^/]+/bin/", member.name)
            if match:
                name = member.name[match.span(0)[1]:]
                with archive.extractfile(member) as infile:
                    outname = os.path.join(wabt_bin, name)
                    with open(outname, "wb") as outfile:
                        outfile.write(infile.read())
                    if sys.platform != "win32":
                        os.chmod(outname, 0o755)
    os.remove(tempfile)


def is_installed():
    return os.path.exists(os.path.join(wabt_bin, "wasm-validate.exe" if sys.platform == "win32" else "wasm-validate"))


def main():
    platform = determine_platform()
    print("Platform: " + platform)
    release = determine_release(platform)
    print("Latest release: " + release)
    print("Downloading to '" + wabt_bin + "'")
    download(release)
    if is_installed():
        print("Complete - consider adding the download directory to path!")
    else:
        print("Something went wrong :(")


if __name__ == "__main__":
    sys.exit(main())
