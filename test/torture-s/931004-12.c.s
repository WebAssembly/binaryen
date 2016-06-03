	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-12.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push24=, 0
	i32.const	$push21=, 0
	i32.load	$push22=, __stack_pointer($pop21)
	i32.const	$push23=, 16
	i32.sub 	$push28=, $pop22, $pop23
	i32.store	$push34=, __stack_pointer($pop24), $pop28
	tee_local	$push33=, $2=, $pop34
	i32.store	$push32=, 12($2), $1
	tee_local	$push31=, $3=, $pop32
	i32.const	$push30=, 4
	i32.add 	$push2=, $pop31, $pop30
	i32.store	$drop=, 12($pop33), $pop2
	block
	block
	block
	i32.const	$push29=, 1
	i32.lt_s	$push3=, $0, $pop29
	br_if   	0, $pop3        # 0: down to label2
# BB#1:                                 # %for.body.preheader
	i32.const	$push4=, 8
	i32.add 	$1=, $3, $pop4
	i32.const	$3=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.const	$push36=, 10
	i32.add 	$push5=, $3, $pop36
	i32.const	$push35=, -8
	i32.add 	$push6=, $1, $pop35
	i32.load8_s	$push7=, 0($pop6)
	i32.ne  	$push8=, $pop5, $pop7
	br_if   	3, $pop8        # 3: down to label1
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push38=, 20
	i32.add 	$push10=, $3, $pop38
	i32.const	$push37=, -7
	i32.add 	$push11=, $1, $pop37
	i32.load8_s	$push12=, 0($pop11)
	i32.ne  	$push13=, $pop10, $pop12
	br_if   	3, $pop13       # 3: down to label1
# BB#4:                                 # %if.end9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push40=, 30
	i32.add 	$push14=, $3, $pop40
	i32.const	$push39=, -6
	i32.add 	$push9=, $1, $pop39
	i32.load8_s	$push1=, 0($pop9)
	i32.ne  	$push15=, $pop14, $pop1
	br_if   	4, $pop15       # 4: down to label0
# BB#5:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.store	$push0=, 12($2), $1
	i32.const	$push44=, 4
	i32.add 	$1=, $pop0, $pop44
	i32.const	$push43=, 1
	i32.add 	$push42=, $3, $pop43
	tee_local	$push41=, $3=, $pop42
	i32.lt_s	$push16=, $pop41, $0
	br_if   	0, $pop16       # 0: up to label3
# BB#6:                                 # %for.end.loopexit
	end_loop                        # label4:
	i32.const	$push17=, -8
	i32.add 	$1=, $1, $pop17
.LBB0_7:                                # %for.end
	end_block                       # label2:
	i32.load	$push18=, 0($1)
	i32.const	$push19=, 123
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label1
# BB#8:                                 # %if.end22
	i32.const	$push27=, 0
	i32.const	$push25=, 16
	i32.add 	$push26=, $2, $pop25
	i32.store	$drop=, __stack_pointer($pop27), $pop26
	return  	$1
.LBB0_9:                                # %if.then21
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %if.then14
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
	i32.const	$push25=, 0
	i32.const	$push22=, 0
	i32.load	$push23=, __stack_pointer($pop22)
	i32.const	$push24=, 48
	i32.sub 	$push38=, $pop23, $pop24
	i32.store	$push44=, __stack_pointer($pop25), $pop38
	tee_local	$push43=, $0=, $pop44
	i32.const	$push0=, 30
	i32.store8	$drop=, 34($pop43), $pop0
	i32.const	$push1=, 11
	i32.store8	$drop=, 35($0), $pop1
	i32.const	$push2=, 12
	i32.store8	$drop=, 38($0), $pop2
	i32.const	$push3=, 5130
	i32.store16	$drop=, 32($0), $pop3
	i32.const	$push4=, 21
	i32.store8	$drop=, 36($0), $pop4
	i32.const	$push5=, 22
	i32.store8	$drop=, 39($0), $pop5
	i32.const	$push26=, 28
	i32.add 	$push27=, $0, $pop26
	i32.const	$push6=, 2
	i32.add 	$push7=, $pop27, $pop6
	i32.load8_u	$push8=, 34($0)
	i32.store8	$drop=, 0($pop7), $pop8
	i32.const	$push9=, 31
	i32.store8	$drop=, 37($0), $pop9
	i32.const	$push10=, 40
	i32.add 	$push42=, $0, $pop10
	tee_local	$push41=, $1=, $pop42
	i32.const	$push11=, 32
	i32.store8	$drop=, 0($pop41), $pop11
	i32.const	$push28=, 24
	i32.add 	$push29=, $0, $pop28
	i32.const	$push40=, 2
	i32.add 	$push12=, $pop29, $pop40
	i32.load8_u	$push13=, 37($0)
	i32.store8	$drop=, 0($pop12), $pop13
	i32.load16_u	$push14=, 32($0)
	i32.store16	$drop=, 28($0), $pop14
	i32.load16_u	$push15=, 35($0):p2align=0
	i32.store16	$drop=, 24($0), $pop15
	i32.const	$push30=, 20
	i32.add 	$push31=, $0, $pop30
	i32.const	$push39=, 2
	i32.add 	$push16=, $pop31, $pop39
	i32.load8_u	$push17=, 0($1)
	i32.store8	$drop=, 0($pop16), $pop17
	i32.load16_u	$push18=, 38($0)
	i32.store16	$drop=, 20($0), $pop18
	i32.const	$push19=, 123
	i32.store	$drop=, 12($0), $pop19
	i32.const	$push32=, 28
	i32.add 	$push33=, $0, $pop32
	i32.store	$drop=, 0($0), $pop33
	i32.const	$push34=, 20
	i32.add 	$push35=, $0, $pop34
	i32.store	$drop=, 8($0), $pop35
	i32.const	$push36=, 24
	i32.add 	$push37=, $0, $pop36
	i32.store	$drop=, 4($0), $pop37
	i32.const	$push20=, 3
	i32.call	$drop=, f@FUNCTION, $pop20, $0
	i32.const	$push21=, 0
	call    	exit@FUNCTION, $pop21
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
