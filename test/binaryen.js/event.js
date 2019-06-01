function cleanInfo(info) {
  var ret = {};
  for (var x in info) {
    ret[x] = info[x];
  }
  return ret;
}

var module = new Binaryen.Module();
module.setFeatures(Binaryen.Features.ExceptionHandling);

var vi = module.addFunctionType("vi", Binaryen.none, [Binaryen.i32]);
var vif = module.addFunctionType("vif", Binaryen.none, [Binaryen.i32, Binaryen.f32]);

var event_ = module.addEvent("a-event", 0, vi);

console.log("GetEvent is equal: " + (event_ === module.getEvent("a-event")));

var eventInfo = Binaryen.getEventInfo(event_);
console.log("getEventInfo=" + JSON.stringify(cleanInfo(eventInfo)));

module.addEventExport("a-event", "a-event-exp");
module.addEventImport("a-event-imp", "module", "base", 0, vif);

module.validate();
console.log(module.emitText());

module.removeExport("a-event-exp");
module.removeEvent("a-event");

module.validate();
console.log(module.emitText());
