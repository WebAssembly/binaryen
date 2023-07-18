// This file began as an import from LLVM, and so it has the same license as
// LLVM, copied below together with the code.

//===- llvm/ADT/SuffixTreeNode.cpp - Nodes for SuffixTrees --------*- C++
//-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines nodes for use within a SuffixTree.
//
//===----------------------------------------------------------------------===//

#include "support/suffix_tree_node.h"
#include <cassert>

namespace wasm {

unsigned SuffixTreeNode::getStartIdx() const { return StartIdx; }
void SuffixTreeNode::incrementStartIdx(unsigned Inc) { StartIdx += Inc; }
void SuffixTreeNode::setConcatLen(unsigned Len) { ConcatLen = Len; }
unsigned SuffixTreeNode::getConcatLen() const { return ConcatLen; }

bool SuffixTreeInternalNode::isRoot() const {
  return getStartIdx() == EmptyIdx;
}
unsigned SuffixTreeInternalNode::getEndIdx() const { return EndIdx; }
void SuffixTreeInternalNode::setLink(SuffixTreeInternalNode* L) {
  assert(L && "Cannot set a null link?");
  Link = L;
}
SuffixTreeInternalNode* SuffixTreeInternalNode::getLink() const { return Link; }

unsigned SuffixTreeLeafNode::getEndIdx() const {
  assert(EndIdx && "EndIdx is empty?");
  return *EndIdx;
}

unsigned SuffixTreeLeafNode::getSuffixIdx() const { return SuffixIdx; }
void SuffixTreeLeafNode::setSuffixIdx(unsigned Idx) { SuffixIdx = Idx; }

} // namespace wasm
