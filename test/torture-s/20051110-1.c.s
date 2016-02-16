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
	i32.const	$1=, bytes
	block
	i32.const	$push0=, -516
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 2
	i32.shr_s	$push11=, $pop1, $pop2
	tee_local	$push10=, $0=, $pop11
	i32.const	$push14=, 0
	i32.eq  	$push15=, $pop10, $pop14
	br_if   	0, $pop15       # 0: down to label0
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push6=, 128
	i32.or  	$push7=, $0, $pop6
	i32.const	$push3=, 127
	i32.and 	$push4=, $0, $pop3
	i32.const	$push5=, 7
	i32.shr_u	$push13=, $0, $pop5
	tee_local	$push12=, $2=, $pop13
	i32.select	$push8=, $pop7, $pop4, $pop12
	i32.store8	$discard=, 0($1), $pop8
	i32.const	$push9=, 1
	i32.add 	$1=, $1, $pop9
	copy_local	$0=, $2
	br_if   	0, $2           # 0: up to label1
.LBB0_2:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	return
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
	i32.const	$1=, 904
	i32.const	$0=, bytes
.LBB1_1:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.const	$push17=, 128
	i32.or  	$push1=, $1, $pop17
	i32.const	$push16=, 127
	i32.and 	$push0=, $1, $pop16
	i32.const	$push15=, 7
	i32.shr_u	$push14=, $1, $pop15
	tee_local	$push13=, $2=, $pop14
	i32.select	$push2=, $pop1, $pop0, $pop13
	i32.store8	$discard=, 0($0), $pop2
	i32.const	$push12=, 1
	i32.add 	$0=, $0, $pop12
	copy_local	$1=, $2
	br_if   	0, $2           # 0: up to label3
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
