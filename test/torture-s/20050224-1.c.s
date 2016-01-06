	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050224-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block   	BB0_4
	i32.const	$push0=, 245
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, BB0_4
# BB#1:                                 # %entry
	i32.const	$push2=, 36
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, BB0_4
# BB#2:                                 # %entry
	i32.const	$push4=, 444
	i32.ne  	$push5=, $2, $pop4
	br_if   	$pop5, BB0_4
# BB#3:                                 # %if.end
	return
BB0_4:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, 0
	i32.load	$5=, a($8)
	i32.load	$0=, b($8)
	block   	BB1_13
	i32.ge_u	$push0=, $5, $0
	br_if   	$pop0, BB1_13
# BB#1:                                 # %for.body.lr.ph
	i32.load	$1=, c($8)
	i32.load	$2=, d($8)
	i32.load	$3=, e($8)
	i32.load	$4=, f($8)
	copy_local	$7=, $8
	copy_local	$6=, $8
BB1_2:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB1_9
	block   	BB1_8
	block   	BB1_4
	i32.ge_u	$push1=, $5, $1
	br_if   	$pop1, BB1_4
# BB#3:                                 # %if.then
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push6=, 1
	i32.add 	$6=, $6, $pop6
	br      	BB1_8
BB1_4:                                  # %if.else
                                        #   in Loop: Header=BB1_2 Depth=1
	block   	BB1_7
	i32.lt_u	$push2=, $5, $2
	br_if   	$pop2, BB1_7
# BB#5:                                 # %if.else
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.ge_u	$push3=, $5, $3
	br_if   	$pop3, BB1_7
# BB#6:                                 # %if.then4
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push5=, 1
	i32.add 	$8=, $8, $pop5
	br      	BB1_8
BB1_7:                                  # %if.else6
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.lt_u	$push4=, $5, $4
	i32.add 	$7=, $pop4, $7
BB1_8:                                  # %for.inc
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push7=, 4096
	i32.add 	$5=, $5, $pop7
	i32.lt_u	$push8=, $5, $0
	br_if   	$pop8, BB1_2
BB1_9:                                  # %for.end
	i32.const	$push9=, 444
	i32.ne  	$push10=, $6, $pop9
	br_if   	$pop10, BB1_13
# BB#10:                                # %for.end
	i32.const	$push11=, 245
	i32.ne  	$push12=, $7, $pop11
	br_if   	$pop12, BB1_13
# BB#11:                                # %for.end
	i32.const	$push13=, 36
	i32.ne  	$push14=, $8, $pop13
	br_if   	$pop14, BB1_13
# BB#12:                                # %foo.exit
	i32.const	$push15=, 0
	return  	$pop15
BB1_13:                                 # %if.then.i
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	a,@object               # @a
	.data
	.globl	a
	.align	2
a:
	.int32	3221225472              # 0xc0000000
	.size	a, 4

	.type	b,@object               # @b
	.globl	b
	.align	2
b:
	.int32	3489660928              # 0xd0000000
	.size	b, 4

	.type	c,@object               # @c
	.globl	c
	.align	2
c:
	.int32	3223042392              # 0xc01bb958
	.size	c, 4

	.type	d,@object               # @d
	.globl	d
	.align	2
d:
	.int32	3223732224              # 0xc0264000
	.size	d, 4

	.type	e,@object               # @e
	.globl	e
	.align	2
e:
	.int32	3223879680              # 0xc0288000
	.size	e, 4

	.type	f,@object               # @f
	.globl	f
	.align	2
f:
	.int32	3224191864              # 0xc02d4378
	.size	f, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
