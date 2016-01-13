	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041124-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, gs($pop0)
	i32.store16	$1=, 0($0), $pop1
	i32.const	$push2=, 2
	i32.add 	$push3=, $0, $pop2
	i32.const	$push4=, 16
	i32.shr_u	$push5=, $1, $pop4
	i32.store16	$discard=, 0($pop3), $pop5
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$7=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$7=, 0($4), $7
	i32.const	$5=, 8
	i32.add 	$5=, $7, $5
	call    	foo@FUNCTION, $5
	i32.const	$0=, 0
	i32.load	$1=, gs($0)
	i32.const	$2=, 65535
	block
	i32.load16_u	$push2=, 8($7)
	i32.and 	$push5=, $1, $2
	i32.ne  	$push7=, $pop2, $pop5
	br_if   	$pop7, 0        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push3=, 2
	i32.const	$6=, 8
	i32.add 	$6=, $7, $6
	i32.or  	$push4=, $6, $pop3
	i32.load16_u	$push0=, 0($pop4)
	i32.and 	$push8=, $pop0, $2
	i32.const	$push6=, 16
	i32.shr_u	$push1=, $1, $pop6
	i32.ne  	$push9=, $pop8, $pop1
	br_if   	$pop9, 0        # 0: down to label0
# BB#2:                                 # %if.end
	call    	exit@FUNCTION, $0
	unreachable
.LBB1_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	gs                      # @gs
	.type	gs,@object
	.section	.data.gs,"aw",@progbits
	.globl	gs
	.align	2
gs:
	.int16	100                     # 0x64
	.int16	200                     # 0xc8
	.size	gs, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
