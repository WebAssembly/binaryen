	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr51877.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push9=, 0
	i32.load	$push1=, bar.n($pop9)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$push4=, bar.n($pop0), $pop3
	i32.store	$discard=, 0($0), $pop4
	i32.store8	$discard=, 4($0):p2align=2, $1
	i32.const	$push5=, 5
	i32.add 	$push6=, $0, $pop5
	i32.const	$push8=, 0
	i32.const	$push7=, 31
	i32.call	$discard=, memset@FUNCTION, $pop6, $pop8, $pop7
	return
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
	return
	.endfunc
.Lfunc_end1:
	.size	baz, .Lfunc_end1-baz

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 80
	i32.sub 	$7=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$7=, 0($3), $7
	block
	block
	i32.const	$push0=, 6
	i32.ne  	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %if.then
	i32.const	$push4=, 7
	i32.const	$5=, 40
	i32.add 	$5=, $7, $5
	call    	bar@FUNCTION, $5, $pop4
	i32.const	$push5=, a
	i32.const	$push6=, 36
	i32.const	$6=, 40
	i32.add 	$6=, $7, $6
	i32.call	$discard=, memcpy@FUNCTION, $pop5, $6, $pop6
	br      	1               # 1: down to label0
.LBB2_2:                                # %if.else
	end_block                       # label1:
	i32.const	$push2=, 7
	call    	bar@FUNCTION, $7, $pop2
	i32.const	$push3=, 36
	i32.call	$discard=, memcpy@FUNCTION, $0, $7, $pop3
.LBB2_3:                                # %if.end
	end_block                       # label0:
	call    	baz@FUNCTION
	i32.const	$4=, 80
	i32.add 	$7=, $7, $4
	i32.const	$4=, __stack_pointer
	i32.store	$7=, 0($4), $7
	return
	.endfunc
.Lfunc_end2:
	.size	foo, .Lfunc_end2-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 80
	i32.sub 	$5=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$5=, 0($1), $5
	i32.const	$push49=, 3
	i32.const	$3=, 40
	i32.add 	$3=, $5, $3
	call    	bar@FUNCTION, $3, $pop49
	i32.const	$push0=, a
	i32.const	$push1=, 36
	i32.const	$4=, 40
	i32.add 	$4=, $5, $4
	i32.call	$discard=, memcpy@FUNCTION, $pop0, $4, $pop1
	i32.const	$push2=, 4
	call    	bar@FUNCTION, $5, $pop2
	i32.const	$push3=, b
	i32.const	$push48=, 36
	i32.call	$discard=, memcpy@FUNCTION, $pop3, $5, $pop48
	block
	block
	block
	i32.const	$push47=, 0
	i32.load	$push4=, a($pop47)
	i32.const	$push5=, 1
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label4
# BB#1:                                 # %lor.lhs.false
	i32.const	$push51=, 0
	i32.load8_u	$push9=, a+4($pop51):p2align=2
	i32.const	$push50=, 3
	i32.ne  	$push10=, $pop9, $pop50
	br_if   	0, $pop10       # 0: down to label4
# BB#2:                                 # %lor.lhs.false
	i32.const	$push52=, 0
	i32.load	$push7=, b($pop52)
	i32.const	$push11=, 2
	i32.ne  	$push12=, $pop7, $pop11
	br_if   	0, $pop12       # 0: down to label4
# BB#3:                                 # %lor.lhs.false
	i32.const	$push53=, 0
	i32.load8_u	$push8=, b+4($pop53):p2align=2
	i32.const	$push13=, 255
	i32.and 	$push14=, $pop8, $pop13
	i32.const	$push15=, 4
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	0, $pop16       # 0: down to label4
# BB#4:                                 # %if.end
	i32.const	$push17=, b
	i32.const	$push55=, 0
	call    	foo@FUNCTION, $pop17, $pop55
	i32.const	$push54=, 0
	i32.load	$push18=, a($pop54)
	i32.const	$push19=, 1
	i32.ne  	$push20=, $pop18, $pop19
	br_if   	1, $pop20       # 1: down to label3
# BB#5:                                 # %lor.lhs.false13
	i32.const	$push57=, 0
	i32.load8_u	$push23=, a+4($pop57):p2align=2
	i32.const	$push56=, 3
	i32.ne  	$push24=, $pop23, $pop56
	br_if   	1, $pop24       # 1: down to label3
# BB#6:                                 # %lor.lhs.false13
	i32.const	$push59=, 0
	i32.load	$push21=, b($pop59)
	i32.const	$push58=, 3
	i32.ne  	$push25=, $pop21, $pop58
	br_if   	1, $pop25       # 1: down to label3
# BB#7:                                 # %lor.lhs.false13
	i32.const	$push60=, 0
	i32.load8_u	$push22=, b+4($pop60):p2align=2
	i32.const	$push26=, 255
	i32.and 	$push27=, $pop22, $pop26
	i32.const	$push28=, 7
	i32.ne  	$push29=, $pop27, $pop28
	br_if   	1, $pop29       # 1: down to label3
# BB#8:                                 # %if.end25
	i32.const	$push30=, b
	i32.const	$push31=, 6
	call    	foo@FUNCTION, $pop30, $pop31
	i32.const	$push61=, 0
	i32.load	$push32=, a($pop61)
	i32.const	$push33=, 4
	i32.ne  	$push34=, $pop32, $pop33
	br_if   	2, $pop34       # 2: down to label2
# BB#9:                                 # %lor.lhs.false28
	i32.const	$push62=, 0
	i32.load8_u	$push37=, a+4($pop62):p2align=2
	i32.const	$push38=, 7
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	2, $pop39       # 2: down to label2
# BB#10:                                # %lor.lhs.false28
	i32.const	$push63=, 0
	i32.load	$push35=, b($pop63)
	i32.const	$push40=, 3
	i32.ne  	$push41=, $pop35, $pop40
	br_if   	2, $pop41       # 2: down to label2
# BB#11:                                # %lor.lhs.false28
	i32.const	$push64=, 0
	i32.load8_u	$push36=, b+4($pop64):p2align=2
	i32.const	$push42=, 255
	i32.and 	$push43=, $pop36, $pop42
	i32.const	$push44=, 7
	i32.ne  	$push45=, $pop43, $pop44
	br_if   	2, $pop45       # 2: down to label2
# BB#12:                                # %if.end40
	i32.const	$push46=, 0
	i32.const	$2=, 80
	i32.add 	$5=, $5, $2
	i32.const	$2=, __stack_pointer
	i32.store	$5=, 0($2), $5
	return  	$pop46
.LBB3_13:                               # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB3_14:                               # %if.then24
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB3_15:                               # %if.then39
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	bar.n,@object           # @bar.n
	.lcomm	bar.n,4,2
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


	.ident	"clang version 3.9.0 "
