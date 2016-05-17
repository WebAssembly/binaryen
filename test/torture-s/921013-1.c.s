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
	i32.eqz 	$push10=, $3
	br_if   	0, $pop10       # 0: down to label0
# BB#1:                                 # %while.body.preheader
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	f32.load	$push3=, 0($1)
	f32.load	$push4=, 0($2)
	f32.eq  	$push5=, $pop3, $pop4
	i32.store	$drop=, 0($0), $pop5
	i32.const	$push9=, -1
	i32.add 	$3=, $3, $pop9
	i32.const	$push8=, 4
	i32.add 	$push1=, $2, $pop8
	copy_local	$2=, $pop1
	i32.const	$push7=, 4
	i32.add 	$push0=, $1, $pop7
	copy_local	$1=, $pop0
	i32.const	$push6=, 4
	i32.add 	$push2=, $0, $pop6
	copy_local	$0=, $pop2
	br_if   	0, $3           # 0: up to label1
.LBB0_3:                                # %while.end
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
