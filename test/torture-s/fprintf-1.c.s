	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/fprintf-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push59=, __stack_pointer
	i32.const	$push56=, __stack_pointer
	i32.load	$push57=, 0($pop56)
	i32.const	$push58=, 144
	i32.sub 	$push79=, $pop57, $pop58
	i32.store	$2=, 0($pop59), $pop79
	i32.const	$push1=, .L.str
	i32.const	$push2=, 5
	i32.const	$push85=, 1
	i32.const	$push84=, 0
	i32.load	$push0=, stdout($pop84)
	i32.call	$discard=, fwrite@FUNCTION, $pop1, $pop2, $pop85, $pop0
	block
	i32.const	$push83=, 0
	i32.load	$push3=, stdout($pop83)
	i32.const	$push82=, .L.str
	i32.const	$push81=, 0
	i32.call	$push4=, fprintf@FUNCTION, $pop3, $pop82, $pop81
	i32.const	$push80=, 5
	i32.ne  	$push5=, $pop4, $pop80
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push7=, .L.str.1
	i32.const	$push8=, 6
	i32.const	$push91=, 1
	i32.const	$push90=, 0
	i32.load	$push6=, stdout($pop90)
	i32.call	$discard=, fwrite@FUNCTION, $pop7, $pop8, $pop91, $pop6
	i32.const	$push89=, 0
	i32.load	$push9=, stdout($pop89)
	i32.const	$push88=, .L.str.1
	i32.const	$push87=, 0
	i32.call	$push10=, fprintf@FUNCTION, $pop9, $pop88, $pop87
	i32.const	$push86=, 6
	i32.ne  	$push11=, $pop10, $pop86
	br_if   	0, $pop11       # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push13=, 97
	i32.const	$push94=, 0
	i32.load	$push12=, stdout($pop94)
	i32.call	$discard=, fputc@FUNCTION, $pop13, $pop12
	i32.const	$push93=, 0
	i32.load	$push14=, stdout($pop93)
	i32.const	$push15=, .L.str.2
	i32.const	$push92=, 0
	i32.call	$push16=, fprintf@FUNCTION, $pop14, $pop15, $pop92
	i32.const	$push17=, 1
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	0, $pop18       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push96=, 0
	i32.load	$push19=, stdout($pop96)
	i32.const	$push20=, .L.str.3
	i32.const	$push95=, 0
	i32.call	$push21=, fprintf@FUNCTION, $pop19, $pop20, $pop95
	br_if   	0, $pop21       # 0: down to label0
# BB#4:                                 # %if.end16
	i32.const	$push23=, .L.str
	i32.const	$push24=, 5
	i32.const	$push102=, 1
	i32.const	$push101=, 0
	i32.load	$push22=, stdout($pop101)
	i32.call	$discard=, fwrite@FUNCTION, $pop23, $pop24, $pop102, $pop22
	i32.const	$push100=, 0
	i32.load	$1=, stdout($pop100)
	i32.const	$push99=, .L.str
	i32.store	$discard=, 128($2), $pop99
	i32.const	$push98=, .L.str.4
	i32.const	$push63=, 128
	i32.add 	$push64=, $2, $pop63
	i32.call	$push25=, fprintf@FUNCTION, $1, $pop98, $pop64
	i32.const	$push97=, 5
	i32.ne  	$push26=, $pop25, $pop97
	br_if   	0, $pop26       # 0: down to label0
# BB#5:                                 # %if.end21
	i32.const	$push28=, .L.str.1
	i32.const	$push29=, 6
	i32.const	$push108=, 1
	i32.const	$push107=, 0
	i32.load	$push27=, stdout($pop107)
	i32.call	$discard=, fwrite@FUNCTION, $pop28, $pop29, $pop108, $pop27
	i32.const	$push106=, 0
	i32.load	$1=, stdout($pop106)
	i32.const	$push105=, .L.str.1
	i32.store	$discard=, 112($2), $pop105
	i32.const	$push104=, .L.str.4
	i32.const	$push65=, 112
	i32.add 	$push66=, $2, $pop65
	i32.call	$push30=, fprintf@FUNCTION, $1, $pop104, $pop66
	i32.const	$push103=, 6
	i32.ne  	$push31=, $pop30, $pop103
	br_if   	0, $pop31       # 0: down to label0
# BB#6:                                 # %if.end26
	i32.const	$push33=, 97
	i32.const	$push111=, 0
	i32.load	$push32=, stdout($pop111)
	i32.call	$discard=, fputc@FUNCTION, $pop33, $pop32
	i32.const	$push110=, 0
	i32.load	$1=, stdout($pop110)
	i32.const	$push34=, .L.str.2
	i32.store	$discard=, 96($2), $pop34
	i32.const	$push109=, .L.str.4
	i32.const	$push67=, 96
	i32.add 	$push68=, $2, $pop67
	i32.call	$push35=, fprintf@FUNCTION, $1, $pop109, $pop68
	i32.const	$push36=, 1
	i32.ne  	$push37=, $pop35, $pop36
	br_if   	0, $pop37       # 0: down to label0
# BB#7:                                 # %if.end31
	i32.const	$push113=, 0
	i32.load	$1=, stdout($pop113)
	i32.const	$push38=, .L.str.3
	i32.store	$discard=, 80($2), $pop38
	i32.const	$push112=, .L.str.4
	i32.const	$push69=, 80
	i32.add 	$push70=, $2, $pop69
	i32.call	$push39=, fprintf@FUNCTION, $1, $pop112, $pop70
	br_if   	0, $pop39       # 0: down to label0
# BB#8:                                 # %if.end36
	i32.const	$push41=, 120
	i32.const	$push116=, 0
	i32.load	$push40=, stdout($pop116)
	i32.call	$discard=, fputc@FUNCTION, $pop41, $pop40
	i32.const	$push115=, 0
	i32.load	$1=, stdout($pop115)
	i32.const	$push114=, 120
	i32.store	$discard=, 64($2), $pop114
	i32.const	$push42=, .L.str.5
	i32.const	$push71=, 64
	i32.add 	$push72=, $2, $pop71
	i32.call	$push43=, fprintf@FUNCTION, $1, $pop42, $pop72
	i32.const	$push44=, 1
	i32.ne  	$push45=, $pop43, $pop44
	br_if   	0, $pop45       # 0: down to label0
# BB#9:                                 # %if.end41
	i32.const	$push119=, 0
	i32.load	$1=, stdout($pop119)
	i32.const	$push46=, .L.str.1
	i32.store	$0=, 48($2), $pop46
	i32.const	$push47=, .L.str.6
	i32.const	$push73=, 48
	i32.add 	$push74=, $2, $pop73
	i32.call	$discard=, fprintf@FUNCTION, $1, $pop47, $pop74
	i32.const	$push118=, 0
	i32.load	$1=, stdout($pop118)
	i32.store	$discard=, 32($2), $0
	i32.const	$push117=, .L.str.6
	i32.const	$push75=, 32
	i32.add 	$push76=, $2, $pop75
	i32.call	$push48=, fprintf@FUNCTION, $1, $pop117, $pop76
	i32.const	$push49=, 7
	i32.ne  	$push50=, $pop48, $pop49
	br_if   	0, $pop50       # 0: down to label0
# BB#10:                                # %if.end46
	i32.const	$push51=, 0
	i32.load	$0=, stdout($pop51)
	i32.const	$push121=, 0
	i32.store	$1=, 16($2), $pop121
	i32.const	$push52=, .L.str.7
	i32.const	$push77=, 16
	i32.add 	$push78=, $2, $pop77
	i32.call	$discard=, fprintf@FUNCTION, $0, $pop52, $pop78
	i32.load	$0=, stdout($1)
	i32.store	$discard=, 0($2), $1
	i32.const	$push120=, .L.str.7
	i32.call	$push53=, fprintf@FUNCTION, $0, $pop120, $2
	i32.const	$push54=, 2
	i32.ne  	$push55=, $pop53, $pop54
	br_if   	0, $pop55       # 0: down to label0
# BB#11:                                # %if.end51
	i32.const	$push62=, __stack_pointer
	i32.const	$push60=, 144
	i32.add 	$push61=, $2, $pop60
	i32.store	$discard=, 0($pop62), $pop61
	return  	$1
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


	.ident	"clang version 3.9.0 "
