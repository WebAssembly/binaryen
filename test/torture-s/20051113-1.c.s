	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20051113-1.c"
	.section	.text.Sum,"ax",@progbits
	.hidden	Sum
	.globl	Sum
	.type	Sum,@function
Sum:                                    # @Sum
	.param  	i32
	.result 	i64
	.local  	i32, i64, i32
# BB#0:                                 # %entry
	i64.const	$2=, 0
	block
	i32.load	$push6=, 0($0):p2align=0
	tee_local	$push5=, $3=, $pop6
	i32.const	$push4=, 1
	i32.lt_s	$push0=, $pop5, $pop4
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push1=, 10
	i32.add 	$0=, $0, $pop1
	i64.const	$2=, 0
	i32.const	$1=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i64.load	$push2=, 0($0):p2align=0
	i64.add 	$2=, $pop2, $2
	i32.const	$push8=, 1
	i32.add 	$1=, $1, $pop8
	i32.const	$push7=, 30
	i32.add 	$0=, $0, $pop7
	i32.lt_s	$push3=, $1, $3
	br_if   	0, $pop3        # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	return  	$2
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
	.local  	i32, i64, i32
# BB#0:                                 # %entry
	i64.const	$2=, 0
	block
	i32.load	$push6=, 0($0):p2align=0
	tee_local	$push5=, $3=, $pop6
	i32.const	$push4=, 1
	i32.lt_s	$push0=, $pop5, $pop4
	br_if   	0, $pop0        # 0: down to label3
# BB#1:                                 # %for.body.preheader
	i32.const	$push1=, 18
	i32.add 	$0=, $0, $pop1
	i64.const	$2=, 0
	i32.const	$1=, 0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i64.load	$push2=, 0($0):p2align=0
	i64.add 	$2=, $pop2, $2
	i32.const	$push8=, 1
	i32.add 	$1=, $1, $pop8
	i32.const	$push7=, 30
	i32.add 	$0=, $0, $pop7
	i32.lt_s	$push3=, $1, $3
	br_if   	0, $pop3        # 0: up to label4
.LBB1_3:                                # %for.end
	end_loop                        # label5:
	end_block                       # label3:
	return  	$2
	.endfunc
.Lfunc_end1:
	.size	Sum2, .Lfunc_end1-Sum2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 94
	i32.call	$push19=, malloc@FUNCTION, $pop0
	tee_local	$push18=, $0=, $pop19
	i32.const	$push1=, 4
	i32.add 	$push2=, $pop18, $pop1
	i32.const	$push4=, 0
	i32.const	$push3=, 90
	i32.call	$discard=, memset@FUNCTION, $pop2, $pop4, $pop3
	i32.const	$push5=, 3
	i32.store	$discard=, 0($0):p2align=0, $pop5
	i64.const	$push6=, 555
	i64.store	$push7=, 10($0):p2align=0, $pop6
	i64.store	$discard=, 18($0):p2align=0, $pop7
	i64.const	$push8=, 999
	i64.store	$push9=, 40($0):p2align=0, $pop8
	i64.store	$discard=, 48($0):p2align=0, $pop9
	i64.const	$push10=, 4311810305
	i64.store	$push11=, 70($0):p2align=0, $pop10
	i64.store	$discard=, 78($0):p2align=0, $pop11
	block
	i64.call	$push12=, Sum@FUNCTION, $0
	i64.const	$push17=, 4311811859
	i64.ne  	$push13=, $pop12, $pop17
	br_if   	0, $pop13       # 0: down to label6
# BB#1:                                 # %if.end
	i64.call	$push14=, Sum2@FUNCTION, $0
	i64.const	$push20=, 4311811859
	i64.ne  	$push15=, $pop14, $pop20
	br_if   	0, $pop15       # 0: down to label6
# BB#2:                                 # %if.end25
	i32.const	$push16=, 0
	return  	$pop16
.LBB2_3:                                # %if.then24
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
