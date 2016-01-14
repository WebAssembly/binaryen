	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050224-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 245
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push2=, 36
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#2:                                 # %entry
	i32.const	$push4=, 444
	i32.ne  	$push5=, $2, $pop4
	br_if   	$pop5, 0        # 0: down to label0
# BB#3:                                 # %if.end
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, 0
	i32.load	$5=, a($8)
	i32.load	$0=, b($8)
	block
	i32.ge_u	$push0=, $5, $0
	br_if   	$pop0, 0        # 0: down to label1
# BB#1:                                 # %for.body.lr.ph
	i32.load	$1=, c($8)
	i32.load	$2=, d($8)
	i32.load	$3=, e($8)
	i32.load	$4=, f($8)
	copy_local	$7=, $8
	copy_local	$6=, $8
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	block
	block
	i32.ge_u	$push1=, $5, $1
	br_if   	$pop1, 0        # 0: down to label5
# BB#3:                                 # %if.then
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push6=, 1
	i32.add 	$6=, $6, $pop6
	br      	1               # 1: down to label4
.LBB1_4:                                # %if.else
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label5:
	block
	i32.lt_u	$push2=, $5, $2
	br_if   	$pop2, 0        # 0: down to label6
# BB#5:                                 # %if.else
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.ge_u	$push3=, $5, $3
	br_if   	$pop3, 0        # 0: down to label6
# BB#6:                                 # %if.then4
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push5=, 1
	i32.add 	$8=, $8, $pop5
	br      	1               # 1: down to label4
.LBB1_7:                                # %if.else6
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label6:
	i32.lt_u	$push4=, $5, $4
	i32.add 	$7=, $pop4, $7
.LBB1_8:                                # %for.inc
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label4:
	i32.const	$push7=, 4096
	i32.add 	$5=, $5, $pop7
	i32.lt_u	$push8=, $5, $0
	br_if   	$pop8, 0        # 0: up to label2
# BB#9:                                 # %for.end
	end_loop                        # label3:
	i32.const	$push9=, 444
	i32.ne  	$push10=, $6, $pop9
	br_if   	$pop10, 0       # 0: down to label1
# BB#10:                                # %for.end
	i32.const	$push11=, 245
	i32.ne  	$push12=, $7, $pop11
	br_if   	$pop12, 0       # 0: down to label1
# BB#11:                                # %for.end
	i32.const	$push13=, 36
	i32.ne  	$push14=, $8, $pop13
	br_if   	$pop14, 0       # 0: down to label1
# BB#12:                                # %foo.exit
	i32.const	$push15=, 0
	return  	$pop15
.LBB1_13:                               # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.align	2
a:
	.int32	3221225472              # 0xc0000000
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.align	2
b:
	.int32	3489660928              # 0xd0000000
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.align	2
c:
	.int32	3223042392              # 0xc01bb958
	.size	c, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.data.d,"aw",@progbits
	.globl	d
	.align	2
d:
	.int32	3223732224              # 0xc0264000
	.size	d, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.data.e,"aw",@progbits
	.globl	e
	.align	2
e:
	.int32	3223879680              # 0xc0288000
	.size	e, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.data.f,"aw",@progbits
	.globl	f
	.align	2
f:
	.int32	3224191864              # 0xc02d4378
	.size	f, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
