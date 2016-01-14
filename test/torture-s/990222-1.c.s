	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990222-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, 1
	i32.load8_u	$push0=, line+2($0)
	i32.add 	$4=, $pop0, $1
	i32.store8	$discard=, line+2($0), $4
	i32.const	$2=, 24
	i32.shl 	$push1=, $4, $2
	i32.shr_s	$3=, $pop1, $2
	i32.const	$4=, line+1
	block
	i32.const	$push2=, 58
	i32.lt_s	$push3=, $3, $pop2
	br_if   	$pop3, 0        # 0: down to label0
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load8_u	$3=, 0($4)
	i32.add 	$push4=, $4, $1
	i32.const	$push5=, 48
	i32.store8	$discard=, 0($pop4), $pop5
	i32.add 	$3=, $3, $1
	i32.store8	$discard=, 0($4), $3
	i32.const	$push10=, -1
	i32.add 	$4=, $4, $pop10
	i32.shl 	$push6=, $3, $2
	i32.shr_s	$push7=, $pop6, $2
	i32.const	$push8=, 57
	i32.gt_s	$push9=, $pop7, $pop8
	br_if   	$pop9, 0        # 0: up to label1
# BB#2:                                 # %while.end.loopexit
	end_loop                        # label2:
	i32.load8_u	$3=, line+2($0)
.LBB0_3:                                # %while.end
	end_block                       # label0:
	block
	i32.load8_u	$push12=, line($0)
	i32.const	$push13=, 50
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	$pop14, 0       # 0: down to label3
# BB#4:                                 # %while.end
	i32.const	$4=, 255
	i32.const	$2=, 48
	i32.load8_u	$push11=, line+1($0)
	i32.and 	$push15=, $pop11, $4
	i32.ne  	$push16=, $pop15, $2
	br_if   	$pop16, 0       # 0: down to label3
# BB#5:                                 # %while.end
	i32.and 	$push17=, $3, $4
	i32.ne  	$push18=, $pop17, $2
	br_if   	$pop18, 0       # 0: down to label3
# BB#6:                                 # %if.end
	return  	$0
.LBB0_7:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	line                    # @line
	.type	line,@object
	.section	.data.line,"aw",@progbits
	.globl	line
line:
	.asciz	"199"
	.size	line, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
