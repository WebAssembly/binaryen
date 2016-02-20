	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr52760.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push32=, 2
	i32.add 	$2=, $1, $pop32
	i32.const	$push31=, 4
	i32.add 	$push30=, $1, $pop31
	tee_local	$push29=, $5=, $pop30
	i32.load16_u	$3=, 0($pop29)
	i32.load16_u	$push28=, 0($2)
	tee_local	$push27=, $4=, $pop28
	i32.const	$push26=, 8
	i32.shr_u	$push5=, $pop27, $pop26
	i32.const	$push25=, 8
	i32.shl 	$push6=, $4, $pop25
	i32.or  	$push7=, $pop5, $pop6
	i32.store16	$discard=, 0($2), $pop7
	i32.const	$push24=, 6
	i32.add 	$push23=, $1, $pop24
	tee_local	$push22=, $4=, $pop23
	i32.load16_u	$2=, 0($pop22)
	i32.const	$push21=, 8
	i32.shr_u	$push8=, $3, $pop21
	i32.const	$push20=, 8
	i32.shl 	$push9=, $3, $pop20
	i32.or  	$push10=, $pop8, $pop9
	i32.store16	$discard=, 0($5), $pop10
	i32.load16_u	$3=, 0($1)
	i32.const	$push19=, 8
	i32.shr_u	$push11=, $2, $pop19
	i32.const	$push18=, 8
	i32.shl 	$push12=, $2, $pop18
	i32.or  	$push13=, $pop11, $pop12
	i32.store16	$discard=, 0($4), $pop13
	i32.const	$push17=, 8
	i32.shr_u	$push2=, $3, $pop17
	i32.const	$push16=, 8
	i32.shl 	$push3=, $3, $pop16
	i32.or  	$push4=, $pop2, $pop3
	i32.store16	$discard=, 0($1), $pop4
	i32.const	$push15=, -1
	i32.add 	$0=, $0, $pop15
	i32.const	$push14=, 8
	i32.add 	$1=, $1, $pop14
	br_if   	0, $0           # 0: up to label1
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
	call    	foo@FUNCTION, $pop1, $3
	block
	i64.load	$push2=, 8($4)
	i64.const	$push3=, 506097522914230528
	i64.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label3
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
