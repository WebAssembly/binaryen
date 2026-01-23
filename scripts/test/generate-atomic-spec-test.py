import enum
from dataclasses import dataclass
from enum import Enum

# Workaround for python <3.10, escape characters can't appear in f-strings.
# Although we require 3.10 in some places, the formatter complains without this.
newline = "\n"


def indent(s):
    return "\n".join(f"  {line}" if line else "" for line in s.split("\n"))


class ValueType(Enum):
    i32 = enum.auto()
    i64 = enum.auto()


class Ordering(Enum):
    seqcst = 0
    acqrel = 1


@dataclass
class Template:
    str: str
    value_type: object
    args: int


templates = [
    Template(str="(drop (i32.atomic.load %(memarg)s%(args)s))", value_type=ValueType.i32, args=1),
    Template(str="(drop (i64.atomic.load %(memarg)s%(args)s))", value_type=ValueType.i64, args=1),
    Template(str="(i32.atomic.store %(memarg)s%(args)s)", value_type=ValueType.i32, args=2),
    Template(str="(i64.atomic.store %(memarg)s%(args)s)", value_type=ValueType.i64, args=2),
]


def statement(template, mem_idx: str | None, ordering: Ordering | None):
    """Return a statement exercising the op in `template` e.g. (i32.atomic.store 1 acqrel (i64.const 42) (i32.const 42))"""
    memargs = []
    if mem_idx is not None:
        memargs.append(mem_idx)
    if ordering is not None:
        memargs.append(ordering.name)

    memarg_str = " ".join(memargs) + " " if memargs else ""
    idx_type = ValueType.i64 if mem_idx == "1" else ValueType.i32 if mem_idx == "0" else ValueType.i32

    # The first argument (the memory location) must match the memory that we're indexing. Other arguments match the op (e.g. i32 for i32.atomic.load).
    args = [f"({idx_type.name}.const 42)"] + [f"({template.value_type.name}.const 42)" for _ in range(template.args - 1)]
    return template.str % {"memarg": memarg_str, "args": " ".join(args)}


def func():
    """Return a func exercising all ops in `templates` e.g.
      (func $test-all-ops
        (drop (i32.atomic.load (i32.const 42)))
        (drop (i32.atomic.load acqrel (i32.const 42)))
        ...
      )
    """
    statements = [statement(template, mem_idx, ordering) for template in templates for mem_idx in [None, "0", "1"] for ordering in [None, Ordering.acqrel, Ordering.seqcst]]
    return f'''(func $test-all-ops
{indent(newline.join(statements))}
)'''


def text_test():
    """Return a (module ...) that exercises all ops in `templates`."""
    return f'''(module
  (memory i32 1 1)
  (memory i64 1 1)

{indent(func())}
)'''


def invalid_text_test():
    return '''(assert_invalid (module
  (memory 1 1 shared)

  (func $i32load (drop (i32.load acqrel (i32.const 51))))
) "Can't set memory ordering for non-atomic i32.load")'''


def main():
    print(text_test())
    print()
    print(invalid_text_test())


if __name__ == "__main__":
    main()
