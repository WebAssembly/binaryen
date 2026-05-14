The Dhrystone benchmark: a popular benchmark for CPU/compiler performance
measurement. Description and sources available
[here](https://www.netlib.org/benchmark/dhry-c).

# Running the benchmark
Use the command `make benchmark` to run the benchmark.

This compares the performance of three builds of Dhrystone (1) Native (2) Wasm2c
(3) Wasm2C + Segue optimization. The Segue optimization is enabled only on
specific CPU+OS+Compiler combinations. If unsupported on your platform, builds
(2) and (3) above will be identical

# Sample output

```
Starting Dhrystone benchmark. (Smaller number is better)
Native
Microseconds for one run through Dhrystone: 0.011133
Wasm
Microseconds for one run through Dhrystone: 0.013670
Wasm+Segue
Microseconds for one run through Dhrystone: 0.008666
```