	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041124-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, gs($pop0)
	i32.store	$drop=, 0($0):p2align=1, $pop1
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 16
	i32.sub 	$push16=, $pop11, $pop12
	i32.store	$push21=, __stack_pointer($pop13), $pop16
	tee_local	$push20=, $0=, $pop21
	i32.const	$push14=, 8
	i32.add 	$push15=, $pop20, $pop14
	call    	foo@FUNCTION, $pop15
	block
	i32.load16_u	$push5=, 8($0)
	i32.const	$push2=, 0
	i32.load	$push19=, gs($pop2)
	tee_local	$push18=, $1=, $pop19
	i32.const	$push17=, 65535
	i32.and 	$push4=, $pop18, $pop17
	i32.ne  	$push6=, $pop5, $pop4
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %entry
	i32.load16_u	$push0=, 10($0)
	i32.const	$push22=, 65535
	i32.and 	$push7=, $pop0, $pop22
	i32.const	$push3=, 16
	i32.shr_u	$push1=, $1, $pop3
	i32.ne  	$push8=, $pop7, $pop1
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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
