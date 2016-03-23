	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-10.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push23=, __stack_pointer
	i32.load	$push24=, 0($pop23)
	i32.const	$push25=, 16
	i32.sub 	$4=, $pop24, $pop25
	i32.const	$push26=, __stack_pointer
	i32.store	$discard=, 0($pop26), $4
	i32.store	$push16=, 12($4), $1
	tee_local	$push15=, $1=, $pop16
	i32.const	$push14=, 4
	i32.add 	$push2=, $pop15, $pop14
	i32.store	$discard=, 12($4), $pop2
	block
	block
	block
	i32.const	$push0=, 0
	i32.le_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label2
# BB#1:
	i32.const	$2=, 10
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.load8_s	$push3=, 0($1)
	i32.ne  	$push4=, $2, $pop3
	br_if   	4, $pop4        # 4: down to label0
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push22=, 10
	i32.add 	$push7=, $2, $pop22
	i32.const	$push21=, 1
	i32.add 	$push5=, $1, $pop21
	i32.load8_s	$push6=, 0($pop5)
	i32.ne  	$push8=, $pop7, $pop6
	br_if   	3, $pop8        # 3: down to label1
# BB#4:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push20=, 8
	i32.add 	$push9=, $1, $pop20
	i32.store	$discard=, 12($4), $pop9
	i32.const	$push19=, 4
	i32.add 	$1=, $1, $pop19
	i32.const	$push18=, -9
	i32.add 	$3=, $2, $pop18
	i32.const	$push17=, 1
	i32.add 	$2=, $2, $pop17
	i32.lt_s	$push10=, $3, $0
	br_if   	0, $pop10       # 0: up to label3
.LBB0_5:                                # %for.end
	end_loop                        # label4:
	end_block                       # label2:
	i32.load	$push11=, 0($1)
	i32.const	$push12=, 123
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	1, $pop13       # 1: down to label0
# BB#6:                                 # %if.end16
	i32.const	$push29=, __stack_pointer
	i32.const	$push27=, 16
	i32.add 	$push28=, $4, $pop27
	i32.store	$discard=, 0($pop29), $pop28
	return  	$1
.LBB0_7:                                # %if.then8
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.then15
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
	i32.const	$push12=, __stack_pointer
	i32.load	$push13=, 0($pop12)
	i32.const	$push14=, 32
	i32.sub 	$0=, $pop13, $pop14
	i32.const	$push15=, __stack_pointer
	i32.store	$discard=, 0($pop15), $0
	i32.const	$push0=, 10
	i32.store8	$discard=, 24($0):p2align=3, $pop0
	i32.const	$push1=, 11
	i32.store8	$discard=, 26($0):p2align=1, $pop1
	i32.const	$push2=, 12
	i32.store8	$discard=, 28($0):p2align=2, $pop2
	i32.const	$push3=, 20
	i32.store8	$discard=, 25($0), $pop3
	i32.const	$push4=, 21
	i32.store8	$discard=, 27($0), $pop4
	i32.const	$push5=, 22
	i32.store8	$discard=, 29($0), $pop5
	i32.load16_u	$push6=, 24($0):p2align=3
	i32.store16	$discard=, 22($0), $pop6
	i32.load16_u	$push7=, 26($0)
	i32.store16	$discard=, 20($0), $pop7
	i32.load16_u	$push8=, 28($0):p2align=2
	i32.store16	$discard=, 18($0), $pop8
	i32.const	$push9=, 123
	i32.store	$discard=, 12($0), $pop9
	i32.const	$push16=, 18
	i32.add 	$push17=, $0, $pop16
	i32.store	$discard=, 8($0):p2align=3, $pop17
	i32.const	$push18=, 20
	i32.add 	$push19=, $0, $pop18
	i32.store	$discard=, 4($0), $pop19
	i32.const	$push20=, 22
	i32.add 	$push21=, $0, $pop20
	i32.store	$discard=, 0($0):p2align=4, $pop21
	i32.const	$push10=, 3
	i32.call	$discard=, f@FUNCTION, $pop10, $0
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
