	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050121-1.c"
	.globl	foo_float
	.type	foo_float,@function
foo_float:                              # @foo_float
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.add 	$push1=, $1, $pop0
	f32.convert_s/i32	$push2=, $pop1
	f32.store	$discard=, 0($0), $pop2
	i32.const	$push3=, -1
	i32.add 	$push4=, $1, $pop3
	f32.convert_s/i32	$push5=, $pop4
	f32.store	$discard=, 4($0), $pop5
	return
.Lfunc_end0:
	.size	foo_float, .Lfunc_end0-foo_float

	.globl	bar_float
	.type	bar_float,@function
bar_float:                              # @bar_float
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1086324736
	i32.store	$discard=, 0($0), $pop0
	return
.Lfunc_end1:
	.size	bar_float, .Lfunc_end1-bar_float

	.globl	baz_float
	.type	baz_float,@function
baz_float:                              # @baz_float
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1082130432
	i32.store	$discard=, 0($0), $pop0
	return
.Lfunc_end2:
	.size	baz_float, .Lfunc_end2-baz_float

	.globl	foo_double
	.type	foo_double,@function
foo_double:                             # @foo_double
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.add 	$push1=, $1, $pop0
	f64.convert_s/i32	$push2=, $pop1
	f64.store	$discard=, 0($0), $pop2
	i32.const	$push3=, -1
	i32.add 	$push4=, $1, $pop3
	f64.convert_s/i32	$push5=, $pop4
	f64.store	$discard=, 8($0), $pop5
	return
.Lfunc_end3:
	.size	foo_double, .Lfunc_end3-foo_double

	.globl	bar_double
	.type	bar_double,@function
bar_double:                             # @bar_double
	.param  	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 4618441417868443648
	i64.store	$discard=, 0($0), $pop0
	return
.Lfunc_end4:
	.size	bar_double, .Lfunc_end4-bar_double

	.globl	baz_double
	.type	baz_double,@function
baz_double:                             # @baz_double
	.param  	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 4616189618054758400
	i64.store	$discard=, 0($0), $pop0
	return
.Lfunc_end5:
	.size	baz_double, .Lfunc_end5-baz_double

	.globl	foo_ldouble_t
	.type	foo_ldouble_t,@function
foo_ldouble_t:                          # @foo_ldouble_t
	.param  	i32, i32
	.local  	i32, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 32
	i32.sub 	$12=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$12=, 0($8), $12
	i32.const	$push0=, 1
	i32.add 	$push1=, $1, $pop0
	i32.const	$10=, 16
	i32.add 	$10=, $12, $10
	call    	__floatsitf, $10, $pop1
	i32.const	$2=, 8
	i32.const	$11=, 16
	i32.add 	$11=, $12, $11
	i32.add 	$push2=, $11, $2
	i64.load	$3=, 0($pop2)
	i64.load	$4=, 16($12)
	i32.const	$push3=, -1
	i32.add 	$push4=, $1, $pop3
	i32.const	$12=, 0
	i32.add 	$12=, $12, $12
	call    	__floatsitf, $12, $pop4
	i32.const	$13=, 0
	i32.add 	$13=, $12, $13
	i32.add 	$push5=, $13, $2
	i64.load	$5=, 0($pop5)
	i64.load	$6=, 0($12)
	i32.add 	$push6=, $0, $2
	i64.store	$discard=, 0($pop6), $3
	i32.const	$push7=, 24
	i32.add 	$push8=, $0, $pop7
	i64.store	$discard=, 0($pop8), $5
	i64.store	$discard=, 0($0), $4
	i64.store	$discard=, 16($0), $6
	i32.const	$9=, 32
	i32.add 	$12=, $12, $9
	i32.const	$9=, __stack_pointer
	i32.store	$12=, 0($9), $12
	return
.Lfunc_end6:
	.size	foo_ldouble_t, .Lfunc_end6-foo_ldouble_t

	.globl	bar_ldouble_t
	.type	bar_ldouble_t,@function
bar_ldouble_t:                          # @bar_ldouble_t
	.param  	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.store	$discard=, 0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i64.const	$push3=, 4612108230892453888
	i64.store	$discard=, 0($pop2), $pop3
	return
.Lfunc_end7:
	.size	bar_ldouble_t, .Lfunc_end7-bar_ldouble_t

	.globl	baz_ldouble_t
	.type	baz_ldouble_t,@function
baz_ldouble_t:                          # @baz_ldouble_t
	.param  	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.store	$discard=, 0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i64.const	$push3=, 4611967493404098560
	i64.store	$discard=, 0($pop2), $pop3
	return
.Lfunc_end8:
	.size	baz_ldouble_t, .Lfunc_end8-baz_ldouble_t

	.globl	foo_char
	.type	foo_char,@function
foo_char:                               # @foo_char
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.add 	$push1=, $1, $pop0
	i32.store8	$discard=, 0($0), $pop1
	i32.const	$push2=, 255
	i32.add 	$push3=, $1, $pop2
	i32.store8	$discard=, 1($0), $pop3
	return
.Lfunc_end9:
	.size	foo_char, .Lfunc_end9-foo_char

	.globl	bar_char
	.type	bar_char,@function
bar_char:                               # @bar_char
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.store8	$discard=, 0($0), $pop0
	return
.Lfunc_end10:
	.size	bar_char, .Lfunc_end10-bar_char

	.globl	baz_char
	.type	baz_char,@function
baz_char:                               # @baz_char
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4
	i32.store8	$discard=, 0($0), $pop0
	return
.Lfunc_end11:
	.size	baz_char, .Lfunc_end11-baz_char

	.globl	foo_short
	.type	foo_short,@function
foo_short:                              # @foo_short
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.add 	$push1=, $1, $pop0
	i32.store16	$discard=, 0($0), $pop1
	i32.const	$push2=, 65535
	i32.add 	$push3=, $1, $pop2
	i32.store16	$discard=, 2($0), $pop3
	return
.Lfunc_end12:
	.size	foo_short, .Lfunc_end12-foo_short

	.globl	bar_short
	.type	bar_short,@function
bar_short:                              # @bar_short
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.store16	$discard=, 0($0), $pop0
	return
.Lfunc_end13:
	.size	bar_short, .Lfunc_end13-bar_short

	.globl	baz_short
	.type	baz_short,@function
baz_short:                              # @baz_short
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4
	i32.store16	$discard=, 0($0), $pop0
	return
.Lfunc_end14:
	.size	baz_short, .Lfunc_end14-baz_short

	.globl	foo_int
	.type	foo_int,@function
foo_int:                                # @foo_int
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.add 	$push1=, $1, $pop0
	i32.store	$discard=, 0($0), $pop1
	i32.const	$push2=, -1
	i32.add 	$push3=, $1, $pop2
	i32.store	$discard=, 4($0), $pop3
	return
.Lfunc_end15:
	.size	foo_int, .Lfunc_end15-foo_int

	.globl	bar_int
	.type	bar_int,@function
bar_int:                                # @bar_int
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.store	$discard=, 0($0), $pop0
	return
.Lfunc_end16:
	.size	bar_int, .Lfunc_end16-bar_int

	.globl	baz_int
	.type	baz_int,@function
baz_int:                                # @baz_int
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4
	i32.store	$discard=, 0($0), $pop0
	return
.Lfunc_end17:
	.size	baz_int, .Lfunc_end17-baz_int

	.globl	foo_long
	.type	foo_long,@function
foo_long:                               # @foo_long
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.add 	$push1=, $1, $pop0
	i32.store	$discard=, 0($0), $pop1
	i32.const	$push2=, -1
	i32.add 	$push3=, $1, $pop2
	i32.store	$discard=, 4($0), $pop3
	return
.Lfunc_end18:
	.size	foo_long, .Lfunc_end18-foo_long

	.globl	bar_long
	.type	bar_long,@function
bar_long:                               # @bar_long
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.store	$discard=, 0($0), $pop0
	return
.Lfunc_end19:
	.size	bar_long, .Lfunc_end19-bar_long

	.globl	baz_long
	.type	baz_long,@function
baz_long:                               # @baz_long
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4
	i32.store	$discard=, 0($0), $pop0
	return
.Lfunc_end20:
	.size	baz_long, .Lfunc_end20-baz_long

	.globl	foo_llong
	.type	foo_llong,@function
foo_llong:                              # @foo_llong
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.add 	$push1=, $1, $pop0
	i64.extend_s/i32	$push2=, $pop1
	i64.store	$discard=, 0($0), $pop2
	i32.const	$push3=, -1
	i32.add 	$push4=, $1, $pop3
	i64.extend_s/i32	$push5=, $pop4
	i64.store	$discard=, 8($0), $pop5
	return
.Lfunc_end21:
	.size	foo_llong, .Lfunc_end21-foo_llong

	.globl	bar_llong
	.type	bar_llong,@function
bar_llong:                              # @bar_llong
	.param  	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 6
	i64.store	$discard=, 0($0), $pop0
	return
.Lfunc_end22:
	.size	bar_llong, .Lfunc_end22-bar_llong

	.globl	baz_llong
	.type	baz_llong,@function
baz_llong:                              # @baz_llong
	.param  	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 4
	i64.store	$discard=, 0($0), $pop0
	return
.Lfunc_end23:
	.size	baz_llong, .Lfunc_end23-baz_llong

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end65
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end24:
	.size	main, .Lfunc_end24-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
