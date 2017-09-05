	.text
	.file	"va-arg-6.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push51=, 0
	i32.const	$push49=, 0
	i32.load	$push48=, __stack_pointer($pop49)
	i32.const	$push50=, 16
	i32.sub 	$push58=, $pop48, $pop50
	tee_local	$push57=, $4=, $pop58
	i32.store	__stack_pointer($pop51), $pop57
	i32.const	$push0=, 4
	i32.add 	$push56=, $1, $pop0
	tee_local	$push55=, $2=, $pop56
	i32.store	12($4), $pop55
	block   	
	i32.load	$push1=, 0($1)
	i32.const	$push2=, 10
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 7
	i32.add 	$push5=, $2, $pop4
	i32.const	$push6=, -8
	i32.and 	$push62=, $pop5, $pop6
	tee_local	$push61=, $1=, $pop62
	i32.const	$push7=, 8
	i32.add 	$push60=, $pop61, $pop7
	tee_local	$push59=, $2=, $pop60
	i32.store	12($4), $pop59
	i64.load	$push8=, 0($1)
	i64.const	$push9=, 10000000000
	i64.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$push11=, 12
	i32.add 	$push64=, $1, $pop11
	tee_local	$push63=, $1=, $pop64
	i32.store	12($4), $pop63
	i32.load	$push12=, 0($2)
	i32.const	$push13=, 11
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label0
# BB#3:                                 # %if.end11
	i32.const	$push15=, 15
	i32.add 	$push16=, $1, $pop15
	i32.const	$push17=, -16
	i32.and 	$push68=, $pop16, $pop17
	tee_local	$push67=, $1=, $pop68
	i32.const	$push18=, 16
	i32.add 	$push66=, $pop67, $pop18
	tee_local	$push65=, $2=, $pop66
	i32.store	12($4), $pop65
	i64.load	$push20=, 0($1)
	i64.load	$push19=, 8($1)
	i64.const	$push22=, -1475739525896764129
	i64.const	$push21=, 4611846459164112977
	i32.call	$push23=, __eqtf2@FUNCTION, $pop20, $pop19, $pop22, $pop21
	br_if   	0, $pop23       # 0: down to label0
# BB#4:                                 # %if.end16
	i32.const	$push24=, 20
	i32.add 	$push70=, $1, $pop24
	tee_local	$push69=, $3=, $pop70
	i32.store	12($4), $pop69
	i32.load	$push25=, 0($2)
	i32.const	$push26=, 12
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#5:                                 # %if.end21
	i32.const	$push28=, 24
	i32.add 	$push72=, $1, $pop28
	tee_local	$push71=, $2=, $pop72
	i32.store	12($4), $pop71
	i32.load	$push29=, 0($3)
	i32.const	$push30=, 13
	i32.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label0
# BB#6:                                 # %if.end26
	i32.const	$push32=, 32
	i32.add 	$push74=, $1, $pop32
	tee_local	$push73=, $3=, $pop74
	i32.store	12($4), $pop73
	i64.load	$push33=, 0($2)
	i64.const	$push34=, 20000000000
	i64.ne  	$push35=, $pop33, $pop34
	br_if   	0, $pop35       # 0: down to label0
# BB#7:                                 # %if.end31
	i32.const	$push36=, 36
	i32.add 	$push76=, $1, $pop36
	tee_local	$push75=, $1=, $pop76
	i32.store	12($4), $pop75
	i32.load	$push37=, 0($3)
	i32.const	$push38=, 14
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label0
# BB#8:                                 # %if.end36
	i32.const	$push40=, 7
	i32.add 	$push41=, $1, $pop40
	i32.const	$push42=, -8
	i32.and 	$push78=, $pop41, $pop42
	tee_local	$push77=, $1=, $pop78
	i32.const	$push43=, 8
	i32.add 	$push44=, $pop77, $pop43
	i32.store	12($4), $pop44
	f64.load	$push45=, 0($1)
	f64.const	$push46=, 0x1.5c28f5c28f5c3p1
	f64.ne  	$push47=, $pop45, $pop46
	br_if   	0, $pop47       # 0: down to label0
# BB#9:                                 # %if.end41
	i32.const	$push54=, 0
	i32.const	$push52=, 16
	i32.add 	$push53=, $4, $pop52
	i32.store	__stack_pointer($pop54), $pop53
	return  	$4
.LBB0_10:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push27=, 0
	i32.const	$push25=, 0
	i32.load	$push24=, __stack_pointer($pop25)
	i32.const	$push26=, 80
	i32.sub 	$push29=, $pop24, $pop26
	tee_local	$push28=, $0=, $pop29
	i32.store	__stack_pointer($pop27), $pop28
	i32.const	$push0=, 64
	i32.add 	$push1=, $0, $pop0
	i64.const	$push2=, 4613307314293241283
	i64.store	0($pop1), $pop2
	i32.const	$push3=, 56
	i32.add 	$push4=, $0, $pop3
	i32.const	$push5=, 14
	i32.store	0($pop4), $pop5
	i32.const	$push6=, 48
	i32.add 	$push7=, $0, $pop6
	i64.const	$push8=, 20000000000
	i64.store	0($pop7), $pop8
	i32.const	$push9=, 40
	i32.add 	$push10=, $0, $pop9
	i64.const	$push11=, 55834574860
	i64.store	0($pop10), $pop11
	i32.const	$push12=, 32
	i32.add 	$push13=, $0, $pop12
	i64.const	$push14=, 4611846459164112977
	i64.store	0($pop13), $pop14
	i32.const	$push15=, 24
	i32.add 	$push16=, $0, $pop15
	i64.const	$push17=, -1475739525896764129
	i64.store	0($pop16), $pop17
	i32.const	$push18=, 16
	i32.add 	$push19=, $0, $pop18
	i32.const	$push20=, 11
	i32.store	0($pop19), $pop20
	i64.const	$push21=, 10000000000
	i64.store	8($0), $pop21
	i32.const	$push22=, 10
	i32.store	0($0), $pop22
	i32.call	$drop=, f@FUNCTION, $0, $0
	i32.const	$push23=, 0
	call    	exit@FUNCTION, $pop23
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
