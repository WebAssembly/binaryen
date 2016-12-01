	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/fprintf-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push47=, 0
	i32.const	$push44=, 0
	i32.load	$push45=, __stack_pointer($pop44)
	i32.const	$push46=, 144
	i32.sub 	$push75=, $pop45, $pop46
	tee_local	$push74=, $1=, $pop75
	i32.store	__stack_pointer($pop47), $pop74
	i32.const	$push1=, .L.str
	i32.const	$push0=, 5
	i32.const	$push73=, 1
	i32.const	$push72=, 0
	i32.load	$push71=, stdout($pop72)
	tee_local	$push70=, $0=, $pop71
	i32.call	$drop=, fwrite@FUNCTION, $pop1, $pop0, $pop73, $pop70
	block   	
	i32.const	$push69=, .L.str
	i32.const	$push68=, 0
	i32.call	$push2=, fprintf@FUNCTION, $0, $pop69, $pop68
	i32.const	$push67=, 5
	i32.ne  	$push3=, $pop2, $pop67
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, .L.str.1
	i32.const	$push4=, 6
	i32.const	$push79=, 1
	i32.call	$drop=, fwrite@FUNCTION, $pop5, $pop4, $pop79, $0
	i32.const	$push78=, .L.str.1
	i32.const	$push77=, 0
	i32.call	$push6=, fprintf@FUNCTION, $0, $pop78, $pop77
	i32.const	$push76=, 6
	i32.ne  	$push7=, $pop6, $pop76
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push8=, 97
	i32.call	$drop=, fputc@FUNCTION, $pop8, $0
	i32.const	$push9=, .L.str.2
	i32.const	$push80=, 0
	i32.call	$push10=, fprintf@FUNCTION, $0, $pop9, $pop80
	i32.const	$push11=, 1
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push13=, .L.str.3
	i32.const	$push81=, 0
	i32.call	$push14=, fprintf@FUNCTION, $0, $pop13, $pop81
	br_if   	0, $pop14       # 0: down to label0
# BB#4:                                 # %if.end16
	i32.const	$push16=, .L.str
	i32.const	$push15=, 5
	i32.const	$push85=, 1
	i32.call	$drop=, fwrite@FUNCTION, $pop16, $pop15, $pop85, $0
	i32.const	$push84=, .L.str
	i32.store	128($1), $pop84
	i32.const	$push83=, .L.str.4
	i32.const	$push51=, 128
	i32.add 	$push52=, $1, $pop51
	i32.call	$push17=, fprintf@FUNCTION, $0, $pop83, $pop52
	i32.const	$push82=, 5
	i32.ne  	$push18=, $pop17, $pop82
	br_if   	0, $pop18       # 0: down to label0
# BB#5:                                 # %if.end21
	i32.const	$push20=, .L.str.1
	i32.const	$push19=, 6
	i32.const	$push89=, 1
	i32.call	$drop=, fwrite@FUNCTION, $pop20, $pop19, $pop89, $0
	i32.const	$push88=, .L.str.1
	i32.store	112($1), $pop88
	i32.const	$push87=, .L.str.4
	i32.const	$push53=, 112
	i32.add 	$push54=, $1, $pop53
	i32.call	$push21=, fprintf@FUNCTION, $0, $pop87, $pop54
	i32.const	$push86=, 6
	i32.ne  	$push22=, $pop21, $pop86
	br_if   	0, $pop22       # 0: down to label0
# BB#6:                                 # %if.end26
	i32.const	$push23=, 97
	i32.call	$drop=, fputc@FUNCTION, $pop23, $0
	i32.const	$push24=, .L.str.2
	i32.store	96($1), $pop24
	i32.const	$push90=, .L.str.4
	i32.const	$push55=, 96
	i32.add 	$push56=, $1, $pop55
	i32.call	$push25=, fprintf@FUNCTION, $0, $pop90, $pop56
	i32.const	$push26=, 1
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#7:                                 # %if.end31
	i32.const	$push28=, .L.str.3
	i32.store	80($1), $pop28
	i32.const	$push91=, .L.str.4
	i32.const	$push57=, 80
	i32.add 	$push58=, $1, $pop57
	i32.call	$push29=, fprintf@FUNCTION, $0, $pop91, $pop58
	br_if   	0, $pop29       # 0: down to label0
# BB#8:                                 # %if.end36
	i32.const	$push30=, 120
	i32.call	$drop=, fputc@FUNCTION, $pop30, $0
	i32.const	$push92=, 120
	i32.store	64($1), $pop92
	i32.const	$push31=, .L.str.5
	i32.const	$push59=, 64
	i32.add 	$push60=, $1, $pop59
	i32.call	$push32=, fprintf@FUNCTION, $0, $pop31, $pop60
	i32.const	$push33=, 1
	i32.ne  	$push34=, $pop32, $pop33
	br_if   	0, $pop34       # 0: down to label0
# BB#9:                                 # %if.end41
	i32.const	$push35=, .L.str.1
	i32.store	48($1), $pop35
	i32.const	$push36=, .L.str.6
	i32.const	$push61=, 48
	i32.add 	$push62=, $1, $pop61
	i32.call	$drop=, fprintf@FUNCTION, $0, $pop36, $pop62
	i32.const	$push94=, .L.str.1
	i32.store	32($1), $pop94
	i32.const	$push93=, .L.str.6
	i32.const	$push63=, 32
	i32.add 	$push64=, $1, $pop63
	i32.call	$push37=, fprintf@FUNCTION, $0, $pop93, $pop64
	i32.const	$push38=, 7
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label0
# BB#10:                                # %if.end46
	i32.const	$push97=, 0
	i32.store	16($1), $pop97
	i32.const	$push40=, .L.str.7
	i32.const	$push65=, 16
	i32.add 	$push66=, $1, $pop65
	i32.call	$drop=, fprintf@FUNCTION, $0, $pop40, $pop66
	i32.const	$push96=, 0
	i32.store	0($1), $pop96
	i32.const	$push95=, .L.str.7
	i32.call	$push41=, fprintf@FUNCTION, $0, $pop95, $1
	i32.const	$push42=, 2
	i32.ne  	$push43=, $pop41, $pop42
	br_if   	0, $pop43       # 0: down to label0
# BB#11:                                # %if.end51
	i32.const	$push50=, 0
	i32.const	$push48=, 144
	i32.add 	$push49=, $1, $pop48
	i32.store	__stack_pointer($pop50), $pop49
	i32.const	$push98=, 0
	return  	$pop98
.LBB0_12:                               # %if.then50
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


	.ident	"clang version 4.0.0 "
	.functype	fprintf, i32, i32, i32
	.functype	abort, void
	.functype	fwrite, i32, i32, i32, i32, i32
	.functype	fputc, i32, i32, i32
	.import_global	stdout
