	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/printf-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$50=, __stack_pointer
	i32.load	$50=, 0($50)
	i32.const	$51=, 16
	i32.sub 	$53=, $50, $51
	i32.const	$51=, __stack_pointer
	i32.store	$53=, 0($51), $53
	i32.const	$push32=, .Lstr
	i32.call	$discard=, printf@FUNCTION, $pop32
	i32.const	$push31=, .Lstr
	i32.call	$0=, printf@FUNCTION, $pop31
	block
	i32.const	$push0=, 5
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push33=, .Lstr
	i32.call	$discard=, puts@FUNCTION, $pop33
	i32.const	$push2=, .L.str.1
	i32.call	$0=, printf@FUNCTION, $pop2
	block
	i32.const	$push3=, 6
	i32.ne  	$push4=, $0, $pop3
	br_if   	$pop4, 0        # 0: down to label1
# BB#2:                                 # %if.end6
	i32.const	$push5=, 97
	i32.call	$discard=, putchar@FUNCTION, $pop5
	i32.const	$push6=, .L.str.2
	i32.call	$0=, printf@FUNCTION, $pop6
	block
	i32.const	$push7=, 1
	i32.ne  	$push8=, $0, $pop7
	br_if   	$pop8, 0        # 0: down to label2
# BB#3:                                 # %if.end16
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 4
	i32.sub 	$53=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$53=, 0($3), $53
	i32.const	$push9=, .Lstr
	i32.store	$0=, 0($53), $pop9
	i32.const	$push35=, .L.str.4
	i32.call	$discard=, printf@FUNCTION, $pop35
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 4
	i32.add 	$53=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$53=, 0($5), $53
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 4
	i32.sub 	$53=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$53=, 0($7), $53
	i32.store	$discard=, 0($53), $0
	i32.const	$push34=, .L.str.4
	i32.call	$0=, printf@FUNCTION, $pop34
	i32.const	$8=, __stack_pointer
	i32.load	$8=, 0($8)
	i32.const	$9=, 4
	i32.add 	$53=, $8, $9
	i32.const	$9=, __stack_pointer
	i32.store	$53=, 0($9), $53
	block
	i32.const	$push10=, 5
	i32.ne  	$push11=, $0, $pop10
	br_if   	$pop11, 0       # 0: down to label3
# BB#4:                                 # %if.end21
	i32.const	$10=, __stack_pointer
	i32.load	$10=, 0($10)
	i32.const	$11=, 4
	i32.sub 	$53=, $10, $11
	i32.const	$11=, __stack_pointer
	i32.store	$53=, 0($11), $53
	i32.const	$push12=, .L.str.1
	i32.store	$0=, 0($53), $pop12
	i32.const	$push37=, .L.str.4
	i32.call	$discard=, printf@FUNCTION, $pop37
	i32.const	$12=, __stack_pointer
	i32.load	$12=, 0($12)
	i32.const	$13=, 4
	i32.add 	$53=, $12, $13
	i32.const	$13=, __stack_pointer
	i32.store	$53=, 0($13), $53
	i32.const	$14=, __stack_pointer
	i32.load	$14=, 0($14)
	i32.const	$15=, 4
	i32.sub 	$53=, $14, $15
	i32.const	$15=, __stack_pointer
	i32.store	$53=, 0($15), $53
	i32.store	$discard=, 0($53), $0
	i32.const	$push36=, .L.str.4
	i32.call	$0=, printf@FUNCTION, $pop36
	i32.const	$16=, __stack_pointer
	i32.load	$16=, 0($16)
	i32.const	$17=, 4
	i32.add 	$53=, $16, $17
	i32.const	$17=, __stack_pointer
	i32.store	$53=, 0($17), $53
	block
	i32.const	$push13=, 6
	i32.ne  	$push14=, $0, $pop13
	br_if   	$pop14, 0       # 0: down to label4
# BB#5:                                 # %if.end26
	i32.const	$18=, __stack_pointer
	i32.load	$18=, 0($18)
	i32.const	$19=, 4
	i32.sub 	$53=, $18, $19
	i32.const	$19=, __stack_pointer
	i32.store	$53=, 0($19), $53
	i32.const	$push15=, .L.str.2
	i32.store	$0=, 0($53), $pop15
	i32.const	$push39=, .L.str.4
	i32.call	$discard=, printf@FUNCTION, $pop39
	i32.const	$20=, __stack_pointer
	i32.load	$20=, 0($20)
	i32.const	$21=, 4
	i32.add 	$53=, $20, $21
	i32.const	$21=, __stack_pointer
	i32.store	$53=, 0($21), $53
	i32.const	$22=, __stack_pointer
	i32.load	$22=, 0($22)
	i32.const	$23=, 4
	i32.sub 	$53=, $22, $23
	i32.const	$23=, __stack_pointer
	i32.store	$53=, 0($23), $53
	i32.store	$discard=, 0($53), $0
	i32.const	$push38=, .L.str.4
	i32.call	$0=, printf@FUNCTION, $pop38
	i32.const	$24=, __stack_pointer
	i32.load	$24=, 0($24)
	i32.const	$25=, 4
	i32.add 	$53=, $24, $25
	i32.const	$25=, __stack_pointer
	i32.store	$53=, 0($25), $53
	block
	i32.const	$push16=, 1
	i32.ne  	$push17=, $0, $pop16
	br_if   	$pop17, 0       # 0: down to label5
# BB#6:                                 # %if.end31
	i32.const	$26=, __stack_pointer
	i32.load	$26=, 0($26)
	i32.const	$27=, 4
	i32.sub 	$53=, $26, $27
	i32.const	$27=, __stack_pointer
	i32.store	$53=, 0($27), $53
	i32.const	$push18=, .L.str.3
	i32.store	$0=, 0($53), $pop18
	i32.const	$push41=, .L.str.4
	i32.call	$discard=, printf@FUNCTION, $pop41
	i32.const	$28=, __stack_pointer
	i32.load	$28=, 0($28)
	i32.const	$29=, 4
	i32.add 	$53=, $28, $29
	i32.const	$29=, __stack_pointer
	i32.store	$53=, 0($29), $53
	i32.const	$30=, __stack_pointer
	i32.load	$30=, 0($30)
	i32.const	$31=, 4
	i32.sub 	$53=, $30, $31
	i32.const	$31=, __stack_pointer
	i32.store	$53=, 0($31), $53
	i32.store	$discard=, 0($53), $0
	i32.const	$push40=, .L.str.4
	i32.call	$0=, printf@FUNCTION, $pop40
	i32.const	$32=, __stack_pointer
	i32.load	$32=, 0($32)
	i32.const	$33=, 4
	i32.add 	$53=, $32, $33
	i32.const	$33=, __stack_pointer
	i32.store	$53=, 0($33), $53
	block
	br_if   	$0, 0           # 0: down to label6
# BB#7:                                 # %if.end36
	i32.const	$push19=, 120
	i32.call	$discard=, putchar@FUNCTION, $pop19
	i32.const	$34=, __stack_pointer
	i32.load	$34=, 0($34)
	i32.const	$35=, 4
	i32.sub 	$53=, $34, $35
	i32.const	$35=, __stack_pointer
	i32.store	$53=, 0($35), $53
	i32.const	$push42=, 120
	i32.store	$discard=, 0($53), $pop42
	i32.const	$push20=, .L.str.5
	i32.call	$0=, printf@FUNCTION, $pop20
	i32.const	$36=, __stack_pointer
	i32.load	$36=, 0($36)
	i32.const	$37=, 4
	i32.add 	$53=, $36, $37
	i32.const	$37=, __stack_pointer
	i32.store	$53=, 0($37), $53
	block
	i32.const	$push21=, 1
	i32.ne  	$push22=, $0, $pop21
	br_if   	$pop22, 0       # 0: down to label7
# BB#8:                                 # %if.end41
	i32.const	$push23=, .L.str.1
	i32.call	$discard=, puts@FUNCTION, $pop23
	i32.const	$38=, __stack_pointer
	i32.load	$38=, 0($38)
	i32.const	$39=, 4
	i32.sub 	$53=, $38, $39
	i32.const	$39=, __stack_pointer
	i32.store	$53=, 0($39), $53
	i32.const	$push43=, .L.str.1
	i32.store	$discard=, 0($53), $pop43
	i32.const	$push24=, .L.str.6
	i32.call	$0=, printf@FUNCTION, $pop24
	i32.const	$40=, __stack_pointer
	i32.load	$40=, 0($40)
	i32.const	$41=, 4
	i32.add 	$53=, $40, $41
	i32.const	$41=, __stack_pointer
	i32.store	$53=, 0($41), $53
	block
	i32.const	$push25=, 7
	i32.ne  	$push26=, $0, $pop25
	br_if   	$pop26, 0       # 0: down to label8
# BB#9:                                 # %if.end46
	i32.const	$42=, __stack_pointer
	i32.load	$42=, 0($42)
	i32.const	$43=, 4
	i32.sub 	$53=, $42, $43
	i32.const	$43=, __stack_pointer
	i32.store	$53=, 0($43), $53
	i32.const	$push27=, 0
	i32.store	$0=, 0($53), $pop27
	i32.const	$push28=, .L.str.7
	i32.call	$discard=, printf@FUNCTION, $pop28
	i32.const	$44=, __stack_pointer
	i32.load	$44=, 0($44)
	i32.const	$45=, 4
	i32.add 	$53=, $44, $45
	i32.const	$45=, __stack_pointer
	i32.store	$53=, 0($45), $53
	i32.const	$46=, __stack_pointer
	i32.load	$46=, 0($46)
	i32.const	$47=, 4
	i32.sub 	$53=, $46, $47
	i32.const	$47=, __stack_pointer
	i32.store	$53=, 0($47), $53
	i32.store	$1=, 0($53), $0
	i32.const	$push44=, .L.str.7
	i32.call	$0=, printf@FUNCTION, $pop44
	i32.const	$48=, __stack_pointer
	i32.load	$48=, 0($48)
	i32.const	$49=, 4
	i32.add 	$53=, $48, $49
	i32.const	$49=, __stack_pointer
	i32.store	$53=, 0($49), $53
	block
	i32.const	$push29=, 2
	i32.ne  	$push30=, $0, $pop29
	br_if   	$pop30, 0       # 0: down to label9
# BB#10:                                # %if.end51
	i32.const	$52=, 16
	i32.add 	$53=, $53, $52
	i32.const	$52=, __stack_pointer
	i32.store	$53=, 0($52), $53
	return  	$1
.LBB0_11:                               # %if.then50
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %if.then45
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB0_13:                               # %if.then40
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %if.then35
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_15:                               # %if.then30
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %if.then25
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_17:                               # %if.then20
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %if.then10
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_19:                               # %if.then5
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_20:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	.L.str.1,@object        # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
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

	.type	.Lstr,@object           # @str
.Lstr:
	.asciz	"hello"
	.size	.Lstr, 6


	.ident	"clang version 3.9.0 "
