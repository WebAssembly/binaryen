	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041218-1.c"
	.section	.text.dummy1,"ax",@progbits
	.hidden	dummy1
	.globl	dummy1
	.type	dummy1,@function
dummy1:                                 # @dummy1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, .L.str
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	dummy1, .Lfunc_end0-dummy1

	.section	.text.dummy2,"ax",@progbits
	.hidden	dummy2
	.globl	dummy2
	.type	dummy2,@function
dummy2:                                 # @dummy2
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	dummy2, .Lfunc_end1-dummy2

	.section	.text.baz,"ax",@progbits
	.hidden	baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push3=, baz.v
	i32.const	$push2=, 85
	i32.const	$push1=, 44
	i32.call	$push0=, memset@FUNCTION, $pop3, $pop2, $pop1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	baz, .Lfunc_end2-baz

	.section	.text.check,"ax",@progbits
	.hidden	check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push0=, 0($1)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push1=, 4($1)
	br_if   	0, $pop1        # 0: down to label0
# BB#2:                                 # %lor.lhs.false2
	i32.const	$push2=, 8
	i32.add 	$push3=, $1, $pop2
	i32.load	$push4=, 0($pop3)
	br_if   	0, $pop4        # 0: down to label0
# BB#3:                                 # %lor.lhs.false5
	i32.const	$push5=, 12
	i32.add 	$push6=, $1, $pop5
	i32.load	$push7=, 0($pop6)
	br_if   	0, $pop7        # 0: down to label0
# BB#4:                                 # %lor.lhs.false8
	i32.const	$push8=, 16
	i32.add 	$push9=, $1, $pop8
	i32.load8_u	$push10=, 0($pop9)
	br_if   	0, $pop10       # 0: down to label0
# BB#5:                                 # %if.end
	i32.const	$push11=, 1
	return  	$pop11
.LBB3_6:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	check, .Lfunc_end3-check

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %for.cond
	i32.const	$3=, 0
	i32.const	$push6=, 0
	i32.store	0($2), $pop6
	block   	
	block   	
	i32.eqz 	$push10=, $1
	br_if   	0, $pop10       # 0: down to label2
# BB#1:                                 # %for.body
	i32.const	$3=, 1
	i32.load	$push0=, 0($0)
	i32.const	$push7=, 1
	i32.ne  	$push1=, $pop0, $pop7
	br_if   	1, $pop1        # 1: down to label1
# BB#2:                                 # %sw.bb
	i32.const	$push3=, 0
	i32.const	$push2=, 1
	i32.store	baz.v($pop3), $pop2
	i32.const	$push5=, baz.v+4
	i32.const	$push8=, 0
	i32.const	$push4=, 40
	i32.call	$drop=, memset@FUNCTION, $pop5, $pop8, $pop4
	i32.call	$drop=, dummy2@FUNCTION, $3, $3
	unreachable
.LBB4_3:                                # %for.end
	end_block                       # label2:
	i32.const	$push9=, 0
	i32.store	0($2), $pop9
.LBB4_4:                                # %cleanup2
	end_block                       # label1:
	copy_local	$push11=, $3
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end4:
	.size	foo, .Lfunc_end4-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push1=, 0
	i32.load	$push2=, __stack_pointer($pop1)
	i32.const	$push3=, 16
	i32.sub 	$push11=, $pop2, $pop3
	tee_local	$push10=, $0=, $pop11
	i32.store	__stack_pointer($pop4), $pop10
	i32.const	$push0=, 1
	i32.store	12($0), $pop0
	i32.const	$push5=, 12
	i32.add 	$push6=, $0, $pop5
	i32.const	$push9=, 1
	i32.const	$push7=, 8
	i32.add 	$push8=, $0, $pop7
	i32.call	$drop=, foo@FUNCTION, $pop6, $pop9, $pop8
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end5:
	.size	main, .Lfunc_end5-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.skip	1
	.size	.L.str, 1

	.type	baz.v,@object           # @baz.v
	.section	.bss.baz.v,"aw",@nobits
	.p2align	2
baz.v:
	.skip	44
	.size	baz.v, 44


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
	.functype	abort, void
