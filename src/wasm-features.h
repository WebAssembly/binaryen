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

struct FeatureSet {
  enum Feature : uint32_t {
    MVP = 0,
    Atomics = 1 << 0,
    MutableGlobals = 1 << 1,
    TruncSat = 1 << 2,
    SIMD = 1 << 3,
    BulkMemory = 1 << 4,
    SignExt = 1 << 5,
    ExceptionHandling = 1 << 6,
    All = Atomics | MutableGlobals | TruncSat | SIMD | BulkMemory | SignExt |
          ExceptionHandling
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
      default:
        WASM_UNREACHABLE();
    }
  }

  FeatureSet() : features(MVP) {}
  FeatureSet(uint32_t features) : features(features) {}

  bool isMVP() const { return features == MVP; }
  bool has(Feature f) { return (features & f) == f; }
  bool hasAtomics() const { return features & Atomics; }
  bool hasMutableGlobals() const { return features & MutableGlobals; }
  bool hasTruncSat() const { return features & TruncSat; }
  bool hasSIMD() const { return features & SIMD; }
  bool hasBulkMemory() const { return features & BulkMemory; }
  bool hasSignExt() const { return features & SignExt; }
  bool hasExceptionHandling() const { return features & ExceptionHandling; }
  bool hasAll() const { return features & All; }

  void makeMVP() { features = MVP; }
  void set(Feature f, bool v = true) {
    features = v ? (features | f) : (features & ~f);
  }
  void setAtomics(bool v = true) { set(Atomics, v); }
  void setMutableGlobals(bool v = true) { set(MutableGlobals, v); }
  void setTruncSat(bool v = true) { set(TruncSat, v); }
  void setSIMD(bool v = true) { set(SIMD, v); }
  void setBulkMemory(bool v = true) { set(BulkMemory, v); }
  void setSignExt(bool v = true) { set(SignExt, v); }
  void setExceptionHandling(bool v = true) { set(ExceptionHandling, v); }
  void setAll(bool v = true) { features = v ? All : MVP; }

  void enable(const FeatureSet& other) { features |= other.features; }
  void disable(const FeatureSet& other) {
    features = features & ~other.features & All;
  }

  template<typename F> void iterFeatures(F f) {
    if (hasAtomics()) {
      f(Atomics);
    }
    if (hasBulkMemory()) {
      f(BulkMemory);
    }
    if (hasExceptionHandling()) {
      f(ExceptionHandling);
    }
    if (hasMutableGlobals()) {
      f(MutableGlobals);
    }
    if (hasTruncSat()) {
      f(TruncSat);
    }
    if (hasSignExt()) {
      f(SignExt);
    }
    if (hasSIMD()) {
      f(SIMD);
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

private:
  uint32_t features;
};

#endif // wasm_features_h
