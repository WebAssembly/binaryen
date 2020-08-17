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

import collections
import json
import io
import os
import re
import sys
import tarfile
import urllib.request
import zipfile

# mozjs
# see: https://github.com/GoogleChromeLabs/jsvu/tree/main/engines/spidermonkey

mozjs_bin = os.path.join(os.path.dirname(os.path.realpath(__file__)), "mozjs")


def mozjs_determine_platform():
    is_64bits = sys.maxsize > 2**32
    if sys.platform == "linux" or sys.platform == "linux2":
        return "linux-x86_64" if is_64bits else "linux-i686"
    if sys.platform == "darwin":
        return "mac"
    if sys.platform == "win32":
        return "win64" if is_64bits else "win32"
    print("Cannot determine platform, assuming 'linux-x86_64'")
    return "linux-x86_64"


def mozjs_determine_version(platform):
    with urllib.request.urlopen("https://product-details.mozilla.org/1.0/firefox_history_development_releases.json") as url:
        data = json.loads(url.read().decode())
        latest = ""
        version = ""
        for v, t in data.items():
            if t > latest:
                latest = t
                version = v
        return version


def mozjs_download(platform, version):
    with urllib.request.urlopen("https://archive.mozilla.org/pub/firefox/releases/" + version + "/jsshell/jsshell-" + platform + ".zip") as url:
        data = io.BytesIO(url.read())
        archive = zipfile.ZipFile(data)
        for name in archive.namelist():
            file = archive.open(name)
            with open(os.path.join(mozjs_bin, name), "wb") as output:
                output.write(file.read())
        if sys.platform != "win32":
            os.rename(os.path.join(mozjs_bin, "js"), os.path.join(mozjs_bin, "mozjs"))
            os.chmod(os.path.join(mozjs_bin, "mozjs"), 0o755)
        else:
            os.rename(os.path.join(mozjs_bin, "js.exe"), os.path.join(mozjs_bin, "mozjs.exe"))


def mozjs_is_installed():
    return os.path.exists(os.path.join(mozjs_bin, "mozjs.exe" if sys.platform == "win32" else "mozjs"))


def mozjs_main():
    print("Setting up mozjs ...")
    platform = mozjs_determine_platform()
    print("* Platform: " + platform)
    version = mozjs_determine_version(platform)
    print("* Latest version: " + version)
    print("* Downloading to '" + mozjs_bin + "'")
    mozjs_download(platform, version)
    if mozjs_is_installed():
        print("Complete - consider adding the download directory to path!")
    else:
        print("Something went wrong :(")


# V8
# see: https://github.com/GoogleChromeLabs/jsvu/tree/main/engines/v8

v8_bin = os.path.join(os.path.dirname(os.path.realpath(__file__)), "v8")


def v8_determine_platform():
    is_64bits = sys.maxsize > 2**32
    if sys.platform == "linux" or sys.platform == "linux2":
        return "linux64" if is_64bits else "linux32"
    if sys.platform == "darwin":
        return "mac64"
    if sys.platform == "win32":
        return "win64" if is_64bits else "win32"
    print("Cannot determine platform, assuming 'linux64'")
    return "linux64"


def v8_determine_version(platform):
    with urllib.request.urlopen("https://storage.googleapis.com/chromium-v8/official/canary/v8-" + platform + "-rel-latest.json") as url:
        data = json.loads(url.read().decode())
        return data["version"]


def v8_download(platform, version):
    with urllib.request.urlopen("https://storage.googleapis.com/chromium-v8/official/canary/v8-" + platform + "-rel-" + version + ".zip") as url:
        data = io.BytesIO(url.read())
        archive = zipfile.ZipFile(data)
        for name in archive.namelist():
            file = archive.open(name)
            with open(os.path.join(v8_bin, name), "wb") as output:
                output.write(file.read())
        if sys.platform != "win32":
            os.chmod(os.path.join(v8_bin, "d8"), 0o755)


def v8_is_installed():
    return os.path.exists(os.path.join(v8_bin, "d8.exe" if sys.platform == "win32" else "d8"))


def v8_main():
    print("Setting up V8 ...")
    platform = v8_determine_platform()
    print("* Platform: " + platform)
    version = v8_determine_version(platform)
    print("* Latest version: " + version)
    print("* Downloading to '" + v8_bin + "'")
    v8_download(platform, version)
    if v8_is_installed():
        print("Complete - consider adding the download directory to path!")
    else:
        print("Something went wrong :(")


# WABT
# see: https://github.com/WebAssembly/wabt/releases

wabt_bin = os.path.join(os.path.dirname(os.path.realpath(__file__)), "wabt")


def wabt_determine_platform():
    if sys.platform == "linux" or sys.platform == "linux2":
        return "ubuntu"
    if sys.platform == "darwin":
        return "macos"
    if sys.platform == "win32":
        return "windows"
    print("Cannot determine platform, assuming 'ubuntu'")
    return "ubuntu"


def wabt_determine_release(platform):
    with urllib.request.urlopen("https://api.github.com/repos/WebAssembly/wabt/releases/latest") as url:
        data = json.loads(url.read().decode())
        for asset in data["assets"]:
            if asset["name"].endswith("-" + platform + ".tar.gz"):
                return asset["browser_download_url"]
    print("Cannot determine release")
    return ""


def wabt_download(release):
    tempfile = os.path.join(wabt_bin, "temp.tar.gz")
    with urllib.request.urlopen(release) as url:
        with open(tempfile, "wb") as temp:
            temp.write(url.read())
    with tarfile.open(tempfile, "r") as archive:
        for member in archive.getmembers():
            match = re.match("^wabt-[^/]+/bin/", member.name)
            if match:
                name = member.name[match.span(0)[1]:]
                with archive.extractfile(member) as infile:
                    outname = os.path.join(wabt_bin, name)
                    with open(outname, "wb") as outfile:
                        outfile.write(infile.read())
                    if sys.platform != "win32":
                        os.chmod(outname, 0o755)
    os.remove(tempfile)


def wabt_is_installed():
    return os.path.exists(os.path.join(wabt_bin, "wasm-validate.exe" if sys.platform == "win32" else "wasm-validate"))


def wabt_main():
    print("Setting up WABT ...")
    platform = wabt_determine_platform()
    print("* Platform: " + platform)
    release = wabt_determine_release(platform)
    print("* Latest release: " + release)
    print("* Downloading to '" + wabt_bin + "'")
    wabt_download(release)
    if wabt_is_installed():
        print("Complete - consider adding the download directory to path!")
    else:
        print("Something went wrong :(")


TOOLS = collections.OrderedDict([
    ("mozjs", mozjs_main),
    ("v8", v8_main),
    ("wabt", wabt_main),
])

if __name__ == "__main__":
    if len(sys.argv) < 2 or sys.argv[1] == "--help":
        msg = ""
        for key in TOOLS.keys():
            if len(msg):
                msg += "|"
            msg += key
        print("usage: ./setup.py [" + msg + "|all]")
        sys.exit(0)
    tool = sys.argv[1]
    if tool == "all":
        for main in TOOLS.values():
            code = main()
            if code:
                sys.exit(code)
        sys.exit(0)
    elif TOOLS[tool]:
        main = TOOLS[tool]
        sys.exit(main())
    else:
        print("No such tool: " + tool)
        sys.exit(1)
