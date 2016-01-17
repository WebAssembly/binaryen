	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr48973-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, -1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
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
	i32.const	$0=, 0
	block
	i32.load	$push0=, v($0)
	i32.const	$push4=, 1
	i32.and 	$1=, $pop0, $pop4
	i32.load8_u	$push1=, s($0)
	i32.const	$push2=, 254
	i32.and 	$push3=, $pop1, $pop2
	i32.or  	$push5=, $pop3, $1
	i32.store8	$discard=, s($0), $pop5
	i32.const	$push6=, 0
	i32.eq  	$push7=, $1, $pop6
	br_if   	$pop7, 0        # 0: down to label1
# BB#1:                                 # %foo.exit
	return  	$0
.LBB1_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	v                       # @v
	.type	v,@object
	.section	.data.v,"aw",@progbits
	.globl	v
	.align	2
v:
	.int32	4294967295              # 0xffffffff
	.size	v, 4

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.align	2
s:
	.skip	4
	.size	s, 4


	.ident	"clang version 3.9.0 "
