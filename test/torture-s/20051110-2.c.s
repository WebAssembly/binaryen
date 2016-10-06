	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20051110-2.c"
	.section	.text.add_unwind_adjustsp,"ax",@progbits
	.hidden	add_unwind_adjustsp
	.globl	add_unwind_adjustsp
	.type	add_unwind_adjustsp,@function
add_unwind_adjustsp:                    # @add_unwind_adjustsp
	.param  	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, -516
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 2
	i32.shr_s	$0=, $pop1, $pop2
	i32.const	$3=, 0
	i32.const	$push9=, 0
	i32.load	$1=, flag($pop9)
.LBB0_1:                                # %a
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	copy_local	$push17=, $0
	tee_local	$push16=, $2=, $pop17
	i32.const	$push15=, 7
	i32.shr_u	$push14=, $pop16, $pop15
	tee_local	$push13=, $0=, $pop14
	i32.eqz 	$push18=, $pop13
	br_if   	1, $pop18       # 1: down to label0
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	br_if   	0, $1           # 0: up to label1
# BB#3:                                 # %if.end7.thread
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push12=, bytes
	i32.add 	$push4=, $3, $pop12
	i32.const	$push11=, 128
	i32.or  	$push3=, $2, $pop11
	i32.store8	0($pop4), $pop3
	i32.const	$push10=, 1
	i32.add 	$3=, $3, $pop10
	br      	0               # 0: up to label1
.LBB0_4:                                # %do.end
	end_loop
	end_block                       # label0:
	i32.const	$push7=, bytes
	i32.add 	$push8=, $3, $pop7
	i32.const	$push5=, 127
	i32.and 	$push6=, $2, $pop5
	i32.store8	0($pop8), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	add_unwind_adjustsp, .Lfunc_end0-add_unwind_adjustsp

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.const	$push15=, 0
	i32.load	$0=, flag($pop15)
	i32.const	$3=, 904
.LBB1_1:                                # %a.i
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label3:
	copy_local	$push23=, $3
	tee_local	$push22=, $1=, $pop23
	i32.const	$push21=, 7
	i32.shr_u	$push20=, $pop22, $pop21
	tee_local	$push19=, $3=, $pop20
	i32.eqz 	$push26=, $pop19
	br_if   	1, $pop26       # 1: down to label2
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB1_1 Depth=1
	br_if   	0, $0           # 0: up to label3
# BB#3:                                 # %if.end7.thread.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push18=, bytes
	i32.add 	$push1=, $2, $pop18
	i32.const	$push17=, 128
	i32.or  	$push0=, $1, $pop17
	i32.store8	0($pop1), $pop0
	i32.const	$push16=, 1
	i32.add 	$2=, $2, $pop16
	br      	0               # 0: up to label3
.LBB1_4:                                # %add_unwind_adjustsp.exit
	end_loop
	end_block                       # label2:
	i32.const	$push5=, bytes
	i32.add 	$push6=, $2, $pop5
	i32.const	$push3=, 127
	i32.and 	$push4=, $1, $pop3
	i32.store8	0($pop6), $pop4
	block   	
	i32.const	$push24=, 0
	i32.load8_u	$push7=, bytes($pop24)
	i32.const	$push8=, 136
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label4
# BB#5:                                 # %add_unwind_adjustsp.exit
	i32.const	$push25=, 0
	i32.load8_u	$push2=, bytes+1($pop25)
	i32.const	$push10=, 255
	i32.and 	$push11=, $pop2, $pop10
	i32.const	$push12=, 7
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label4
# BB#6:                                 # %if.end
	i32.const	$push14=, 0
	return  	$pop14
.LBB1_7:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	bytes                   # @bytes
	.type	bytes,@object
	.section	.bss.bytes,"aw",@nobits
	.globl	bytes
bytes:
	.skip	5
	.size	bytes, 5

	.hidden	flag                    # @flag
	.type	flag,@object
	.section	.bss.flag,"aw",@nobits
	.globl	flag
	.p2align	2
flag:
	.int32	0                       # 0x0
	.size	flag, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
