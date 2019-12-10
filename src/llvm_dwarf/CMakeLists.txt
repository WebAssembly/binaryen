# LLVM sources have warnings, ignore them.
foreach(variable CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
  if(NOT MSVC)
    set(${variable} "${${variable}} -w")
  else()
    set(${variable} "${${variable}} /w")
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
  Triple.cpp
  Twine.cpp
  UnicodeCaseFold.cpp
  WithColor.cpp
  YAMLParser.cpp # XXX needed?
  YAMLTraits.cpp
)
ADD_LIBRARY(llvm_dwarf OBJECT ${llvm_dwarf_SOURCES})
