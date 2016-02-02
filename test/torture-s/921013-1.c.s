	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/921013-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push7=, 0
	i32.eq  	$push8=, $3, $pop7
	br_if   	$pop8, 0        # 0: down to label0
.LBB0_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	f32.load	$push2=, 0($1)
	f32.load	$push3=, 0($2)
	f32.eq  	$push4=, $pop2, $pop3
	i32.store	$discard=, 0($0), $pop4
	i32.const	$push1=, 4
	i32.add 	$1=, $1, $pop1
	i32.const	$push6=, 4
	i32.add 	$2=, $2, $pop6
	i32.const	$push5=, 4
	i32.add 	$0=, $0, $pop5
	i32.const	$push0=, -1
	i32.add 	$3=, $3, $pop0
	br_if   	$3, 0           # 0: up to label1
.LBB0_2:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	return  	$3
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %for.cond.3
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
