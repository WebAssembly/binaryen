	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/printf-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push46=, 0
	i32.const	$push43=, 0
	i32.load	$push44=, __stack_pointer($pop43)
	i32.const	$push45=, 176
	i32.sub 	$push70=, $pop44, $pop45
	i32.store	$1=, __stack_pointer($pop46), $pop70
	i32.const	$push74=, .Lstr
	i32.const	$push73=, 0
	i32.call	$drop=, printf@FUNCTION, $pop74, $pop73
	block
	i32.const	$push72=, .Lstr
	i32.const	$push71=, 0
	i32.call	$push0=, printf@FUNCTION, $pop72, $pop71
	i32.const	$push1=, 5
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push76=, .Lstr
	i32.call	$drop=, puts@FUNCTION, $pop76
	i32.const	$push3=, .L.str.1
	i32.const	$push75=, 0
	i32.call	$push4=, printf@FUNCTION, $pop3, $pop75
	i32.const	$push5=, 6
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push7=, 97
	i32.call	$drop=, putchar@FUNCTION, $pop7
	i32.const	$push9=, .L.str.2
	i32.const	$push8=, 0
	i32.call	$push10=, printf@FUNCTION, $pop9, $pop8
	i32.const	$push11=, 1
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#3:                                 # %if.end16
	i32.const	$push13=, .Lstr
	i32.store	$0=, 160($1), $pop13
	i32.const	$push78=, .L.str.4
	i32.const	$push50=, 160
	i32.add 	$push51=, $1, $pop50
	i32.call	$drop=, printf@FUNCTION, $pop78, $pop51
	i32.store	$drop=, 144($1), $0
	i32.const	$push77=, .L.str.4
	i32.const	$push52=, 144
	i32.add 	$push53=, $1, $pop52
	i32.call	$push14=, printf@FUNCTION, $pop77, $pop53
	i32.const	$push15=, 5
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label0
# BB#4:                                 # %if.end21
	i32.const	$push17=, .L.str.1
	i32.store	$0=, 128($1), $pop17
	i32.const	$push80=, .L.str.4
	i32.const	$push54=, 128
	i32.add 	$push55=, $1, $pop54
	i32.call	$drop=, printf@FUNCTION, $pop80, $pop55
	i32.store	$drop=, 112($1), $0
	i32.const	$push79=, .L.str.4
	i32.const	$push56=, 112
	i32.add 	$push57=, $1, $pop56
	i32.call	$push18=, printf@FUNCTION, $pop79, $pop57
	i32.const	$push19=, 6
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label0
# BB#5:                                 # %if.end26
	i32.const	$push21=, 97
	i32.call	$drop=, putchar@FUNCTION, $pop21
	i32.const	$push22=, .L.str.2
	i32.store	$drop=, 96($1), $pop22
	i32.const	$push81=, .L.str.4
	i32.const	$push58=, 96
	i32.add 	$push59=, $1, $pop58
	i32.call	$push23=, printf@FUNCTION, $pop81, $pop59
	i32.const	$push24=, 1
	i32.ne  	$push25=, $pop23, $pop24
	br_if   	0, $pop25       # 0: down to label0
# BB#6:                                 # %if.end31
	i32.const	$push26=, .L.str.3
	i32.store	$0=, 80($1), $pop26
	i32.const	$push83=, .L.str.4
	i32.const	$push60=, 80
	i32.add 	$push61=, $1, $pop60
	i32.call	$drop=, printf@FUNCTION, $pop83, $pop61
	i32.store	$drop=, 64($1), $0
	i32.const	$push82=, .L.str.4
	i32.const	$push62=, 64
	i32.add 	$push63=, $1, $pop62
	i32.call	$push27=, printf@FUNCTION, $pop82, $pop63
	br_if   	0, $pop27       # 0: down to label0
# BB#7:                                 # %if.end36
	i32.const	$push28=, 120
	i32.call	$drop=, putchar@FUNCTION, $pop28
	i32.const	$push84=, 120
	i32.store	$drop=, 48($1), $pop84
	i32.const	$push29=, .L.str.5
	i32.const	$push64=, 48
	i32.add 	$push65=, $1, $pop64
	i32.call	$push30=, printf@FUNCTION, $pop29, $pop65
	i32.const	$push31=, 1
	i32.ne  	$push32=, $pop30, $pop31
	br_if   	0, $pop32       # 0: down to label0
# BB#8:                                 # %if.end41
	i32.const	$push33=, .L.str.1
	i32.call	$drop=, puts@FUNCTION, $pop33
	i32.const	$push85=, .L.str.1
	i32.store	$drop=, 32($1), $pop85
	i32.const	$push34=, .L.str.6
	i32.const	$push66=, 32
	i32.add 	$push67=, $1, $pop66
	i32.call	$push35=, printf@FUNCTION, $pop34, $pop67
	i32.const	$push36=, 7
	i32.ne  	$push37=, $pop35, $pop36
	br_if   	0, $pop37       # 0: down to label0
# BB#9:                                 # %if.end46
	i32.const	$push38=, 0
	i32.store	$0=, 16($1), $pop38
	i32.const	$push39=, .L.str.7
	i32.const	$push68=, 16
	i32.add 	$push69=, $1, $pop68
	i32.call	$drop=, printf@FUNCTION, $pop39, $pop69
	i32.store	$drop=, 0($1), $0
	i32.const	$push86=, .L.str.7
	i32.call	$push40=, printf@FUNCTION, $pop86, $1
	i32.const	$push41=, 2
	i32.ne  	$push42=, $pop40, $pop41
	br_if   	0, $pop42       # 0: down to label0
# BB#10:                                # %if.end51
	i32.const	$push49=, 0
	i32.const	$push47=, 176
	i32.add 	$push48=, $1, $pop47
	i32.store	$drop=, __stack_pointer($pop49), $pop48
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
	.functype	printf, i32, i32
	.functype	abort, void
	.functype	puts, i32, i32
	.functype	putchar, i32, i32
