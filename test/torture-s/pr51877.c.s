	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr51877.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.store8	4($0), $1
	i32.const	$push0=, 0
	i32.load	$push1=, bar.n($pop0)
	i32.const	$push2=, 1
	i32.add 	$push9=, $pop1, $pop2
	tee_local	$push8=, $1=, $pop9
	i32.store	0($0), $pop8
	i32.const	$push7=, 0
	i32.store	bar.n($pop7), $1
	i32.const	$push3=, 5
	i32.add 	$push4=, $0, $pop3
	i32.const	$push6=, 0
	i32.const	$push5=, 31
	i32.call	$drop=, memset@FUNCTION, $pop4, $pop6, $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.baz,"ax",@progbits
	.hidden	baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
# BB#0:                                 # %entry
	#APP
	#NO_APP
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	baz, .Lfunc_end1-baz

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push7=, 0
	i32.load	$push8=, __stack_pointer($pop7)
	i32.const	$push9=, 80
	i32.sub 	$push19=, $pop8, $pop9
	tee_local	$push18=, $2=, $pop19
	i32.store	__stack_pointer($pop10), $pop18
	block   	
	block   	
	i32.const	$push0=, 6
	i32.ne  	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %if.then
	i32.const	$push14=, 40
	i32.add 	$push15=, $2, $pop14
	i32.const	$push4=, 7
	call    	bar@FUNCTION, $pop15, $pop4
	i32.const	$push6=, a
	i32.const	$push16=, 40
	i32.add 	$push17=, $2, $pop16
	i32.const	$push5=, 36
	i32.call	$drop=, memcpy@FUNCTION, $pop6, $pop17, $pop5
	br      	1               # 1: down to label0
.LBB2_2:                                # %if.else
	end_block                       # label1:
	i32.const	$push2=, 7
	call    	bar@FUNCTION, $2, $pop2
	i32.const	$push3=, 36
	i32.call	$drop=, memcpy@FUNCTION, $0, $2, $pop3
.LBB2_3:                                # %if.end
	end_block                       # label0:
	call    	baz@FUNCTION
	i32.const	$push13=, 0
	i32.const	$push11=, 80
	i32.add 	$push12=, $2, $pop11
	i32.store	__stack_pointer($pop13), $pop12
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	foo, .Lfunc_end2-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push50=, 0
	i32.const	$push47=, 0
	i32.load	$push48=, __stack_pointer($pop47)
	i32.const	$push49=, 80
	i32.sub 	$push62=, $pop48, $pop49
	tee_local	$push61=, $0=, $pop62
	i32.store	__stack_pointer($pop50), $pop61
	i32.const	$push54=, 40
	i32.add 	$push55=, $0, $pop54
	i32.const	$push60=, 3
	call    	bar@FUNCTION, $pop55, $pop60
	i32.const	$push1=, a
	i32.const	$push56=, 40
	i32.add 	$push57=, $0, $pop56
	i32.const	$push0=, 36
	i32.call	$drop=, memcpy@FUNCTION, $pop1, $pop57, $pop0
	i32.const	$push2=, 4
	call    	bar@FUNCTION, $0, $pop2
	i32.const	$push3=, b
	i32.const	$push59=, 36
	i32.call	$drop=, memcpy@FUNCTION, $pop3, $0, $pop59
	block   	
	i32.const	$push58=, 0
	i32.load	$push4=, a($pop58)
	i32.const	$push5=, 1
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label2
# BB#1:                                 # %lor.lhs.false
	i32.const	$push64=, 0
	i32.load8_u	$push9=, a+4($pop64)
	i32.const	$push63=, 3
	i32.ne  	$push10=, $pop9, $pop63
	br_if   	0, $pop10       # 0: down to label2
# BB#2:                                 # %lor.lhs.false
	i32.const	$push65=, 0
	i32.load	$push7=, b($pop65)
	i32.const	$push11=, 2
	i32.ne  	$push12=, $pop7, $pop11
	br_if   	0, $pop12       # 0: down to label2
# BB#3:                                 # %lor.lhs.false
	i32.const	$push66=, 0
	i32.load8_u	$push8=, b+4($pop66)
	i32.const	$push13=, 255
	i32.and 	$push14=, $pop8, $pop13
	i32.const	$push15=, 4
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label2
# BB#4:                                 # %if.end
	i32.const	$push17=, b
	i32.const	$push68=, 0
	call    	foo@FUNCTION, $pop17, $pop68
	i32.const	$push67=, 0
	i32.load	$push18=, a($pop67)
	i32.const	$push19=, 1
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label2
# BB#5:                                 # %lor.lhs.false13
	i32.const	$push70=, 0
	i32.load8_u	$push23=, a+4($pop70)
	i32.const	$push69=, 3
	i32.ne  	$push24=, $pop23, $pop69
	br_if   	0, $pop24       # 0: down to label2
# BB#6:                                 # %lor.lhs.false13
	i32.const	$push72=, 0
	i32.load	$push21=, b($pop72)
	i32.const	$push71=, 3
	i32.ne  	$push25=, $pop21, $pop71
	br_if   	0, $pop25       # 0: down to label2
# BB#7:                                 # %lor.lhs.false13
	i32.const	$push73=, 0
	i32.load8_u	$push22=, b+4($pop73)
	i32.const	$push26=, 255
	i32.and 	$push27=, $pop22, $pop26
	i32.const	$push28=, 7
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label2
# BB#8:                                 # %if.end25
	i32.const	$push31=, b
	i32.const	$push30=, 6
	call    	foo@FUNCTION, $pop31, $pop30
	i32.const	$push74=, 0
	i32.load	$push32=, a($pop74)
	i32.const	$push33=, 4
	i32.ne  	$push34=, $pop32, $pop33
	br_if   	0, $pop34       # 0: down to label2
# BB#9:                                 # %lor.lhs.false28
	i32.const	$push75=, 0
	i32.load8_u	$push37=, a+4($pop75)
	i32.const	$push38=, 7
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label2
# BB#10:                                # %lor.lhs.false28
	i32.const	$push76=, 0
	i32.load	$push35=, b($pop76)
	i32.const	$push40=, 3
	i32.ne  	$push41=, $pop35, $pop40
	br_if   	0, $pop41       # 0: down to label2
# BB#11:                                # %lor.lhs.false28
	i32.const	$push77=, 0
	i32.load8_u	$push36=, b+4($pop77)
	i32.const	$push42=, 255
	i32.and 	$push43=, $pop36, $pop42
	i32.const	$push44=, 7
	i32.ne  	$push45=, $pop43, $pop44
	br_if   	0, $pop45       # 0: down to label2
# BB#12:                                # %if.end40
	i32.const	$push53=, 0
	i32.const	$push51=, 80
	i32.add 	$push52=, $0, $pop51
	i32.store	__stack_pointer($pop53), $pop52
	i32.const	$push46=, 0
	return  	$pop46
.LBB3_13:                               # %if.then39
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	bar.n,@object           # @bar.n
	.section	.bss.bar.n,"aw",@nobits
	.p2align	2
bar.n:
	.int32	0                       # 0x0
	.size	bar.n, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.skip	36
	.size	a, 36

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.skip	36
	.size	b, 36


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
