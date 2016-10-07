	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43784.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i32.const	$push9=, 0
	i32.load	$push10=, __stack_pointer($pop9)
	i32.const	$push11=, 256
	i32.sub 	$push17=, $pop10, $pop11
	tee_local	$push16=, $2=, $pop17
	i32.store	__stack_pointer($pop12), $pop16
	i32.const	$1=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push22=, v
	i32.add 	$push0=, $1, $pop22
	i32.store8	0($pop0), $1
	i32.const	$push21=, 1
	i32.add 	$push20=, $1, $pop21
	tee_local	$push19=, $1=, $pop20
	i32.const	$push18=, 256
	i32.ne  	$push1=, $pop19, $pop18
	br_if   	0, $pop1        # 0: up to label0
# BB#2:                                 # %for.end
	end_loop
	call    	rp@FUNCTION, $2
	i32.const	$push3=, v+4
	i32.const	$push2=, 256
	i32.call	$0=, memcpy@FUNCTION, $pop3, $2, $pop2
	i32.const	$1=, 0
.LBB0_3:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.add 	$push4=, $1, $0
	i32.load8_u	$push5=, 0($pop4)
	i32.ne  	$push6=, $1, $pop5
	br_if   	1, $pop6        # 1: down to label1
# BB#4:                                 # %for.cond1
                                        #   in Loop: Header=BB0_3 Depth=1
	i32.const	$push26=, 1
	i32.add 	$push25=, $1, $pop26
	tee_local	$push24=, $1=, $pop25
	i32.const	$push23=, 255
	i32.le_s	$push7=, $pop24, $pop23
	br_if   	0, $pop7        # 0: up to label2
# BB#5:                                 # %for.end12
	end_loop
	i32.const	$push15=, 0
	i32.const	$push13=, 256
	i32.add 	$push14=, $2, $pop13
	i32.store	__stack_pointer($pop15), $pop14
	i32.const	$push8=, 0
	return  	$pop8
.LBB0_6:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.rp,"ax",@progbits
	.type	rp,@function
rp:                                     # @rp
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, v
	i32.const	$push0=, 256
	i32.call	$drop=, memcpy@FUNCTION, $0, $pop1, $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	rp, .Lfunc_end1-rp

	.type	v,@object               # @v
	.section	.bss.v,"aw",@nobits
	.p2align	2
v:
	.skip	260
	.size	v, 260


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
