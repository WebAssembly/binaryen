	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20051110-2.c"
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
	i32.const	$push6=, 0
	i32.load	$1=, flag($pop6)
.LBB0_1:                                # %a
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	copy_local	$push13=, $0
	tee_local	$push12=, $2=, $pop13
	i32.const	$push11=, 7
	i32.shr_u	$push10=, $pop12, $pop11
	tee_local	$push9=, $0=, $pop10
	i32.eqz 	$push14=, $pop9
	br_if   	1, $pop14       # 1: down to label1
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	br_if   	0, $1           # 0: up to label0
# BB#3:                                 # %if.end7.thread
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push8=, 128
	i32.or  	$push3=, $2, $pop8
	i32.store8	$drop=, bytes($3), $pop3
	i32.const	$push7=, 1
	i32.add 	$3=, $3, $pop7
	br      	0               # 0: up to label0
.LBB0_4:                                # %do.end
	end_loop                        # label1:
	i32.const	$push4=, 127
	i32.and 	$push5=, $2, $pop4
	i32.store8	$drop=, bytes($3), $pop5
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
	i32.const	$push12=, 0
	i32.load	$0=, flag($pop12)
	i32.const	$3=, 904
.LBB1_1:                                # %a.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	copy_local	$push19=, $3
	tee_local	$push18=, $1=, $pop19
	i32.const	$push17=, 7
	i32.shr_u	$push16=, $pop18, $pop17
	tee_local	$push15=, $3=, $pop16
	i32.eqz 	$push22=, $pop15
	br_if   	1, $pop22       # 1: down to label3
# BB#2:                                 # %if.then.i
                                        #   in Loop: Header=BB1_1 Depth=1
	br_if   	0, $0           # 0: up to label2
# BB#3:                                 # %if.end7.thread.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push14=, 128
	i32.or  	$push0=, $1, $pop14
	i32.store8	$drop=, bytes($2), $pop0
	i32.const	$push13=, 1
	i32.add 	$2=, $2, $pop13
	br      	0               # 0: up to label2
.LBB1_4:                                # %add_unwind_adjustsp.exit
	end_loop                        # label3:
	i32.const	$push2=, 127
	i32.and 	$push3=, $1, $pop2
	i32.store8	$drop=, bytes($2), $pop3
	block
	i32.const	$push20=, 0
	i32.load8_u	$push4=, bytes($pop20)
	i32.const	$push5=, 136
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label4
# BB#5:                                 # %add_unwind_adjustsp.exit
	i32.const	$push21=, 0
	i32.load8_u	$push1=, bytes+1($pop21)
	i32.const	$push7=, 255
	i32.and 	$push8=, $pop1, $pop7
	i32.const	$push9=, 7
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label4
# BB#6:                                 # %if.end
	i32.const	$push11=, 0
	return  	$pop11
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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
