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
	i32.const	$push18=, 0
	i32.const	$push15=, 0
	i32.load	$push16=, __stack_pointer($pop15)
	i32.const	$push17=, 16
	i32.sub 	$push22=, $pop16, $pop17
	i32.store	$push26=, __stack_pointer($pop18), $pop22
	tee_local	$push25=, $2=, $pop26
	i32.store	$push0=, 12($2), $1
	i32.const	$push24=, 4
	i32.add 	$push2=, $pop0, $pop24
	i32.store	$drop=, 12($pop25), $pop2
	block
	block
	block
	i32.const	$push23=, 1
	i32.lt_s	$push3=, $0, $pop23
	br_if   	0, $pop3        # 0: down to label2
# BB#1:                                 # %for.body.preheader
	i32.const	$3=, 10
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.load8_s	$push4=, 0($1)
	i32.ne  	$push5=, $3, $pop4
	br_if   	4, $pop5        # 4: down to label0
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push28=, 10
	i32.add 	$push6=, $3, $pop28
	i32.const	$push27=, 1
	i32.add 	$push7=, $1, $pop27
	i32.load8_s	$push8=, 0($pop7)
	i32.ne  	$push9=, $pop6, $pop8
	br_if   	3, $pop9        # 3: down to label1
# BB#4:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push32=, 8
	i32.add 	$push10=, $1, $pop32
	i32.store	$drop=, 12($2), $pop10
	i32.const	$push31=, 4
	i32.add 	$1=, $1, $pop31
	i32.const	$push30=, -9
	i32.add 	$4=, $3, $pop30
	i32.const	$push29=, 1
	i32.add 	$push1=, $3, $pop29
	copy_local	$3=, $pop1
	i32.lt_s	$push11=, $4, $0
	br_if   	0, $pop11       # 0: up to label3
.LBB0_5:                                # %for.end
	end_loop                        # label4:
	end_block                       # label2:
	i32.load	$push12=, 0($1)
	i32.const	$push13=, 123
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	1, $pop14       # 1: down to label0
# BB#6:                                 # %if.end16
	i32.const	$push21=, 0
	i32.const	$push19=, 16
	i32.add 	$push20=, $2, $pop19
	i32.store	$drop=, __stack_pointer($pop21), $pop20
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
	i32.const	$push14=, 0
	i32.const	$push11=, 0
	i32.load	$push12=, __stack_pointer($pop11)
	i32.const	$push13=, 32
	i32.sub 	$push21=, $pop12, $pop13
	i32.store	$push23=, __stack_pointer($pop14), $pop21
	tee_local	$push22=, $0=, $pop23
	i32.const	$push0=, 5130
	i32.store16	$drop=, 24($pop22), $pop0
	i32.const	$push1=, 21
	i32.store8	$drop=, 27($0), $pop1
	i32.const	$push2=, 22
	i32.store8	$drop=, 29($0), $pop2
	i32.const	$push3=, 11
	i32.store8	$drop=, 26($0), $pop3
	i32.const	$push4=, 12
	i32.store8	$drop=, 28($0), $pop4
	i32.load16_u	$push5=, 24($0)
	i32.store16	$drop=, 22($0), $pop5
	i32.load16_u	$push6=, 26($0)
	i32.store16	$drop=, 20($0), $pop6
	i32.load16_u	$push7=, 28($0)
	i32.store16	$drop=, 18($0), $pop7
	i32.const	$push8=, 123
	i32.store	$drop=, 12($0), $pop8
	i32.const	$push15=, 22
	i32.add 	$push16=, $0, $pop15
	i32.store	$drop=, 0($0), $pop16
	i32.const	$push17=, 18
	i32.add 	$push18=, $0, $pop17
	i32.store	$drop=, 8($0), $pop18
	i32.const	$push19=, 20
	i32.add 	$push20=, $0, $pop19
	i32.store	$drop=, 4($0), $pop20
	i32.const	$push9=, 3
	i32.call	$drop=, f@FUNCTION, $pop9, $0
	i32.const	$push10=, 0
	call    	exit@FUNCTION, $pop10
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
