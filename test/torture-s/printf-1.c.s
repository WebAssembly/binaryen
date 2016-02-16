	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/printf-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 192
	i32.sub 	$15=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$15=, 0($2), $15
	i32.const	$push45=, .Lstr
	i32.const	$push44=, 0
	i32.call	$discard=, printf@FUNCTION, $pop45, $pop44
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
	i32.const	$push43=, .Lstr
	i32.const	$push42=, 0
	i32.call	$push0=, printf@FUNCTION, $pop43, $pop42
	i32.const	$push1=, 5
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label9
# BB#1:                                 # %if.end
	i32.const	$push47=, .Lstr
	i32.call	$discard=, puts@FUNCTION, $pop47
	i32.const	$push3=, .L.str.1
	i32.const	$push46=, 0
	i32.call	$push4=, printf@FUNCTION, $pop3, $pop46
	i32.const	$push5=, 6
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	1, $pop6        # 1: down to label8
# BB#2:                                 # %if.end6
	i32.const	$push7=, 97
	i32.call	$discard=, putchar@FUNCTION, $pop7
	i32.const	$push8=, .L.str.2
	i32.const	$push9=, 0
	i32.call	$push10=, printf@FUNCTION, $pop8, $pop9
	i32.const	$push11=, 1
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	2, $pop12       # 2: down to label7
# BB#3:                                 # %if.end16
	i32.const	$push13=, .Lstr
	i32.store	$0=, 176($15):p2align=4, $pop13
	i32.const	$push49=, .L.str.4
	i32.const	$4=, 176
	i32.add 	$4=, $15, $4
	i32.call	$discard=, printf@FUNCTION, $pop49, $4
	i32.store	$discard=, 160($15):p2align=4, $0
	i32.const	$push48=, .L.str.4
	i32.const	$5=, 160
	i32.add 	$5=, $15, $5
	i32.call	$push14=, printf@FUNCTION, $pop48, $5
	i32.const	$push15=, 5
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	3, $pop16       # 3: down to label6
# BB#4:                                 # %if.end21
	i32.const	$push17=, .L.str.1
	i32.store	$0=, 144($15):p2align=4, $pop17
	i32.const	$push51=, .L.str.4
	i32.const	$6=, 144
	i32.add 	$6=, $15, $6
	i32.call	$discard=, printf@FUNCTION, $pop51, $6
	i32.store	$discard=, 128($15):p2align=4, $0
	i32.const	$push50=, .L.str.4
	i32.const	$7=, 128
	i32.add 	$7=, $15, $7
	i32.call	$push18=, printf@FUNCTION, $pop50, $7
	i32.const	$push19=, 6
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	4, $pop20       # 4: down to label5
# BB#5:                                 # %if.end26
	i32.const	$push21=, .L.str.2
	i32.store	$0=, 112($15):p2align=4, $pop21
	i32.const	$push53=, .L.str.4
	i32.const	$8=, 112
	i32.add 	$8=, $15, $8
	i32.call	$discard=, printf@FUNCTION, $pop53, $8
	i32.store	$discard=, 96($15):p2align=4, $0
	i32.const	$push52=, .L.str.4
	i32.const	$9=, 96
	i32.add 	$9=, $15, $9
	i32.call	$push22=, printf@FUNCTION, $pop52, $9
	i32.const	$push23=, 1
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	5, $pop24       # 5: down to label4
# BB#6:                                 # %if.end31
	i32.const	$push25=, .L.str.3
	i32.store	$0=, 80($15):p2align=4, $pop25
	i32.const	$push55=, .L.str.4
	i32.const	$10=, 80
	i32.add 	$10=, $15, $10
	i32.call	$discard=, printf@FUNCTION, $pop55, $10
	i32.store	$discard=, 64($15):p2align=4, $0
	i32.const	$push54=, .L.str.4
	i32.const	$11=, 64
	i32.add 	$11=, $15, $11
	i32.call	$push26=, printf@FUNCTION, $pop54, $11
	br_if   	6, $pop26       # 6: down to label3
# BB#7:                                 # %if.end36
	i32.const	$push27=, 120
	i32.call	$discard=, putchar@FUNCTION, $pop27
	i32.const	$push56=, 120
	i32.store	$discard=, 48($15):p2align=4, $pop56
	i32.const	$push28=, .L.str.5
	i32.const	$12=, 48
	i32.add 	$12=, $15, $12
	i32.call	$push29=, printf@FUNCTION, $pop28, $12
	i32.const	$push30=, 1
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	7, $pop31       # 7: down to label2
# BB#8:                                 # %if.end41
	i32.const	$push32=, .L.str.1
	i32.call	$discard=, puts@FUNCTION, $pop32
	i32.const	$push57=, .L.str.1
	i32.store	$discard=, 32($15):p2align=4, $pop57
	i32.const	$push33=, .L.str.6
	i32.const	$13=, 32
	i32.add 	$13=, $15, $13
	i32.call	$push34=, printf@FUNCTION, $pop33, $13
	i32.const	$push35=, 7
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	8, $pop36       # 8: down to label1
# BB#9:                                 # %if.end46
	i32.const	$push37=, 0
	i32.store	$0=, 16($15):p2align=4, $pop37
	i32.const	$push38=, .L.str.7
	i32.const	$14=, 16
	i32.add 	$14=, $15, $14
	i32.call	$discard=, printf@FUNCTION, $pop38, $14
	i32.store	$discard=, 0($15):p2align=4, $0
	i32.const	$push58=, .L.str.7
	i32.call	$push39=, printf@FUNCTION, $pop58, $15
	i32.const	$push40=, 2
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	9, $pop41       # 9: down to label0
# BB#10:                                # %if.end51
	i32.const	$3=, 192
	i32.add 	$15=, $15, $3
	i32.const	$3=, __stack_pointer
	i32.store	$15=, 0($3), $15
	return  	$0
.LBB0_11:                               # %if.then
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %if.then5
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB0_13:                               # %if.then10
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB0_14:                               # %if.then20
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_15:                               # %if.then25
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_16:                               # %if.then30
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_17:                               # %if.then35
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_18:                               # %if.then40
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_19:                               # %if.then45
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_20:                               # %if.then50
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
