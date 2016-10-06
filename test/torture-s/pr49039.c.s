	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49039.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 1
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push2=, -2
	i32.eq  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.end
	i32.gt_u	$push4=, $0, $1
	i32.select	$2=, $0, $1, $pop4
	block   	
	i32.lt_u	$push5=, $0, $1
	i32.select	$push6=, $0, $1, $pop5
	i32.const	$push17=, 1
	i32.ne  	$push7=, $pop6, $pop17
	br_if   	0, $pop7        # 0: down to label1
# BB#3:                                 # %if.then9
	i32.const	$push8=, 0
	i32.const	$push19=, 0
	i32.load	$push9=, cnt($pop19)
	i32.const	$push18=, 1
	i32.add 	$push10=, $pop9, $pop18
	i32.store	cnt($pop8), $pop10
.LBB0_4:                                # %if.end10
	end_block                       # label1:
	i32.const	$push11=, -2
	i32.ne  	$push12=, $2, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#5:                                 # %if.then12
	i32.const	$push13=, 0
	i32.const	$push20=, 0
	i32.load	$push14=, cnt($pop20)
	i32.const	$push15=, 1
	i32.add 	$push16=, $pop14, $pop15
	i32.store	cnt($pop13), $pop16
.LBB0_6:                                # %cleanup
	end_block                       # label0:
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
# BB#0:                                 # %entry
	i32.const	$push1=, -2
	i32.const	$push0=, 1
	call    	foo@FUNCTION, $pop1, $pop0
	block   	
	i32.const	$push5=, 0
	i32.load	$push2=, cnt($pop5)
	i32.const	$push3=, 2
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push6=, 0
	return  	$pop6
.LBB1_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	cnt                     # @cnt
	.type	cnt,@object
	.section	.bss.cnt,"aw",@nobits
	.globl	cnt
	.p2align	2
cnt:
	.int32	0                       # 0x0
	.size	cnt, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
