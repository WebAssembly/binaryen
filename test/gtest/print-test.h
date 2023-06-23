#include <iostream>

#include "support/colors.h"
#include "wasm-s-parser.h"
#include "wasm.h"
#include "gtest/gtest.h"

#ifndef wasm_test_gtest_print_test_h
#define wasm_test_gtest_print_test_h

// Helper test fixture for parsing wast and checking some printed output.
class PrintTest : public ::testing::Test {
  bool colors = Colors::isEnabled();

public:
  PrintTest() { Colors::setEnabled(false); }

protected:
  void TearDown() override { Colors::setEnabled(colors); }

  void parseWast(wasm::Module& wasm, const std::string& wast) {
    wasm::SExpressionParser parser(wast.c_str());
    wasm::SExpressionWasmBuilder builder(
      wasm, *(*parser.root)[0], wasm::IRProfile::Normal);
  }
};

#endif
