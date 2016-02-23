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
	i32.store	$discard=, 0($0):p2align=1, $pop1
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push14=, __stack_pointer
	i32.load	$push15=, 0($pop14)
	i32.const	$push16=, 16
	i32.sub 	$2=, $pop15, $pop16
	i32.const	$push17=, __stack_pointer
	i32.store	$discard=, 0($pop17), $2
	i32.const	$1=, 8
	i32.add 	$1=, $2, $1
	call    	foo@FUNCTION, $1
	block
	i32.load16_u	$push2=, 8($2):p2align=3
	i32.const	$push3=, 0
	i32.load	$push12=, gs($pop3)
	tee_local	$push11=, $0=, $pop12
	i32.const	$push10=, 65535
	i32.and 	$push4=, $pop11, $pop10
	i32.ne  	$push6=, $pop2, $pop4
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %entry
	i32.load16_u	$push0=, 10($2)
	i32.const	$push13=, 65535
	i32.and 	$push7=, $pop0, $pop13
	i32.const	$push5=, 16
	i32.shr_u	$push1=, $0, $pop5
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
