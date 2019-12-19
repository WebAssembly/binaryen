# LLVM sources have warnings, ignore them. Otherwise, use options as close
# as possible to LLVM's defaults.
foreach(variable CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
  if(NOT MSVC)
    set(${variable} "${${variable}} -w -std=c++14 -D_GNU_SOURCE -D_DEBUG -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS")
  else()
    set(${variable} "${${variable}} /w -std:c++14 -D_CRT_SECURE_NO_DEPRECATE -D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE -D_CRT_NONSTDC_NO_WARNINGS -D_SCL_SECURE_NO_DEPRECATE -D_SCL_SECURE_NO_WARNINGS -DUNICODE -D_UNICODE -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS")
  endif()
endforeach(variable)

SET(llvm_dwarf_SOURCES
  Binary.cpp
  ConvertUTF.cpp
  DataExtractor.cpp
  Debug.cpp
  DJB.cpp
  Dwarf.cpp
  dwarf2yaml.cpp
  DWARFAbbreviationDeclaration.cpp
  DWARFAcceleratorTable.cpp
  DWARFAddressRange.cpp
  DWARFCompileUnit.cpp
  DWARFContext.cpp
  DWARFDataExtractor.cpp
  DWARFDebugAbbrev.cpp
  DWARFDebugAddr.cpp
  DWARFDebugAranges.cpp
  DWARFDebugArangeSet.cpp
  DWARFDebugFrame.cpp
  DWARFDebugInfoEntry.cpp
  DWARFDebugLine.cpp
  DWARFDebugLoc.cpp
  DWARFDebugMacro.cpp
  DWARFDebugPubTable.cpp
  DWARFDebugRangeList.cpp
  DWARFDebugRnglists.cpp
  DWARFDie.cpp
  DWARFEmitter.cpp
  DWARFExpression.cpp
  DWARFFormValue.cpp
  DWARFGdbIndex.cpp
  DWARFListTable.cpp
  DWARFTypeUnit.cpp
  DWARFUnit.cpp
  DWARFUnitIndex.cpp
  DWARFVerifier.cpp
  DWARFVisitor.cpp
  DWARFYAML.cpp
  Error.cpp
  ErrorHandling.cpp
  FormatVariadic.cpp
  Hashing.cpp
  LEB128.cpp
  LineIterator.cpp
  MCRegisterInfo.cpp
  MD5.cpp
  MemoryBuffer.cpp
  NativeFormatting.cpp
  ObjectFile.cpp
  obj2yaml_Error.cpp
  Optional.cpp
  Path.cpp
  raw_ostream.cpp
  ScopedPrinter.cpp
  SmallVector.cpp
  SourceMgr.cpp 
  StringMap.cpp
  StringRef.cpp
  SymbolicFile.cpp
  Twine.cpp
  UnicodeCaseFold.cpp
  WithColor.cpp
  YAMLParser.cpp # XXX needed?
  YAMLTraits.cpp
)
ADD_LIBRARY(llvm_dwarf OBJECT ${llvm_dwarf_SOURCES})
