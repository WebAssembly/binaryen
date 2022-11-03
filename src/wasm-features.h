/*
 * Copyright 2019 WebAssembly Community Group participants
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

#ifndef wasm_features_h
#define wasm_features_h

#include <stdint.h>
#include <string>

#include "compiler-support.h"
#include "support/utilities.h"

namespace wasm {

struct FeatureSet {
  enum Feature : uint32_t {
    None = 0,
    Atomics = 1 << 0,
    MutableGlobals = 1 << 1,
    TruncSat = 1 << 2,
    SIMD = 1 << 3,
    BulkMemory = 1 << 4,
    SignExt = 1 << 5,
    ExceptionHandling = 1 << 6,
    TailCall = 1 << 7,
    ReferenceTypes = 1 << 8,
    Multivalue = 1 << 9,
    GC = 1 << 10,
    Memory64 = 1 << 11,
    // TODO: Remove this feature when the wasm spec stabilizes.
    GCNNLocals = 1 << 12,
    RelaxedSIMD = 1 << 13,
    ExtendedConst = 1 << 14,
    Strings = 1 << 15,
    MultiMemories = 1 << 16,
    MVP = None,
    // Keep in sync with llvm default features:
    // https://github.com/llvm/llvm-project/blob/c7576cb89d6c95f03968076e902d3adfd1996577/clang/lib/Basic/Targets/WebAssembly.cpp#L150-L153
    Default = SignExt | MutableGlobals,
    // GCNNLocals are opt-in: merely asking for "All" does not apply them. To
    // get all possible values use AllPossible. See setAll() below for more
    // details.
    All = ((1 << 17) - 1) & ~GCNNLocals,
    AllPossible = (1 << 17) - 1,
  };

  static std::string toString(Feature f) {
    switch (f) {
      case Atomics:
        return "threads";
      case MutableGlobals:
        return "mutable-globals";
      case TruncSat:
        return "nontrapping-float-to-int";
      case SIMD:
        return "simd";
      case BulkMemory:
        return "bulk-memory";
      case SignExt:
        return "sign-ext";
      case ExceptionHandling:
        return "exception-handling";
      case TailCall:
        return "tail-call";
      case ReferenceTypes:
        return "reference-types";
      case Multivalue:
        return "multivalue";
      case GC:
        return "gc";
      case Memory64:
        return "memory64";
      case GCNNLocals:
        return "gc-nn-locals";
      case RelaxedSIMD:
        return "relaxed-simd";
      case ExtendedConst:
        return "extended-const";
      case Strings:
        return "strings";
      case MultiMemories:
        return "multi-memories";
      default:
        WASM_UNREACHABLE("unexpected feature");
    }
  }

  std::string toString() const {
    std::string ret;
    uint32_t x = 1;
    while (x & Feature::AllPossible) {
      if (features & x) {
        if (!ret.empty()) {
          ret += ", ";
        }
        ret += toString(Feature(x));
      }
      x <<= 1;
    }
    return ret;
  }

  FeatureSet() : features(None) {}
  FeatureSet(uint32_t features) : features(features) {}
  operator uint32_t() const { return features; }

  bool isMVP() const { return features == MVP; }
  bool has(FeatureSet f) const { return (features & f) == f.features; }
  bool hasAtomics() const { return (features & Atomics) != 0; }
  bool hasMutableGlobals() const { return (features & MutableGlobals) != 0; }
  bool hasTruncSat() const { return (features & TruncSat) != 0; }
  bool hasSIMD() const { return (features & SIMD) != 0; }
  bool hasBulkMemory() const { return (features & BulkMemory) != 0; }
  bool hasSignExt() const { return (features & SignExt) != 0; }
  bool hasExceptionHandling() const {
    return (features & ExceptionHandling) != 0;
  }
  bool hasTailCall() const { return (features & TailCall) != 0; }
  bool hasReferenceTypes() const { return (features & ReferenceTypes) != 0; }
  bool hasMultivalue() const { return (features & Multivalue) != 0; }
  bool hasGC() const { return (features & GC) != 0; }
  bool hasMemory64() const { return (features & Memory64) != 0; }
  bool hasGCNNLocals() const { return (features & GCNNLocals) != 0; }
  bool hasRelaxedSIMD() const { return (features & RelaxedSIMD) != 0; }
  bool hasExtendedConst() const { return (features & ExtendedConst) != 0; }
  bool hasStrings() const { return (features & Strings) != 0; }
  bool hasMultiMemories() const { return (features & MultiMemories) != 0; }
  bool hasAll() const { return (features & AllPossible) != 0; }

  void set(FeatureSet f, bool v = true) {
    features = v ? (features | f) : (features & ~f);
  }
  void setAtomics(bool v = true) { set(Atomics, v); }
  void setMutableGlobals(bool v = true) { set(MutableGlobals, v); }
  void setTruncSat(bool v = true) { set(TruncSat, v); }
  void setSIMD(bool v = true) { set(SIMD, v); }
  void setBulkMemory(bool v = true) { set(BulkMemory, v); }
  void setSignExt(bool v = true) { set(SignExt, v); }
  void setExceptionHandling(bool v = true) { set(ExceptionHandling, v); }
  void setTailCall(bool v = true) { set(TailCall, v); }
  void setReferenceTypes(bool v = true) { set(ReferenceTypes, v); }
  void setMultivalue(bool v = true) { set(Multivalue, v); }
  void setGC(bool v = true) { set(GC, v); }
  void setMemory64(bool v = true) { set(Memory64, v); }
  void setGCNNLocals(bool v = true) { set(GCNNLocals, v); }
  void setRelaxedSIMD(bool v = true) { set(RelaxedSIMD, v); }
  void setExtendedConst(bool v = true) { set(ExtendedConst, v); }
  void setStrings(bool v = true) { set(Strings, v); }
  void setMultiMemories(bool v = true) { set(MultiMemories, v); }
  void setMVP() { features = MVP; }
  void setAll() {
    // Do not set GCNNLocals, which forces the user to opt in to that feature
    // explicitly. That is, wasm-opt -all will enable GC but *not* enable
    // non-nullable locals. To get them, do wasm-opt -all --enable-gc-nn-locals
    // FIXME: When the wasm spec stabilizes, this feature will go away, as the
    //        non-nullable locals experiment will either become the standard,
    //        or it will go away.
    // Leave the old GCNNLocals value unmodified. This makes things like
    // --enable-gc-nn-locals -all work (that is, if we enable the feature,
    // then -all does not disable it; it simply does not enable it by itself).
    auto oldGCNNLocals = hasGCNNLocals();
    features = AllPossible;
    setGCNNLocals(oldGCNNLocals);
  }

  void enable(const FeatureSet& other) { features |= other.features; }
  void disable(const FeatureSet& other) {
    features = features & ~other.features & AllPossible;
  }

  template<typename F> void iterFeatures(F f) const {
    for (uint32_t feature = MVP + 1; feature < AllPossible; feature <<= 1) {
      if (has(feature)) {
        f(static_cast<Feature>(feature));
      }
    }
  }

  bool operator<=(const FeatureSet& other) const {
    return !(features & ~other.features);
  }

  bool operator==(const FeatureSet& other) const {
    return *this <= other && other <= *this;
  }

  bool operator!=(const FeatureSet& other) const { return !(*this == other); }

  FeatureSet& operator|=(const FeatureSet& other) {
    features |= other.features;
    return *this;
  }

  uint32_t features;
};

} // namespace wasm

#endif // wasm_features_h
