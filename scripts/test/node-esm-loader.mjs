// originally lifted from https://nodejs.org/api/esm.html

import path from 'path';
import process from 'process';

const binaryen_root = "file://" + path.dirname(path.dirname(process.cwd())) + "/";

const specialTestSuiteModules = {
  'spectest': {
    url: new URL('scripts/test/spectest.js', binaryen_root).href,
    format: 'module'
  },
  'env': {
    url: new URL('scripts/test/env.js', binaryen_root).href,
    format: 'module'
  },
  'mod.ule': {
    url: new URL('scripts/test/mod.ule.js', binaryen_root).href,
    format: 'module'
  }
};

export async function resolve(specifier, context, defaultResolve) {
  const specialModule = specialTestSuiteModules[specifier];
  if (specialModule) {
    return specialModule;
  }
  return defaultResolve(specifier, context, defaultResolve);
}

export async function getFormat(url, context, defaultGetFormat) {
  const specifiers = Object.keys(specialTestSuiteModules);
  for (let i = 0, k = specifiers.length; i < k; ++i) {
    const specialModule = specialTestSuiteModules[specifiers[i]];
    if (specialModule.url == url) {
      return specialModule;
    }
  }
  return defaultGetFormat(url, context, defaultGetFormat);
}
