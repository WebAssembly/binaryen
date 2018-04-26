	.text
	.file	"printf-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push43=, 0
	i32.load	$push42=, __stack_pointer($pop43)
	i32.const	$push44=, 176
	i32.sub 	$0=, $pop42, $pop44
	i32.const	$push45=, 0
	i32.store	__stack_pointer($pop45), $0
	i32.const	$push72=, .Lstr
	i32.const	$push71=, 0
	i32.call	$drop=, printf@FUNCTION, $pop72, $pop71
	block   	
	i32.const	$push70=, .Lstr
	i32.const	$push69=, 0
	i32.call	$push0=, printf@FUNCTION, $pop70, $pop69
	i32.const	$push1=, 5
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push74=, .Lstr
	i32.call	$drop=, puts@FUNCTION, $pop74
	i32.const	$push3=, .L.str.1
	i32.const	$push73=, 0
	i32.call	$push4=, printf@FUNCTION, $pop3, $pop73
	i32.const	$push5=, 6
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# %bb.2:                                # %if.end6
	i32.const	$push7=, 97
	i32.call	$drop=, putchar@FUNCTION, $pop7
	i32.const	$push9=, .L.str.2
	i32.const	$push8=, 0
	i32.call	$push10=, printf@FUNCTION, $pop9, $pop8
	i32.const	$push11=, 1
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label0
# %bb.3:                                # %if.end16
	i32.const	$push13=, .Lstr
	i32.store	160($0), $pop13
	i32.const	$push77=, .L.str.4
	i32.const	$push49=, 160
	i32.add 	$push50=, $0, $pop49
	i32.call	$drop=, printf@FUNCTION, $pop77, $pop50
	i32.const	$push76=, .Lstr
	i32.store	144($0), $pop76
	i32.const	$push75=, .L.str.4
	i32.const	$push51=, 144
	i32.add 	$push52=, $0, $pop51
	i32.call	$push14=, printf@FUNCTION, $pop75, $pop52
	i32.const	$push15=, 5
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label0
# %bb.4:                                # %if.end21
	i32.const	$push17=, .L.str.1
	i32.store	128($0), $pop17
	i32.const	$push80=, .L.str.4
	i32.const	$push53=, 128
	i32.add 	$push54=, $0, $pop53
	i32.call	$drop=, printf@FUNCTION, $pop80, $pop54
	i32.const	$push79=, .L.str.1
	i32.store	112($0), $pop79
	i32.const	$push78=, .L.str.4
	i32.const	$push55=, 112
	i32.add 	$push56=, $0, $pop55
	i32.call	$push18=, printf@FUNCTION, $pop78, $pop56
	i32.const	$push19=, 6
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label0
# %bb.5:                                # %if.end26
	i32.const	$push21=, 97
	i32.call	$drop=, putchar@FUNCTION, $pop21
	i32.const	$push22=, .L.str.2
	i32.store	96($0), $pop22
	i32.const	$push81=, .L.str.4
	i32.const	$push57=, 96
	i32.add 	$push58=, $0, $pop57
	i32.call	$push23=, printf@FUNCTION, $pop81, $pop58
	i32.const	$push24=, 1
	i32.ne  	$push25=, $pop23, $pop24
	br_if   	0, $pop25       # 0: down to label0
# %bb.6:                                # %if.end31
	i32.const	$push26=, .L.str.3
	i32.store	80($0), $pop26
	i32.const	$push84=, .L.str.4
	i32.const	$push59=, 80
	i32.add 	$push60=, $0, $pop59
	i32.call	$drop=, printf@FUNCTION, $pop84, $pop60
	i32.const	$push83=, .L.str.3
	i32.store	64($0), $pop83
	i32.const	$push82=, .L.str.4
	i32.const	$push61=, 64
	i32.add 	$push62=, $0, $pop61
	i32.call	$push27=, printf@FUNCTION, $pop82, $pop62
	br_if   	0, $pop27       # 0: down to label0
# %bb.7:                                # %if.end36
	i32.const	$push28=, 120
	i32.call	$drop=, putchar@FUNCTION, $pop28
	i32.const	$push85=, 120
	i32.store	48($0), $pop85
	i32.const	$push29=, .L.str.5
	i32.const	$push63=, 48
	i32.add 	$push64=, $0, $pop63
	i32.call	$push30=, printf@FUNCTION, $pop29, $pop64
	i32.const	$push31=, 1
	i32.ne  	$push32=, $pop30, $pop31
	br_if   	0, $pop32       # 0: down to label0
# %bb.8:                                # %if.end41
	i32.const	$push33=, .L.str.1
	i32.call	$drop=, puts@FUNCTION, $pop33
	i32.const	$push86=, .L.str.1
	i32.store	32($0), $pop86
	i32.const	$push34=, .L.str.6
	i32.const	$push65=, 32
	i32.add 	$push66=, $0, $pop65
	i32.call	$push35=, printf@FUNCTION, $pop34, $pop66
	i32.const	$push36=, 7
	i32.ne  	$push37=, $pop35, $pop36
	br_if   	0, $pop37       # 0: down to label0
# %bb.9:                                # %if.end46
	i32.const	$push89=, 0
	i32.store	16($0), $pop89
	i32.const	$push38=, .L.str.7
	i32.const	$push67=, 16
	i32.add 	$push68=, $0, $pop67
	i32.call	$drop=, printf@FUNCTION, $pop38, $pop68
	i32.const	$push88=, 0
	i32.store	0($0), $pop88
	i32.const	$push87=, .L.str.7
	i32.call	$push39=, printf@FUNCTION, $pop87, $0
	i32.const	$push40=, 2
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	0, $pop41       # 0: down to label0
# %bb.10:                               # %if.end51
	i32.const	$push48=, 0
	i32.const	$push46=, 176
	i32.add 	$push47=, $0, $pop46
	i32.store	__stack_pointer($pop48), $pop47
	i32.const	$push90=, 0
	return  	$pop90
.LBB0_11:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	printf, i32, i32
	.functype	abort, void
	.functype	puts, i32, i32
	.functype	putchar, i32, i32
