"""Replicates CMake logic to generate WasmIntrinsics.cpp."""

from typing import Sequence
from absl import app


def main(argv: Sequence[str]) -> None:
  if len(argv) != 4:
    raise app.UsageError(
        'Usage: {} INPUT_FILE TEMPLATE_FILE OUTPUT_FILE'.format(argv[0]))

  with open(argv[1], 'rb') as input_file, \
      open(argv[2], 'r') as template_file, \
      open(argv[3], 'w') as output_file:

    raw_input_data = input_file.read()
    input_data = ','.join(str(ch) for ch in raw_input_data) + ',0'

    template_string = template_file.read()
    template_string = template_string.replace('@WASM_INTRINSICS_SIZE@',
                                              str(len(raw_input_data) + 1))
    template_string = template_string.replace('@WASM_INTRINSICS_EMBED@',
                                              input_data)

    output_file.write(template_string)


if __name__ == '__main__':
  app.run(main)

