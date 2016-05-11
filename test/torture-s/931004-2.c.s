	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-2.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push12=, __stack_pointer
	i32.const	$push9=, __stack_pointer
	i32.load	$push10=, 0($pop9)
	i32.const	$push11=, 16
	i32.sub 	$push16=, $pop10, $pop11
	i32.store	$2=, 0($pop12), $pop16
	i32.store	$push20=, 12($2), $1
	tee_local	$push19=, $1=, $pop20
	i32.const	$push18=, 4
	i32.add 	$push1=, $pop19, $pop18
	i32.store	$discard=, 12($2), $pop1
	i32.load	$5=, 0($1)
	block
	block
	block
	i32.const	$push17=, 1
	i32.lt_s	$push2=, $0, $pop17
	br_if   	0, $pop2        # 0: down to label2
# BB#1:                                 # %for.body.preheader
	i32.const	$push3=, 8
	i32.add 	$4=, $1, $pop3
	i32.const	$1=, 10
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.ne  	$push4=, $1, $5
	br_if   	3, $pop4        # 3: down to label1
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.store	$push26=, 12($2), $4
	tee_local	$push25=, $4=, $pop26
	i32.const	$push24=, -4
	i32.add 	$push5=, $pop25, $pop24
	i32.load	$5=, 0($pop5)
	i32.const	$push23=, 4
	i32.add 	$4=, $4, $pop23
	i32.const	$push22=, -9
	i32.add 	$3=, $1, $pop22
	i32.const	$push21=, 1
	i32.add 	$push0=, $1, $pop21
	copy_local	$1=, $pop0
	i32.lt_s	$push6=, $3, $0
	br_if   	0, $pop6        # 0: up to label3
.LBB0_4:                                # %for.end
	end_loop                        # label4:
	end_block                       # label2:
	i32.const	$push7=, 123
	i32.ne  	$push8=, $5, $pop7
	br_if   	1, $pop8        # 1: down to label0
# BB#5:                                 # %if.end8
	i32.const	$push15=, __stack_pointer
	i32.const	$push13=, 16
	i32.add 	$push14=, $2, $pop13
	i32.store	$discard=, 0($pop15), $pop14
	return  	$1
.LBB0_6:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_7:                                # %if.then7
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push7=, __stack_pointer
	i32.const	$push4=, __stack_pointer
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push8=, $pop5, $pop6
	i32.store	$push10=, 0($pop7), $pop8
	tee_local	$push9=, $0=, $pop10
	i64.const	$push0=, 528280977420
	i64.store	$discard=, 8($pop9), $pop0
	i64.const	$push1=, 47244640266
	i64.store	$discard=, 0($0), $pop1
	i32.const	$push2=, 3
	i32.call	$discard=, f@FUNCTION, $pop2, $0
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
