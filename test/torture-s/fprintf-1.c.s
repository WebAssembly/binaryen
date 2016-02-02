	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/fprintf-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$39=, __stack_pointer
	i32.load	$39=, 0($39)
	i32.const	$40=, 16
	i32.sub 	$42=, $39, $40
	i32.const	$40=, __stack_pointer
	i32.store	$42=, 0($40), $42
	i32.const	$push1=, .L.str
	i32.const	$push2=, 5
	i32.const	$push49=, 1
	i32.const	$push48=, 0
	i32.load	$push0=, stdout($pop48)
	i32.call	$discard=, fwrite@FUNCTION, $pop1, $pop2, $pop49, $pop0
	i32.const	$push47=, 0
	i32.load	$push3=, stdout($pop47)
	i32.const	$push46=, .L.str
	i32.call	$1=, fprintf@FUNCTION, $pop3, $pop46
	block
	i32.const	$push45=, 5
	i32.ne  	$push4=, $1, $pop45
	br_if   	$pop4, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push6=, .L.str.1
	i32.const	$push7=, 6
	i32.const	$push54=, 1
	i32.const	$push53=, 0
	i32.load	$push5=, stdout($pop53)
	i32.call	$discard=, fwrite@FUNCTION, $pop6, $pop7, $pop54, $pop5
	i32.const	$push52=, 0
	i32.load	$push8=, stdout($pop52)
	i32.const	$push51=, .L.str.1
	i32.call	$1=, fprintf@FUNCTION, $pop8, $pop51
	block
	i32.const	$push50=, 6
	i32.ne  	$push9=, $1, $pop50
	br_if   	$pop9, 0        # 0: down to label1
# BB#2:                                 # %if.end6
	i32.const	$push11=, 97
	i32.const	$push56=, 0
	i32.load	$push10=, stdout($pop56)
	i32.call	$discard=, fputc@FUNCTION, $pop11, $pop10
	i32.const	$push55=, 0
	i32.load	$push12=, stdout($pop55)
	i32.const	$push13=, .L.str.2
	i32.call	$1=, fprintf@FUNCTION, $pop12, $pop13
	block
	i32.const	$push14=, 1
	i32.ne  	$push15=, $1, $pop14
	br_if   	$pop15, 0       # 0: down to label2
# BB#3:                                 # %if.end11
	i32.const	$push57=, 0
	i32.load	$push16=, stdout($pop57)
	i32.const	$push17=, .L.str.3
	i32.call	$1=, fprintf@FUNCTION, $pop16, $pop17
	block
	br_if   	$1, 0           # 0: down to label3
# BB#4:                                 # %if.end16
	i32.const	$push19=, .L.str
	i32.const	$push20=, 5
	i32.const	$push63=, 1
	i32.const	$push62=, 0
	i32.load	$push18=, stdout($pop62)
	i32.call	$discard=, fwrite@FUNCTION, $pop19, $pop20, $pop63, $pop18
	i32.const	$push61=, 0
	i32.load	$1=, stdout($pop61)
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 4
	i32.sub 	$42=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$42=, 0($4), $42
	i32.const	$push60=, .L.str
	i32.store	$discard=, 0($42), $pop60
	i32.const	$push59=, .L.str.4
	i32.call	$1=, fprintf@FUNCTION, $1, $pop59
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 4
	i32.add 	$42=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$42=, 0($6), $42
	block
	i32.const	$push58=, 5
	i32.ne  	$push21=, $1, $pop58
	br_if   	$pop21, 0       # 0: down to label4
# BB#5:                                 # %if.end21
	i32.const	$push23=, .L.str.1
	i32.const	$push24=, 6
	i32.const	$push69=, 1
	i32.const	$push68=, 0
	i32.load	$push22=, stdout($pop68)
	i32.call	$discard=, fwrite@FUNCTION, $pop23, $pop24, $pop69, $pop22
	i32.const	$push67=, 0
	i32.load	$1=, stdout($pop67)
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 4
	i32.sub 	$42=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$42=, 0($8), $42
	i32.const	$push66=, .L.str.1
	i32.store	$discard=, 0($42), $pop66
	i32.const	$push65=, .L.str.4
	i32.call	$1=, fprintf@FUNCTION, $1, $pop65
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 4
	i32.add 	$42=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$42=, 0($10), $42
	block
	i32.const	$push64=, 6
	i32.ne  	$push25=, $1, $pop64
	br_if   	$pop25, 0       # 0: down to label5
# BB#6:                                 # %if.end26
	i32.const	$push27=, 97
	i32.const	$push72=, 0
	i32.load	$push26=, stdout($pop72)
	i32.call	$discard=, fputc@FUNCTION, $pop27, $pop26
	i32.const	$push71=, 0
	i32.load	$1=, stdout($pop71)
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 4
	i32.sub 	$42=, $11, $12
	i32.const	$12=, __stack_pointer
	i32.store	$42=, 0($12), $42
	i32.const	$push28=, .L.str.2
	i32.store	$discard=, 0($42), $pop28
	i32.const	$push70=, .L.str.4
	i32.call	$1=, fprintf@FUNCTION, $1, $pop70
	i32.const	$13=, __stack_pointer
	i32.load	$13=, 0($13)
	i32.const	$14=, 4
	i32.add 	$42=, $13, $14
	i32.const	$14=, __stack_pointer
	i32.store	$42=, 0($14), $42
	block
	i32.const	$push29=, 1
	i32.ne  	$push30=, $1, $pop29
	br_if   	$pop30, 0       # 0: down to label6
# BB#7:                                 # %if.end31
	i32.const	$push74=, 0
	i32.load	$1=, stdout($pop74)
	i32.const	$15=, __stack_pointer
	i32.load	$15=, 0($15)
	i32.const	$16=, 4
	i32.sub 	$42=, $15, $16
	i32.const	$16=, __stack_pointer
	i32.store	$42=, 0($16), $42
	i32.const	$push31=, .L.str.3
	i32.store	$discard=, 0($42), $pop31
	i32.const	$push73=, .L.str.4
	i32.call	$1=, fprintf@FUNCTION, $1, $pop73
	i32.const	$17=, __stack_pointer
	i32.load	$17=, 0($17)
	i32.const	$18=, 4
	i32.add 	$42=, $17, $18
	i32.const	$18=, __stack_pointer
	i32.store	$42=, 0($18), $42
	block
	br_if   	$1, 0           # 0: down to label7
# BB#8:                                 # %if.end36
	i32.const	$push33=, 120
	i32.const	$push77=, 0
	i32.load	$push32=, stdout($pop77)
	i32.call	$discard=, fputc@FUNCTION, $pop33, $pop32
	i32.const	$push76=, 0
	i32.load	$1=, stdout($pop76)
	i32.const	$19=, __stack_pointer
	i32.load	$19=, 0($19)
	i32.const	$20=, 4
	i32.sub 	$42=, $19, $20
	i32.const	$20=, __stack_pointer
	i32.store	$42=, 0($20), $42
	i32.const	$push75=, 120
	i32.store	$discard=, 0($42), $pop75
	i32.const	$push34=, .L.str.5
	i32.call	$1=, fprintf@FUNCTION, $1, $pop34
	i32.const	$21=, __stack_pointer
	i32.load	$21=, 0($21)
	i32.const	$22=, 4
	i32.add 	$42=, $21, $22
	i32.const	$22=, __stack_pointer
	i32.store	$42=, 0($22), $42
	block
	i32.const	$push35=, 1
	i32.ne  	$push36=, $1, $pop35
	br_if   	$pop36, 0       # 0: down to label8
# BB#9:                                 # %if.end41
	i32.const	$push80=, 0
	i32.load	$1=, stdout($pop80)
	i32.const	$23=, __stack_pointer
	i32.load	$23=, 0($23)
	i32.const	$24=, 4
	i32.sub 	$42=, $23, $24
	i32.const	$24=, __stack_pointer
	i32.store	$42=, 0($24), $42
	i32.const	$push37=, .L.str.1
	i32.store	$0=, 0($42), $pop37
	i32.const	$push38=, .L.str.6
	i32.call	$discard=, fprintf@FUNCTION, $1, $pop38
	i32.const	$25=, __stack_pointer
	i32.load	$25=, 0($25)
	i32.const	$26=, 4
	i32.add 	$42=, $25, $26
	i32.const	$26=, __stack_pointer
	i32.store	$42=, 0($26), $42
	i32.const	$push79=, 0
	i32.load	$1=, stdout($pop79)
	i32.const	$27=, __stack_pointer
	i32.load	$27=, 0($27)
	i32.const	$28=, 4
	i32.sub 	$42=, $27, $28
	i32.const	$28=, __stack_pointer
	i32.store	$42=, 0($28), $42
	i32.store	$discard=, 0($42), $0
	i32.const	$push78=, .L.str.6
	i32.call	$1=, fprintf@FUNCTION, $1, $pop78
	i32.const	$29=, __stack_pointer
	i32.load	$29=, 0($29)
	i32.const	$30=, 4
	i32.add 	$42=, $29, $30
	i32.const	$30=, __stack_pointer
	i32.store	$42=, 0($30), $42
	block
	i32.const	$push39=, 7
	i32.ne  	$push40=, $1, $pop39
	br_if   	$pop40, 0       # 0: down to label9
# BB#10:                                # %if.end46
	i32.const	$push41=, 0
	i32.load	$0=, stdout($pop41)
	i32.const	$31=, __stack_pointer
	i32.load	$31=, 0($31)
	i32.const	$32=, 4
	i32.sub 	$42=, $31, $32
	i32.const	$32=, __stack_pointer
	i32.store	$42=, 0($32), $42
	i32.const	$push82=, 0
	i32.store	$1=, 0($42), $pop82
	i32.const	$push42=, .L.str.7
	i32.call	$discard=, fprintf@FUNCTION, $0, $pop42
	i32.const	$33=, __stack_pointer
	i32.load	$33=, 0($33)
	i32.const	$34=, 4
	i32.add 	$42=, $33, $34
	i32.const	$34=, __stack_pointer
	i32.store	$42=, 0($34), $42
	i32.load	$0=, stdout($1)
	i32.const	$35=, __stack_pointer
	i32.load	$35=, 0($35)
	i32.const	$36=, 4
	i32.sub 	$42=, $35, $36
	i32.const	$36=, __stack_pointer
	i32.store	$42=, 0($36), $42
	i32.store	$2=, 0($42), $1
	i32.const	$push81=, .L.str.7
	i32.call	$1=, fprintf@FUNCTION, $0, $pop81
	i32.const	$37=, __stack_pointer
	i32.load	$37=, 0($37)
	i32.const	$38=, 4
	i32.add 	$42=, $37, $38
	i32.const	$38=, __stack_pointer
	i32.store	$42=, 0($38), $42
	block
	i32.const	$push43=, 2
	i32.ne  	$push44=, $1, $pop43
	br_if   	$pop44, 0       # 0: down to label10
# BB#11:                                # %if.end51
	i32.const	$41=, 16
	i32.add 	$42=, $42, $41
	i32.const	$41=, __stack_pointer
	i32.store	$42=, 0($41), $42
	return  	$2
.LBB0_12:                               # %if.then50
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB0_13:                               # %if.then45
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %if.then40
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB0_15:                               # %if.then35
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %if.then30
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_17:                               # %if.then25
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %if.then20
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_19:                               # %if.then15
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_20:                               # %if.then10
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_21:                               # %if.then5
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_22:                               # %if.then
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
