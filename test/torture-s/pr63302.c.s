	.text
	.file	"pr63302.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push2=, -9223372036854773761
	i64.and 	$push11=, $0, $pop2
	tee_local	$push10=, $0=, $pop11
	i64.or  	$push7=, $pop10, $1
	i64.eqz 	$push8=, $pop7
	i64.const	$push3=, -9223372036854775808
	i64.xor 	$push4=, $0, $pop3
	i64.const	$push0=, -1
	i64.xor 	$push1=, $1, $pop0
	i64.or  	$push5=, $pop4, $pop1
	i64.eqz 	$push6=, $pop5
	i32.or  	$push9=, $pop8, $pop6
                                        # fallthrough-return: $pop9
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, -2147481601
	i64.and 	$push6=, $0, $pop0
	tee_local	$push5=, $0=, $pop6
	i64.eqz 	$push3=, $pop5
	i64.const	$push1=, -2147483648
	i64.eq  	$push2=, $0, $pop1
	i32.or  	$push4=, $pop3, $pop2
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i64.const	$push52=, 0
	i64.const	$push51=, 0
	i32.call	$push0=, foo@FUNCTION, $pop52, $pop51
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i64.const	$push3=, 1
	i64.const	$push53=, 0
	i32.call	$push4=, foo@FUNCTION, $pop3, $pop53
	br_if   	0, $pop4        # 0: down to label0
# BB#2:                                 # %lor.lhs.false3
	i64.const	$push5=, 2048
	i64.const	$push54=, 0
	i32.call	$push6=, foo@FUNCTION, $pop5, $pop54
	i32.const	$push7=, 1
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %lor.lhs.false6
	i64.const	$push9=, 2049
	i64.const	$push55=, 0
	i32.call	$push10=, foo@FUNCTION, $pop9, $pop55
	br_if   	0, $pop10       # 0: down to label0
# BB#4:                                 # %lor.lhs.false9
	i64.const	$push56=, -9223372036854775808
	i64.const	$push11=, 0
	i32.call	$push12=, foo@FUNCTION, $pop56, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#5:                                 # %lor.lhs.false12
	i64.const	$push58=, -9223372036854775808
	i64.const	$push57=, -1
	i32.call	$push13=, foo@FUNCTION, $pop58, $pop57
	i32.const	$push14=, 1
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label0
# BB#6:                                 # %lor.lhs.false15
	i64.const	$push16=, -9223372036854775807
	i64.const	$push59=, -1
	i32.call	$push17=, foo@FUNCTION, $pop16, $pop59
	br_if   	0, $pop17       # 0: down to label0
# BB#7:                                 # %lor.lhs.false18
	i64.const	$push18=, -9223372036854773760
	i64.const	$push60=, -1
	i32.call	$push19=, foo@FUNCTION, $pop18, $pop60
	i32.const	$push20=, 1
	i32.ne  	$push21=, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label0
# BB#8:                                 # %lor.lhs.false21
	i64.const	$push22=, -9223372036854773759
	i64.const	$push61=, -1
	i32.call	$push23=, foo@FUNCTION, $pop22, $pop61
	br_if   	0, $pop23       # 0: down to label0
# BB#9:                                 # %if.end
	i64.const	$push24=, 0
	i32.call	$push25=, bar@FUNCTION, $pop24
	i32.const	$push26=, 1
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#10:                                # %lor.lhs.false26
	i64.const	$push28=, 1
	i32.call	$push29=, bar@FUNCTION, $pop28
	br_if   	0, $pop29       # 0: down to label0
# BB#11:                                # %lor.lhs.false29
	i64.const	$push30=, 2048
	i32.call	$push31=, bar@FUNCTION, $pop30
	i32.const	$push32=, 1
	i32.ne  	$push33=, $pop31, $pop32
	br_if   	0, $pop33       # 0: down to label0
# BB#12:                                # %lor.lhs.false32
	i64.const	$push34=, 2049
	i32.call	$push35=, bar@FUNCTION, $pop34
	br_if   	0, $pop35       # 0: down to label0
# BB#13:                                # %lor.lhs.false35
	i64.const	$push36=, 2147483648
	i32.call	$push37=, bar@FUNCTION, $pop36
	br_if   	0, $pop37       # 0: down to label0
# BB#14:                                # %lor.lhs.false38
	i64.const	$push38=, -2147483648
	i32.call	$push39=, bar@FUNCTION, $pop38
	i32.const	$push40=, 1
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	0, $pop41       # 0: down to label0
# BB#15:                                # %lor.lhs.false41
	i64.const	$push42=, -2147483647
	i32.call	$push43=, bar@FUNCTION, $pop42
	br_if   	0, $pop43       # 0: down to label0
# BB#16:                                # %lor.lhs.false44
	i64.const	$push44=, -2147481600
	i32.call	$push45=, bar@FUNCTION, $pop44
	i32.const	$push46=, 1
	i32.ne  	$push47=, $pop45, $pop46
	br_if   	0, $pop47       # 0: down to label0
# BB#17:                                # %lor.lhs.false47
	i64.const	$push48=, -2147481599
	i32.call	$push49=, bar@FUNCTION, $pop48
	br_if   	0, $pop49       # 0: down to label0
# BB#18:                                # %if.end51
	i32.const	$push50=, 0
	return  	$pop50
.LBB2_19:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
