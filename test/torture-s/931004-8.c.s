	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-8.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push14=, 0
	i32.const	$push11=, 0
	i32.load	$push12=, __stack_pointer($pop11)
	i32.const	$push13=, 16
	i32.sub 	$push18=, $pop12, $pop13
	i32.store	$push22=, __stack_pointer($pop14), $pop18
	tee_local	$push21=, $2=, $pop22
	i32.store	$push0=, 12($2), $1
	i32.const	$push20=, 4
	i32.add 	$push2=, $pop0, $pop20
	i32.store	$drop=, 12($pop21), $pop2
	block
	block
	block
	i32.const	$push19=, 1
	i32.lt_s	$push3=, $0, $pop19
	br_if   	0, $pop3        # 0: down to label2
# BB#1:                                 # %for.body.preheader
	i32.const	$4=, 10
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.load8_s	$push4=, 0($1)
	i32.ne  	$push5=, $4, $pop4
	br_if   	3, $pop5        # 3: down to label1
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push26=, 8
	i32.add 	$push6=, $1, $pop26
	i32.store	$drop=, 12($2), $pop6
	i32.const	$push25=, 4
	i32.add 	$1=, $1, $pop25
	i32.const	$push24=, -9
	i32.add 	$3=, $4, $pop24
	i32.const	$push23=, 1
	i32.add 	$push1=, $4, $pop23
	copy_local	$4=, $pop1
	i32.lt_s	$push7=, $3, $0
	br_if   	0, $pop7        # 0: up to label3
.LBB0_4:                                # %for.end
	end_loop                        # label4:
	end_block                       # label2:
	i32.load	$push8=, 0($1)
	i32.const	$push9=, 123
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	1, $pop10       # 1: down to label0
# BB#5:                                 # %if.end10
	i32.const	$push17=, 0
	i32.const	$push15=, 16
	i32.add 	$push16=, $2, $pop15
	i32.store	$drop=, __stack_pointer($pop17), $pop16
	return  	$1
.LBB0_6:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_7:                                # %if.then9
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
