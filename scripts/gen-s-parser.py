#!/usr/bin/env python3
#
# Copyright 2018 WebAssembly Community Group participants
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

instructions = [
    ("unreachable",    "makeUnreachable()"),
    ("nop",            "makeNop()"),
    ("block",          "makeBlock(s)"),
    ("loop",           "makeLoop(s)"),
    ("if",             "makeIf(s)"),
    ("then",           "makeThenOrElse(s)"),
    ("else",           "makeThenOrElse(s)"),
    ("br",             "makeBreak(s)"),
    ("br_if",          "makeBreak(s)"),
    ("br_table",       "makeBreakTable(s)"),
    ("return",         "makeReturn(s)"),
    ("call",           "makeCall(s)"),
    ("call_indirect",  "makeCallIndirect(s)"),
    ("drop",           "makeDrop(s)"),
    ("select",         "makeSelect(s)"),
    ("get_local",      "makeGetLocal(s)"),
    ("set_local",      "makeSetLocal(s)"),
    ("tee_local",      "makeTeeLocal(s)"),
    ("get_global",     "makeGetGlobal(s)"),
    ("set_global",     "makeSetGlobal(s)"),
    ("i32.load",       "makeLoad(s, i32, /*isAtomic=*/false)"),
    ("i64.load",       "makeLoad(s, i64, /*isAtomic=*/false)"),
    ("f32.load",       "makeLoad(s, f32, /*isAtomic=*/false)"),
    ("f64.load",       "makeLoad(s, f64, /*isAtomic=*/false)"),
    ("i32.load8_s",    "makeLoad(s, i32, /*isAtomic=*/false)"),
    ("i32.load8_u",    "makeLoad(s, i32, /*isAtomic=*/false)"),
    ("i32.load16_s",   "makeLoad(s, i32, /*isAtomic=*/false)"),
    ("i32.load16_u",   "makeLoad(s, i32, /*isAtomic=*/false)"),
    ("i64.load8_s",    "makeLoad(s, i64, /*isAtomic=*/false)"),
    ("i64.load8_u",    "makeLoad(s, i64, /*isAtomic=*/false)"),
    ("i64.load16_s",   "makeLoad(s, i64, /*isAtomic=*/false)"),
    ("i64.load16_u",   "makeLoad(s, i64, /*isAtomic=*/false)"),
    ("i64.load32_s",   "makeLoad(s, i64, /*isAtomic=*/false)"),
    ("i64.load32_u",   "makeLoad(s, i64, /*isAtomic=*/false)"),
    ("i32.store",      "makeStore(s, i32, /*isAtomic=*/false)"),
    ("i64.store",      "makeStore(s, i64, /*isAtomic=*/false)"),
    ("f32.store",      "makeStore(s, f32, /*isAtomic=*/false)"),
    ("f64.store",      "makeStore(s, f64, /*isAtomic=*/false)"),
    ("i32.store8",     "makeStore(s, i32, /*isAtomic=*/false)"),
    ("i32.store16",    "makeStore(s, i32, /*isAtomic=*/false)"),
    ("i64.store8",     "makeStore(s, i64, /*isAtomic=*/false)"),
    ("i64.store16",    "makeStore(s, i64, /*isAtomic=*/false)"),
    ("i64.store32",    "makeStore(s, i64, /*isAtomic=*/false)"),
    ("current_memory", "makeHost(s, HostOp::CurrentMemory)"),
    ("grow_memory",    "makeHost(s, HostOp::GrowMemory)"),
    ("i32.const",      "makeConst(s, i32)"),
    ("i64.const",      "makeConst(s, i64)"),
    ("f32.const",      "makeConst(s, f32)"),
    ("f64.const",      "makeConst(s, f64)"),
    ("i32.eqz",        "makeUnary(s, UnaryOp::EqZInt32)"),
    ("i32.eq",         "makeBinary(s, BinaryOp::EqInt32)"),
    ("i32.ne",         "makeBinary(s, BinaryOp::NeInt32)"),
    ("i32.lt_s",       "makeBinary(s, BinaryOp::LtSInt32)"),
    ("i32.lt_u",       "makeBinary(s, BinaryOp::LtUInt32)"),
    ("i32.gt_s",       "makeBinary(s, BinaryOp::GtSInt32)"),
    ("i32.gt_u",       "makeBinary(s, BinaryOp::GtUInt32)"),
    ("i32.le_s",       "makeBinary(s, BinaryOp::LeSInt32)"),
    ("i32.le_u",       "makeBinary(s, BinaryOp::LeUInt32)"),
    ("i32.ge_s",       "makeBinary(s, BinaryOp::GeSInt32)"),
    ("i32.ge_u",       "makeBinary(s, BinaryOp::GeUInt32)"),
    ("i64.eqz",        "makeUnary(s, UnaryOp::EqZInt64)"),
    ("i64.eq",         "makeBinary(s, BinaryOp::EqInt64)"),
    ("i64.ne",         "makeBinary(s, BinaryOp::NeInt64)"),
    ("i64.lt_s",       "makeBinary(s, BinaryOp::LtSInt64)"),
    ("i64.lt_u",       "makeBinary(s, BinaryOp::LtUInt64)"),
    ("i64.gt_s",       "makeBinary(s, BinaryOp::GtSInt64)"),
    ("i64.gt_u",       "makeBinary(s, BinaryOp::GtUInt64)"),
    ("i64.le_s",       "makeBinary(s, BinaryOp::LeSInt64)"),
    ("i64.le_u",       "makeBinary(s, BinaryOp::LeUInt64)"),
    ("i64.ge_s",       "makeBinary(s, BinaryOp::GeSInt64)"),
    ("i64.ge_u",       "makeBinary(s, BinaryOp::GeUInt64)"),
    ("f32.eq",         "makeBinary(s, BinaryOp::EqFloat32)"),
    ("f32.ne",         "makeBinary(s, BinaryOp::NeFloat32)"),
    ("f32.lt",         "makeBinary(s, BinaryOp::LtFloat32)"),
    ("f32.gt",         "makeBinary(s, BinaryOp::GtFloat32)"),
    ("f32.le",         "makeBinary(s, BinaryOp::LeFloat32)"),
    ("f32.ge",         "makeBinary(s, BinaryOp::GeFloat32)"),
    ("f64.eq",         "makeBinary(s, BinaryOp::EqFloat64)"),
    ("f64.ne",         "makeBinary(s, BinaryOp::NeFloat64)"),
    ("f64.lt",         "makeBinary(s, BinaryOp::LtFloat64)"),
    ("f64.gt",         "makeBinary(s, BinaryOp::GtFloat64)"),
    ("f64.le",         "makeBinary(s, BinaryOp::LeFloat64)"),
    ("f64.ge",         "makeBinary(s, BinaryOp::GeFloat64)"),
    ("i32.clz",        "makeUnary(s, UnaryOp::ClzInt32)"),
    ("i32.ctz",        "makeUnary(s, UnaryOp::CtzInt32)"),
    ("i32.popcnt",     "makeUnary(s, UnaryOp::PopcntInt32)"),
    ("i32.add",        "makeBinary(s, BinaryOp::AddInt32)"),
    ("i32.sub",        "makeBinary(s, BinaryOp::SubInt32)"),
    ("i32.mul",        "makeBinary(s, BinaryOp::MulInt32)"),
    ("i32.div_s",      "makeBinary(s, BinaryOp::DivSInt32)"),
    ("i32.div_u",      "makeBinary(s, BinaryOp::DivUInt32)"),
    ("i32.rem_s",      "makeBinary(s, BinaryOp::RemSInt32)"),
    ("i32.rem_u",      "makeBinary(s, BinaryOp::RemUInt32)"),
    ("i32.and",        "makeBinary(s, BinaryOp::AndInt32)"),
    ("i32.or",         "makeBinary(s, BinaryOp::OrInt32)"),
    ("i32.xor",        "makeBinary(s, BinaryOp::XorInt32)"),
    ("i32.shl",        "makeBinary(s, BinaryOp::ShlInt32)"),
    ("i32.shr_s",      "makeBinary(s, BinaryOp::ShrSInt32)"),
    ("i32.shr_u",      "makeBinary(s, BinaryOp::ShrUInt32)"),
    ("i32.rotl",       "makeBinary(s, BinaryOp::RotLInt32)"),
    ("i32.rotr",       "makeBinary(s, BinaryOp::RotRInt32)"),
    ("i64.clz",        "makeUnary(s, UnaryOp::ClzInt64)"),
    ("i64.ctz",        "makeUnary(s, UnaryOp::CtzInt64)"),
    ("i64.popcnt",     "makeUnary(s, UnaryOp::PopcntInt64)"),
    ("i64.add",        "makeBinary(s, BinaryOp::AddInt64)"),
    ("i64.sub",        "makeBinary(s, BinaryOp::SubInt64)"),
    ("i64.mul",        "makeBinary(s, BinaryOp::MulInt64)"),
    ("i64.div_s",      "makeBinary(s, BinaryOp::DivSInt64)"),
    ("i64.div_u",      "makeBinary(s, BinaryOp::DivUInt64)"),
    ("i64.rem_s",      "makeBinary(s, BinaryOp::RemSInt64)"),
    ("i64.rem_u",      "makeBinary(s, BinaryOp::RemUInt64)"),
    ("i64.and",        "makeBinary(s, BinaryOp::AndInt64)"),
    ("i64.or",         "makeBinary(s, BinaryOp::OrInt64)"),
    ("i64.xor",        "makeBinary(s, BinaryOp::XorInt64)"),
    ("i64.shl",        "makeBinary(s, BinaryOp::ShlInt64)"),
    ("i64.shr_s",      "makeBinary(s, BinaryOp::ShrSInt64)"),
    ("i64.shr_u",      "makeBinary(s, BinaryOp::ShrUInt64)"),
    ("i64.rotl",       "makeBinary(s, BinaryOp::RotLInt64)"),
    ("i64.rotr",       "makeBinary(s, BinaryOp::RotRInt64)"),
    ("f32.abs",        "makeUnary(s, UnaryOp::AbsFloat32)"),
    ("f32.neg",        "makeUnary(s, UnaryOp::NegFloat32)"),
    ("f32.ceil",       "makeUnary(s, UnaryOp::CeilFloat32)"),
    ("f32.floor",      "makeUnary(s, UnaryOp::FloorFloat32)"),
    ("f32.trunc",      "makeUnary(s, UnaryOp::TruncFloat32)"),
    ("f32.nearest",    "makeUnary(s, UnaryOp::NearestFloat32)"),
    ("f32.sqrt",       "makeUnary(s, UnaryOp::SqrtFloat32)"),
    ("f32.add",        "makeBinary(s, BinaryOp::AddFloat32)"),
    ("f32.sub",        "makeBinary(s, BinaryOp::SubFloat32)"),
    ("f32.mul",        "makeBinary(s, BinaryOp::MulFloat32)"),
    ("f32.div",        "makeBinary(s, BinaryOp::DivFloat32)"),
    ("f32.min",        "makeBinary(s, BinaryOp::MinFloat32)"),
    ("f32.max",        "makeBinary(s, BinaryOp::MaxFloat32)"),
    ("f32.copysign",   "makeBinary(s, BinaryOp::CopySignFloat32)"),
    ("f64.abs",        "makeUnary(s, UnaryOp::AbsFloat64)"),
    ("f64.neg",        "makeUnary(s, UnaryOp::NegFloat64)"),
    ("f64.ceil",       "makeUnary(s, UnaryOp::CeilFloat64)"),
    ("f64.floor",      "makeUnary(s, UnaryOp::FloorFloat64)"),
    ("f64.trunc",      "makeUnary(s, UnaryOp::TruncFloat64)"),
    ("f64.nearest",    "makeUnary(s, UnaryOp::NearestFloat64)"),
    ("f64.sqrt",       "makeUnary(s, UnaryOp::SqrtFloat64)"),
    ("f64.add",        "makeBinary(s, BinaryOp::AddFloat64)"),
    ("f64.sub",        "makeBinary(s, BinaryOp::SubFloat64)"),
    ("f64.mul",        "makeBinary(s, BinaryOp::MulFloat64)"),
    ("f64.div",        "makeBinary(s, BinaryOp::DivFloat64)"),
    ("f64.min",        "makeBinary(s, BinaryOp::MinFloat64)"),
    ("f64.max",        "makeBinary(s, BinaryOp::MaxFloat64)"),
    ("f64.copysign",   "makeBinary(s, BinaryOp::CopySignFloat64)"),
    ("i32.wrap/i64",   "makeUnary(s, UnaryOp::WrapInt64)"),
    ("i32.trunc_s/f32",     "makeUnary(s, UnaryOp::TruncSFloat32ToInt32)"),
    ("i32.trunc_u/f32",     "makeUnary(s, UnaryOp::TruncUFloat32ToInt32)"),
    ("i32.trunc_s/f64",     "makeUnary(s, UnaryOp::TruncSFloat64ToInt32)"),
    ("i32.trunc_u/f64",     "makeUnary(s, UnaryOp::TruncUFloat64ToInt32)"),
    ("i64.extend_s/i32",    "makeUnary(s, UnaryOp::ExtendSInt32)"),
    ("i64.extend_u/i32",    "makeUnary(s, UnaryOp::ExtendUInt32)"),
    ("i64.trunc_s/f32",     "makeUnary(s, UnaryOp::TruncSFloat32ToInt64)"),
    ("i64.trunc_u/f32",     "makeUnary(s, UnaryOp::TruncUFloat32ToInt64)"),
    ("i64.trunc_s/f64",     "makeUnary(s, UnaryOp::TruncSFloat64ToInt64)"),
    ("i64.trunc_u/f64",     "makeUnary(s, UnaryOp::TruncUFloat64ToInt64)"),
    ("f32.convert_s/i32",   "makeUnary(s, UnaryOp::ConvertSInt32ToFloat32)"),
    ("f32.convert_u/i32",   "makeUnary(s, UnaryOp::ConvertUInt32ToFloat32)"),
    ("f32.convert_s/i64",   "makeUnary(s, UnaryOp::ConvertSInt64ToFloat32)"),
    ("f32.convert_u/i64",   "makeUnary(s, UnaryOp::ConvertUInt64ToFloat32)"),
    ("f32.demote/f64",      "makeUnary(s, UnaryOp::DemoteFloat64)"),
    ("f64.convert_s/i32",   "makeUnary(s, UnaryOp::ConvertSInt32ToFloat64)"),
    ("f64.convert_u/i32",   "makeUnary(s, UnaryOp::ConvertUInt32ToFloat64)"),
    ("f64.convert_s/i64",   "makeUnary(s, UnaryOp::ConvertSInt64ToFloat64)"),
    ("f64.convert_u/i64",   "makeUnary(s, UnaryOp::ConvertUInt64ToFloat64)"),
    ("f64.promote/f32",     "makeUnary(s, UnaryOp::PromoteFloat32)"),
    ("i32.reinterpret/f32", "makeUnary(s, UnaryOp::ReinterpretFloat32)"),
    ("i64.reinterpret/f64", "makeUnary(s, UnaryOp::ReinterpretFloat64)"),
    ("f32.reinterpret/i32", "makeUnary(s, UnaryOp::ReinterpretInt32)"),
    ("f64.reinterpret/i64", "makeUnary(s, UnaryOp::ReinterpretInt64)"),
    ("i32.extend8_s",       "makeUnary(s, UnaryOp::ExtendS8Int32)"),
    ("i32.extend16_s",      "makeUnary(s, UnaryOp::ExtendS16Int32)"),
    ("i64.extend8_s",       "makeUnary(s, UnaryOp::ExtendS8Int64)"),
    ("i64.extend16_s",      "makeUnary(s, UnaryOp::ExtendS16Int64)"),
    ("i64.extend32_s",      "makeUnary(s, UnaryOp::ExtendS32Int64)"),
    # atomic instructions
    ("wake",             "makeAtomicWake(s)"),
    ("i32.wait",         "makeAtomicWait(s, i32)"),
    ("i64.wait",         "makeAtomicWait(s, i64)"),
    ("i32.atomic.load8_u",      "makeLoad(s, i32, /*isAtomic=*/true)"),
    ("i32.atomic.load16_u",     "makeLoad(s, i32, /*isAtomic=*/true)"),
    ("i32.atomic.load",         "makeLoad(s, i32, /*isAtomic=*/true)"),
    ("i64.atomic.load8_u",      "makeLoad(s, i64, /*isAtomic=*/true)"),
    ("i64.atomic.load16_u",     "makeLoad(s, i64, /*isAtomic=*/true)"),
    ("i64.atomic.load32_u",     "makeLoad(s, i64, /*isAtomic=*/true)"),
    ("i64.atomic.load",         "makeLoad(s, i64, /*isAtomic=*/true)"),
    ("i32.atomic.store8",       "makeStore(s, i32, /*isAtomic=*/true)"),
    ("i32.atomic.store16",      "makeStore(s, i32, /*isAtomic=*/true)"),
    ("i32.atomic.store",        "makeStore(s, i32, /*isAtomic=*/true)"),
    ("i64.atomic.store8",       "makeStore(s, i64, /*isAtomic=*/true)"),
    ("i64.atomic.store16",      "makeStore(s, i64, /*isAtomic=*/true)"),
    ("i64.atomic.store32",      "makeStore(s, i64, /*isAtomic=*/true)"),
    ("i64.atomic.store",        "makeStore(s, i64, /*isAtomic=*/true)"),
    ("i32.atomic.rmw8_u.add",   "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i32.atomic.rmw16_u.add",  "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i32.atomic.rmw.add",      "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i64.atomic.rmw8_u.add",   "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw16_u.add",  "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw32_u.add",  "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw.add",      "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i32.atomic.rmw8_u.sub",   "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i32.atomic.rmw16_u.sub",  "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i32.atomic.rmw.sub",      "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i64.atomic.rmw8_u.sub",   "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw16_u.sub",  "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw32_u.sub",  "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw.sub",      "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i32.atomic.rmw8_u.and",   "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i32.atomic.rmw16_u.and",  "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i32.atomic.rmw.and",      "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i64.atomic.rmw8_u.and",   "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw16_u.and",  "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw32_u.and",  "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw.and",      "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i32.atomic.rmw8_u.or",    "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i32.atomic.rmw16_u.or",   "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i32.atomic.rmw.or",       "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i64.atomic.rmw8_u.or",    "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw16_u.or",   "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw32_u.or",   "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw.or",       "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i32.atomic.rmw8_u.xor",   "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i32.atomic.rmw16_u.xor",  "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i32.atomic.rmw.xor",      "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i64.atomic.rmw8_u.xor",   "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw16_u.xor",  "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw32_u.xor",  "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw.xor",      "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i32.atomic.rmw8_u.xchg",  "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i32.atomic.rmw16_u.xchg", "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i32.atomic.rmw.xchg",     "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i64.atomic.rmw8_u.xchg",  "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw16_u.xchg", "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw32_u.xchg", "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw.xchg",     "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i32.atomic.rmw8_u.cmpxchg",  "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i32.atomic.rmw16_u.cmpxchg", "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i32.atomic.rmw.cmpxchg",     "makeAtomicRMWOrCmpxchg(s, i32)"),
    ("i64.atomic.rmw8_u.cmpxchg",  "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw16_u.cmpxchg", "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw32_u.cmpxchg", "makeAtomicRMWOrCmpxchg(s, i64)"),
    ("i64.atomic.rmw.cmpxchg",     "makeAtomicRMWOrCmpxchg(s, i64)")
]


class CodePrinter:
  indents = 0

  def __enter__(self):
    CodePrinter.indents += 1

  def __exit__(self, *args):
    CodePrinter.indents -= 1

  def indent(self):
    # call in a 'with' statement
    return self

  def print_line(self, line):
    print("  " * CodePrinter.indents + line)


class Node:
  def __init__(self, expr=None, children=None, inst=None):
    # the expression to return if this is the string has ended
    self.expr = expr
    # map unique strings to children nodes
    self.children = children if children else {}
    # full instruction leading to this node
    self.inst = inst

  def _common_prefix(a, b):
    """Return the common prefix of two strings."""
    prefix = []
    while a and b and a[0] == b[0]:
      prefix.append(a[0])
      a = a[1:]
      b = b[1:]
    return "".join(prefix)

  def do_insert(self, full_inst, inst, expr):
    if inst is "":
      assert self.expr is None, "Repeated instruction"
      self.expr = expr
      self.inst = full_inst
      return
    # find key with shared prefix
    prefix, key = "", None
    for k in self.children:
      prefix = Node._common_prefix(inst, k)
      if prefix is not "":
        key = k
        break
    if key is None:
      # unique prefix, insert and stop
      self.children[inst] = Node(expr, inst=full_inst)
      return
    key_remainder = key[len(prefix):]
    if key_remainder is not "":
      # split key and move everything after the prefix to a new node
      child = self.children.pop(key)
      self.children[prefix] = Node(children={key_remainder: child})
      # update key for recursive insert
      key = prefix
    # chop off prefix and recurse
    self.children[key].do_insert(full_inst, inst[len(key):], expr)

  def insert(self, inst, expr):
    self.do_insert(inst, inst, expr)


def instruction_parser():
  """Build a trie out of all the instructions, then emit it as C++ code."""
  trie = Node()
  inst_length = 0
  for inst, expr in instructions:
    inst_length = max(inst_length, len(inst))
    trie.insert(inst, expr)

  printer = CodePrinter()

  printer.print_line("char op[{}] = {{'\\0'}};".format(inst_length + 1))
  printer.print_line("strncpy(op, s[0]->c_str(), {});".format(inst_length))

  def print_leaf(expr, inst):
    printer.print_line("if (strcmp(op, \"{inst}\") == 0) return {expr};"
                       .format(inst=inst, expr=expr))
    printer.print_line("goto parse_error;")

  def emit(node, idx=0):
    assert node.children
    printer.print_line("switch (op[{}]) {{".format(idx))
    with printer.indent():
      if node.expr:
        printer.print_line("case '\\0':")
        with printer.indent():
          print_leaf(node.expr, node.inst)
      children = sorted(node.children.items(), key=lambda pair: pair[0])
      for prefix, child in children:
        if child.children:
          printer.print_line("case '{}': {{".format(prefix[0]))
          with printer.indent():
            emit(child, idx + len(prefix))
          printer.print_line("}")
        else:
          assert child.expr
          printer.print_line("case '{}':".format(prefix[0]))
          with printer.indent():
            print_leaf(child.expr, child.inst)
      printer.print_line("default: goto parse_error;")
    printer.print_line("}")

  emit(trie)
  printer.print_line("parse_error:")
  with printer.indent():
    printer.print_line("throw ParseException(std::string(op));")


def print_header():
  print("// DO NOT EDIT! This file generated by scripts/gen-s-parser.py\n")


def generate_with_guard(generator, guard):
  print("#ifdef {}".format(guard))
  print("#undef {}".format(guard))
  generator()
  print("#endif // {}".format(guard))


def main():
  print_header()
  generate_with_guard(instruction_parser, "INSTRUCTION_PARSER")


if __name__ == "__main__":
  main()
