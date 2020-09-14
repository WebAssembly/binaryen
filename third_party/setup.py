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


def fetch_json(url):
    with urllib.request.urlopen(url) as res:
        return json.loads(res.read().decode())


def download_zip(url, dir):
    with urllib.request.urlopen(url) as res:
        data = io.BytesIO(res.read())
        archive = zipfile.ZipFile(data)
        for name in archive.namelist():
            file = archive.open(name)
            with open(os.path.join(dir, name), 'wb') as output:
                output.write(file.read())


def download_tar(url, dir):
    tempfile = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'temp.tar.gz')
    with urllib.request.urlopen(url) as res:
        with open(tempfile, 'wb') as temp:
            temp.write(res.read())
    with tarfile.open(tempfile, 'r') as archive:
        for member in archive.getmembers():
            match = re.match('^[^/]+/', member.name)
            if match:
                outname = os.path.join(dir, member.name[match.span(0)[1]:])
                if member.isdir():
                    if not os.path.exists(outname):
                        os.mkdir(outname)
                elif member.isfile():
                    with archive.extractfile(member) as infile:
                        with open(outname, 'wb') as outfile:
                            outfile.write(infile.read())
                        if sys.platform != 'win32':
                            os.chmod(outname, member.mode)
    os.remove(tempfile)


# mozjs
# see: https://github.com/GoogleChromeLabs/jsvu/tree/main/engines/spidermonkey

mozjs_bin = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'mozjs')


def mozjs_determine_platform():
    is_64bits = sys.maxsize > 2**32
    if sys.platform.startswith('linux'):
        return 'linux-x86_64' if is_64bits else 'linux-i686'
    if sys.platform == 'darwin':
        return 'mac'
    if sys.platform == 'win32':
        return 'win64' if is_64bits else 'win32'
    print('Cannot determine platform, assuming \'linux-x86_64\'')
    return 'linux-x86_64'


def mozjs_determine_version(platform):
    data = fetch_json('https://product-details.mozilla.org/1.0/firefox_history_development_releases.json')
    latest = ''
    version = ''
    for v, t in data.items():
        if t > latest:
            latest = t
            version = v
    return version


def mozjs_download(platform, version):
    download_zip('https://archive.mozilla.org/pub/firefox/releases/' + version + '/jsshell/jsshell-' + platform + '.zip', mozjs_bin)
    if sys.platform != 'win32':
        os.rename(os.path.join(mozjs_bin, 'js'), os.path.join(mozjs_bin, 'mozjs'))
        os.chmod(os.path.join(mozjs_bin, 'mozjs'), 0o755)
    else:
        os.rename(os.path.join(mozjs_bin, 'js.exe'), os.path.join(mozjs_bin, 'mozjs.exe'))


def mozjs_is_installed():
    return os.path.exists(os.path.join(mozjs_bin, 'mozjs.exe' if sys.platform == 'win32' else 'mozjs'))


def mozjs_main():
    print('Setting up mozjs ...')
    platform = mozjs_determine_platform()
    print('* Platform: ' + platform)
    version = mozjs_determine_version(platform)
    print('* Latest version: ' + version)
    print('* Downloading to: ' + mozjs_bin)
    mozjs_download(platform, version)
    if mozjs_is_installed():
        print('* Complete')
    else:
        print('* Something went wrong :(')


# V8
# see: https://github.com/GoogleChromeLabs/jsvu/tree/main/engines/v8

v8_bin = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'v8')


def v8_determine_platform():
    is_64bits = sys.maxsize > 2**32
    if sys.platform.startswith('linux'):
        return 'linux64' if is_64bits else 'linux32'
    if sys.platform == 'darwin':
        return 'mac64'
    if sys.platform == 'win32':
        return 'win64' if is_64bits else 'win32'
    print('Cannot determine platform, assuming \'linux64\'')
    return 'linux64'


def v8_determine_version(platform):
    data = fetch_json('https://storage.googleapis.com/chromium-v8/official/canary/v8-' + platform + '-rel-latest.json')
    return data['version']


def v8_download(platform, version):
    download_zip('https://storage.googleapis.com/chromium-v8/official/canary/v8-' + platform + '-rel-' + version + '.zip', v8_bin)
    if sys.platform != 'win32':
        os.chmod(os.path.join(v8_bin, 'd8'), 0o755)


def v8_is_installed():
    return os.path.exists(os.path.join(v8_bin, 'd8.exe' if sys.platform == 'win32' else 'd8'))


def v8_main():
    print('Setting up V8 ...')
    platform = v8_determine_platform()
    print('* Platform: ' + platform)
    version = v8_determine_version(platform)
    print('* Latest version: ' + version)
    print('* Downloading to: ' + v8_bin)
    v8_download(platform, version)
    if v8_is_installed():
        print('* Complete')
    else:
        print('* Something went wrong :(')


# WABT
# see: https://github.com/WebAssembly/wabt/releases

wabt_dir = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'wabt')
wabt_bin = os.path.join(wabt_dir, 'bin')


def wabt_determine_platform():
    if sys.platform.startswith('linux'):
        return 'ubuntu'
    if sys.platform == 'darwin':
        return 'macos'
    if sys.platform == 'win32':
        return 'windows'
    print('Cannot determine platform, assuming \'ubuntu\'')
    return 'ubuntu'


def wabt_determine_release(platform):
    data = fetch_json('https://api.github.com/repos/WebAssembly/wabt/releases/latest')
    for asset in data['assets']:
        if asset['name'].endswith('-' + platform + '.tar.gz'):
            return asset['browser_download_url']
    print('Cannot determine release')
    return ''


def wabt_download(release):
    download_tar(release, wabt_dir)


def wabt_is_installed():
    return os.path.exists(os.path.join(wabt_bin, 'wasm2c.exe' if sys.platform == 'win32' else 'wasm2c'))


def wabt_main():
    print('Setting up WABT ...')
    platform = wabt_determine_platform()
    print('* Platform: ' + platform)
    release = wabt_determine_release(platform)
    print('* Latest release: ' + release)
    print('* Downloading to: ' + wabt_bin)
    wabt_download(release)
    if wabt_is_installed():
        print('* Complete')
    else:
        print('* Something went wrong :(')


TOOLS = collections.OrderedDict([
    ('mozjs', mozjs_main),
    ('v8', v8_main),
    ('wabt', wabt_main),
])

if __name__ == '__main__':
    if len(sys.argv) < 2 or sys.argv[1] == '--help':
        msg = ''
        for key in TOOLS.keys():
            if len(msg):
                msg += '|'
            msg += key
        print('usage: ./setup.py [' + msg + '|all]')
        sys.exit(0)
    tool = sys.argv[1]
    if tool == 'all':
        for main in TOOLS.values():
            code = main()
            if code:
                sys.exit(code)
        sys.exit(0)
    elif TOOLS[tool]:
        main = TOOLS[tool]
        sys.exit(main())
    else:
        print('No such tool: ' + tool)
        sys.exit(1)
