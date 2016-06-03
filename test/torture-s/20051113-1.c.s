	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20051113-1.c"
	.section	.text.Sum,"ax",@progbits
	.hidden	Sum
	.globl	Sum
	.type	Sum,@function
Sum:                                    # @Sum
	.param  	i32
	.result 	i64
	.local  	i32, i32, i64
# BB#0:                                 # %entry
	i64.const	$3=, 0
	block
	i32.load	$push7=, 0($0):p2align=0
	tee_local	$push6=, $1=, $pop7
	i32.const	$push5=, 1
	i32.lt_s	$push1=, $pop6, $pop5
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push2=, 10
	i32.add 	$0=, $0, $pop2
	i64.const	$3=, 0
	i32.const	$2=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i64.load	$push3=, 0($0):p2align=0
	i64.add 	$3=, $pop3, $3
	i32.const	$push11=, 30
	i32.add 	$push0=, $0, $pop11
	copy_local	$0=, $pop0
	i32.const	$push10=, 1
	i32.add 	$push9=, $2, $pop10
	tee_local	$push8=, $2=, $pop9
	i32.lt_s	$push4=, $pop8, $1
	br_if   	0, $pop4        # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	copy_local	$push12=, $3
                                        # fallthrough-return: $pop12
	.endfunc
.Lfunc_end0:
	.size	Sum, .Lfunc_end0-Sum

	.section	.text.Sum2,"ax",@progbits
	.hidden	Sum2
	.globl	Sum2
	.type	Sum2,@function
Sum2:                                   # @Sum2
	.param  	i32
	.result 	i64
	.local  	i32, i32, i64
# BB#0:                                 # %entry
	i64.const	$3=, 0
	block
	i32.load	$push7=, 0($0):p2align=0
	tee_local	$push6=, $1=, $pop7
	i32.const	$push5=, 1
	i32.lt_s	$push1=, $pop6, $pop5
	br_if   	0, $pop1        # 0: down to label3
# BB#1:                                 # %for.body.preheader
	i32.const	$push2=, 18
	i32.add 	$0=, $0, $pop2
	i64.const	$3=, 0
	i32.const	$2=, 0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i64.load	$push3=, 0($0):p2align=0
	i64.add 	$3=, $pop3, $3
	i32.const	$push11=, 30
	i32.add 	$push0=, $0, $pop11
	copy_local	$0=, $pop0
	i32.const	$push10=, 1
	i32.add 	$push9=, $2, $pop10
	tee_local	$push8=, $2=, $pop9
	i32.lt_s	$push4=, $pop8, $1
	br_if   	0, $pop4        # 0: up to label4
.LBB1_3:                                # %for.end
	end_loop                        # label5:
	end_block                       # label3:
	copy_local	$push12=, $3
                                        # fallthrough-return: $pop12
	.endfunc
.Lfunc_end1:
	.size	Sum2, .Lfunc_end1-Sum2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 94
	i32.call	$push16=, malloc@FUNCTION, $pop0
	tee_local	$push15=, $3=, $pop16
	i32.const	$push1=, 4
	i32.add 	$push2=, $pop15, $pop1
	i32.const	$push4=, 0
	i32.const	$push3=, 90
	i32.call	$drop=, memset@FUNCTION, $pop2, $pop4, $pop3
	i64.const	$push5=, 555
	i64.store	$0=, 10($3):p2align=0, $pop5
	i32.const	$push6=, 3
	i32.store	$drop=, 0($3):p2align=0, $pop6
	i64.const	$push7=, 999
	i64.store	$1=, 40($3):p2align=0, $pop7
	i64.const	$push8=, 4311810305
	i64.store	$2=, 70($3):p2align=0, $pop8
	i64.store	$drop=, 18($3):p2align=0, $0
	i64.store	$drop=, 48($3):p2align=0, $1
	i64.store	$drop=, 78($3):p2align=0, $2
	block
	i64.call	$push9=, Sum@FUNCTION, $3
	i64.const	$push14=, 4311811859
	i64.ne  	$push10=, $pop9, $pop14
	br_if   	0, $pop10       # 0: down to label6
# BB#1:                                 # %if.end
	i64.call	$push11=, Sum2@FUNCTION, $3
	i64.const	$push17=, 4311811859
	i64.ne  	$push12=, $pop11, $pop17
	br_if   	0, $pop12       # 0: down to label6
# BB#2:                                 # %if.end25
	i32.const	$push13=, 0
	return  	$pop13
.LBB2_3:                                # %if.then24
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
	.functype	malloc, i32, i32
	.functype	abort, void
