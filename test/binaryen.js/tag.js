function cleanInfo(info) {
  var ret = {};
  for (var x in info) {
    ret[x] = info[x];
  }
  return ret;
}

var module = new binaryen.Module();
module.setFeatures(binaryen.Features.ReferenceTypes |
                   binaryen.Features.ExceptionHandling |
                   binaryen.Features.Multivalue);

var pairType = binaryen.createType([binaryen.i32, binaryen.f32]);

var tag = module.addTag("a-tag", binaryen.i32, binaryen.none);

console.log("GetTag is equal: " + (tag === module.getTag("a-tag")));

var tagInfo = binaryen.getTagInfo(tag);
console.log("getTagInfo=" + JSON.stringify(cleanInfo(tagInfo)));

module.addTagExport("a-tag", "a-tag-exp");
module.addTagImport("a-tag-imp", "module", "base", pairType, binaryen.none);

assert(module.validate());
console.log(module.emitText());

module.removeExport("a-tag-exp");
module.removeTag("a-tag");

assert(module.validate());
console.log(module.emitText());
