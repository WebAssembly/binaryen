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
	i32.const	$push34=, __stack_pointer
	i32.load	$push35=, 0($pop34)
	i32.const	$push36=, 16
	i32.sub 	$4=, $pop35, $pop36
	i32.const	$push37=, __stack_pointer
	i32.store	$discard=, 0($pop37), $4
	i32.store	$push22=, 12($4), $1
	tee_local	$push21=, $1=, $pop22
	i32.const	$push20=, 4
	i32.add 	$push1=, $pop21, $pop20
	i32.store	$discard=, 12($4), $pop1
	block
	block
	i32.const	$push19=, 1
	i32.lt_s	$push2=, $0, $pop19
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$push3=, 8
	i32.add 	$2=, $1, $pop3
	i32.const	$1=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push29=, 10
	i32.add 	$push7=, $1, $pop29
	i32.const	$push28=, -8
	i32.add 	$push4=, $2, $pop28
	i32.load8_s	$push6=, 0($pop4)
	i32.ne  	$push8=, $pop7, $pop6
	br_if   	3, $pop8        # 3: down to label0
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push31=, 20
	i32.add 	$push11=, $1, $pop31
	i32.const	$push30=, -7
	i32.add 	$push9=, $2, $pop30
	i32.load8_s	$push10=, 0($pop9)
	i32.ne  	$push12=, $pop11, $pop10
	br_if   	3, $pop12       # 3: down to label0
# BB#4:                                 # %if.end9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push33=, 30
	i32.add 	$push13=, $1, $pop33
	i32.const	$push32=, -6
	i32.add 	$push5=, $2, $pop32
	i32.load8_s	$push0=, 0($pop5)
	i32.ne  	$push14=, $pop13, $pop0
	br_if   	3, $pop14       # 3: down to label0
# BB#5:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push26=, 1
	i32.add 	$1=, $1, $pop26
	i32.store	$push25=, 12($4), $2
	tee_local	$push24=, $3=, $pop25
	i32.const	$push23=, 4
	i32.add 	$2=, $pop24, $pop23
	i32.lt_s	$push15=, $1, $0
	br_if   	0, $pop15       # 0: up to label2
# BB#6:
	end_loop                        # label3:
	i32.const	$push27=, -4
	i32.add 	$1=, $3, $pop27
.LBB0_7:                                # %for.end
	end_block                       # label1:
	i32.load	$push16=, 0($1)
	i32.const	$push17=, 123
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	0, $pop18       # 0: down to label0
# BB#8:                                 # %if.end22
	i32.const	$push40=, __stack_pointer
	i32.const	$push38=, 16
	i32.add 	$push39=, $4, $pop38
	i32.store	$discard=, 0($pop40), $pop39
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
	i32.const	$push26=, __stack_pointer
	i32.load	$push27=, 0($pop26)
	i32.const	$push28=, 48
	i32.sub 	$1=, $pop27, $pop28
	i32.const	$push29=, __stack_pointer
	i32.store	$discard=, 0($pop29), $1
	i32.const	$push0=, 5130
	i32.store16	$discard=, 32($1), $pop0
	i32.const	$push1=, 11
	i32.store8	$discard=, 35($1), $pop1
	i32.const	$push2=, 12
	i32.store8	$discard=, 38($1), $pop2
	i32.const	$push3=, 21
	i32.store8	$discard=, 36($1), $pop3
	i32.const	$push4=, 22
	i32.store8	$discard=, 39($1), $pop4
	i32.const	$push5=, 30
	i32.store8	$discard=, 34($1), $pop5
	i32.const	$push6=, 31
	i32.store8	$discard=, 37($1), $pop6
	i32.const	$push30=, 32
	i32.add 	$push31=, $1, $pop30
	i32.const	$push7=, 8
	i32.add 	$push25=, $pop31, $pop7
	tee_local	$push24=, $0=, $pop25
	i32.const	$push8=, 32
	i32.store8	$discard=, 0($pop24), $pop8
	i32.const	$push32=, 28
	i32.add 	$push33=, $1, $pop32
	i32.const	$push9=, 2
	i32.add 	$push10=, $pop33, $pop9
	i32.load8_u	$push11=, 34($1)
	i32.store8	$discard=, 0($pop10), $pop11
	i32.const	$push34=, 24
	i32.add 	$push35=, $1, $pop34
	i32.const	$push23=, 2
	i32.add 	$push12=, $pop35, $pop23
	i32.load8_u	$push13=, 37($1)
	i32.store8	$discard=, 0($pop12), $pop13
	i32.load16_u	$push14=, 32($1)
	i32.store16	$discard=, 28($1), $pop14
	i32.load16_u	$push15=, 35($1):p2align=0
	i32.store16	$discard=, 24($1), $pop15
	i32.const	$push36=, 20
	i32.add 	$push37=, $1, $pop36
	i32.const	$push22=, 2
	i32.add 	$push16=, $pop37, $pop22
	i32.load8_u	$push17=, 0($0)
	i32.store8	$discard=, 0($pop16), $pop17
	i32.load16_u	$push18=, 38($1)
	i32.store16	$discard=, 20($1), $pop18
	i32.const	$push19=, 123
	i32.store	$discard=, 12($1), $pop19
	i32.const	$push38=, 28
	i32.add 	$push39=, $1, $pop38
	i32.store	$discard=, 0($1), $pop39
	i32.const	$push40=, 20
	i32.add 	$push41=, $1, $pop40
	i32.store	$discard=, 8($1), $pop41
	i32.const	$push42=, 24
	i32.add 	$push43=, $1, $pop42
	i32.store	$discard=, 4($1), $pop43
	i32.const	$push20=, 3
	i32.call	$discard=, f@FUNCTION, $pop20, $1
	i32.const	$push21=, 0
	call    	exit@FUNCTION, $pop21
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
