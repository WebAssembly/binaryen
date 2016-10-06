	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041124-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, gs($pop0)
	i32.store	0($0):p2align=1, $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 16
	i32.sub 	$push18=, $pop11, $pop12
	tee_local	$push17=, $0=, $pop18
	i32.store	__stack_pointer($pop13), $pop17
	i32.const	$push14=, 8
	i32.add 	$push15=, $0, $pop14
	call    	foo@FUNCTION, $pop15
	block   	
	i32.load16_u	$push3=, 8($0)
	i32.const	$push16=, 0
	i32.load16_u	$push2=, gs($pop16)
	i32.ne  	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %entry
	i32.load16_u	$push0=, 10($0)
	i32.const	$push5=, 65535
	i32.and 	$push7=, $pop0, $pop5
	i32.const	$push20=, 0
	i32.load16_u	$push1=, gs+2($pop20)
	i32.const	$push19=, 65535
	i32.and 	$push6=, $pop1, $pop19
	i32.ne  	$push8=, $pop7, $pop6
	br_if   	0, $pop8        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
.LBB1_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	gs                      # @gs
	.type	gs,@object
	.section	.data.gs,"aw",@progbits
	.globl	gs
	.p2align	2
gs:
	.int16	100                     # 0x64
	.int16	200                     # 0xc8
	.size	gs, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
