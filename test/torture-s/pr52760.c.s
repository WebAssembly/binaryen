	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr52760.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.load16_u	$2=, 0($1)
	i32.const	$3=, 8
	i32.shr_u	$push2=, $2, $3
	i32.shl 	$push3=, $2, $3
	i32.or  	$push4=, $pop2, $pop3
	i32.store16	$discard=, 0($1), $pop4
	i32.const	$push5=, 2
	i32.add 	$2=, $1, $pop5
	i32.load16_u	$4=, 0($2)
	i32.shr_u	$push6=, $4, $3
	i32.shl 	$push7=, $4, $3
	i32.or  	$push8=, $pop6, $pop7
	i32.store16	$discard=, 0($2), $pop8
	i32.const	$push9=, 4
	i32.add 	$2=, $1, $pop9
	i32.load16_u	$4=, 0($2)
	i32.shr_u	$push10=, $4, $3
	i32.shl 	$push11=, $4, $3
	i32.or  	$push12=, $pop10, $pop11
	i32.store16	$discard=, 0($2), $pop12
	i32.const	$push13=, 6
	i32.add 	$2=, $1, $pop13
	i32.load16_u	$4=, 0($2)
	i32.shr_u	$push14=, $4, $3
	i32.shl 	$push15=, $4, $3
	i32.or  	$push16=, $pop14, $pop15
	i32.store16	$discard=, 0($2), $pop16
	i32.const	$push17=, -1
	i32.add 	$0=, $0, $pop17
	i32.add 	$1=, $1, $3
	br_if   	$0, 0           # 0: up to label1
.LBB0_2:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$4=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$4=, 0($1), $4
	i64.const	$push0=, 434320308619640833
	i64.store	$discard=, 8($4), $pop0
	i32.const	$push1=, 1
	i32.const	$3=, 8
	i32.add 	$3=, $4, $3
	block
	call    	foo@FUNCTION, $pop1, $3
	i64.load	$push2=, 8($4)
	i64.const	$push3=, 506097522914230528
	i64.ne  	$push4=, $pop2, $pop3
	br_if   	$pop4, 0        # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$push5=, 0
	i32.const	$2=, 16
	i32.add 	$4=, $4, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	return  	$pop5
.LBB1_2:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
