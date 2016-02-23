	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/printf-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push59=, __stack_pointer
	i32.load	$push60=, 0($pop59)
	i32.const	$push61=, 192
	i32.sub 	$12=, $pop60, $pop61
	i32.const	$push62=, __stack_pointer
	i32.store	$discard=, 0($pop62), $12
	i32.const	$push45=, .Lstr
	i32.const	$push44=, 0
	i32.call	$discard=, printf@FUNCTION, $pop45, $pop44
	block
	i32.const	$push43=, .Lstr
	i32.const	$push42=, 0
	i32.call	$push0=, printf@FUNCTION, $pop43, $pop42
	i32.const	$push1=, 5
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push47=, .Lstr
	i32.call	$discard=, puts@FUNCTION, $pop47
	i32.const	$push3=, .L.str.1
	i32.const	$push46=, 0
	i32.call	$push4=, printf@FUNCTION, $pop3, $pop46
	i32.const	$push5=, 6
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push7=, 97
	i32.call	$discard=, putchar@FUNCTION, $pop7
	i32.const	$push8=, .L.str.2
	i32.const	$push9=, 0
	i32.call	$push10=, printf@FUNCTION, $pop8, $pop9
	i32.const	$push11=, 1
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#3:                                 # %if.end16
	i32.const	$push13=, .Lstr
	i32.store	$0=, 176($12):p2align=4, $pop13
	i32.const	$push49=, .L.str.4
	i32.const	$1=, 176
	i32.add 	$1=, $12, $1
	i32.call	$discard=, printf@FUNCTION, $pop49, $1
	i32.store	$discard=, 160($12):p2align=4, $0
	i32.const	$push48=, .L.str.4
	i32.const	$2=, 160
	i32.add 	$2=, $12, $2
	i32.call	$push14=, printf@FUNCTION, $pop48, $2
	i32.const	$push15=, 5
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label0
# BB#4:                                 # %if.end21
	i32.const	$push17=, .L.str.1
	i32.store	$0=, 144($12):p2align=4, $pop17
	i32.const	$push51=, .L.str.4
	i32.const	$3=, 144
	i32.add 	$3=, $12, $3
	i32.call	$discard=, printf@FUNCTION, $pop51, $3
	i32.store	$discard=, 128($12):p2align=4, $0
	i32.const	$push50=, .L.str.4
	i32.const	$4=, 128
	i32.add 	$4=, $12, $4
	i32.call	$push18=, printf@FUNCTION, $pop50, $4
	i32.const	$push19=, 6
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label0
# BB#5:                                 # %if.end26
	i32.const	$push21=, .L.str.2
	i32.store	$0=, 112($12):p2align=4, $pop21
	i32.const	$push53=, .L.str.4
	i32.const	$5=, 112
	i32.add 	$5=, $12, $5
	i32.call	$discard=, printf@FUNCTION, $pop53, $5
	i32.store	$discard=, 96($12):p2align=4, $0
	i32.const	$push52=, .L.str.4
	i32.const	$6=, 96
	i32.add 	$6=, $12, $6
	i32.call	$push22=, printf@FUNCTION, $pop52, $6
	i32.const	$push23=, 1
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	0, $pop24       # 0: down to label0
# BB#6:                                 # %if.end31
	i32.const	$push25=, .L.str.3
	i32.store	$0=, 80($12):p2align=4, $pop25
	i32.const	$push55=, .L.str.4
	i32.const	$7=, 80
	i32.add 	$7=, $12, $7
	i32.call	$discard=, printf@FUNCTION, $pop55, $7
	i32.store	$discard=, 64($12):p2align=4, $0
	i32.const	$push54=, .L.str.4
	i32.const	$8=, 64
	i32.add 	$8=, $12, $8
	i32.call	$push26=, printf@FUNCTION, $pop54, $8
	br_if   	0, $pop26       # 0: down to label0
# BB#7:                                 # %if.end36
	i32.const	$push27=, 120
	i32.call	$discard=, putchar@FUNCTION, $pop27
	i32.const	$push56=, 120
	i32.store	$discard=, 48($12):p2align=4, $pop56
	i32.const	$push28=, .L.str.5
	i32.const	$9=, 48
	i32.add 	$9=, $12, $9
	i32.call	$push29=, printf@FUNCTION, $pop28, $9
	i32.const	$push30=, 1
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label0
# BB#8:                                 # %if.end41
	i32.const	$push32=, .L.str.1
	i32.call	$discard=, puts@FUNCTION, $pop32
	i32.const	$push57=, .L.str.1
	i32.store	$discard=, 32($12):p2align=4, $pop57
	i32.const	$push33=, .L.str.6
	i32.const	$10=, 32
	i32.add 	$10=, $12, $10
	i32.call	$push34=, printf@FUNCTION, $pop33, $10
	i32.const	$push35=, 7
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label0
# BB#9:                                 # %if.end46
	i32.const	$push37=, 0
	i32.store	$0=, 16($12):p2align=4, $pop37
	i32.const	$push38=, .L.str.7
	i32.const	$11=, 16
	i32.add 	$11=, $12, $11
	i32.call	$discard=, printf@FUNCTION, $pop38, $11
	i32.store	$discard=, 0($12):p2align=4, $0
	i32.const	$push58=, .L.str.7
	i32.call	$push39=, printf@FUNCTION, $pop58, $12
	i32.const	$push40=, 2
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	0, $pop41       # 0: down to label0
# BB#10:                                # %if.end51
	i32.const	$push63=, 192
	i32.add 	$12=, $12, $pop63
	i32.const	$push64=, __stack_pointer
	i32.store	$discard=, 0($pop64), $12
	return  	$0
.LBB0_11:                               # %if.then50
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
