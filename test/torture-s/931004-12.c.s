	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-12.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push22=, __stack_pointer
	i32.const	$push19=, __stack_pointer
	i32.load	$push20=, 0($pop19)
	i32.const	$push21=, 16
	i32.sub 	$push26=, $pop20, $pop21
	i32.store	$2=, 0($pop22), $pop26
	i32.store	$push30=, 12($2), $1
	tee_local	$push29=, $3=, $pop30
	i32.const	$push28=, 4
	i32.add 	$push1=, $pop29, $pop28
	i32.store	$drop=, 12($2), $pop1
	block
	block
	i32.const	$push27=, 1
	i32.lt_s	$push2=, $0, $pop27
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$push3=, 8
	i32.add 	$3=, $3, $pop3
	i32.const	$1=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push34=, 10
	i32.add 	$push7=, $1, $pop34
	copy_local	$push33=, $3
	tee_local	$push32=, $3=, $pop33
	i32.const	$push31=, -8
	i32.add 	$push4=, $pop32, $pop31
	i32.load8_s	$push6=, 0($pop4)
	i32.ne  	$push8=, $pop7, $pop6
	br_if   	3, $pop8        # 3: down to label0
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push36=, 20
	i32.add 	$push11=, $1, $pop36
	i32.const	$push35=, -7
	i32.add 	$push9=, $3, $pop35
	i32.load8_s	$push10=, 0($pop9)
	i32.ne  	$push12=, $pop11, $pop10
	br_if   	3, $pop12       # 3: down to label0
# BB#4:                                 # %if.end9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push38=, 30
	i32.add 	$push13=, $1, $pop38
	i32.const	$push37=, -6
	i32.add 	$push5=, $3, $pop37
	i32.load8_s	$push0=, 0($pop5)
	i32.ne  	$push14=, $pop13, $pop0
	br_if   	3, $pop14       # 3: down to label0
# BB#5:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push42=, 1
	i32.add 	$1=, $1, $pop42
	i32.store	$push41=, 12($2), $3
	tee_local	$push40=, $4=, $pop41
	i32.const	$push39=, 4
	i32.add 	$3=, $pop40, $pop39
	i32.lt_s	$push15=, $1, $0
	br_if   	0, $pop15       # 0: up to label2
# BB#6:
	end_loop                        # label3:
	i32.const	$push43=, -4
	i32.add 	$1=, $4, $pop43
.LBB0_7:                                # %for.end
	end_block                       # label1:
	i32.load	$push16=, 0($1)
	i32.const	$push17=, 123
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	0, $pop18       # 0: down to label0
# BB#8:                                 # %if.end22
	i32.const	$push25=, __stack_pointer
	i32.const	$push23=, 16
	i32.add 	$push24=, $2, $pop23
	i32.store	$drop=, 0($pop25), $pop24
	return  	$1
.LBB0_9:                                # %if.then14
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push25=, __stack_pointer
	i32.const	$push22=, __stack_pointer
	i32.load	$push23=, 0($pop22)
	i32.const	$push24=, 48
	i32.sub 	$push38=, $pop23, $pop24
	i32.store	$push44=, 0($pop25), $pop38
	tee_local	$push43=, $1=, $pop44
	i32.const	$push0=, 5130
	i32.store16	$drop=, 32($pop43), $pop0
	i32.const	$push1=, 11
	i32.store8	$drop=, 35($1), $pop1
	i32.const	$push2=, 12
	i32.store8	$drop=, 38($1), $pop2
	i32.const	$push3=, 21
	i32.store8	$drop=, 36($1), $pop3
	i32.const	$push4=, 22
	i32.store8	$drop=, 39($1), $pop4
	i32.const	$push5=, 30
	i32.store8	$drop=, 34($1), $pop5
	i32.const	$push6=, 31
	i32.store8	$drop=, 37($1), $pop6
	i32.const	$push7=, 40
	i32.add 	$push42=, $1, $pop7
	tee_local	$push41=, $0=, $pop42
	i32.const	$push8=, 32
	i32.store8	$drop=, 0($pop41), $pop8
	i32.const	$push26=, 28
	i32.add 	$push27=, $1, $pop26
	i32.const	$push9=, 2
	i32.add 	$push10=, $pop27, $pop9
	i32.load8_u	$push11=, 34($1)
	i32.store8	$drop=, 0($pop10), $pop11
	i32.const	$push28=, 24
	i32.add 	$push29=, $1, $pop28
	i32.const	$push40=, 2
	i32.add 	$push12=, $pop29, $pop40
	i32.load8_u	$push13=, 37($1)
	i32.store8	$drop=, 0($pop12), $pop13
	i32.load16_u	$push14=, 32($1)
	i32.store16	$drop=, 28($1), $pop14
	i32.load16_u	$push15=, 35($1):p2align=0
	i32.store16	$drop=, 24($1), $pop15
	i32.const	$push30=, 20
	i32.add 	$push31=, $1, $pop30
	i32.const	$push39=, 2
	i32.add 	$push16=, $pop31, $pop39
	i32.load8_u	$push17=, 0($0)
	i32.store8	$drop=, 0($pop16), $pop17
	i32.load16_u	$push18=, 38($1)
	i32.store16	$drop=, 20($1), $pop18
	i32.const	$push19=, 123
	i32.store	$drop=, 12($1), $pop19
	i32.const	$push32=, 28
	i32.add 	$push33=, $1, $pop32
	i32.store	$drop=, 0($1), $pop33
	i32.const	$push34=, 20
	i32.add 	$push35=, $1, $pop34
	i32.store	$drop=, 8($1), $pop35
	i32.const	$push36=, 24
	i32.add 	$push37=, $1, $pop36
	i32.store	$drop=, 4($1), $pop37
	i32.const	$push20=, 3
	i32.call	$drop=, f@FUNCTION, $pop20, $1
	i32.const	$push21=, 0
	call    	exit@FUNCTION, $pop21
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
