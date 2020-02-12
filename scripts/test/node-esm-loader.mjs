// originally lifted from https://nodejs.org/api/esm.html

import path from 'path';
import process from 'process';

const baseURL = new URL('file://');
const binaryen_root = path.dirname(path.dirname(process.cwd()));
baseURL.pathname = `${binaryen_root}/`;

const specialTestSuiteModules = [ 'spectest', 'env', 'mod.ule' ];
const specialTestSuiteUrls = [];

export async function resolve(specifier, context, defaultResolve) {
  if (specialTestSuiteModules.includes(specifier)) {
    const url = new URL('./scripts/test/' + specifier + '.js', baseURL).href;
    specialTestSuiteUrls.push(url);
    return {
      url
    };
  }
  return defaultResolve(specifier, context, defaultResolve);
}

export async function getFormat(url, context, defaultGetFormat) {
  if (specialTestSuiteUrls.includes(url)) {
    return {
      format: 'module'
    };
  }
  return defaultGetFormat(url, context, defaultGetFormat);
}
