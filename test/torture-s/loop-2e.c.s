	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-2e.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.store	0($1), $0
	i32.const	$push0=, 4
	i32.add 	$push1=, $0, $pop0
	i32.store	4($1), $pop1
	i32.const	$push2=, 8
	i32.add 	$push3=, $0, $pop2
	i32.store	8($1), $pop3
	i32.const	$push4=, 12
	i32.add 	$push5=, $0, $pop4
	i32.store	12($1), $pop5
	i32.const	$push6=, 16
	i32.add 	$push7=, $0, $pop6
	i32.store	16($1), $pop7
	i32.const	$push8=, 20
	i32.add 	$push9=, $0, $pop8
	i32.store	20($1), $pop9
	i32.const	$push10=, 24
	i32.add 	$push11=, $0, $pop10
	i32.store	24($1), $pop11
	i32.const	$push12=, 28
	i32.add 	$push13=, $0, $pop12
	i32.store	28($1), $pop13
	i32.const	$push14=, 32
	i32.add 	$push15=, $0, $pop14
	i32.store	32($1), $pop15
	i32.const	$push16=, 36
	i32.add 	$push17=, $0, $pop16
	i32.store	36($1), $pop17
	i32.const	$push18=, 40
	i32.add 	$push19=, $0, $pop18
	i32.store	40($1), $pop19
	i32.const	$push20=, 44
	i32.add 	$push21=, $0, $pop20
	i32.store	44($1), $pop21
	i32.const	$push22=, 48
	i32.add 	$push23=, $0, $pop22
	i32.store	48($1), $pop23
	i32.const	$push24=, 52
	i32.add 	$push25=, $0, $pop24
	i32.store	52($1), $pop25
	i32.const	$push26=, 56
	i32.add 	$push27=, $0, $pop26
	i32.store	56($1), $pop27
	i32.const	$push28=, 60
	i32.add 	$push29=, $0, $pop28
	i32.store	60($1), $pop29
	i32.const	$push30=, 64
	i32.add 	$push31=, $0, $pop30
	i32.store	64($1), $pop31
	i32.const	$push32=, 68
	i32.add 	$push33=, $0, $pop32
	i32.store	68($1), $pop33
	i32.const	$push34=, 72
	i32.add 	$push35=, $0, $pop34
	i32.store	72($1), $pop35
	i32.const	$push36=, 76
	i32.add 	$push37=, $0, $pop36
	i32.store	76($1), $pop37
	i32.const	$push38=, 80
	i32.add 	$push39=, $0, $pop38
	i32.store	80($1), $pop39
	i32.const	$push40=, 84
	i32.add 	$push41=, $0, $pop40
	i32.store	84($1), $pop41
	i32.const	$push42=, 88
	i32.add 	$push43=, $0, $pop42
	i32.store	88($1), $pop43
	i32.const	$push44=, 92
	i32.add 	$push45=, $0, $pop44
	i32.store	92($1), $pop45
	i32.const	$push46=, 96
	i32.add 	$push47=, $0, $pop46
	i32.store	96($1), $pop47
	i32.const	$push48=, 100
	i32.add 	$push49=, $0, $pop48
	i32.store	100($1), $pop49
	i32.const	$push50=, 104
	i32.add 	$push51=, $0, $pop50
	i32.store	104($1), $pop51
	i32.const	$push52=, 108
	i32.add 	$push53=, $0, $pop52
	i32.store	108($1), $pop53
	i32.const	$push54=, 112
	i32.add 	$push55=, $0, $pop54
	i32.store	112($1), $pop55
	i32.const	$push56=, 116
	i32.add 	$push57=, $0, $pop56
	i32.store	116($1), $pop57
	i32.const	$push58=, 120
	i32.add 	$push59=, $0, $pop58
	i32.store	120($1), $pop59
	i32.const	$push60=, 124
	i32.add 	$push61=, $0, $pop60
	i32.store	124($1), $pop61
	i32.const	$push62=, 128
	i32.add 	$push63=, $0, $pop62
	i32.store	128($1), $pop63
	i32.const	$push64=, 132
	i32.add 	$push65=, $0, $pop64
	i32.store	132($1), $pop65
	i32.const	$push66=, 136
	i32.add 	$push67=, $0, $pop66
	i32.store	136($1), $pop67
	i32.const	$push68=, 140
	i32.add 	$push69=, $0, $pop68
	i32.store	140($1), $pop69
	i32.const	$push70=, 144
	i32.add 	$push71=, $0, $pop70
	i32.store	144($1), $pop71
	i32.const	$push72=, 148
	i32.add 	$push73=, $0, $pop72
	i32.store	148($1), $pop73
	i32.const	$push74=, 152
	i32.add 	$push75=, $0, $pop74
	i32.store	152($1), $pop75
	i32.const	$push76=, 156
	i32.add 	$push77=, $0, $pop76
	i32.store	156($1), $pop77
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
