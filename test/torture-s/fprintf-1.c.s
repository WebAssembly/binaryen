	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/fprintf-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 144
	i32.sub 	$13=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$13=, 0($3), $13
	i32.const	$push1=, .L.str
	i32.const	$push2=, 5
	i32.const	$push61=, 1
	i32.const	$push60=, 0
	i32.load	$push0=, stdout($pop60)
	i32.call	$discard=, fwrite@FUNCTION, $pop1, $pop2, $pop61, $pop0
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	i32.const	$push59=, 0
	i32.load	$push3=, stdout($pop59)
	i32.const	$push58=, .L.str
	i32.const	$push57=, 0
	i32.call	$push4=, fprintf@FUNCTION, $pop3, $pop58, $pop57
	i32.const	$push56=, 5
	i32.ne  	$push5=, $pop4, $pop56
	br_if   	0, $pop5        # 0: down to label10
# BB#1:                                 # %if.end
	i32.const	$push7=, .L.str.1
	i32.const	$push8=, 6
	i32.const	$push67=, 1
	i32.const	$push66=, 0
	i32.load	$push6=, stdout($pop66)
	i32.call	$discard=, fwrite@FUNCTION, $pop7, $pop8, $pop67, $pop6
	i32.const	$push65=, 0
	i32.load	$push9=, stdout($pop65)
	i32.const	$push64=, .L.str.1
	i32.const	$push63=, 0
	i32.call	$push10=, fprintf@FUNCTION, $pop9, $pop64, $pop63
	i32.const	$push62=, 6
	i32.ne  	$push11=, $pop10, $pop62
	br_if   	1, $pop11       # 1: down to label9
# BB#2:                                 # %if.end6
	i32.const	$push13=, 97
	i32.const	$push70=, 0
	i32.load	$push12=, stdout($pop70)
	i32.call	$discard=, fputc@FUNCTION, $pop13, $pop12
	i32.const	$push69=, 0
	i32.load	$push14=, stdout($pop69)
	i32.const	$push15=, .L.str.2
	i32.const	$push68=, 0
	i32.call	$push16=, fprintf@FUNCTION, $pop14, $pop15, $pop68
	i32.const	$push17=, 1
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	2, $pop18       # 2: down to label8
# BB#3:                                 # %if.end11
	i32.const	$push72=, 0
	i32.load	$push19=, stdout($pop72)
	i32.const	$push20=, .L.str.3
	i32.const	$push71=, 0
	i32.call	$push21=, fprintf@FUNCTION, $pop19, $pop20, $pop71
	br_if   	3, $pop21       # 3: down to label7
# BB#4:                                 # %if.end16
	i32.const	$push23=, .L.str
	i32.const	$push24=, 5
	i32.const	$push78=, 1
	i32.const	$push77=, 0
	i32.load	$push22=, stdout($pop77)
	i32.call	$discard=, fwrite@FUNCTION, $pop23, $pop24, $pop78, $pop22
	i32.const	$push76=, 0
	i32.load	$1=, stdout($pop76)
	i32.const	$push75=, .L.str
	i32.store	$discard=, 128($13):p2align=4, $pop75
	i32.const	$push74=, .L.str.4
	i32.const	$5=, 128
	i32.add 	$5=, $13, $5
	i32.call	$push25=, fprintf@FUNCTION, $1, $pop74, $5
	i32.const	$push73=, 5
	i32.ne  	$push26=, $pop25, $pop73
	br_if   	4, $pop26       # 4: down to label6
# BB#5:                                 # %if.end21
	i32.const	$push28=, .L.str.1
	i32.const	$push29=, 6
	i32.const	$push84=, 1
	i32.const	$push83=, 0
	i32.load	$push27=, stdout($pop83)
	i32.call	$discard=, fwrite@FUNCTION, $pop28, $pop29, $pop84, $pop27
	i32.const	$push82=, 0
	i32.load	$1=, stdout($pop82)
	i32.const	$push81=, .L.str.1
	i32.store	$discard=, 112($13):p2align=4, $pop81
	i32.const	$push80=, .L.str.4
	i32.const	$6=, 112
	i32.add 	$6=, $13, $6
	i32.call	$push30=, fprintf@FUNCTION, $1, $pop80, $6
	i32.const	$push79=, 6
	i32.ne  	$push31=, $pop30, $pop79
	br_if   	5, $pop31       # 5: down to label5
# BB#6:                                 # %if.end26
	i32.const	$push33=, 97
	i32.const	$push87=, 0
	i32.load	$push32=, stdout($pop87)
	i32.call	$discard=, fputc@FUNCTION, $pop33, $pop32
	i32.const	$push86=, 0
	i32.load	$1=, stdout($pop86)
	i32.const	$push34=, .L.str.2
	i32.store	$discard=, 96($13):p2align=4, $pop34
	i32.const	$push85=, .L.str.4
	i32.const	$7=, 96
	i32.add 	$7=, $13, $7
	i32.call	$push35=, fprintf@FUNCTION, $1, $pop85, $7
	i32.const	$push36=, 1
	i32.ne  	$push37=, $pop35, $pop36
	br_if   	6, $pop37       # 6: down to label4
# BB#7:                                 # %if.end31
	i32.const	$push89=, 0
	i32.load	$1=, stdout($pop89)
	i32.const	$push38=, .L.str.3
	i32.store	$discard=, 80($13):p2align=4, $pop38
	i32.const	$push88=, .L.str.4
	i32.const	$8=, 80
	i32.add 	$8=, $13, $8
	i32.call	$push39=, fprintf@FUNCTION, $1, $pop88, $8
	br_if   	7, $pop39       # 7: down to label3
# BB#8:                                 # %if.end36
	i32.const	$push41=, 120
	i32.const	$push92=, 0
	i32.load	$push40=, stdout($pop92)
	i32.call	$discard=, fputc@FUNCTION, $pop41, $pop40
	i32.const	$push91=, 0
	i32.load	$1=, stdout($pop91)
	i32.const	$push90=, 120
	i32.store	$discard=, 64($13):p2align=4, $pop90
	i32.const	$push42=, .L.str.5
	i32.const	$9=, 64
	i32.add 	$9=, $13, $9
	i32.call	$push43=, fprintf@FUNCTION, $1, $pop42, $9
	i32.const	$push44=, 1
	i32.ne  	$push45=, $pop43, $pop44
	br_if   	8, $pop45       # 8: down to label2
# BB#9:                                 # %if.end41
	i32.const	$push95=, 0
	i32.load	$1=, stdout($pop95)
	i32.const	$push46=, .L.str.1
	i32.store	$0=, 48($13):p2align=4, $pop46
	i32.const	$push47=, .L.str.6
	i32.const	$10=, 48
	i32.add 	$10=, $13, $10
	i32.call	$discard=, fprintf@FUNCTION, $1, $pop47, $10
	i32.const	$push94=, 0
	i32.load	$1=, stdout($pop94)
	i32.store	$discard=, 32($13):p2align=4, $0
	i32.const	$push93=, .L.str.6
	i32.const	$11=, 32
	i32.add 	$11=, $13, $11
	i32.call	$push48=, fprintf@FUNCTION, $1, $pop93, $11
	i32.const	$push49=, 7
	i32.ne  	$push50=, $pop48, $pop49
	br_if   	9, $pop50       # 9: down to label1
# BB#10:                                # %if.end46
	i32.const	$push51=, 0
	i32.load	$0=, stdout($pop51)
	i32.const	$push97=, 0
	i32.store	$1=, 16($13):p2align=4, $pop97
	i32.const	$push52=, .L.str.7
	i32.const	$12=, 16
	i32.add 	$12=, $13, $12
	i32.call	$discard=, fprintf@FUNCTION, $0, $pop52, $12
	i32.load	$0=, stdout($1)
	i32.store	$discard=, 0($13):p2align=4, $1
	i32.const	$push96=, .L.str.7
	i32.call	$push53=, fprintf@FUNCTION, $0, $pop96, $13
	i32.const	$push54=, 2
	i32.ne  	$push55=, $pop53, $pop54
	br_if   	10, $pop55      # 10: down to label0
# BB#11:                                # %if.end51
	i32.const	$4=, 144
	i32.add 	$13=, $13, $4
	i32.const	$4=, __stack_pointer
	i32.store	$13=, 0($4), $13
	return  	$1
.LBB0_12:                               # %if.then
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB0_13:                               # %if.then5
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %if.then10
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB0_15:                               # %if.then15
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %if.then20
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_17:                               # %if.then25
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %if.then30
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_19:                               # %if.then35
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_20:                               # %if.then40
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_21:                               # %if.then45
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_22:                               # %if.then50
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"hello"
	.size	.L.str, 6

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"hello\n"
	.size	.L.str.1, 7

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"a"
	.size	.L.str.2, 2

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.skip	1
	.size	.L.str.3, 1

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"%s"
	.size	.L.str.4, 3

	.type	.L.str.5,@object        # @.str.5
.L.str.5:
	.asciz	"%c"
	.size	.L.str.5, 3

	.type	.L.str.6,@object        # @.str.6
.L.str.6:
	.asciz	"%s\n"
	.size	.L.str.6, 4

	.type	.L.str.7,@object        # @.str.7
.L.str.7:
	.asciz	"%d\n"
	.size	.L.str.7, 4


	.ident	"clang version 3.9.0 "
