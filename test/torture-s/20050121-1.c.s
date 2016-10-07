	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050121-1.c"
	.section	.text.foo_float,"ax",@progbits
	.hidden	foo_float
	.globl	foo_float
	.type	foo_float,@function
foo_float:                              # @foo_float
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	i32.add 	$push1=, $1, $pop0
	f32.convert_s/i32	$push2=, $pop1
	f32.store	4($0), $pop2
	i32.const	$push3=, 1
	i32.add 	$push4=, $1, $pop3
	f32.convert_s/i32	$push5=, $pop4
	f32.store	0($0), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo_float, .Lfunc_end0-foo_float

	.section	.text.bar_float,"ax",@progbits
	.hidden	bar_float
	.globl	bar_float
	.type	bar_float,@function
bar_float:                              # @bar_float
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1086324736
	i32.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	bar_float, .Lfunc_end1-bar_float

	.section	.text.baz_float,"ax",@progbits
	.hidden	baz_float
	.globl	baz_float
	.type	baz_float,@function
baz_float:                              # @baz_float
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1082130432
	i32.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	baz_float, .Lfunc_end2-baz_float

	.section	.text.foo_double,"ax",@progbits
	.hidden	foo_double
	.globl	foo_double
	.type	foo_double,@function
foo_double:                             # @foo_double
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	i32.add 	$push1=, $1, $pop0
	f64.convert_s/i32	$push2=, $pop1
	f64.store	8($0), $pop2
	i32.const	$push3=, 1
	i32.add 	$push4=, $1, $pop3
	f64.convert_s/i32	$push5=, $pop4
	f64.store	0($0), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	foo_double, .Lfunc_end3-foo_double

	.section	.text.bar_double,"ax",@progbits
	.hidden	bar_double
	.globl	bar_double
	.type	bar_double,@function
bar_double:                             # @bar_double
	.param  	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 4618441417868443648
	i64.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	bar_double, .Lfunc_end4-bar_double

	.section	.text.baz_double,"ax",@progbits
	.hidden	baz_double
	.globl	baz_double
	.type	baz_double,@function
baz_double:                             # @baz_double
	.param  	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 4616189618054758400
	i64.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end5:
	.size	baz_double, .Lfunc_end5-baz_double

	.section	.text.foo_ldouble_t,"ax",@progbits
	.hidden	foo_ldouble_t
	.globl	foo_ldouble_t
	.type	foo_ldouble_t,@function
foo_ldouble_t:                          # @foo_ldouble_t
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push17=, 0
	i32.const	$push14=, 0
	i32.load	$push15=, __stack_pointer($pop14)
	i32.const	$push16=, 32
	i32.sub 	$push28=, $pop15, $pop16
	tee_local	$push27=, $2=, $pop28
	i32.store	__stack_pointer($pop17), $pop27
	i32.const	$push0=, -1
	i32.add 	$push1=, $1, $pop0
	call    	__floatsitf@FUNCTION, $2, $pop1
	i32.const	$push2=, 24
	i32.add 	$push3=, $0, $pop2
	i32.const	$push4=, 8
	i32.add 	$push5=, $2, $pop4
	i64.load	$push6=, 0($pop5)
	i64.store	0($pop3), $pop6
	i64.load	$push7=, 0($2)
	i64.store	16($0), $pop7
	i32.const	$push21=, 16
	i32.add 	$push22=, $2, $pop21
	i32.const	$push8=, 1
	i32.add 	$push9=, $1, $pop8
	call    	__floatsitf@FUNCTION, $pop22, $pop9
	i32.const	$push26=, 8
	i32.add 	$push10=, $0, $pop26
	i32.const	$push23=, 16
	i32.add 	$push24=, $2, $pop23
	i32.const	$push25=, 8
	i32.add 	$push11=, $pop24, $pop25
	i64.load	$push12=, 0($pop11)
	i64.store	0($pop10), $pop12
	i64.load	$push13=, 16($2)
	i64.store	0($0), $pop13
	i32.const	$push20=, 0
	i32.const	$push18=, 32
	i32.add 	$push19=, $2, $pop18
	i32.store	__stack_pointer($pop20), $pop19
                                        # fallthrough-return
	.endfunc
.Lfunc_end6:
	.size	foo_ldouble_t, .Lfunc_end6-foo_ldouble_t

	.section	.text.bar_ldouble_t,"ax",@progbits
	.hidden	bar_ldouble_t
	.globl	bar_ldouble_t
	.type	bar_ldouble_t,@function
bar_ldouble_t:                          # @bar_ldouble_t
	.param  	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.store	0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i64.const	$push3=, 4612108230892453888
	i64.store	0($pop2), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end7:
	.size	bar_ldouble_t, .Lfunc_end7-bar_ldouble_t

	.section	.text.baz_ldouble_t,"ax",@progbits
	.hidden	baz_ldouble_t
	.globl	baz_ldouble_t
	.type	baz_ldouble_t,@function
baz_ldouble_t:                          # @baz_ldouble_t
	.param  	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 0
	i64.store	0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i64.const	$push3=, 4611967493404098560
	i64.store	0($pop2), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end8:
	.size	baz_ldouble_t, .Lfunc_end8-baz_ldouble_t

	.section	.text.foo_char,"ax",@progbits
	.hidden	foo_char
	.globl	foo_char
	.type	foo_char,@function
foo_char:                               # @foo_char
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 255
	i32.add 	$push1=, $1, $pop0
	i32.store8	1($0), $pop1
	i32.const	$push2=, 1
	i32.add 	$push3=, $1, $pop2
	i32.store8	0($0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end9:
	.size	foo_char, .Lfunc_end9-foo_char

	.section	.text.bar_char,"ax",@progbits
	.hidden	bar_char
	.globl	bar_char
	.type	bar_char,@function
bar_char:                               # @bar_char
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.store8	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end10:
	.size	bar_char, .Lfunc_end10-bar_char

	.section	.text.baz_char,"ax",@progbits
	.hidden	baz_char
	.globl	baz_char
	.type	baz_char,@function
baz_char:                               # @baz_char
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4
	i32.store8	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end11:
	.size	baz_char, .Lfunc_end11-baz_char

	.section	.text.foo_short,"ax",@progbits
	.hidden	foo_short
	.globl	foo_short
	.type	foo_short,@function
foo_short:                              # @foo_short
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 65535
	i32.add 	$push1=, $1, $pop0
	i32.store16	2($0), $pop1
	i32.const	$push2=, 1
	i32.add 	$push3=, $1, $pop2
	i32.store16	0($0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end12:
	.size	foo_short, .Lfunc_end12-foo_short

	.section	.text.bar_short,"ax",@progbits
	.hidden	bar_short
	.globl	bar_short
	.type	bar_short,@function
bar_short:                              # @bar_short
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.store16	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end13:
	.size	bar_short, .Lfunc_end13-bar_short

	.section	.text.baz_short,"ax",@progbits
	.hidden	baz_short
	.globl	baz_short
	.type	baz_short,@function
baz_short:                              # @baz_short
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4
	i32.store16	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end14:
	.size	baz_short, .Lfunc_end14-baz_short

	.section	.text.foo_int,"ax",@progbits
	.hidden	foo_int
	.globl	foo_int
	.type	foo_int,@function
foo_int:                                # @foo_int
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	i32.add 	$push1=, $1, $pop0
	i32.store	4($0), $pop1
	i32.const	$push2=, 1
	i32.add 	$push3=, $1, $pop2
	i32.store	0($0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end15:
	.size	foo_int, .Lfunc_end15-foo_int

	.section	.text.bar_int,"ax",@progbits
	.hidden	bar_int
	.globl	bar_int
	.type	bar_int,@function
bar_int:                                # @bar_int
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end16:
	.size	bar_int, .Lfunc_end16-bar_int

	.section	.text.baz_int,"ax",@progbits
	.hidden	baz_int
	.globl	baz_int
	.type	baz_int,@function
baz_int:                                # @baz_int
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4
	i32.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end17:
	.size	baz_int, .Lfunc_end17-baz_int

	.section	.text.foo_long,"ax",@progbits
	.hidden	foo_long
	.globl	foo_long
	.type	foo_long,@function
foo_long:                               # @foo_long
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	i32.add 	$push1=, $1, $pop0
	i32.store	4($0), $pop1
	i32.const	$push2=, 1
	i32.add 	$push3=, $1, $pop2
	i32.store	0($0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end18:
	.size	foo_long, .Lfunc_end18-foo_long

	.section	.text.bar_long,"ax",@progbits
	.hidden	bar_long
	.globl	bar_long
	.type	bar_long,@function
bar_long:                               # @bar_long
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end19:
	.size	bar_long, .Lfunc_end19-bar_long

	.section	.text.baz_long,"ax",@progbits
	.hidden	baz_long
	.globl	baz_long
	.type	baz_long,@function
baz_long:                               # @baz_long
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4
	i32.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end20:
	.size	baz_long, .Lfunc_end20-baz_long

	.section	.text.foo_llong,"ax",@progbits
	.hidden	foo_llong
	.globl	foo_llong
	.type	foo_llong,@function
foo_llong:                              # @foo_llong
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	i32.add 	$push1=, $1, $pop0
	i64.extend_s/i32	$push2=, $pop1
	i64.store	8($0), $pop2
	i32.const	$push3=, 1
	i32.add 	$push4=, $1, $pop3
	i64.extend_s/i32	$push5=, $pop4
	i64.store	0($0), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end21:
	.size	foo_llong, .Lfunc_end21-foo_llong

	.section	.text.bar_llong,"ax",@progbits
	.hidden	bar_llong
	.globl	bar_llong
	.type	bar_llong,@function
bar_llong:                              # @bar_llong
	.param  	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 6
	i64.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end22:
	.size	bar_llong, .Lfunc_end22-bar_llong

	.section	.text.baz_llong,"ax",@progbits
	.hidden	baz_llong
	.globl	baz_llong
	.type	baz_llong,@function
baz_llong:                              # @baz_llong
	.param  	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 4
	i64.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end23:
	.size	baz_llong, .Lfunc_end23-baz_llong

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end65
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end24:
	.size	main, .Lfunc_end24-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
