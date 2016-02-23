	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/931004-14.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push40=, __stack_pointer
	i32.load	$push41=, 0($pop40)
	i32.const	$push42=, 16
	i32.sub 	$4=, $pop41, $pop42
	i32.const	$push43=, __stack_pointer
	i32.store	$discard=, 0($pop43), $4
	i32.store	$push26=, 12($4), $1
	tee_local	$push25=, $1=, $pop26
	i32.const	$push24=, 4
	i32.add 	$push2=, $pop25, $pop24
	i32.store	$discard=, 12($4), $pop2
	block
	block
	i32.const	$push23=, 1
	i32.lt_s	$push3=, $0, $pop23
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$push4=, 8
	i32.add 	$2=, $1, $pop4
	i32.const	$1=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push33=, 10
	i32.add 	$push9=, $1, $pop33
	i32.const	$push32=, -8
	i32.add 	$push5=, $2, $pop32
	i32.load8_s	$push8=, 0($pop5)
	i32.ne  	$push10=, $pop9, $pop8
	br_if   	3, $pop10       # 3: down to label0
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push35=, 20
	i32.add 	$push13=, $1, $pop35
	i32.const	$push34=, -7
	i32.add 	$push11=, $2, $pop34
	i32.load8_s	$push12=, 0($pop11)
	i32.ne  	$push14=, $pop13, $pop12
	br_if   	3, $pop14       # 3: down to label0
# BB#4:                                 # %if.end9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push37=, 30
	i32.add 	$push15=, $1, $pop37
	i32.const	$push36=, -6
	i32.add 	$push6=, $2, $pop36
	i32.load8_s	$push0=, 0($pop6)
	i32.ne  	$push16=, $pop15, $pop0
	br_if   	3, $pop16       # 3: down to label0
# BB#5:                                 # %if.end15
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push39=, 40
	i32.add 	$push17=, $1, $pop39
	i32.const	$push38=, -5
	i32.add 	$push7=, $2, $pop38
	i32.load8_s	$push1=, 0($pop7)
	i32.ne  	$push18=, $pop17, $pop1
	br_if   	3, $pop18       # 3: down to label0
# BB#6:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push30=, 1
	i32.add 	$1=, $1, $pop30
	i32.store	$push29=, 12($4), $2
	tee_local	$push28=, $3=, $pop29
	i32.const	$push27=, 4
	i32.add 	$2=, $pop28, $pop27
	i32.lt_s	$push19=, $1, $0
	br_if   	0, $pop19       # 0: up to label2
# BB#7:
	end_loop                        # label3:
	i32.const	$push31=, -4
	i32.add 	$1=, $3, $pop31
.LBB0_8:                                # %for.end
	end_block                       # label1:
	i32.load	$push20=, 0($1)
	i32.const	$push21=, 123
	i32.ne  	$push22=, $pop20, $pop21
	br_if   	0, $pop22       # 0: down to label0
# BB#9:                                 # %if.end28
	i32.const	$push44=, 16
	i32.add 	$4=, $4, $pop44
	i32.const	$push45=, __stack_pointer
	i32.store	$discard=, 0($pop45), $4
	return  	$1
.LBB0_10:                               # %if.then20
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
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push24=, __stack_pointer
	i32.load	$push25=, 0($pop24)
	i32.const	$push26=, 48
	i32.sub 	$6=, $pop25, $pop26
	i32.const	$push27=, __stack_pointer
	i32.store	$discard=, 0($pop27), $6
	i32.const	$push7=, 9
	i32.const	$0=, 32
	i32.add 	$0=, $6, $0
	i32.add 	$push8=, $0, $pop7
	i32.const	$push9=, 22
	i32.store8	$discard=, 0($pop8), $pop9
	i32.const	$push0=, 10
	i32.store8	$push1=, 32($6):p2align=3, $pop0
	i32.const	$1=, 32
	i32.add 	$1=, $6, $1
	i32.add 	$push12=, $1, $pop1
	i32.const	$push13=, 32
	i32.store8	$discard=, 0($pop12):p2align=1, $pop13
	i32.const	$push2=, 11
	i32.store8	$push3=, 36($6):p2align=2, $pop2
	i32.const	$2=, 32
	i32.add 	$2=, $6, $2
	i32.add 	$push16=, $2, $pop3
	i32.const	$push17=, 42
	i32.store8	$discard=, 0($pop16), $pop17
	i32.const	$push4=, 12
	i32.store8	$discard=, 40($6):p2align=3, $pop4
	i32.const	$push5=, 20
	i32.store8	$discard=, 33($6), $pop5
	i32.const	$push6=, 21
	i32.store8	$discard=, 37($6), $pop6
	i32.const	$push10=, 30
	i32.store8	$discard=, 34($6):p2align=1, $pop10
	i32.const	$push11=, 31
	i32.store8	$discard=, 38($6):p2align=1, $pop11
	i32.const	$push14=, 40
	i32.store8	$discard=, 35($6), $pop14
	i32.const	$push15=, 41
	i32.store8	$discard=, 39($6), $pop15
	i32.load	$push18=, 32($6):p2align=3
	i32.store	$discard=, 28($6), $pop18
	i32.load	$push19=, 36($6)
	i32.store	$discard=, 24($6), $pop19
	i32.load	$push20=, 40($6):p2align=3
	i32.store	$discard=, 20($6), $pop20
	i32.const	$push21=, 123
	i32.store	$discard=, 12($6), $pop21
	i32.const	$3=, 20
	i32.add 	$3=, $6, $3
	i32.store	$discard=, 8($6):p2align=3, $3
	i32.const	$4=, 24
	i32.add 	$4=, $6, $4
	i32.store	$discard=, 4($6), $4
	i32.const	$5=, 28
	i32.add 	$5=, $6, $5
	i32.store	$discard=, 0($6):p2align=4, $5
	i32.const	$push22=, 3
	i32.call	$discard=, f@FUNCTION, $pop22, $6
	i32.const	$push23=, 0
	call    	exit@FUNCTION, $pop23
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
