#include <iostream>

#include "support/sparse_square_matrix.h"

int main() {
  sparse_square_matrix<uint32_t> m;

  // New matrix should initialize to 0x0 size.
  assert(m.width() == 0);

  // Recreating should resize the matrix.
  m.recreate(100);
  assert(m.width() == 100);

  // Small matrices should use dense storage.
  assert(m.usingDenseStorage());

  // Setting and getting element values in dense storage should work.
  for (int y = 0; y < 100; ++y)
    for (int x = 0; x < 100; ++x)
      m.set(y, x, y * 100 + x);
  for (int y = 0; y < 100; ++y)
    for (int x = 0; x < 100; ++x)
      assert(m.get(y, x) == y * 100 + x);

  // Recreating should clear the matrix elements to zero,
  // even if recreating to same size as before.
  assert(m.width() == 100);
  m.recreate(100);
  for (int y = 0; y < 100; ++y)
    for (int x = 0; x < 100; ++x)
      assert(m.get(y, x) == 0);

  // Large matrices should use sparse storage.
  m.recreate(m.DenseLimit);
  assert(!m.usingDenseStorage());

  // Setting and getting element values in sparse storage should work.
  for (int y = 0; y < m.DenseLimit; y += 128)
    for (int x = 0; x < m.DenseLimit; x += 128)
      m.set(y, x, y * m.DenseLimit + x);
  for (int y = 0; y < m.DenseLimit; y += 128)
    for (int x = 0; x < m.DenseLimit; x += 128)
      assert(m.get(y, x) == y * m.DenseLimit + x);

  // Recreating matrix in sparse mode should reset values in sparse
  // storage to zero.
  m.recreate(m.DenseLimit + 1);
  for (int y = 0; y < m.width(); y += 128)
    for (int x = 0; x < m.width(); x += 128)
      assert(m.get(y, x) == 0);

  std::cout << "ok.\n";
}
