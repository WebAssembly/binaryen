	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/lower-em-ehsjlj-options.ll"
	.hidden	exception
	.globl	exception
	.type	exception,@function
exception:                              # @exception
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.store	__THREW__($pop8), $pop7
	i32.const	$push0=, foo@FUNCTION
	call    	__invoke_void@FUNCTION, $pop0
	i32.const	$push6=, 0
	i32.load	$0=, __THREW__($pop6)
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i32.store	__THREW__($pop5), $pop4
	block   	
	i32.const	$push1=, 1
	i32.ne  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %lpad
	i32.const	$push9=, 0
	i32.call	$push3=, __cxa_find_matching_catch_3@FUNCTION, $pop9
	i32.call	$drop=, __cxa_begin_catch@FUNCTION, $pop3
	call    	__cxa_end_catch@FUNCTION
.LBB0_2:                                # %try.cont
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	exception, .Lfunc_end0-exception

	.hidden	setjmp_longjmp
	.globl	setjmp_longjmp
	.type	setjmp_longjmp,@function
setjmp_longjmp:                         # @setjmp_longjmp
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push1=, 0
	i32.load	$push2=, __stack_pointer($pop1)
	i32.const	$push3=, 160
	i32.sub 	$push6=, $pop2, $pop3
	tee_local	$push5=, $0=, $pop6
	i32.store	__stack_pointer($pop4), $pop5
	i32.call	$drop=, setjmp@FUNCTION, $0
	i32.const	$push0=, 1
	call    	longjmp@FUNCTION, $0, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	setjmp_longjmp, .Lfunc_end1-setjmp_longjmp

	.globl	setThrew
	.type	setThrew,@function
setThrew:                               # @setThrew
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push1=, 0
	i32.load	$push0=, __THREW__($pop1)
	br_if   	0, $pop0        # 0: down to label1
# BB#1:                                 # %if.then
	i32.const	$push3=, 0
	i32.store	__threwValue($pop3), $1
	i32.const	$push2=, 0
	i32.store	__THREW__($pop2), $0
.LBB2_2:                                # %if.end
	end_block                       # label1:
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	setThrew, .Lfunc_end2-setThrew

	.globl	setTempRet0
	.type	setTempRet0,@function
setTempRet0:                            # @setTempRet0
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	__tempRet0($pop0), $0
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	setTempRet0, .Lfunc_end3-setTempRet0

	.type	__THREW__,@object       # @__THREW__
	.bss
	.globl	__THREW__
	.p2align	2
__THREW__:
	.int32	0                       # 0x0
	.size	__THREW__, 4

	.type	__threwValue,@object    # @__threwValue
	.globl	__threwValue
	.p2align	2
__threwValue:
	.int32	0                       # 0x0
	.size	__threwValue, 4

	.type	__tempRet0,@object      # @__tempRet0
	.globl	__tempRet0
	.p2align	2
__tempRet0:
	.int32	0                       # 0x0
	.size	__tempRet0, 4


	.functype	foo, void
	.functype	__gxx_personality_v0, i32
	.functype	__cxa_begin_catch, i32, i32
	.functype	__cxa_end_catch, void
	.functype	setjmp, i32, i32
	.functype	longjmp, void, i32, i32
	.functype	malloc, i32, i32
	.functype	free, void, i32
	.functype	__resumeException, void, i32
	.functype	llvm_eh_typeid_for, i32, i32
	.functype	__invoke_void, void, i32
	.functype	__cxa_find_matching_catch_3, i32, i32
