/*
 * Copyright 2025 WebAssembly Community Group participants
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

#include "ir/module-utils.h"
#include "pass.h"
#include "support/file.h"
#include "support/json.h"
#include "wasm.h"

namespace wasm {

constexpr Index NodeTypeIndex = 0;
constexpr Index NodeNameIndex = 1;
constexpr Index NodeIdIndex = 2;
constexpr Index NodeSelfSizeIndex = 3;
constexpr Index NodeEdgeCountIndex = 4;
constexpr Index NodeDetachednessIndex = 5;
constexpr Index NodeFieldCount = 6;

constexpr Index EdgeTypeIndex = 0;
constexpr Index EdgeNameIndex = 1;
constexpr Index EdgeDestIndex = 2;
constexpr Index EdgeFieldCount = 3;

constexpr Index DisplayedTypesCount = 10;

struct Node {
  IString name;
  Index size;
  std::vector<Index> edges;
};

struct HeapSnapshotAnalysis : Pass {
  void run(Module* wasm) override {
    auto snapshotFile =
      getArgument("heap-snapshot-analysis",
                  "Heap snapshot analysis requires heap shapshot "
                  "file argument [--heap-snapshot-analysis=FILE]");
    auto snapshotData = read_file<std::vector<char>>(snapshotFile, Flags::Text);
    std::cout << "snapshot length " << snapshotData.size() << "\n";

    // TODO: We would prefer UTF-8.
    json::Value snapshot;
    snapshot.parse(snapshotData.data(), json::Value::StringEncoding::ASCII);

    std::cout << "parsed snapshot\n";

    validateSnapshotMeta(snapshot);
    auto nodes = getGraph(snapshot);

    Index totalHeapSize = 0;
    Index totalWasmHeapSize = 0;
    Index totalWasmAllocations = 0;
    std::unordered_map<IString, Index> heapSizeByType;
    std::unordered_map<IString, Index> allocationsByType;
    for (auto& node : nodes) {
      totalHeapSize += node.size;
      if (maybeGetWasmTypeIndex(node.name)) {
        totalWasmHeapSize += node.size;
        heapSizeByType[node.name] += node.size;
        ++totalWasmAllocations;
        ++allocationsByType[node.name];
      }
    }
    auto sortData = [](auto begin, auto end) {
      std::vector<std::pair<IString, Index>> pairs(begin, end);
      std::sort(pairs.begin(), pairs.end(), [](auto a, auto b) {
        if (a.second != b.second) {
          return a.second > b.second;
        }
        return a.first < b.first;
      });
      return pairs;
    };

    auto topTypesByHeapSize =
      sortData(heapSizeByType.begin(), heapSizeByType.end());
    auto topTypesByAllocations =
      sortData(allocationsByType.begin(), allocationsByType.end());

    std::cout << "total heap size is " << totalHeapSize << "\n";
    std::cout << "wasm heap size is " << totalWasmHeapSize << " ("
              << (double(totalWasmHeapSize) / double(totalHeapSize) * 100)
              << "%)\n";
    std::cout << "there are " << totalWasmAllocations
              << " wasm objects (average "
              << (double(totalWasmHeapSize) / double(totalWasmAllocations))
              << " bytes per object)\n";

    std::cout << "\ntop types by total heap size:\n";
    for (Index i = 0; i < DisplayedTypesCount; ++i) {
      if (i >= topTypesByHeapSize.size()) {
        break;
      }
      auto [name, size] = topTypesByHeapSize[i];
      std::cout << "  " << name << ": " << size << " bytes\n";
    }

    std::cout << "\ntop types by allocations:\n";
    for (Index i = 0; i < DisplayedTypesCount; ++i) {
      if (i >= topTypesByAllocations.size()) {
        break;
      }
      auto [name, allocs] = topTypesByAllocations[i];
      std::cout << "  " << name << ": " << allocs << " objects\n";
    }

    // Measure the savings of removing vtable pointers. Assume any object that
    // contains an edge to another object that contains an edge to a "system /
    // WasmFuncRef" contains a vtable pointer.
    IString funcrefName = "system / WasmFuncRef";
    std::unordered_set<Index> vtableIndices;
    for (Index i = 0; i < nodes.size(); ++i) {
      for (Index j = 0; j < nodes[i].edges.size(); ++j) {
        auto dest = nodes[i].edges[j];
        if (dest >= nodes.size()) {
          Fatal() << "Unexpected out-of-bounds edge (" << dest
                  << " >= " << nodes.size() << ")";
        }
        if (nodes[dest].name == funcrefName) {
          vtableIndices.insert(i);
          break;
        }
      }
    }
    Index objectsWithVtableCount = 0;
    for (Index i = 0; i < nodes.size(); ++i) {
      for (Index j = 0; j < nodes[i].edges.size(); ++j) {
        auto dest = nodes[i].edges[j];
        assert(dest < nodes.size());
        if (vtableIndices.count(dest)) {
          ++objectsWithVtableCount;
          break;
        }
      }
    }

    Index vtableSavings = objectsWithVtableCount * 4;
    std::cout << "\nRemoving vtable fields would save " << vtableSavings
              << " bytes ("
              << (double(vtableSavings) / double(totalWasmHeapSize) * 100)
              << "% wasm heap, "
              << (double(vtableSavings) / double(totalHeapSize) * 100)
              << "% total heap)\n";
  }

  void validateSnapshotMeta(json::Value& snapshotRoot) {
    auto snapshot = snapshotRoot.maybeGet("snapshot");
    if (!snapshot) {
      Fatal() << "Expected .snapshot to exist";
    }

    auto meta = snapshot->maybeGet("meta");
    if (!meta) {
      Fatal() << "Expected .snapshot.meta to exist";
    }

    validateNodeFields(meta);
    validateEdgeFields(meta);
  }

  void validateNodeFields(json::Ref& meta) {
    auto nodeFields = meta->maybeGet("node_fields");
    if (!nodeFields) {
      Fatal() << "Expected .snapshot.meta.node_fields to exist";
    }
    if (!nodeFields->isArray()) {
      Fatal() << "Expected .snapshot.meta.node_fields to be an array";
    }

    auto& nodeFieldsArray = nodeFields->getArray();

    auto expectNodeField = [&](unsigned i, IString field) {
      if (nodeFieldsArray.size() <= i || !nodeFieldsArray[i]->isString() ||
          nodeFieldsArray[i]->getIString() != field) {
        Fatal() << "Expected .snapshot.meta.node_fields[" << i << "] to be \""
                << field << '"';
      }
    };

    expectNodeField(NodeTypeIndex, "type");
    expectNodeField(NodeNameIndex, "name");
    expectNodeField(NodeIdIndex, "id");
    expectNodeField(NodeSelfSizeIndex, "self_size");
    expectNodeField(NodeEdgeCountIndex, "edge_count");
    expectNodeField(NodeDetachednessIndex, "detachedness");
    if (nodeFieldsArray.size() != NodeFieldCount) {
      Fatal() << "Unexpected fields in .snapshot.meta.node_fields";
    }
  }

  void validateEdgeFields(json::Ref& meta) {
    json::Ref edgeFields = meta->maybeGet("edge_fields");
    if (!edgeFields) {
      Fatal() << "Expected .snapshot.meta.edge_fields to exist";
    }
    if (!edgeFields->isArray()) {
      Fatal() << "Expected .snapshot.meta.edge_fields to be an array";
    }

    auto& edgeFieldsArray = edgeFields->getArray();

    auto expectEdgeField = [&](unsigned i, IString field) {
      if (edgeFieldsArray.size() <= i || !edgeFieldsArray[i]->isString() ||
          edgeFieldsArray[i]->getIString() != field) {
        Fatal() << "Expected .snapshot.meta.edge_fields[" << i << "] to be \""
                << field << '"';
      }
    };

    expectEdgeField(EdgeTypeIndex, "type");
    expectEdgeField(EdgeNameIndex, "name_or_index");
    expectEdgeField(EdgeDestIndex, "to_node");
    if (edgeFieldsArray.size() != EdgeFieldCount) {
      Fatal() << "Unexpected fields in .snapshot.meta.edge_fields";
    }
  }

  std::vector<Node> getGraph(json::Value& snapshotRoot) {
    auto nodes = getNodes(snapshotRoot);
    auto edges = getEdges(snapshotRoot);
    auto strings = getStrings(snapshotRoot);

    if (nodes.size() % NodeFieldCount != 0) {
      Fatal() << "Expected length of .nodes to be a multiple of "
              << NodeFieldCount;
    }
    if (edges.size() % EdgeFieldCount != 0) {
      Fatal() << "Expected length of .edges to be a multiple of "
              << EdgeFieldCount;
    }

    std::vector<Node> results;
    Index currNode = 0, currEdge = 0;
    for (; currNode < nodes.size(); currNode += NodeFieldCount) {
      Index nameIndex = nodes[currNode + NodeNameIndex];
      if (nameIndex >= strings.size()) {
        Fatal() << "Node name index " << nameIndex
                << " is out of bounds at .nodes[" << (currNode + NodeNameIndex)
                << ']';
      }

      IString name = strings[nameIndex];
      Index size = nodes[currNode + NodeSelfSizeIndex];

      Index edgeCount = nodes[currNode + NodeEdgeCountIndex];
      Index edgeFieldCount = edgeCount * EdgeFieldCount;
      if (edgeFieldCount < edgeCount || edgeFieldCount > edges.size() ||
          currEdge > edges.size() - edgeFieldCount) {
        Fatal() << "Edge count " << edgeCount << " is out of bounds at .nodes["
                << (currNode + NodeEdgeCountIndex) << ']';
      }
      std::vector<Index> destinations;
      destinations.reserve(edgeCount);
      for (Index i = 0; i < edgeCount; ++i) {
        Index dest = edges[currEdge + EdgeDestIndex];
        if (dest % NodeFieldCount != 0) {
          Fatal() << "Expected to_node index to be a multiple of "
                  << NodeFieldCount << "\n";
        }
        dest /= NodeFieldCount;
        destinations.push_back(dest);
        currEdge += EdgeFieldCount;
      }
      results.emplace_back(Node{name, size, std::move(destinations)});
    }
    if (currEdge != edges.size()) {
      Fatal() << "Unexpected extra edges";
    }
    return results;
  }

  std::vector<Index> getNodes(json::Value& snapshotRoot) {
    auto nodes = snapshotRoot.maybeGet("nodes");
    if (!nodes) {
      Fatal() << "Expected .nodes to exist";
    }
    return getIndices(nodes, ".nodes");
  }

  std::vector<Index> getEdges(json::Value& snapshotRoot) {
    auto edges = snapshotRoot.maybeGet("edges");
    if (!edges) {
      Fatal() << "Expected .edges to exist";
    }
    return getIndices(edges, ".edges");
  }

  std::vector<Index> getIndices(json::Ref& array, const char* name) {
    if (!array->isArray()) {
      Fatal() << "Expected " << name << " to be an array";
    }
    auto& refs = array->getArray();

    std::vector<Index> results;
    for (size_t i = 0; i < refs.size(); ++i) {
      if (!refs[i]->isNumber()) {
        Fatal() << "Expected " << name << "[" << i << "] to be a number";
      }
      // TODO: Bounds checks, etc.
      results.push_back(Index(refs[i]->getNumber()));
    }

    return results;
  }

  std::vector<IString> getStrings(json::Value& snapshotRoot) {
    auto strings = snapshotRoot.maybeGet("strings");
    if (!strings) {
      Fatal() << "Expected .strings to exist";
    }
    if (!strings->isArray()) {
      Fatal() << "Expected .strings to be an array";
    }
    auto& stringRefs = strings->getArray();

    std::vector<IString> results;
    for (size_t i = 0; i < stringRefs.size(); ++i) {
      if (!stringRefs[i]->isString()) {
        Fatal() << "Expected .strings[" << i << "] to be a string";
      }
      results.push_back(stringRefs[i]->getIString());
    }
    return results;
  }

  std::optional<Index> maybeGetWasmTypeIndex(IString name) {
    // Nodes for Wasm heap objects have names like `$canonNN (wasm)`. Parse
    // and return the NN as an index if the name matches that format.
    constexpr std::string_view prefix = "$canon";
    constexpr std::string_view suffix = " (wasm)";
    // TODO: Use C++20 `starts_with`
    if (name.str.substr(0, prefix.size()) != prefix) {
      return std::nullopt;
    }
    if (name.str.substr(name.str.size() - suffix.size()) != suffix) {
      return std::nullopt;
    }
    size_t count = name.str.size() - prefix.size() - suffix.size();
    std::string_view index = name.str.substr(prefix.size(), count);
    Index result = 0;
    for (char c : index) {
      if (!std::isdigit(c)) {
        return std::nullopt;
      }
      result = result * 10 + (c - '0');
    }
    return result;
  }
};

Pass* createHeapSnapshotAnalysisPass() { return new HeapSnapshotAnalysis(); }

} // namespace wasm
