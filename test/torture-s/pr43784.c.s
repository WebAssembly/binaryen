	.text
	.file	"pr43784.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, __stack_pointer($pop10)
	i32.const	$push11=, 256
	i32.sub 	$push17=, $pop9, $pop11
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
	i32.call	$drop=, memcpy@FUNCTION, $pop3, $2, $pop2
	i32.const	$1=, -1
.LBB0_3:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.const	$push26=, 1
	i32.add 	$push25=, $1, $pop26
	tee_local	$push24=, $0=, $pop25
	i32.const	$push23=, v+5
	i32.add 	$push4=, $1, $pop23
	i32.load8_u	$push5=, 0($pop4)
	i32.ne  	$push6=, $pop24, $pop5
	br_if   	1, $pop6        # 1: down to label1
# BB#4:                                 # %for.cond1
                                        #   in Loop: Header=BB0_3 Depth=1
	copy_local	$1=, $0
	i32.const	$push27=, 254
	i32.le_u	$push7=, $0, $pop27
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
                                        # -- End function
	.section	.text.rp,"ax",@progbits
	.type	rp,@function            # -- Begin function rp
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
                                        # -- End function
	.type	v,@object               # @v
	.section	.bss.v,"aw",@nobits
	.p2align	2
v:
	.skip	260
	.size	v, 260


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
