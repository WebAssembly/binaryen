	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20051110-2.c"
	.globl	add_unwind_adjustsp
	.type	add_unwind_adjustsp,@function
add_unwind_adjustsp:                    # @add_unwind_adjustsp
	.param  	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, -516
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 2
	i32.shr_s	$5=, $pop1, $pop2
	i32.const	$3=, 127
	i32.const	$0=, 0
	i32.and 	$push3=, $5, $3
	i32.store8	$discard=, bytes($0), $pop3
	i32.const	$4=, 7
	i32.shr_u	$2=, $5, $4
	block   	BB0_3
	i32.const	$push8=, 0
	i32.eq  	$push9=, $2, $pop8
	br_if   	$pop9, BB0_3
# BB#1:                                 # %if.then.lr.ph
	i32.load	$push4=, flag($0)
	i32.eq  	$1=, $pop4, $0
	i32.const	$0=, bytes
BB0_2:                                  # %if.then
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_3
	i32.const	$push5=, 128
	i32.or  	$push6=, $5, $pop5
	i32.store8	$discard=, 0($0), $pop6
	i32.add 	$0=, $0, $1
	i32.and 	$push7=, $2, $3
	i32.store8	$discard=, 0($0), $pop7
	copy_local	$5=, $2
	i32.shr_u	$2=, $2, $4
	br_if   	$2, BB0_2
BB0_3:                                  # %do.end
	return
func_end0:
	.size	add_unwind_adjustsp, func_end0-add_unwind_adjustsp

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %add_unwind_adjustsp.exit
	i32.const	$0=, 0
	i32.load	$1=, flag($0)
	block   	BB1_3
	i32.const	$push2=, 136
	i32.store8	$2=, bytes($0), $pop2
	i32.const	$push3=, bytes
	i32.eq  	$push1=, $1, $0
	i32.add 	$push4=, $pop3, $pop1
	i32.const	$push5=, 7
	i32.store8	$1=, 0($pop4), $pop5
	i32.load8_u	$push6=, bytes($0)
	i32.ne  	$push7=, $pop6, $2
	br_if   	$pop7, BB1_3
# BB#1:                                 # %add_unwind_adjustsp.exit
	i32.load8_u	$push0=, bytes+1($0)
	i32.const	$push8=, 255
	i32.and 	$push9=, $pop0, $pop8
	i32.ne  	$push10=, $pop9, $1
	br_if   	$pop10, BB1_3
# BB#2:                                 # %if.end
	return  	$0
BB1_3:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	bytes,@object           # @bytes
	.bss
	.globl	bytes
bytes:
	.zero	5
	.size	bytes, 5

	.type	flag,@object            # @flag
	.globl	flag
	.align	2
flag:
	.int32	0                       # 0x0
	.size	flag, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
