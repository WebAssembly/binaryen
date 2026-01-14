const module = new binaryen.Module();

// Test table
const tableName = "a-table";
const tableMin = 5;
const tableMax = 15;
const tablePtr = module.addTable(tableName, tableMin, tableMax);

console.log("GetTable is equal: " + (tablePtr === module.getTable(tableName)));

const tableInfo = binaryen.getTableInfo(tablePtr);
console.log("getTableInfo=" + JSON.stringify(tableInfo));

// Test Wrapper
// get/set name
assert(binaryen.Table.getName(tablePtr) === tableName);
binaryen.Table.setName(tablePtr, "new-table-name");
assert(binaryen.Table.getName(tablePtr) === "new-table-name");
binaryen.Table.setName(tablePtr, tableName);

// get/set initial
assert(binaryen.Table.getInitial(tablePtr) === tableMin);
binaryen.Table.setInitial(tablePtr, 10);
assert(binaryen.Table.getInitial(tablePtr) === 10);
binaryen.Table.setInitial(tablePtr, tableMin);

// hasMax
assert(binaryen.Table.hasMax(tablePtr) === true);

// get/set max
assert(binaryen.Table.getMax(tablePtr) === tableMax);
binaryen.Table.setMax(tablePtr, 20);
assert(binaryen.Table.getMax(tablePtr) === 20);
binaryen.Table.setMax(tablePtr, tableMax);

// get/set type
assert(binaryen.Table.getType(tablePtr) === binaryen.funcref);
binaryen.Table.setType(tablePtr, binaryen.anyref);
assert(binaryen.Table.getType(tablePtr) === binaryen.anyref);
binaryen.Table.setType(tablePtr, binaryen.funcref);

const tableRef = binaryen.Table(tablePtr);
assert(tableRef.name === tableName);
assert(tableRef.initial === tableMin);
assert(tableRef.max === tableMax);
assert(tableRef.type === binaryen.funcref);

// Cleanup
assert(module.validate());
console.log(module.emitText());

module.dispose();
