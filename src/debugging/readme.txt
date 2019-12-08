This folder contains files from LLVM. See LICENSE.TXT for their license.

These files were synced from

commit 6c86d6efaf129c42d37121f1e7e9a7adffb54c1a (origin/master, master)
Author: Craig Topper <craig.topper@intel.com>
Date:   Mon Nov 11 16:30:42 2019 -0800

    [X86] Remove some else branches after checking for !useSoftFloat() that set operations to Expand.
    
    If we're using soft floats, then these operations shoudl be
    softened during type legalization. They'll never get to
    LegalizeVectorOps or LegalizeDAG so they don't need to be
    Expanded there.

Local changes in those files are marked with

  // XXX BINARYEN

