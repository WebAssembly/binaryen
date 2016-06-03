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
	i32.const	$push48=, 0
	i32.const	$push45=, 0
	i32.load	$push46=, __stack_pointer($pop45)
	i32.const	$push47=, 144
	i32.sub 	$push68=, $pop46, $pop47
	i32.store	$1=, __stack_pointer($pop48), $pop68
	i32.const	$push1=, .L.str
	i32.const	$push0=, 5
	i32.const	$push75=, 1
	i32.const	$push74=, 0
	i32.load	$push73=, stdout($pop74)
	tee_local	$push72=, $2=, $pop73
	i32.call	$drop=, fwrite@FUNCTION, $pop1, $pop0, $pop75, $pop72
	block
	i32.const	$push71=, .L.str
	i32.const	$push70=, 0
	i32.call	$push2=, fprintf@FUNCTION, $2, $pop71, $pop70
	i32.const	$push69=, 5
	i32.ne  	$push3=, $pop2, $pop69
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, .L.str.1
	i32.const	$push4=, 6
	i32.const	$push79=, 1
	i32.call	$drop=, fwrite@FUNCTION, $pop5, $pop4, $pop79, $2
	i32.const	$push78=, .L.str.1
	i32.const	$push77=, 0
	i32.call	$push6=, fprintf@FUNCTION, $2, $pop78, $pop77
	i32.const	$push76=, 6
	i32.ne  	$push7=, $pop6, $pop76
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push8=, 97
	i32.call	$drop=, fputc@FUNCTION, $pop8, $2
	i32.const	$push9=, .L.str.2
	i32.const	$push80=, 0
	i32.call	$push10=, fprintf@FUNCTION, $2, $pop9, $pop80
	i32.const	$push11=, 1
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push13=, .L.str.3
	i32.const	$push81=, 0
	i32.call	$push14=, fprintf@FUNCTION, $2, $pop13, $pop81
	br_if   	0, $pop14       # 0: down to label0
# BB#4:                                 # %if.end16
	i32.const	$push16=, .L.str
	i32.const	$push15=, 5
	i32.const	$push85=, 1
	i32.call	$drop=, fwrite@FUNCTION, $pop16, $pop15, $pop85, $2
	i32.const	$push84=, .L.str
	i32.store	$drop=, 128($1), $pop84
	i32.const	$push83=, .L.str.4
	i32.const	$push52=, 128
	i32.add 	$push53=, $1, $pop52
	i32.call	$push17=, fprintf@FUNCTION, $2, $pop83, $pop53
	i32.const	$push82=, 5
	i32.ne  	$push18=, $pop17, $pop82
	br_if   	0, $pop18       # 0: down to label0
# BB#5:                                 # %if.end21
	i32.const	$push20=, .L.str.1
	i32.const	$push19=, 6
	i32.const	$push89=, 1
	i32.call	$drop=, fwrite@FUNCTION, $pop20, $pop19, $pop89, $2
	i32.const	$push88=, .L.str.1
	i32.store	$drop=, 112($1), $pop88
	i32.const	$push87=, .L.str.4
	i32.const	$push54=, 112
	i32.add 	$push55=, $1, $pop54
	i32.call	$push21=, fprintf@FUNCTION, $2, $pop87, $pop55
	i32.const	$push86=, 6
	i32.ne  	$push22=, $pop21, $pop86
	br_if   	0, $pop22       # 0: down to label0
# BB#6:                                 # %if.end26
	i32.const	$push23=, 97
	i32.call	$drop=, fputc@FUNCTION, $pop23, $2
	i32.const	$push24=, .L.str.2
	i32.store	$drop=, 96($1), $pop24
	i32.const	$push90=, .L.str.4
	i32.const	$push56=, 96
	i32.add 	$push57=, $1, $pop56
	i32.call	$push25=, fprintf@FUNCTION, $2, $pop90, $pop57
	i32.const	$push26=, 1
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#7:                                 # %if.end31
	i32.const	$push28=, .L.str.3
	i32.store	$drop=, 80($1), $pop28
	i32.const	$push91=, .L.str.4
	i32.const	$push58=, 80
	i32.add 	$push59=, $1, $pop58
	i32.call	$push29=, fprintf@FUNCTION, $2, $pop91, $pop59
	br_if   	0, $pop29       # 0: down to label0
# BB#8:                                 # %if.end36
	i32.const	$push30=, 120
	i32.call	$drop=, fputc@FUNCTION, $pop30, $2
	i32.const	$push92=, 120
	i32.store	$drop=, 64($1), $pop92
	i32.const	$push31=, .L.str.5
	i32.const	$push60=, 64
	i32.add 	$push61=, $1, $pop60
	i32.call	$push32=, fprintf@FUNCTION, $2, $pop31, $pop61
	i32.const	$push33=, 1
	i32.ne  	$push34=, $pop32, $pop33
	br_if   	0, $pop34       # 0: down to label0
# BB#9:                                 # %if.end41
	i32.const	$push35=, .L.str.1
	i32.store	$0=, 48($1), $pop35
	i32.const	$push36=, .L.str.6
	i32.const	$push62=, 48
	i32.add 	$push63=, $1, $pop62
	i32.call	$drop=, fprintf@FUNCTION, $2, $pop36, $pop63
	i32.store	$drop=, 32($1), $0
	i32.const	$push93=, .L.str.6
	i32.const	$push64=, 32
	i32.add 	$push65=, $1, $pop64
	i32.call	$push37=, fprintf@FUNCTION, $2, $pop93, $pop65
	i32.const	$push38=, 7
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label0
# BB#10:                                # %if.end46
	i32.const	$push40=, 0
	i32.store	$0=, 16($1), $pop40
	i32.const	$push41=, .L.str.7
	i32.const	$push66=, 16
	i32.add 	$push67=, $1, $pop66
	i32.call	$drop=, fprintf@FUNCTION, $2, $pop41, $pop67
	i32.store	$drop=, 0($1), $0
	i32.const	$push94=, .L.str.7
	i32.call	$push42=, fprintf@FUNCTION, $2, $pop94, $1
	i32.const	$push43=, 2
	i32.ne  	$push44=, $pop42, $pop43
	br_if   	0, $pop44       # 0: down to label0
# BB#11:                                # %if.end51
	i32.const	$push51=, 0
	i32.const	$push49=, 144
	i32.add 	$push50=, $1, $pop49
	i32.store	$drop=, __stack_pointer($pop51), $pop50
	return  	$0
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
	.functype	fprintf, i32, i32, i32
	.functype	abort, void
	.functype	fwrite, i32, i32, i32, i32, i32
	.functype	fputc, i32, i32, i32
