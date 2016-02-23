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
	i32.const	$push12=, __stack_pointer
	i32.load	$push13=, 0($pop12)
	i32.const	$push14=, 256
	i32.sub 	$1=, $pop13, $pop14
	i32.const	$push15=, __stack_pointer
	i32.store	$discard=, 0($pop15), $1
	i32.const	$0=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.store8	$push0=, v($0), $0
	i32.const	$push9=, 1
	i32.add 	$0=, $pop0, $pop9
	i32.const	$push8=, 256
	i32.ne  	$push1=, $0, $pop8
	br_if   	0, $pop1        # 0: up to label0
# BB#2:                                 # %for.end
	end_loop                        # label1:
	call    	rp@FUNCTION, $1
	i32.const	$push3=, v+4
	i32.const	$push2=, 256
	i32.call	$discard=, memcpy@FUNCTION, $pop3, $1, $pop2
	i32.const	$0=, 0
.LBB0_3:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label3:
	i32.load8_u	$push4=, v+4($0)
	i32.ne  	$push5=, $0, $pop4
	br_if   	2, $pop5        # 2: down to label2
# BB#4:                                 # %for.cond1
                                        #   in Loop: Header=BB0_3 Depth=1
	i32.const	$push11=, 1
	i32.add 	$0=, $0, $pop11
	i32.const	$push10=, 255
	i32.le_s	$push6=, $0, $pop10
	br_if   	0, $pop6        # 0: up to label3
# BB#5:                                 # %for.end12
	end_loop                        # label4:
	i32.const	$push7=, 0
	i32.const	$push16=, 256
	i32.add 	$1=, $1, $pop16
	i32.const	$push17=, __stack_pointer
	i32.store	$discard=, 0($pop17), $1
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
	i32.const	$push0=, v
	i32.const	$push1=, 256
	i32.call	$discard=, memcpy@FUNCTION, $0, $pop0, $pop1
	return
	.endfunc
.Lfunc_end1:
	.size	rp, .Lfunc_end1-rp

	.type	v,@object               # @v
	.lcomm	v,260,2

	.ident	"clang version 3.9.0 "
