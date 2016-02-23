	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strct-stdarg-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push41=, __stack_pointer
	i32.load	$push42=, 0($pop41)
	i32.const	$push43=, 16
	i32.sub 	$4=, $pop42, $pop43
	i32.const	$push44=, __stack_pointer
	i32.store	$discard=, 0($pop44), $4
	i32.store	$2=, 12($4), $1
	block
	block
	block
	i32.const	$push27=, 1
	i32.lt_s	$push3=, $0, $pop27
	br_if   	0, $pop3        # 0: down to label2
# BB#1:                                 # %for.body.preheader
	i32.const	$push28=, 8
	i32.add 	$3=, $2, $pop28
	i32.const	$1=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	i32.store	$2=, 12($4), $3
	i32.const	$push32=, 10
	i32.add 	$push9=, $1, $pop32
	i32.const	$push31=, -8
	i32.add 	$push4=, $2, $pop31
	i32.load8_s	$push8=, 0($pop4)
	i32.ne  	$push10=, $pop9, $pop8
	br_if   	3, $pop10       # 3: down to label1
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push34=, 20
	i32.add 	$push13=, $1, $pop34
	i32.const	$push33=, -7
	i32.add 	$push11=, $2, $pop33
	i32.load8_s	$push12=, 0($pop11)
	i32.ne  	$push14=, $pop13, $pop12
	br_if   	3, $pop14       # 3: down to label1
# BB#4:                                 # %if.end9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push36=, 30
	i32.add 	$push15=, $1, $pop36
	i32.const	$push35=, -6
	i32.add 	$push5=, $2, $pop35
	i32.load8_s	$push0=, 0($pop5)
	i32.ne  	$push16=, $pop15, $pop0
	br_if   	3, $pop16       # 3: down to label1
# BB#5:                                 # %if.end15
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push38=, 40
	i32.add 	$push17=, $1, $pop38
	i32.const	$push37=, -5
	i32.add 	$push6=, $2, $pop37
	i32.load8_s	$push1=, 0($pop6)
	i32.ne  	$push18=, $pop17, $pop1
	br_if   	3, $pop18       # 3: down to label1
# BB#6:                                 # %if.end21
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push40=, 50
	i32.add 	$push19=, $1, $pop40
	i32.const	$push39=, -4
	i32.add 	$push7=, $2, $pop39
	i32.load8_s	$push2=, 0($pop7)
	i32.ne  	$push20=, $pop19, $pop2
	br_if   	4, $pop20       # 4: down to label0
# BB#7:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push30=, 1
	i32.add 	$1=, $1, $pop30
	i32.const	$push29=, 8
	i32.add 	$3=, $2, $pop29
	i32.lt_s	$push21=, $1, $0
	br_if   	0, $pop21       # 0: up to label3
.LBB0_8:                                # %for.end
	end_loop                        # label4:
	end_block                       # label2:
	i32.const	$push22=, 4
	i32.add 	$push23=, $2, $pop22
	i32.store	$discard=, 12($4), $pop23
	i32.load	$push24=, 0($2)
	i32.const	$push25=, 123
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label1
# BB#9:                                 # %if.end34
	i32.const	$push45=, 16
	i32.add 	$4=, $4, $pop45
	i32.const	$push46=, __stack_pointer
	i32.store	$discard=, 0($pop46), $4
	return  	$1
.LBB0_10:                               # %if.then33
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_11:                               # %if.then26
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push44=, __stack_pointer
	i32.load	$push45=, 0($pop44)
	i32.const	$push46=, 64
	i32.sub 	$14=, $pop45, $pop46
	i32.const	$push47=, __stack_pointer
	i32.store	$discard=, 0($pop47), $14
	i32.const	$push1=, 11
	i32.store8	$push2=, 53($14), $pop1
	i32.const	$2=, 48
	i32.add 	$2=, $14, $2
	i32.add 	$push7=, $2, $pop2
	i32.const	$push8=, 22
	i32.store8	$discard=, 0($pop7), $pop8
	i32.const	$push3=, 12
	i32.store8	$push4=, 58($14):p2align=1, $pop3
	i32.const	$3=, 48
	i32.add 	$3=, $14, $3
	i32.add 	$push11=, $3, $pop4
	i32.const	$push12=, 32
	i32.store8	$discard=, 0($pop11):p2align=2, $pop12
	i32.const	$push14=, 8
	i32.const	$4=, 48
	i32.add 	$4=, $14, $4
	i32.add 	$push15=, $4, $pop14
	i32.const	$push16=, 41
	i32.store8	$discard=, 0($pop15):p2align=3, $pop16
	i32.const	$push17=, 13
	i32.const	$5=, 48
	i32.add 	$5=, $14, $5
	i32.add 	$push18=, $5, $pop17
	i32.const	$push19=, 42
	i32.store8	$discard=, 0($pop18), $pop19
	i32.const	$push0=, 10
	i32.store8	$discard=, 48($14):p2align=3, $pop0
	i32.const	$push5=, 20
	i32.store8	$discard=, 49($14), $pop5
	i32.const	$push6=, 21
	i32.store8	$discard=, 54($14):p2align=1, $pop6
	i32.const	$push9=, 30
	i32.store8	$discard=, 50($14):p2align=1, $pop9
	i32.const	$push10=, 31
	i32.store8	$discard=, 55($14), $pop10
	i32.const	$push13=, 40
	i32.store8	$discard=, 51($14), $pop13
	i32.const	$push20=, 50
	i32.store8	$discard=, 52($14):p2align=2, $pop20
	i32.const	$push21=, 9
	i32.const	$6=, 48
	i32.add 	$6=, $14, $6
	i32.add 	$push43=, $6, $pop21
	tee_local	$push42=, $1=, $pop43
	i32.const	$push22=, 51
	i32.store8	$discard=, 0($pop42), $pop22
	i32.const	$push23=, 14
	i32.const	$7=, 48
	i32.add 	$7=, $14, $7
	i32.add 	$push41=, $7, $pop23
	tee_local	$push40=, $0=, $pop41
	i32.const	$push24=, 52
	i32.store8	$discard=, 0($pop40):p2align=1, $pop24
	i32.const	$push25=, 4
	i32.const	$8=, 40
	i32.add 	$8=, $14, $8
	i32.add 	$push26=, $8, $pop25
	i32.load8_u	$push27=, 52($14):p2align=2
	i32.store8	$discard=, 0($pop26):p2align=2, $pop27
	i32.load	$push28=, 48($14):p2align=3
	i32.store	$discard=, 40($14), $pop28
	i32.const	$push39=, 4
	i32.const	$9=, 32
	i32.add 	$9=, $14, $9
	i32.add 	$push29=, $9, $pop39
	i32.load8_u	$push30=, 0($1)
	i32.store8	$discard=, 0($pop29):p2align=2, $pop30
	i32.load	$push31=, 53($14):p2align=0
	i32.store	$discard=, 32($14), $pop31
	i32.const	$push38=, 4
	i32.const	$10=, 24
	i32.add 	$10=, $14, $10
	i32.add 	$push32=, $10, $pop38
	i32.load8_u	$push33=, 0($0):p2align=1
	i32.store8	$discard=, 0($pop32):p2align=2, $pop33
	i32.load	$push34=, 58($14):p2align=1
	i32.store	$discard=, 24($14), $pop34
	i32.const	$push35=, 123
	i32.store	$discard=, 12($14), $pop35
	i32.const	$11=, 24
	i32.add 	$11=, $14, $11
	i32.store	$discard=, 8($14):p2align=3, $11
	i32.const	$12=, 32
	i32.add 	$12=, $14, $12
	i32.store	$discard=, 4($14), $12
	i32.const	$13=, 40
	i32.add 	$13=, $14, $13
	i32.store	$discard=, 0($14):p2align=4, $13
	i32.const	$push36=, 3
	i32.call	$discard=, f@FUNCTION, $pop36, $14
	i32.const	$push37=, 0
	call    	exit@FUNCTION, $pop37
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
