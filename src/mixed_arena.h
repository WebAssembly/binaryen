
#include <vector>

//
// Arena allocation for mixed-type data.
//

struct MixedArena {
  std::vector<char*> chunks;
  int index; // in last chunk

  template<class T>
  T* alloc() {
    const size_t CHUNK = 10000;
    size_t currSize = (sizeof(T) + 7) & (-8); // same alignment as malloc TODO optimize?
    assert(currSize < CHUNK);
    if (chunks.size() == 0 || index + currSize >= CHUNK) {
      chunks.push_back(new char[CHUNK]);
      index = 0;
    }
    T* ret = (T*)(chunks.back() + index);
    index += currSize;
    new (ret) T();
    return ret;
  }

  void clear() {
    for (char* chunk : chunks) {
      delete[] chunk;
    }
    chunks.clear();
  }

  ~MixedArena() {
    clear();
  }
};

