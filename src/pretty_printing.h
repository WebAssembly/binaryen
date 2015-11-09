
//
// Pretty printing helpers
//

#include <ostream>

#include "colors.h"

std::ostream &doIndent(std::ostream &o, unsigned indent) {
  for (unsigned i = 0; i < indent; i++) {
    o << "  ";
  }
  return o;
}

std::ostream &incIndent(std::ostream &o, unsigned& indent) {
  o << '\n';
  indent++;
  return o; 
}

std::ostream &decIndent(std::ostream &o, unsigned& indent) {
  indent--;
  doIndent(o, indent);
  return o << ')';
}

std::ostream &prepareMajorColor(std::ostream &o) {
  Colors::red(o);
  Colors::bold(o);
  return o;
}

std::ostream &prepareColor(std::ostream &o) {
  Colors::magenta(o);
  Colors::bold(o);
  return o;
}

std::ostream &prepareMinorColor(std::ostream &o) {
  Colors::orange(o);
  return o;
}

std::ostream &restoreNormalColor(std::ostream &o) {
  Colors::normal(o);
  return o;
}

std::ostream& printText(std::ostream &o, const char *str) {
  o << '"';
  Colors::green(o);
  o << str;
  Colors::normal(o);
  return o << '"';
}

std::ostream& printOpening(std::ostream &o, const char *str, bool major=false) {
  o << '(';
  major ? prepareMajorColor(o) : prepareColor(o);
  o << str;
  restoreNormalColor(o);
  return o;
}

std::ostream& printMinorOpening(std::ostream &o, const char *str) {
  o << '(';
  prepareMinorColor(o);
  o << str;
  restoreNormalColor(o);
  return o;
}

