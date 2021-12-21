#!/bin/bash

gcc -I../src wasi-stub.c -L../lib -lbinaryen -lpthread -o wasi-stub