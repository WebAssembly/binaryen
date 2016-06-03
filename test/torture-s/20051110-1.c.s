	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20051110-1.c"
	.section	.text.add_unwind_adjustsp,"ax",@progbits
	.hidden	add_unwind_adjustsp
	.globl	add_unwind_adjustsp
	.type	add_unwind_adjustsp,@function
add_unwind_adjustsp:                    # @add_unwind_adjustsp
	.param  	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, -516
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 2
	i32.shr_s	$push7=, $pop1, $pop2
	tee_local	$push6=, $0=, $pop7
	i32.eqz 	$push14=, $pop6
	br_if   	0, $pop14       # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$2=, bytes
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push13=, 128
	i32.or  	$push4=, $0, $pop13
	i32.const	$push12=, 127
	i32.and 	$push3=, $0, $pop12
	i32.const	$push11=, 7
	i32.shr_u	$push10=, $0, $pop11
	tee_local	$push9=, $1=, $pop10
	i32.select	$push5=, $pop4, $pop3, $pop9
	i32.store8	$drop=, 0($2), $pop5
	i32.const	$push8=, 1
	i32.add 	$2=, $2, $pop8
	copy_local	$0=, $1
	br_if   	0, $1           # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 904
	i32.const	$1=, bytes
.LBB1_1:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.const	$push17=, 128
	i32.or  	$push1=, $2, $pop17
	i32.const	$push16=, 127
	i32.and 	$push0=, $2, $pop16
	i32.const	$push15=, 7
	i32.shr_u	$push14=, $2, $pop15
	tee_local	$push13=, $0=, $pop14
	i32.select	$push2=, $pop1, $pop0, $pop13
	i32.store8	$drop=, 0($1), $pop2
	i32.const	$push12=, 1
	i32.add 	$1=, $1, $pop12
	copy_local	$2=, $0
	br_if   	0, $0           # 0: up to label3
# BB#2:                                 # %add_unwind_adjustsp.exit
	end_loop                        # label4:
	block
	i32.const	$push18=, 0
	i32.load8_u	$push4=, bytes($pop18)
	i32.const	$push5=, 136
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label5
# BB#3:                                 # %add_unwind_adjustsp.exit
	i32.const	$push19=, 0
	i32.load8_u	$push3=, bytes+1($pop19)
	i32.const	$push7=, 255
	i32.and 	$push8=, $pop3, $pop7
	i32.const	$push9=, 7
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label5
# BB#4:                                 # %if.end
	i32.const	$push11=, 0
	return  	$pop11
.LBB1_5:                                # %if.then
	end_block                       # label5:
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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
