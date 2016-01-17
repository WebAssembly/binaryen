	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960209-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block
	i32.const	$push1=, -1
	i32.select	$1=, $1, $pop1, $2
	i32.load	$push0=, yabba($2)
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %if.end24
	i32.const	$push4=, an_array
	i32.const	$push2=, 255
	i32.and 	$push3=, $0, $pop2
	i32.add 	$push5=, $pop4, $pop3
	i32.store	$discard=, a_ptr($2), $pop5
.LBB0_2:                                # %cleanup
	end_block                       # label0:
	return  	$1
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.load	$push0=, yabba($0)
	br_if   	$pop0, 0        # 0: down to label1
# BB#1:                                 # %if.end24.i
	i32.const	$push1=, an_array+1
	i32.store	$discard=, a_ptr($0), $pop1
.LBB1_2:                                # %if.end
	end_block                       # label1:
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	yabba                   # @yabba
	.type	yabba,@object
	.section	.data.yabba,"aw",@progbits
	.globl	yabba
	.align	2
yabba:
	.int32	1                       # 0x1
	.size	yabba, 4

	.hidden	an_array                # @an_array
	.type	an_array,@object
	.section	.bss.an_array,"aw",@nobits
	.globl	an_array
an_array:
	.skip	5
	.size	an_array, 5

	.hidden	a_ptr                   # @a_ptr
	.type	a_ptr,@object
	.section	.bss.a_ptr,"aw",@nobits
	.globl	a_ptr
	.align	2
a_ptr:
	.int32	0
	.size	a_ptr, 4


	.ident	"clang version 3.9.0 "
