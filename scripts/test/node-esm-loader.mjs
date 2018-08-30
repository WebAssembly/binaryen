// originally lifted from https://nodejs.org/api/esm.html

import path from 'path';
import process from 'process';
import Module from 'module';

const builtins = Module.builtinModules;

const baseURL = new URL('file://');
baseURL.pathname = `${process.cwd()}/`;

export function resolve(specifier, parentModuleURL = baseURL, defaultResolve) {
  if (builtins.includes(specifier)) {
    return {
      url: specifier,
      format: 'builtin'
    };
  }
  // Resolve the 'spectest' module to our special module which has some builtins
  if (specifier == 'spectest') {
    const resolved = new URL('./scripts/test/spectest.js', parentModuleURL);
    return {
      url: resolved.href,
      format: 'esm'
    };
  }
  const resolved = new URL(specifier, parentModuleURL);
  return {
    url: resolved.href,
    format: 'esm'
  };
}
