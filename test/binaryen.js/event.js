function assert(x) {
  if (!x) throw 'error!';
}

function cleanInfo(info) {
  var ret = {};
  for (var x in info) {
    ret[x] = info[x];
  }
  return ret;
}

function test() {
  var module = new Binaryen.Module();
  module.setFeatures(Binaryen.Features.ExceptionHandling);

  var pairType = Binaryen.createType([Binaryen.i32, Binaryen.f32]);

  var event_ = module.addEvent("a-event", 0, Binaryen.i32, Binaryen.none);

  console.log("GetEvent is equal: " + (event_ === module.getEvent("a-event")));

  var eventInfo = Binaryen.getEventInfo(event_);
  console.log("getEventInfo=" + JSON.stringify(cleanInfo(eventInfo)));

  module.addEventExport("a-event", "a-event-exp");
  module.addEventImport("a-event-imp", "module", "base", 0, pairType, Binaryen.none);

  assert(module.validate());
  console.log(module.emitText());

  module.removeExport("a-event-exp");
  module.removeEvent("a-event");

  assert(module.validate());
  console.log(module.emitText());
}

Binaryen.ready.then(test);
