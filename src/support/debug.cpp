/*
 * Copyright 2015 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "support/debug.h"
#include <execinfo.h>

#include <err.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>

// Adapted from:
//  http://spin.atomicobject.com/2013/01/13/exceptions-stack-traces-c/

namespace wasm {
const char *globalProgramName = nullptr;

#ifdef _WIN32
void setDebugSignalHandler(const char *programName) {}
#else
// Resolve symbol name and source location given the path to the executable
// and an address. For this to work you'll need to compile with:
//  on linux:   gcc -g
//  on OS X:    gcc -g -fno-pie
int addr2line(char const *const program_name, void const *const addr) {
  char cmd[512] = {0};
#ifdef __APPLE__
  sprintf(cmd, "atos -o %.256s %p", program_name, addr);
#else
  sprintf(cmd, "addr2line -f -p -e %.256s %p", program_name, addr);
#endif
  return system(cmd);
}

#define MAX_STACK_FRAMES 64
static void *stackTraces[MAX_STACK_FRAMES];

void printStackTrace(int offset = 5) {
  if (!globalProgramName) {
    printf("You must first call setDebugSignalHandler().\n");
    return;
  }
  int i, traceSize = 0;
  char **messages = (char **)nullptr;

  traceSize = backtrace(stackTraces, MAX_STACK_FRAMES);
  messages = backtrace_symbols(stackTraces, traceSize);
  
  // TODO: Call addr2line once with all the addresses, as it's much faster.
  // Skip the first couple stack frames (as they are this function and
  // our handler) and also skip the last frame as it's (always?) junk.
  for (i = offset; i < (traceSize - 1); ++i) {
    if (addr2line(globalProgramName, stackTraces[i]) != 0) {
      printf("  error determining line # for: %s\n", messages[i]);
    }
  }
  if (messages) {
    free(messages);
  }
}

void signalHandler(int sig, siginfo_t *siginfo, void *context) {
  switch (sig) {
  case SIGSEGV:
    fputs("Caught SIGSEGV: Segmentation Fault\n", stderr);
    break;
  case SIGINT:
    fputs("Caught SIGINT: Interactive attention signal, (usually ctrl+c)\n",
          stderr);
    break;
  case SIGFPE:
    switch (siginfo->si_code) {
    case FPE_INTDIV:
      fputs("Caught SIGFPE: (integer divide by zero)\n", stderr);
      break;
    case FPE_INTOVF:
      fputs("Caught SIGFPE: (integer overflow)\n", stderr);
      break;
    case FPE_FLTDIV:
      fputs("Caught SIGFPE: (floating-point divide by zero)\n", stderr);
      break;
    case FPE_FLTOVF:
      fputs("Caught SIGFPE: (floating-point overflow)\n", stderr);
      break;
    case FPE_FLTUND:
      fputs("Caught SIGFPE: (floating-point underflow)\n", stderr);
      break;
    case FPE_FLTRES:
      fputs("Caught SIGFPE: (floating-point inexact result)\n", stderr);
      break;
    case FPE_FLTINV:
      fputs("Caught SIGFPE: (floating-point invalid operation)\n", stderr);
      break;
    case FPE_FLTSUB:
      fputs("Caught SIGFPE: (subscript out of range)\n", stderr);
      break;
    default:
      fputs("Caught SIGFPE: Arithmetic Exception\n", stderr);
      break;
    }
  case SIGILL:
    switch (siginfo->si_code) {
    case ILL_ILLOPC:
      fputs("Caught SIGILL: (illegal opcode)\n", stderr);
      break;
    case ILL_ILLOPN:
      fputs("Caught SIGILL: (illegal operand)\n", stderr);
      break;
    case ILL_ILLADR:
      fputs("Caught SIGILL: (illegal addressing mode)\n", stderr);
      break;
    case ILL_ILLTRP:
      fputs("Caught SIGILL: (illegal trap)\n", stderr);
      break;
    case ILL_PRVOPC:
      fputs("Caught SIGILL: (privileged opcode)\n", stderr);
      break;
    case ILL_PRVREG:
      fputs("Caught SIGILL: (privileged register)\n", stderr);
      break;
    case ILL_COPROC:
      fputs("Caught SIGILL: (coprocessor error)\n", stderr);
      break;
    case ILL_BADSTK:
      fputs("Caught SIGILL: (internal stack error)\n", stderr);
      break;
    default:
      fputs("Caught SIGILL: Illegal Instruction\n", stderr);
      break;
    }
    break;
  case SIGTERM:
    fputs("Caught SIGTERM: a termination request was sent to the program\n",
          stderr);
    break;
  case SIGABRT:
    fputs("Caught SIGABRT: usually caused by an abort() or assert()\n", stderr);
    break;
  default:
    break;
  }
  printStackTrace();
  _Exit(1);
}

static uint8_t alternateStack[SIGSTKSZ];

void setDebugSignalHandler(const char *programName) {
  globalProgramName = programName;

  // Setup alternate stack.
  stack_t ss = {};
  // Malloc is usually used here, I'm not 100% sure my static allocation
  // is valid but it seems to work just fine.
  ss.ss_sp = (void *)alternateStack;
  ss.ss_size = SIGSTKSZ;
  ss.ss_flags = 0;

  if (sigaltstack(&ss, NULL) != 0) {
    err(1, "sigaltstack");
  }

  // Register our signal handlers.
  struct sigaction sig_action = {};
  sig_action.sa_sigaction = signalHandler;
  sigemptyset(&sig_action.sa_mask);

#ifdef __APPLE__
  // For some reason we backtrace() doesn't work on osx when we use an
  // alternate stack.
  sig_action.sa_flags = SA_SIGINFO;
#else
  sig_action.sa_flags = SA_SIGINFO | SA_ONSTACK;
#endif

  if (sigaction(SIGSEGV, &sig_action, NULL) != 0) {
    err(1, "sigaction");
  }
  if (sigaction(SIGFPE, &sig_action, NULL) != 0) {
    err(1, "sigaction");
  }
  if (sigaction(SIGINT, &sig_action, NULL) != 0) {
    err(1, "sigaction");
  }
  if (sigaction(SIGILL, &sig_action, NULL) != 0) {
    err(1, "sigaction");
  }
  if (sigaction(SIGTERM, &sig_action, NULL) != 0) {
    err(1, "sigaction");
  }
  if (sigaction(SIGABRT, &sig_action, NULL) != 0) {
    err(1, "sigaction");
  }
}
#endif
}