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
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$5=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$5=, 0($2), $5
	i32.const	$3=, 8
	i32.add 	$3=, $5, $3
	call    	foo@FUNCTION, $3
	block
	i32.load16_u	$push2=, 8($5):p2align=3
	i32.const	$push5=, 0
	i32.load	$push14=, gs($pop5)
	tee_local	$push13=, $0=, $pop14
	i32.const	$push12=, 65535
	i32.and 	$push6=, $pop13, $pop12
	i32.ne  	$push8=, $pop2, $pop6
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push3=, 2
	i32.const	$4=, 8
	i32.add 	$4=, $5, $4
	i32.or  	$push4=, $4, $pop3
	i32.load16_u	$push0=, 0($pop4)
	i32.const	$push15=, 65535
	i32.and 	$push9=, $pop0, $pop15
	i32.const	$push7=, 16
	i32.shr_u	$push1=, $0, $pop7
	i32.ne  	$push10=, $pop9, $pop1
	br_if   	0, $pop10       # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
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
