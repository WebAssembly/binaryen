	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43784.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 256
	i32.sub 	$push15=, $pop9, $pop10
	i32.store	$0=, __stack_pointer($pop11), $pop15
	i32.const	$1=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.store8	$push0=, v($1), $1
	i32.const	$push19=, 1
	i32.add 	$push18=, $pop0, $pop19
	tee_local	$push17=, $1=, $pop18
	i32.const	$push16=, 256
	i32.ne  	$push1=, $pop17, $pop16
	br_if   	0, $pop1        # 0: up to label0
# BB#2:                                 # %for.end
	end_loop                        # label1:
	call    	rp@FUNCTION, $0
	i32.const	$push3=, v+4
	i32.const	$push2=, 256
	i32.call	$drop=, memcpy@FUNCTION, $pop3, $0, $pop2
	i32.const	$1=, 0
.LBB0_3:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label3:
	i32.load8_u	$push4=, v+4($1)
	i32.ne  	$push5=, $1, $pop4
	br_if   	2, $pop5        # 2: down to label2
# BB#4:                                 # %for.cond1
                                        #   in Loop: Header=BB0_3 Depth=1
	i32.const	$push23=, 1
	i32.add 	$push22=, $1, $pop23
	tee_local	$push21=, $1=, $pop22
	i32.const	$push20=, 255
	i32.le_s	$push6=, $pop21, $pop20
	br_if   	0, $pop6        # 0: up to label3
# BB#5:                                 # %for.end12
	end_loop                        # label4:
	i32.const	$push14=, 0
	i32.const	$push12=, 256
	i32.add 	$push13=, $0, $pop12
	i32.store	$drop=, __stack_pointer($pop14), $pop13
	i32.const	$push7=, 0
	return  	$pop7
.LBB0_6:                                # %if.then
	end_block                       # label2:
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
	.lcomm	v,260,2

	.ident	"clang version 3.9.0 "
	.functype	abort, void
