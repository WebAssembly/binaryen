function cleanInfo(info) {
  var ret = {};
  for (var x in info) {
    ret[x] = info[x];
  }
  return ret;
}

var module = new binaryen.Module();
module.setFeatures(binaryen.Features.ExceptionHandling | binaryen.Features.Multivalue);

var pairType = binaryen.createType([binaryen.i32, binaryen.f32]);

var event_ = module.addEvent("a-event", 0, binaryen.i32, binaryen.none);

console.log("GetEvent is equal: " + (event_ === module.getEvent("a-event")));

var eventInfo = binaryen.getEventInfo(event_);
console.log("getEventInfo=" + JSON.stringify(cleanInfo(eventInfo)));

module.addEventExport("a-event", "a-event-exp");
module.addEventImport("a-event-imp", "module", "base", 0, pairType, binaryen.none);

assert(module.validate());
console.log(module.emitText());

module.removeExport("a-event-exp");
module.removeEvent("a-event");

assert(module.validate());
console.log(module.emitText());
