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
	i32.const	$push18=, __stack_pointer
	i32.const	$push15=, __stack_pointer
	i32.load	$push16=, 0($pop15)
	i32.const	$push17=, 16
	i32.sub 	$push22=, $pop16, $pop17
	i32.store	$2=, 0($pop18), $pop22
	i32.store	$push0=, 12($2), $1
	i32.const	$push24=, 4
	i32.add 	$push2=, $pop0, $pop24
	i32.store	$discard=, 12($2), $pop2
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
	i32.const	$push26=, 10
	i32.add 	$push8=, $3, $pop26
	i32.const	$push25=, 1
	i32.add 	$push6=, $1, $pop25
	i32.load8_s	$push7=, 0($pop6)
	i32.ne  	$push9=, $pop8, $pop7
	br_if   	3, $pop9        # 3: down to label1
# BB#4:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push30=, 8
	i32.add 	$push10=, $1, $pop30
	i32.store	$discard=, 12($2), $pop10
	i32.const	$push29=, 4
	i32.add 	$1=, $1, $pop29
	i32.const	$push28=, -9
	i32.add 	$4=, $3, $pop28
	i32.const	$push27=, 1
	i32.add 	$push1=, $3, $pop27
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
	i32.const	$push21=, __stack_pointer
	i32.const	$push19=, 16
	i32.add 	$push20=, $2, $pop19
	i32.store	$discard=, 0($pop21), $pop20
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
	i32.const	$push14=, __stack_pointer
	i32.const	$push11=, __stack_pointer
	i32.load	$push12=, 0($pop11)
	i32.const	$push13=, 32
	i32.sub 	$push21=, $pop12, $pop13
	i32.store	$push23=, 0($pop14), $pop21
	tee_local	$push22=, $0=, $pop23
	i32.const	$push0=, 5130
	i32.store16	$discard=, 24($pop22), $pop0
	i32.const	$push1=, 11
	i32.store8	$discard=, 26($0), $pop1
	i32.const	$push2=, 12
	i32.store8	$discard=, 28($0), $pop2
	i32.const	$push3=, 21
	i32.store8	$discard=, 27($0), $pop3
	i32.const	$push4=, 22
	i32.store8	$discard=, 29($0), $pop4
	i32.load16_u	$push5=, 24($0)
	i32.store16	$discard=, 22($0), $pop5
	i32.load16_u	$push6=, 26($0)
	i32.store16	$discard=, 20($0), $pop6
	i32.load16_u	$push7=, 28($0)
	i32.store16	$discard=, 18($0), $pop7
	i32.const	$push8=, 123
	i32.store	$discard=, 12($0), $pop8
	i32.const	$push15=, 22
	i32.add 	$push16=, $0, $pop15
	i32.store	$discard=, 0($0), $pop16
	i32.const	$push17=, 18
	i32.add 	$push18=, $0, $pop17
	i32.store	$discard=, 8($0), $pop18
	i32.const	$push19=, 20
	i32.add 	$push20=, $0, $pop19
	i32.store	$discard=, 4($0), $pop20
	i32.const	$push9=, 3
	i32.call	$discard=, f@FUNCTION, $pop9, $0
	i32.const	$push10=, 0
	call    	exit@FUNCTION, $pop10
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
