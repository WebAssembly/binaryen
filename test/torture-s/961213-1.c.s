	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/961213-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i64, i64, i64
# BB#0:                                 # %entry
	block
	i64.const	$push0=, 0
	i64.store	$6=, 0($0), $pop0
	i32.const	$push1=, 1
	i32.lt_s	$push2=, $1, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %for.body.lr.ph
	i64.extend_s/i32	$4=, $3
	copy_local	$3=, $1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i64.load32_u	$5=, 0($2)
	i32.const	$push4=, 4
	i32.add 	$2=, $2, $pop4
	i32.const	$push5=, -1
	i32.add 	$3=, $3, $pop5
	i64.mul 	$push3=, $6, $4
	i64.add 	$6=, $5, $pop3
	br_if   	$3, 0           # 0: up to label1
# BB#3:                                 # %for.cond.for.end_crit_edge
	end_loop                        # label2:
	i64.store	$discard=, 0($0), $6
.LBB0_4:                                # %for.end
	end_block                       # label0:
	return  	$1
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
