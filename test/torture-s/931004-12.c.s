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
	i32.const	$push38=, 16
	i32.add 	$4=, $4, $pop38
	i32.const	$push39=, __stack_pointer
	i32.store	$discard=, 0($pop39), $4
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push27=, __stack_pointer
	i32.load	$push28=, 0($pop27)
	i32.const	$push29=, 48
	i32.sub 	$8=, $pop28, $pop29
	i32.const	$push30=, __stack_pointer
	i32.store	$discard=, 0($pop30), $8
	i32.const	$push0=, 10
	i32.store8	$discard=, 32($8):p2align=3, $pop0
	i32.const	$push1=, 11
	i32.store8	$discard=, 35($8), $pop1
	i32.const	$push2=, 12
	i32.store8	$discard=, 38($8):p2align=1, $pop2
	i32.const	$push3=, 20
	i32.store8	$discard=, 33($8), $pop3
	i32.const	$push4=, 21
	i32.store8	$discard=, 36($8):p2align=2, $pop4
	i32.const	$push5=, 22
	i32.store8	$discard=, 39($8), $pop5
	i32.const	$push6=, 30
	i32.store8	$discard=, 34($8):p2align=1, $pop6
	i32.const	$push7=, 31
	i32.store8	$discard=, 37($8), $pop7
	i32.const	$push8=, 8
	i32.const	$1=, 32
	i32.add 	$1=, $8, $1
	i32.add 	$push26=, $1, $pop8
	tee_local	$push25=, $0=, $pop26
	i32.const	$push9=, 32
	i32.store8	$discard=, 0($pop25):p2align=3, $pop9
	i32.const	$push10=, 2
	i32.const	$2=, 28
	i32.add 	$2=, $8, $2
	i32.add 	$push11=, $2, $pop10
	i32.load8_u	$push12=, 34($8):p2align=1
	i32.store8	$discard=, 0($pop11):p2align=1, $pop12
	i32.load16_u	$push13=, 32($8):p2align=3
	i32.store16	$discard=, 28($8), $pop13
	i32.const	$push24=, 2
	i32.const	$3=, 24
	i32.add 	$3=, $8, $3
	i32.add 	$push14=, $3, $pop24
	i32.load8_u	$push15=, 37($8)
	i32.store8	$discard=, 0($pop14):p2align=1, $pop15
	i32.load16_u	$push16=, 35($8):p2align=0
	i32.store16	$discard=, 24($8), $pop16
	i32.const	$push23=, 2
	i32.const	$4=, 20
	i32.add 	$4=, $8, $4
	i32.add 	$push17=, $4, $pop23
	i32.load8_u	$push18=, 0($0):p2align=3
	i32.store8	$discard=, 0($pop17):p2align=1, $pop18
	i32.load16_u	$push19=, 38($8)
	i32.store16	$discard=, 20($8), $pop19
	i32.const	$push20=, 123
	i32.store	$discard=, 12($8), $pop20
	i32.const	$5=, 20
	i32.add 	$5=, $8, $5
	i32.store	$discard=, 8($8):p2align=3, $5
	i32.const	$6=, 24
	i32.add 	$6=, $8, $6
	i32.store	$discard=, 4($8), $6
	i32.const	$7=, 28
	i32.add 	$7=, $8, $7
	i32.store	$discard=, 0($8):p2align=4, $7
	i32.const	$push21=, 3
	i32.call	$discard=, f@FUNCTION, $pop21, $8
	i32.const	$push22=, 0
	call    	exit@FUNCTION, $pop22
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
