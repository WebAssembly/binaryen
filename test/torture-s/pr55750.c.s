	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr55750.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 2
	i32.const	$push1=, arr
	i32.shl 	$push0=, $0, $1
	i32.add 	$0=, $pop1, $pop0
	i32.load8_u	$push2=, 0($0)
	i32.add 	$push3=, $pop2, $1
	i32.store8	$discard=, 0($0), $pop3
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push1=, 127
	i32.store8	$discard=, arr($0), $pop1
	i32.const	$push2=, 254
	i32.store8	$discard=, arr+4($0), $pop2
	call    	foo@FUNCTION, $0
	block
	i32.const	$push3=, 1
	call    	foo@FUNCTION, $pop3
	i32.load8_u	$push4=, arr($0)
	i32.const	$push5=, 129
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	$pop6, 0        # 0: down to label0
# BB#1:                                 # %entry
	i32.load8_u	$push0=, arr+4($0)
	i32.const	$push7=, 255
	i32.and 	$push8=, $pop0, $pop7
	br_if   	$pop8, 0        # 0: down to label0
# BB#2:                                 # %if.end
	return  	$0
.LBB1_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	arr                     # @arr
	.type	arr,@object
	.section	.bss.arr,"aw",@nobits
	.globl	arr
	.align	2
arr:
	.skip	8
	.size	arr, 8


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
