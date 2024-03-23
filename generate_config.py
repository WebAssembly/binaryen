"""Replicates CMake logic to generate WasmIntrinsics.cpp."""

from typing import Sequence
from absl import app


def main(argv: Sequence[str]) -> None:
    if len(argv) != 2:
        raise app.UsageError('Usage: {} OUTPUT_FILE'.format(argv[0]))

    with open(argv[1], 'w') as output_file:
        output_file.write("#define PROJECT_VERSION \"HEAD\"")


if __name__ == '__main__':
    app.run(main)
