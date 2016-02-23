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
	i32.const	$push18=, __stack_pointer
	i32.load	$push19=, 0($pop18)
	i32.const	$push20=, 16
	i32.sub 	$5=, $pop19, $pop20
	i32.const	$push21=, __stack_pointer
	i32.store	$discard=, 0($pop21), $5
	i32.store	$push11=, 12($5), $1
	tee_local	$push10=, $1=, $pop11
	i32.const	$push9=, 4
	i32.add 	$push0=, $pop10, $pop9
	i32.store	$discard=, 12($5), $pop0
	i32.load	$4=, 0($1)
	block
	block
	block
	i32.const	$push8=, 1
	i32.lt_s	$push1=, $0, $pop8
	br_if   	0, $pop1        # 0: down to label2
# BB#1:                                 # %for.body.preheader
	i32.const	$push2=, 8
	i32.add 	$3=, $1, $pop2
	i32.const	$1=, 10
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.ne  	$push3=, $1, $4
	br_if   	3, $pop3        # 3: down to label1
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.store	$push17=, 12($5), $3
	tee_local	$push16=, $3=, $pop17
	i32.const	$push15=, -4
	i32.add 	$push4=, $pop16, $pop15
	i32.load	$4=, 0($pop4)
	i32.const	$push14=, 4
	i32.add 	$3=, $3, $pop14
	i32.const	$push13=, -9
	i32.add 	$2=, $1, $pop13
	i32.const	$push12=, 1
	i32.add 	$1=, $1, $pop12
	i32.lt_s	$push5=, $2, $0
	br_if   	0, $pop5        # 0: up to label3
.LBB0_4:                                # %for.end
	end_loop                        # label4:
	end_block                       # label2:
	i32.const	$push6=, 123
	i32.ne  	$push7=, $4, $pop6
	br_if   	1, $pop7        # 1: down to label0
# BB#5:                                 # %if.end8
	i32.const	$push22=, 16
	i32.add 	$5=, $5, $pop22
	i32.const	$push23=, __stack_pointer
	i32.store	$discard=, 0($pop23), $5
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
	i32.const	$push4=, __stack_pointer
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 16
	i32.sub 	$0=, $pop5, $pop6
	i32.const	$push7=, __stack_pointer
	i32.store	$discard=, 0($pop7), $0
	i64.const	$push0=, 528280977420
	i64.store	$discard=, 8($0), $pop0
	i64.const	$push1=, 47244640266
	i64.store	$discard=, 0($0):p2align=4, $pop1
	i32.const	$push2=, 3
	i32.call	$discard=, f@FUNCTION, $pop2, $0
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
