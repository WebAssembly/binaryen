	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr48973-1.c"
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
	br_if   	0, $pop1        # 0: down to label0
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.load8_u	$push2=, s($pop9)
	i32.const	$push3=, 254
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push8=, 0
	i32.load	$push0=, v($pop8)
	i32.const	$push1=, 1
	i32.and 	$push7=, $pop0, $pop1
	tee_local	$push6=, $0=, $pop7
	i32.or  	$push5=, $pop4, $pop6
	i32.store8	s($pop10), $pop5
	block   	
	i32.eqz 	$push12=, $0
	br_if   	0, $pop12       # 0: down to label1
# BB#1:                                 # %foo.exit
	i32.const	$push11=, 0
	return  	$pop11
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
	.p2align	2
v:
	.int32	4294967295              # 0xffffffff
	.size	v, 4

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	2
s:
	.skip	4
	.size	s, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
