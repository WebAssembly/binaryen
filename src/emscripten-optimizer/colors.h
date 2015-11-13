#include <unistd.h>
#include <cstdlib>
#include <ostream>

namespace Colors {
  inline bool use() {
    return (getenv("COLORS") && getenv("COLORS")[0] == '1') || // forced
           (isatty(STDOUT_FILENO) && (!getenv("COLORS") || getenv("COLORS")[0] != '0')); // implicit
  }

  inline void normal(std::ostream& stream) {
    if (!use()) return;
#if defined(__linux__) || defined(__apple__)
    stream << "\033[0m";
#endif
  }
  inline void red(std::ostream& stream) {
    if (!use()) return;
#if defined(__linux__) || defined(__apple__)
    stream << "\033[31m";
#endif
  }
  inline void magenta(std::ostream& stream) {
    if (!use()) return;
#if defined(__linux__) || defined(__apple__)
    stream << "\033[35m";
#endif
  }
  inline void orange(std::ostream& stream) {
    if (!use()) return;
#if defined(__linux__) || defined(__apple__)
    stream << "\033[33m";
#endif
  }
  inline void grey(std::ostream& stream) {
    if (!use()) return;
#if defined(__linux__) || defined(__apple__)
    stream << "\033[37m";
#endif
  }
  inline void green(std::ostream& stream) {
    if (!use()) return;
#if defined(__linux__) || defined(__apple__)
    stream << "\033[32m";
#endif
  }
  inline void blue(std::ostream& stream) {
    if (!use()) return;
#if defined(__linux__) || defined(__apple__)
    stream << "\033[34m";
#endif
  }
  inline void bold(std::ostream& stream) {
    if (!use()) return;
#if defined(__linux__) || defined(__apple__)
    stream << "\033[1m";
#endif
  }
};

