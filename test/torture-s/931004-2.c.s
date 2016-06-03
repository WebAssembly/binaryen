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
	i32.const	$push13=, 0
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 16
	i32.sub 	$push17=, $pop11, $pop12
	i32.store	$push23=, __stack_pointer($pop13), $pop17
	tee_local	$push22=, $2=, $pop23
	i32.store	$push21=, 12($2), $1
	tee_local	$push20=, $1=, $pop21
	i32.const	$push19=, 4
	i32.add 	$push2=, $pop20, $pop19
	i32.store	$drop=, 12($pop22), $pop2
	i32.load	$5=, 0($1)
	block
	block
	block
	i32.const	$push18=, 1
	i32.lt_s	$push3=, $0, $pop18
	br_if   	0, $pop3        # 0: down to label2
# BB#1:                                 # %for.body.preheader
	i32.const	$push4=, 8
	i32.add 	$4=, $1, $pop4
	i32.const	$1=, 10
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.ne  	$push5=, $1, $5
	br_if   	3, $pop5        # 3: down to label1
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push29=, -9
	i32.add 	$3=, $1, $pop29
	i32.store	$push28=, 12($2), $4
	tee_local	$push27=, $4=, $pop28
	i32.const	$push26=, -4
	i32.add 	$push7=, $pop27, $pop26
	i32.load	$5=, 0($pop7)
	i32.const	$push25=, 1
	i32.add 	$push1=, $1, $pop25
	copy_local	$1=, $pop1
	i32.const	$push24=, 4
	i32.add 	$push0=, $4, $pop24
	copy_local	$4=, $pop0
	i32.lt_s	$push6=, $3, $0
	br_if   	0, $pop6        # 0: up to label3
.LBB0_4:                                # %for.end
	end_loop                        # label4:
	end_block                       # label2:
	i32.const	$push8=, 123
	i32.ne  	$push9=, $5, $pop8
	br_if   	1, $pop9        # 1: down to label0
# BB#5:                                 # %if.end8
	i32.const	$push16=, 0
	i32.const	$push14=, 16
	i32.add 	$push15=, $2, $pop14
	i32.store	$drop=, __stack_pointer($pop16), $pop15
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
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push8=, $pop5, $pop6
	i32.store	$push10=, __stack_pointer($pop7), $pop8
	tee_local	$push9=, $0=, $pop10
	i64.const	$push0=, 528280977420
	i64.store	$drop=, 8($pop9), $pop0
	i64.const	$push1=, 47244640266
	i64.store	$drop=, 0($0), $pop1
	i32.const	$push2=, 3
	i32.call	$drop=, f@FUNCTION, $pop2, $0
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
