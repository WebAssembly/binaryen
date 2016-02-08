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
	i32.load	$push0=, 0($0):p2align=0
	tee_local	$push6=, $3=, $pop0
	i32.const	$push5=, 1
	i32.lt_s	$push1=, $pop6, $pop5
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push2=, 10
	i32.add 	$0=, $0, $pop2
	i64.const	$2=, 0
	i32.const	$1=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i64.load	$push3=, 0($0):p2align=0
	i64.add 	$2=, $pop3, $2
	i32.const	$push8=, 1
	i32.add 	$1=, $1, $pop8
	i32.const	$push7=, 30
	i32.add 	$0=, $0, $pop7
	i32.lt_s	$push4=, $1, $3
	br_if   	0, $pop4        # 0: up to label1
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
	i32.load	$push0=, 0($0):p2align=0
	tee_local	$push6=, $3=, $pop0
	i32.const	$push5=, 1
	i32.lt_s	$push1=, $pop6, $pop5
	br_if   	0, $pop1        # 0: down to label3
# BB#1:                                 # %for.body.preheader
	i32.const	$push2=, 18
	i32.add 	$0=, $0, $pop2
	i64.const	$2=, 0
	i32.const	$1=, 0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i64.load	$push3=, 0($0):p2align=0
	i64.add 	$2=, $pop3, $2
	i32.const	$push8=, 1
	i32.add 	$1=, $1, $pop8
	i32.const	$push7=, 30
	i32.add 	$0=, $0, $pop7
	i32.lt_s	$push4=, $1, $3
	br_if   	0, $pop4        # 0: up to label4
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
	i32.const	$push1=, 94
	i32.call	$push0=, malloc@FUNCTION, $pop1
	i32.const	$push2=, 0
	i32.const	$push18=, 94
	i32.call	$push3=, memset@FUNCTION, $pop0, $pop2, $pop18
	tee_local	$push17=, $0=, $pop3
	i32.const	$push4=, 3
	i32.store	$discard=, 0($pop17):p2align=0, $pop4
	i64.const	$push5=, 555
	i64.store	$push6=, 10($0):p2align=0, $pop5
	i64.store	$discard=, 18($0):p2align=0, $pop6
	i64.const	$push7=, 999
	i64.store	$push8=, 40($0):p2align=0, $pop7
	i64.store	$discard=, 48($0):p2align=0, $pop8
	i64.const	$push9=, 4311810305
	i64.store	$push10=, 70($0):p2align=0, $pop9
	i64.store	$discard=, 78($0):p2align=0, $pop10
	block
	i64.call	$push11=, Sum@FUNCTION, $0
	i64.const	$push16=, 4311811859
	i64.ne  	$push12=, $pop11, $pop16
	br_if   	0, $pop12       # 0: down to label6
# BB#1:                                 # %if.end
	block
	i64.call	$push13=, Sum2@FUNCTION, $0
	i64.const	$push19=, 4311811859
	i64.ne  	$push14=, $pop13, $pop19
	br_if   	0, $pop14       # 0: down to label7
# BB#2:                                 # %if.end25
	i32.const	$push15=, 0
	return  	$pop15
.LBB2_3:                                # %if.then24
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB2_4:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
