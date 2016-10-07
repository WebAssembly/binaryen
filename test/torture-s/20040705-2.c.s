	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040705-2.c"
	.section	.text.ret1,"ax",@progbits
	.hidden	ret1
	.globl	ret1
	.type	ret1,@function
ret1:                                   # @ret1
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, b($pop0)
	i32.const	$push2=, 63
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	ret1, .Lfunc_end0-ret1

	.section	.text.ret2,"ax",@progbits
	.hidden	ret2
	.globl	ret2
	.type	ret2,@function
ret2:                                   # @ret2
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, b($pop0)
	i32.const	$push2=, 6
	i32.shr_u	$push3=, $pop1, $pop2
	i32.const	$push4=, 2047
	i32.and 	$push5=, $pop3, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end1:
	.size	ret2, .Lfunc_end1-ret2

	.section	.text.ret3,"ax",@progbits
	.hidden	ret3
	.globl	ret3
	.type	ret3,@function
ret3:                                   # @ret3
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, b($pop0)
	i32.const	$push2=, 17
	i32.shr_u	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end2:
	.size	ret3, .Lfunc_end2-ret3

	.section	.text.ret4,"ax",@progbits
	.hidden	ret4
	.globl	ret4
	.type	ret4,@function
ret4:                                   # @ret4
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, c($pop0)
	i32.const	$push2=, 31
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end3:
	.size	ret4, .Lfunc_end3-ret4

	.section	.text.ret5,"ax",@progbits
	.hidden	ret5
	.globl	ret5
	.type	ret5,@function
ret5:                                   # @ret5
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, c($pop0)
	i32.const	$push2=, 5
	i32.shr_u	$push3=, $pop1, $pop2
	i32.const	$push4=, 1
	i32.and 	$push5=, $pop3, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end4:
	.size	ret5, .Lfunc_end4-ret5

	.section	.text.ret6,"ax",@progbits
	.hidden	ret6
	.globl	ret6
	.type	ret6,@function
ret6:                                   # @ret6
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, c($pop0)
	i32.const	$push2=, 6
	i32.shr_u	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end5:
	.size	ret6, .Lfunc_end5-ret6

	.section	.text.ret7,"ax",@progbits
	.hidden	ret7
	.globl	ret7
	.type	ret7,@function
ret7:                                   # @ret7
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$push1=, d($pop0)
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end6:
	.size	ret7, .Lfunc_end6-ret7

	.section	.text.ret8,"ax",@progbits
	.hidden	ret8
	.globl	ret8
	.type	ret8,@function
ret8:                                   # @ret8
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load8_u	$push1=, d+2($pop0)
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end7:
	.size	ret8, .Lfunc_end7-ret8

	.section	.text.ret9,"ax",@progbits
	.hidden	ret9
	.globl	ret9
	.type	ret9,@function
ret9:                                   # @ret9
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load8_u	$push1=, d+3($pop0)
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end8:
	.size	ret9, .Lfunc_end8-ret9

	.section	.text.fn1_1,"ax",@progbits
	.hidden	fn1_1
	.globl	fn1_1
	.type	fn1_1,@function
fn1_1:                                  # @fn1_1
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push9=, 0
	i32.load	$push8=, b($pop9)
	tee_local	$push7=, $1=, $pop8
	i32.add 	$push3=, $pop7, $0
	i32.const	$push4=, 63
	i32.and 	$push5=, $pop3, $pop4
	i32.const	$push1=, -64
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push6=, $pop5, $pop2
	i32.store	b($pop0), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end9:
	.size	fn1_1, .Lfunc_end9-fn1_1

	.section	.text.fn2_1,"ax",@progbits
	.hidden	fn2_1
	.globl	fn2_1
	.type	fn2_1,@function
fn2_1:                                  # @fn2_1
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, b($pop11)
	tee_local	$push9=, $1=, $pop10
	i32.const	$push3=, 6
	i32.shl 	$push4=, $0, $pop3
	i32.add 	$push5=, $pop9, $pop4
	i32.const	$push6=, 131008
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push1=, -131009
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push8=, $pop7, $pop2
	i32.store	b($pop0), $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end10:
	.size	fn2_1, .Lfunc_end10-fn2_1

	.section	.text.fn3_1,"ax",@progbits
	.hidden	fn3_1
	.globl	fn3_1
	.type	fn3_1,@function
fn3_1:                                  # @fn3_1
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push5=, 0
	i32.load	$push3=, b($pop5)
	i32.const	$push0=, 17
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push4=, $pop3, $pop1
	i32.store	b($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end11:
	.size	fn3_1, .Lfunc_end11-fn3_1

	.section	.text.fn4_1,"ax",@progbits
	.hidden	fn4_1
	.globl	fn4_1
	.type	fn4_1,@function
fn4_1:                                  # @fn4_1
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push9=, 0
	i32.load	$push8=, c($pop9)
	tee_local	$push7=, $1=, $pop8
	i32.add 	$push3=, $pop7, $0
	i32.const	$push4=, 31
	i32.and 	$push5=, $pop3, $pop4
	i32.const	$push1=, -32
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push6=, $pop5, $pop2
	i32.store	c($pop0), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end12:
	.size	fn4_1, .Lfunc_end12-fn4_1

	.section	.text.fn5_1,"ax",@progbits
	.hidden	fn5_1
	.globl	fn5_1
	.type	fn5_1,@function
fn5_1:                                  # @fn5_1
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, c($pop11)
	tee_local	$push9=, $1=, $pop10
	i32.const	$push3=, 5
	i32.shl 	$push4=, $0, $pop3
	i32.add 	$push5=, $pop9, $pop4
	i32.const	$push6=, 32
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push1=, -33
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push8=, $pop7, $pop2
	i32.store	c($pop0), $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end13:
	.size	fn5_1, .Lfunc_end13-fn5_1

	.section	.text.fn6_1,"ax",@progbits
	.hidden	fn6_1
	.globl	fn6_1
	.type	fn6_1,@function
fn6_1:                                  # @fn6_1
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push5=, 0
	i32.load	$push3=, c($pop5)
	i32.const	$push0=, 6
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push4=, $pop3, $pop1
	i32.store	c($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end14:
	.size	fn6_1, .Lfunc_end14-fn6_1

	.section	.text.fn7_1,"ax",@progbits
	.hidden	fn7_1
	.globl	fn7_1
	.type	fn7_1,@function
fn7_1:                                  # @fn7_1
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push3=, 0
	i32.load	$push1=, d($pop3)
	i32.add 	$push2=, $pop1, $0
	i32.store16	d($pop0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end15:
	.size	fn7_1, .Lfunc_end15-fn7_1

	.section	.text.fn8_1,"ax",@progbits
	.hidden	fn8_1
	.globl	fn8_1
	.type	fn8_1,@function
fn8_1:                                  # @fn8_1
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push7=, 0
	i32.load	$push3=, d($pop7)
	i32.const	$push0=, 16
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push4=, $pop3, $pop1
	i32.const	$push6=, 16
	i32.shr_u	$push5=, $pop4, $pop6
	i32.store8	d+2($pop2), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end16:
	.size	fn8_1, .Lfunc_end16-fn8_1

	.section	.text.fn9_1,"ax",@progbits
	.hidden	fn9_1
	.globl	fn9_1
	.type	fn9_1,@function
fn9_1:                                  # @fn9_1
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push5=, 0
	i32.load	$push3=, d($pop5)
	i32.const	$push0=, 24
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push4=, $pop3, $pop1
	i32.store	d($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end17:
	.size	fn9_1, .Lfunc_end17-fn9_1

	.section	.text.fn1_2,"ax",@progbits
	.hidden	fn1_2
	.globl	fn1_2
	.type	fn1_2,@function
fn1_2:                                  # @fn1_2
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, b($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 1
	i32.add 	$push4=, $pop8, $pop3
	i32.const	$push5=, 63
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push1=, -64
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	b($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end18:
	.size	fn1_2, .Lfunc_end18-fn1_2

	.section	.text.fn2_2,"ax",@progbits
	.hidden	fn2_2
	.globl	fn2_2
	.type	fn2_2,@function
fn2_2:                                  # @fn2_2
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, b($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 64
	i32.add 	$push4=, $pop8, $pop3
	i32.const	$push5=, 131008
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push1=, -131009
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	b($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end19:
	.size	fn2_2, .Lfunc_end19-fn2_2

	.section	.text.fn3_2,"ax",@progbits
	.hidden	fn3_2
	.globl	fn3_2
	.type	fn3_2,@function
fn3_2:                                  # @fn3_2
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, b($pop4)
	i32.const	$push2=, 131072
	i32.add 	$push3=, $pop1, $pop2
	i32.store	b($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end20:
	.size	fn3_2, .Lfunc_end20-fn3_2

	.section	.text.fn4_2,"ax",@progbits
	.hidden	fn4_2
	.globl	fn4_2
	.type	fn4_2,@function
fn4_2:                                  # @fn4_2
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, c($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 1
	i32.add 	$push4=, $pop8, $pop3
	i32.const	$push5=, 31
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push1=, -32
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	c($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end21:
	.size	fn4_2, .Lfunc_end21-fn4_2

	.section	.text.fn5_2,"ax",@progbits
	.hidden	fn5_2
	.globl	fn5_2
	.type	fn5_2,@function
fn5_2:                                  # @fn5_2
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, 32
	i32.xor 	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end22:
	.size	fn5_2, .Lfunc_end22-fn5_2

	.section	.text.fn6_2,"ax",@progbits
	.hidden	fn6_2
	.globl	fn6_2
	.type	fn6_2,@function
fn6_2:                                  # @fn6_2
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, 64
	i32.add 	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end23:
	.size	fn6_2, .Lfunc_end23-fn6_2

	.section	.text.fn7_2,"ax",@progbits
	.hidden	fn7_2
	.globl	fn7_2
	.type	fn7_2,@function
fn7_2:                                  # @fn7_2
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store16	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end24:
	.size	fn7_2, .Lfunc_end24-fn7_2

	.section	.text.fn8_2,"ax",@progbits
	.hidden	fn8_2
	.globl	fn8_2
	.type	fn8_2,@function
fn8_2:                                  # @fn8_2
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push6=, 0
	i32.load	$push1=, d($pop6)
	i32.const	$push2=, 65536
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, 16
	i32.shr_u	$push5=, $pop3, $pop4
	i32.store8	d+2($pop0), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end25:
	.size	fn8_2, .Lfunc_end25-fn8_2

	.section	.text.fn9_2,"ax",@progbits
	.hidden	fn9_2
	.globl	fn9_2
	.type	fn9_2,@function
fn9_2:                                  # @fn9_2
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, 16777216
	i32.add 	$push3=, $pop1, $pop2
	i32.store	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end26:
	.size	fn9_2, .Lfunc_end26-fn9_2

	.section	.text.fn1_3,"ax",@progbits
	.hidden	fn1_3
	.globl	fn1_3
	.type	fn1_3,@function
fn1_3:                                  # @fn1_3
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, b($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 1
	i32.add 	$push4=, $pop8, $pop3
	i32.const	$push5=, 63
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push1=, -64
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	b($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end27:
	.size	fn1_3, .Lfunc_end27-fn1_3

	.section	.text.fn2_3,"ax",@progbits
	.hidden	fn2_3
	.globl	fn2_3
	.type	fn2_3,@function
fn2_3:                                  # @fn2_3
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, b($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 64
	i32.add 	$push4=, $pop8, $pop3
	i32.const	$push5=, 131008
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push1=, -131009
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	b($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end28:
	.size	fn2_3, .Lfunc_end28-fn2_3

	.section	.text.fn3_3,"ax",@progbits
	.hidden	fn3_3
	.globl	fn3_3
	.type	fn3_3,@function
fn3_3:                                  # @fn3_3
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, b($pop4)
	i32.const	$push2=, 131072
	i32.add 	$push3=, $pop1, $pop2
	i32.store	b($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end29:
	.size	fn3_3, .Lfunc_end29-fn3_3

	.section	.text.fn4_3,"ax",@progbits
	.hidden	fn4_3
	.globl	fn4_3
	.type	fn4_3,@function
fn4_3:                                  # @fn4_3
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, c($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 1
	i32.add 	$push4=, $pop8, $pop3
	i32.const	$push5=, 31
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push1=, -32
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	c($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end30:
	.size	fn4_3, .Lfunc_end30-fn4_3

	.section	.text.fn5_3,"ax",@progbits
	.hidden	fn5_3
	.globl	fn5_3
	.type	fn5_3,@function
fn5_3:                                  # @fn5_3
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, 32
	i32.xor 	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end31:
	.size	fn5_3, .Lfunc_end31-fn5_3

	.section	.text.fn6_3,"ax",@progbits
	.hidden	fn6_3
	.globl	fn6_3
	.type	fn6_3,@function
fn6_3:                                  # @fn6_3
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, 64
	i32.add 	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end32:
	.size	fn6_3, .Lfunc_end32-fn6_3

	.section	.text.fn7_3,"ax",@progbits
	.hidden	fn7_3
	.globl	fn7_3
	.type	fn7_3,@function
fn7_3:                                  # @fn7_3
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store16	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end33:
	.size	fn7_3, .Lfunc_end33-fn7_3

	.section	.text.fn8_3,"ax",@progbits
	.hidden	fn8_3
	.globl	fn8_3
	.type	fn8_3,@function
fn8_3:                                  # @fn8_3
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push6=, 0
	i32.load	$push1=, d($pop6)
	i32.const	$push2=, 65536
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, 16
	i32.shr_u	$push5=, $pop3, $pop4
	i32.store8	d+2($pop0), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end34:
	.size	fn8_3, .Lfunc_end34-fn8_3

	.section	.text.fn9_3,"ax",@progbits
	.hidden	fn9_3
	.globl	fn9_3
	.type	fn9_3,@function
fn9_3:                                  # @fn9_3
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, 16777216
	i32.add 	$push3=, $pop1, $pop2
	i32.store	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end35:
	.size	fn9_3, .Lfunc_end35-fn9_3

	.section	.text.fn1_4,"ax",@progbits
	.hidden	fn1_4
	.globl	fn1_4
	.type	fn1_4,@function
fn1_4:                                  # @fn1_4
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push9=, 0
	i32.load	$push8=, b($pop9)
	tee_local	$push7=, $1=, $pop8
	i32.sub 	$push3=, $pop7, $0
	i32.const	$push4=, 63
	i32.and 	$push5=, $pop3, $pop4
	i32.const	$push1=, -64
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push6=, $pop5, $pop2
	i32.store	b($pop0), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end36:
	.size	fn1_4, .Lfunc_end36-fn1_4

	.section	.text.fn2_4,"ax",@progbits
	.hidden	fn2_4
	.globl	fn2_4
	.type	fn2_4,@function
fn2_4:                                  # @fn2_4
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, b($pop11)
	tee_local	$push9=, $1=, $pop10
	i32.const	$push3=, 6
	i32.shl 	$push4=, $0, $pop3
	i32.sub 	$push5=, $pop9, $pop4
	i32.const	$push6=, 131008
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push1=, -131009
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push8=, $pop7, $pop2
	i32.store	b($pop0), $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end37:
	.size	fn2_4, .Lfunc_end37-fn2_4

	.section	.text.fn3_4,"ax",@progbits
	.hidden	fn3_4
	.globl	fn3_4
	.type	fn3_4,@function
fn3_4:                                  # @fn3_4
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, b($pop11)
	tee_local	$push9=, $1=, $pop10
	i32.const	$push3=, 17
	i32.shl 	$push4=, $0, $pop3
	i32.sub 	$push5=, $pop9, $pop4
	i32.const	$push6=, -131072
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push1=, 131071
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push8=, $pop7, $pop2
	i32.store	b($pop0), $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end38:
	.size	fn3_4, .Lfunc_end38-fn3_4

	.section	.text.fn4_4,"ax",@progbits
	.hidden	fn4_4
	.globl	fn4_4
	.type	fn4_4,@function
fn4_4:                                  # @fn4_4
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push9=, 0
	i32.load	$push8=, c($pop9)
	tee_local	$push7=, $1=, $pop8
	i32.sub 	$push3=, $pop7, $0
	i32.const	$push4=, 31
	i32.and 	$push5=, $pop3, $pop4
	i32.const	$push1=, -32
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push6=, $pop5, $pop2
	i32.store	c($pop0), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end39:
	.size	fn4_4, .Lfunc_end39-fn4_4

	.section	.text.fn5_4,"ax",@progbits
	.hidden	fn5_4
	.globl	fn5_4
	.type	fn5_4,@function
fn5_4:                                  # @fn5_4
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, c($pop11)
	tee_local	$push9=, $1=, $pop10
	i32.const	$push3=, 5
	i32.shl 	$push4=, $0, $pop3
	i32.sub 	$push5=, $pop9, $pop4
	i32.const	$push6=, 32
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push1=, -33
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push8=, $pop7, $pop2
	i32.store	c($pop0), $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end40:
	.size	fn5_4, .Lfunc_end40-fn5_4

	.section	.text.fn6_4,"ax",@progbits
	.hidden	fn6_4
	.globl	fn6_4
	.type	fn6_4,@function
fn6_4:                                  # @fn6_4
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, c($pop11)
	tee_local	$push9=, $1=, $pop10
	i32.const	$push3=, 6
	i32.shl 	$push4=, $0, $pop3
	i32.sub 	$push5=, $pop9, $pop4
	i32.const	$push6=, -64
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push1=, 63
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push8=, $pop7, $pop2
	i32.store	c($pop0), $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end41:
	.size	fn6_4, .Lfunc_end41-fn6_4

	.section	.text.fn7_4,"ax",@progbits
	.hidden	fn7_4
	.globl	fn7_4
	.type	fn7_4,@function
fn7_4:                                  # @fn7_4
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push3=, 0
	i32.load	$push1=, d($pop3)
	i32.sub 	$push2=, $pop1, $0
	i32.store16	d($pop0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end42:
	.size	fn7_4, .Lfunc_end42-fn7_4

	.section	.text.fn8_4,"ax",@progbits
	.hidden	fn8_4
	.globl	fn8_4
	.type	fn8_4,@function
fn8_4:                                  # @fn8_4
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push7=, 0
	i32.load	$push3=, d($pop7)
	i32.const	$push0=, 16
	i32.shl 	$push1=, $0, $pop0
	i32.sub 	$push4=, $pop3, $pop1
	i32.const	$push6=, 16
	i32.shr_u	$push5=, $pop4, $pop6
	i32.store8	d+2($pop2), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end43:
	.size	fn8_4, .Lfunc_end43-fn8_4

	.section	.text.fn9_4,"ax",@progbits
	.hidden	fn9_4
	.globl	fn9_4
	.type	fn9_4,@function
fn9_4:                                  # @fn9_4
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push7=, 0
	i32.load	$push3=, d($pop7)
	i32.const	$push0=, 24
	i32.shl 	$push1=, $0, $pop0
	i32.sub 	$push4=, $pop3, $pop1
	i32.const	$push6=, 24
	i32.shr_u	$push5=, $pop4, $pop6
	i32.store8	d+3($pop2), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end44:
	.size	fn9_4, .Lfunc_end44-fn9_4

	.section	.text.fn1_5,"ax",@progbits
	.hidden	fn1_5
	.globl	fn1_5
	.type	fn1_5,@function
fn1_5:                                  # @fn1_5
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, b($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 63
	i32.add 	$push4=, $pop8, $pop3
	i32.const	$push7=, 63
	i32.and 	$push5=, $pop4, $pop7
	i32.const	$push1=, -64
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push6=, $pop5, $pop2
	i32.store	b($pop0), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end45:
	.size	fn1_5, .Lfunc_end45-fn1_5

	.section	.text.fn2_5,"ax",@progbits
	.hidden	fn2_5
	.globl	fn2_5
	.type	fn2_5,@function
fn2_5:                                  # @fn2_5
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, b($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 131008
	i32.add 	$push4=, $pop8, $pop3
	i32.const	$push7=, 131008
	i32.and 	$push5=, $pop4, $pop7
	i32.const	$push1=, -131009
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push6=, $pop5, $pop2
	i32.store	b($pop0), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end46:
	.size	fn2_5, .Lfunc_end46-fn2_5

	.section	.text.fn3_5,"ax",@progbits
	.hidden	fn3_5
	.globl	fn3_5
	.type	fn3_5,@function
fn3_5:                                  # @fn3_5
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, b($pop4)
	i32.const	$push2=, -131072
	i32.add 	$push3=, $pop1, $pop2
	i32.store	b($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end47:
	.size	fn3_5, .Lfunc_end47-fn3_5

	.section	.text.fn4_5,"ax",@progbits
	.hidden	fn4_5
	.globl	fn4_5
	.type	fn4_5,@function
fn4_5:                                  # @fn4_5
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, c($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 31
	i32.add 	$push4=, $pop8, $pop3
	i32.const	$push7=, 31
	i32.and 	$push5=, $pop4, $pop7
	i32.const	$push1=, -32
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push6=, $pop5, $pop2
	i32.store	c($pop0), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end48:
	.size	fn4_5, .Lfunc_end48-fn4_5

	.section	.text.fn5_5,"ax",@progbits
	.hidden	fn5_5
	.globl	fn5_5
	.type	fn5_5,@function
fn5_5:                                  # @fn5_5
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, 32
	i32.xor 	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end49:
	.size	fn5_5, .Lfunc_end49-fn5_5

	.section	.text.fn6_5,"ax",@progbits
	.hidden	fn6_5
	.globl	fn6_5
	.type	fn6_5,@function
fn6_5:                                  # @fn6_5
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, -64
	i32.add 	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end50:
	.size	fn6_5, .Lfunc_end50-fn6_5

	.section	.text.fn7_5,"ax",@progbits
	.hidden	fn7_5
	.globl	fn7_5
	.type	fn7_5,@function
fn7_5:                                  # @fn7_5
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, 65535
	i32.add 	$push3=, $pop1, $pop2
	i32.store16	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end51:
	.size	fn7_5, .Lfunc_end51-fn7_5

	.section	.text.fn8_5,"ax",@progbits
	.hidden	fn8_5
	.globl	fn8_5
	.type	fn8_5,@function
fn8_5:                                  # @fn8_5
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push6=, 0
	i32.load	$push1=, d($pop6)
	i32.const	$push2=, 16711680
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, 16
	i32.shr_u	$push5=, $pop3, $pop4
	i32.store8	d+2($pop0), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end52:
	.size	fn8_5, .Lfunc_end52-fn8_5

	.section	.text.fn9_5,"ax",@progbits
	.hidden	fn9_5
	.globl	fn9_5
	.type	fn9_5,@function
fn9_5:                                  # @fn9_5
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, -16777216
	i32.add 	$push3=, $pop1, $pop2
	i32.store	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end53:
	.size	fn9_5, .Lfunc_end53-fn9_5

	.section	.text.fn1_6,"ax",@progbits
	.hidden	fn1_6
	.globl	fn1_6
	.type	fn1_6,@function
fn1_6:                                  # @fn1_6
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, b($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 63
	i32.add 	$push4=, $pop8, $pop3
	i32.const	$push7=, 63
	i32.and 	$push5=, $pop4, $pop7
	i32.const	$push1=, -64
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push6=, $pop5, $pop2
	i32.store	b($pop0), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end54:
	.size	fn1_6, .Lfunc_end54-fn1_6

	.section	.text.fn2_6,"ax",@progbits
	.hidden	fn2_6
	.globl	fn2_6
	.type	fn2_6,@function
fn2_6:                                  # @fn2_6
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, b($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 131008
	i32.add 	$push4=, $pop8, $pop3
	i32.const	$push7=, 131008
	i32.and 	$push5=, $pop4, $pop7
	i32.const	$push1=, -131009
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push6=, $pop5, $pop2
	i32.store	b($pop0), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end55:
	.size	fn2_6, .Lfunc_end55-fn2_6

	.section	.text.fn3_6,"ax",@progbits
	.hidden	fn3_6
	.globl	fn3_6
	.type	fn3_6,@function
fn3_6:                                  # @fn3_6
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, b($pop4)
	i32.const	$push2=, -131072
	i32.add 	$push3=, $pop1, $pop2
	i32.store	b($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end56:
	.size	fn3_6, .Lfunc_end56-fn3_6

	.section	.text.fn4_6,"ax",@progbits
	.hidden	fn4_6
	.globl	fn4_6
	.type	fn4_6,@function
fn4_6:                                  # @fn4_6
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, c($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 31
	i32.add 	$push4=, $pop8, $pop3
	i32.const	$push7=, 31
	i32.and 	$push5=, $pop4, $pop7
	i32.const	$push1=, -32
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push6=, $pop5, $pop2
	i32.store	c($pop0), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end57:
	.size	fn4_6, .Lfunc_end57-fn4_6

	.section	.text.fn5_6,"ax",@progbits
	.hidden	fn5_6
	.globl	fn5_6
	.type	fn5_6,@function
fn5_6:                                  # @fn5_6
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, 32
	i32.xor 	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end58:
	.size	fn5_6, .Lfunc_end58-fn5_6

	.section	.text.fn6_6,"ax",@progbits
	.hidden	fn6_6
	.globl	fn6_6
	.type	fn6_6,@function
fn6_6:                                  # @fn6_6
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, -64
	i32.add 	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end59:
	.size	fn6_6, .Lfunc_end59-fn6_6

	.section	.text.fn7_6,"ax",@progbits
	.hidden	fn7_6
	.globl	fn7_6
	.type	fn7_6,@function
fn7_6:                                  # @fn7_6
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, 65535
	i32.add 	$push3=, $pop1, $pop2
	i32.store16	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end60:
	.size	fn7_6, .Lfunc_end60-fn7_6

	.section	.text.fn8_6,"ax",@progbits
	.hidden	fn8_6
	.globl	fn8_6
	.type	fn8_6,@function
fn8_6:                                  # @fn8_6
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push6=, 0
	i32.load	$push1=, d($pop6)
	i32.const	$push2=, 16711680
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, 16
	i32.shr_u	$push5=, $pop3, $pop4
	i32.store8	d+2($pop0), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end61:
	.size	fn8_6, .Lfunc_end61-fn8_6

	.section	.text.fn9_6,"ax",@progbits
	.hidden	fn9_6
	.globl	fn9_6
	.type	fn9_6,@function
fn9_6:                                  # @fn9_6
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, -16777216
	i32.add 	$push3=, $pop1, $pop2
	i32.store	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end62:
	.size	fn9_6, .Lfunc_end62-fn9_6

	.section	.text.fn1_7,"ax",@progbits
	.hidden	fn1_7
	.globl	fn1_7
	.type	fn1_7,@function
fn1_7:                                  # @fn1_7
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push0=, -64
	i32.or  	$push1=, $0, $pop0
	i32.const	$push5=, 0
	i32.load	$push3=, b($pop5)
	i32.and 	$push4=, $pop1, $pop3
	i32.store	b($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end63:
	.size	fn1_7, .Lfunc_end63-fn1_7

	.section	.text.fn2_7,"ax",@progbits
	.hidden	fn2_7
	.globl	fn2_7
	.type	fn2_7,@function
fn2_7:                                  # @fn2_7
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push0=, 6
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, -131009
	i32.or  	$push3=, $pop1, $pop2
	i32.const	$push7=, 0
	i32.load	$push5=, b($pop7)
	i32.and 	$push6=, $pop3, $pop5
	i32.store	b($pop4), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end64:
	.size	fn2_7, .Lfunc_end64-fn2_7

	.section	.text.fn3_7,"ax",@progbits
	.hidden	fn3_7
	.globl	fn3_7
	.type	fn3_7,@function
fn3_7:                                  # @fn3_7
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push7=, 0
	i32.load	$push5=, b($pop7)
	i32.const	$push0=, 17
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 131071
	i32.or  	$push3=, $pop1, $pop2
	i32.and 	$push6=, $pop5, $pop3
	i32.store	b($pop4), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end65:
	.size	fn3_7, .Lfunc_end65-fn3_7

	.section	.text.fn4_7,"ax",@progbits
	.hidden	fn4_7
	.globl	fn4_7
	.type	fn4_7,@function
fn4_7:                                  # @fn4_7
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push0=, -32
	i32.or  	$push1=, $0, $pop0
	i32.const	$push5=, 0
	i32.load	$push3=, c($pop5)
	i32.and 	$push4=, $pop1, $pop3
	i32.store	c($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end66:
	.size	fn4_7, .Lfunc_end66-fn4_7

	.section	.text.fn5_7,"ax",@progbits
	.hidden	fn5_7
	.globl	fn5_7
	.type	fn5_7,@function
fn5_7:                                  # @fn5_7
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push0=, 5
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, -33
	i32.or  	$push3=, $pop1, $pop2
	i32.const	$push7=, 0
	i32.load	$push5=, c($pop7)
	i32.and 	$push6=, $pop3, $pop5
	i32.store	c($pop4), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end67:
	.size	fn5_7, .Lfunc_end67-fn5_7

	.section	.text.fn6_7,"ax",@progbits
	.hidden	fn6_7
	.globl	fn6_7
	.type	fn6_7,@function
fn6_7:                                  # @fn6_7
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push7=, 0
	i32.load	$push5=, c($pop7)
	i32.const	$push0=, 6
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 63
	i32.or  	$push3=, $pop1, $pop2
	i32.and 	$push6=, $pop5, $pop3
	i32.store	c($pop4), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end68:
	.size	fn6_7, .Lfunc_end68-fn6_7

	.section	.text.fn7_7,"ax",@progbits
	.hidden	fn7_7
	.globl	fn7_7
	.type	fn7_7,@function
fn7_7:                                  # @fn7_7
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push0=, -65536
	i32.or  	$push1=, $0, $pop0
	i32.const	$push5=, 0
	i32.load	$push3=, d($pop5)
	i32.and 	$push4=, $pop1, $pop3
	i32.store	d($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end69:
	.size	fn7_7, .Lfunc_end69-fn7_7

	.section	.text.fn8_7,"ax",@progbits
	.hidden	fn8_7
	.globl	fn8_7
	.type	fn8_7,@function
fn8_7:                                  # @fn8_7
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push0=, 16
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, -16711681
	i32.or  	$push3=, $pop1, $pop2
	i32.const	$push7=, 0
	i32.load	$push5=, d($pop7)
	i32.and 	$push6=, $pop3, $pop5
	i32.store	d($pop4), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end70:
	.size	fn8_7, .Lfunc_end70-fn8_7

	.section	.text.fn9_7,"ax",@progbits
	.hidden	fn9_7
	.globl	fn9_7
	.type	fn9_7,@function
fn9_7:                                  # @fn9_7
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push7=, 0
	i32.load	$push5=, d($pop7)
	i32.const	$push0=, 24
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 16777215
	i32.or  	$push3=, $pop1, $pop2
	i32.and 	$push6=, $pop5, $pop3
	i32.store	d($pop4), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end71:
	.size	fn9_7, .Lfunc_end71-fn9_7

	.section	.text.fn1_8,"ax",@progbits
	.hidden	fn1_8
	.globl	fn1_8
	.type	fn1_8,@function
fn1_8:                                  # @fn1_8
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push5=, 0
	i32.load	$push3=, b($pop5)
	i32.const	$push0=, 63
	i32.and 	$push1=, $0, $pop0
	i32.or  	$push4=, $pop3, $pop1
	i32.store	b($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end72:
	.size	fn1_8, .Lfunc_end72-fn1_8

	.section	.text.fn2_8,"ax",@progbits
	.hidden	fn2_8
	.globl	fn2_8
	.type	fn2_8,@function
fn2_8:                                  # @fn2_8
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push7=, 0
	i32.load	$push5=, b($pop7)
	i32.const	$push0=, 6
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 131008
	i32.and 	$push3=, $pop1, $pop2
	i32.or  	$push6=, $pop5, $pop3
	i32.store	b($pop4), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end73:
	.size	fn2_8, .Lfunc_end73-fn2_8

	.section	.text.fn3_8,"ax",@progbits
	.hidden	fn3_8
	.globl	fn3_8
	.type	fn3_8,@function
fn3_8:                                  # @fn3_8
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, b($pop11)
	tee_local	$push9=, $1=, $pop10
	i32.const	$push3=, -131072
	i32.and 	$push4=, $pop9, $pop3
	i32.const	$push0=, 17
	i32.shl 	$push1=, $0, $pop0
	i32.or  	$push5=, $pop4, $pop1
	i32.const	$push6=, 131071
	i32.and 	$push7=, $1, $pop6
	i32.or  	$push8=, $pop5, $pop7
	i32.store	b($pop2), $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end74:
	.size	fn3_8, .Lfunc_end74-fn3_8

	.section	.text.fn4_8,"ax",@progbits
	.hidden	fn4_8
	.globl	fn4_8
	.type	fn4_8,@function
fn4_8:                                  # @fn4_8
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push5=, 0
	i32.load	$push3=, c($pop5)
	i32.const	$push0=, 31
	i32.and 	$push1=, $0, $pop0
	i32.or  	$push4=, $pop3, $pop1
	i32.store	c($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end75:
	.size	fn4_8, .Lfunc_end75-fn4_8

	.section	.text.fn5_8,"ax",@progbits
	.hidden	fn5_8
	.globl	fn5_8
	.type	fn5_8,@function
fn5_8:                                  # @fn5_8
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push7=, 0
	i32.load	$push5=, c($pop7)
	i32.const	$push0=, 5
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 32
	i32.and 	$push3=, $pop1, $pop2
	i32.or  	$push6=, $pop5, $pop3
	i32.store	c($pop4), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end76:
	.size	fn5_8, .Lfunc_end76-fn5_8

	.section	.text.fn6_8,"ax",@progbits
	.hidden	fn6_8
	.globl	fn6_8
	.type	fn6_8,@function
fn6_8:                                  # @fn6_8
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, c($pop11)
	tee_local	$push9=, $1=, $pop10
	i32.const	$push3=, -64
	i32.and 	$push4=, $pop9, $pop3
	i32.const	$push0=, 6
	i32.shl 	$push1=, $0, $pop0
	i32.or  	$push5=, $pop4, $pop1
	i32.const	$push6=, 63
	i32.and 	$push7=, $1, $pop6
	i32.or  	$push8=, $pop5, $pop7
	i32.store	c($pop2), $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end77:
	.size	fn6_8, .Lfunc_end77-fn6_8

	.section	.text.fn7_8,"ax",@progbits
	.hidden	fn7_8
	.globl	fn7_8
	.type	fn7_8,@function
fn7_8:                                  # @fn7_8
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push5=, 0
	i32.load	$push3=, d($pop5)
	i32.const	$push0=, 65535
	i32.and 	$push1=, $0, $pop0
	i32.or  	$push4=, $pop3, $pop1
	i32.store	d($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end78:
	.size	fn7_8, .Lfunc_end78-fn7_8

	.section	.text.fn8_8,"ax",@progbits
	.hidden	fn8_8
	.globl	fn8_8
	.type	fn8_8,@function
fn8_8:                                  # @fn8_8
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push7=, 0
	i32.load	$push5=, d($pop7)
	i32.const	$push0=, 16
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 16711680
	i32.and 	$push3=, $pop1, $pop2
	i32.or  	$push6=, $pop5, $pop3
	i32.store	d($pop4), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end79:
	.size	fn8_8, .Lfunc_end79-fn8_8

	.section	.text.fn9_8,"ax",@progbits
	.hidden	fn9_8
	.globl	fn9_8
	.type	fn9_8,@function
fn9_8:                                  # @fn9_8
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push7=, 0
	i32.load	$push3=, d($pop7)
	i32.const	$push0=, 24
	i32.shl 	$push1=, $0, $pop0
	i32.or  	$push4=, $pop3, $pop1
	i32.const	$push6=, 24
	i32.shr_u	$push5=, $pop4, $pop6
	i32.store8	d+3($pop2), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end80:
	.size	fn9_8, .Lfunc_end80-fn9_8

	.section	.text.fn1_9,"ax",@progbits
	.hidden	fn1_9
	.globl	fn1_9
	.type	fn1_9,@function
fn1_9:                                  # @fn1_9
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push5=, 0
	i32.load	$push3=, b($pop5)
	i32.const	$push0=, 63
	i32.and 	$push1=, $0, $pop0
	i32.xor 	$push4=, $pop3, $pop1
	i32.store	b($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end81:
	.size	fn1_9, .Lfunc_end81-fn1_9

	.section	.text.fn2_9,"ax",@progbits
	.hidden	fn2_9
	.globl	fn2_9
	.type	fn2_9,@function
fn2_9:                                  # @fn2_9
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push7=, 0
	i32.load	$push5=, b($pop7)
	i32.const	$push0=, 6
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 131008
	i32.and 	$push3=, $pop1, $pop2
	i32.xor 	$push6=, $pop5, $pop3
	i32.store	b($pop4), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end82:
	.size	fn2_9, .Lfunc_end82-fn2_9

	.section	.text.fn3_9,"ax",@progbits
	.hidden	fn3_9
	.globl	fn3_9
	.type	fn3_9,@function
fn3_9:                                  # @fn3_9
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, b($pop11)
	tee_local	$push9=, $1=, $pop10
	i32.const	$push3=, -131072
	i32.and 	$push4=, $pop9, $pop3
	i32.const	$push0=, 17
	i32.shl 	$push1=, $0, $pop0
	i32.xor 	$push5=, $pop4, $pop1
	i32.const	$push6=, 131071
	i32.and 	$push7=, $1, $pop6
	i32.or  	$push8=, $pop5, $pop7
	i32.store	b($pop2), $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end83:
	.size	fn3_9, .Lfunc_end83-fn3_9

	.section	.text.fn4_9,"ax",@progbits
	.hidden	fn4_9
	.globl	fn4_9
	.type	fn4_9,@function
fn4_9:                                  # @fn4_9
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push5=, 0
	i32.load	$push3=, c($pop5)
	i32.const	$push0=, 31
	i32.and 	$push1=, $0, $pop0
	i32.xor 	$push4=, $pop3, $pop1
	i32.store	c($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end84:
	.size	fn4_9, .Lfunc_end84-fn4_9

	.section	.text.fn5_9,"ax",@progbits
	.hidden	fn5_9
	.globl	fn5_9
	.type	fn5_9,@function
fn5_9:                                  # @fn5_9
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push7=, 0
	i32.load	$push5=, c($pop7)
	i32.const	$push0=, 5
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 32
	i32.and 	$push3=, $pop1, $pop2
	i32.xor 	$push6=, $pop5, $pop3
	i32.store	c($pop4), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end85:
	.size	fn5_9, .Lfunc_end85-fn5_9

	.section	.text.fn6_9,"ax",@progbits
	.hidden	fn6_9
	.globl	fn6_9
	.type	fn6_9,@function
fn6_9:                                  # @fn6_9
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, c($pop11)
	tee_local	$push9=, $1=, $pop10
	i32.const	$push3=, -64
	i32.and 	$push4=, $pop9, $pop3
	i32.const	$push0=, 6
	i32.shl 	$push1=, $0, $pop0
	i32.xor 	$push5=, $pop4, $pop1
	i32.const	$push6=, 63
	i32.and 	$push7=, $1, $pop6
	i32.or  	$push8=, $pop5, $pop7
	i32.store	c($pop2), $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end86:
	.size	fn6_9, .Lfunc_end86-fn6_9

	.section	.text.fn7_9,"ax",@progbits
	.hidden	fn7_9
	.globl	fn7_9
	.type	fn7_9,@function
fn7_9:                                  # @fn7_9
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push5=, 0
	i32.load	$push3=, d($pop5)
	i32.const	$push0=, 65535
	i32.and 	$push1=, $0, $pop0
	i32.xor 	$push4=, $pop3, $pop1
	i32.store	d($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end87:
	.size	fn7_9, .Lfunc_end87-fn7_9

	.section	.text.fn8_9,"ax",@progbits
	.hidden	fn8_9
	.globl	fn8_9
	.type	fn8_9,@function
fn8_9:                                  # @fn8_9
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push7=, 0
	i32.load	$push5=, d($pop7)
	i32.const	$push0=, 16
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 16711680
	i32.and 	$push3=, $pop1, $pop2
	i32.xor 	$push6=, $pop5, $pop3
	i32.store	d($pop4), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end88:
	.size	fn8_9, .Lfunc_end88-fn8_9

	.section	.text.fn9_9,"ax",@progbits
	.hidden	fn9_9
	.globl	fn9_9
	.type	fn9_9,@function
fn9_9:                                  # @fn9_9
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push7=, 0
	i32.load	$push3=, d($pop7)
	i32.const	$push0=, 24
	i32.shl 	$push1=, $0, $pop0
	i32.xor 	$push4=, $pop3, $pop1
	i32.const	$push6=, 24
	i32.shr_u	$push5=, $pop4, $pop6
	i32.store8	d+3($pop2), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end89:
	.size	fn9_9, .Lfunc_end89-fn9_9

	.section	.text.fn1_a,"ax",@progbits
	.hidden	fn1_a
	.globl	fn1_a
	.type	fn1_a,@function
fn1_a:                                  # @fn1_a
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push9=, 0
	i32.load	$push8=, b($pop9)
	tee_local	$push7=, $1=, $pop8
	i32.const	$push1=, -64
	i32.and 	$push2=, $pop7, $pop1
	i32.const	$push3=, 63
	i32.and 	$push4=, $1, $pop3
	i32.div_u	$push5=, $pop4, $0
	i32.or  	$push6=, $pop2, $pop5
	i32.store	b($pop0), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end90:
	.size	fn1_a, .Lfunc_end90-fn1_a

	.section	.text.fn2_a,"ax",@progbits
	.hidden	fn2_a
	.globl	fn2_a
	.type	fn2_a,@function
fn2_a:                                  # @fn2_a
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push13=, 0
	i32.load	$push12=, b($pop13)
	tee_local	$push11=, $1=, $pop12
	i32.const	$push3=, 6
	i32.shr_u	$push4=, $pop11, $pop3
	i32.const	$push5=, 2047
	i32.and 	$push6=, $pop4, $pop5
	i32.div_u	$push7=, $pop6, $0
	i32.const	$push10=, 6
	i32.shl 	$push8=, $pop7, $pop10
	i32.const	$push1=, -131009
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push9=, $pop8, $pop2
	i32.store	b($pop0), $pop9
                                        # fallthrough-return
	.endfunc
.Lfunc_end91:
	.size	fn2_a, .Lfunc_end91-fn2_a

	.section	.text.fn3_a,"ax",@progbits
	.hidden	fn3_a
	.globl	fn3_a
	.type	fn3_a,@function
fn3_a:                                  # @fn3_a
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, b($pop11)
	tee_local	$push9=, $1=, $pop10
	i32.const	$push3=, 17
	i32.shr_u	$push4=, $pop9, $pop3
	i32.div_u	$push5=, $pop4, $0
	i32.const	$push8=, 17
	i32.shl 	$push6=, $pop5, $pop8
	i32.const	$push1=, 131071
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	b($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end92:
	.size	fn3_a, .Lfunc_end92-fn3_a

	.section	.text.fn4_a,"ax",@progbits
	.hidden	fn4_a
	.globl	fn4_a
	.type	fn4_a,@function
fn4_a:                                  # @fn4_a
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push9=, 0
	i32.load	$push8=, c($pop9)
	tee_local	$push7=, $1=, $pop8
	i32.const	$push1=, -32
	i32.and 	$push2=, $pop7, $pop1
	i32.const	$push3=, 31
	i32.and 	$push4=, $1, $pop3
	i32.div_u	$push5=, $pop4, $0
	i32.or  	$push6=, $pop2, $pop5
	i32.store	c($pop0), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end93:
	.size	fn4_a, .Lfunc_end93-fn4_a

	.section	.text.fn5_a,"ax",@progbits
	.hidden	fn5_a
	.globl	fn5_a
	.type	fn5_a,@function
fn5_a:                                  # @fn5_a
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push13=, 0
	i32.load	$push12=, c($pop13)
	tee_local	$push11=, $1=, $pop12
	i32.const	$push3=, 5
	i32.shr_u	$push4=, $pop11, $pop3
	i32.const	$push5=, 1
	i32.and 	$push6=, $pop4, $pop5
	i32.div_u	$push7=, $pop6, $0
	i32.const	$push10=, 5
	i32.shl 	$push8=, $pop7, $pop10
	i32.const	$push1=, -33
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push9=, $pop8, $pop2
	i32.store	c($pop0), $pop9
                                        # fallthrough-return
	.endfunc
.Lfunc_end94:
	.size	fn5_a, .Lfunc_end94-fn5_a

	.section	.text.fn6_a,"ax",@progbits
	.hidden	fn6_a
	.globl	fn6_a
	.type	fn6_a,@function
fn6_a:                                  # @fn6_a
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, c($pop11)
	tee_local	$push9=, $1=, $pop10
	i32.const	$push3=, 6
	i32.shr_u	$push4=, $pop9, $pop3
	i32.div_u	$push5=, $pop4, $0
	i32.const	$push8=, 6
	i32.shl 	$push6=, $pop5, $pop8
	i32.const	$push1=, 63
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	c($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end95:
	.size	fn6_a, .Lfunc_end95-fn6_a

	.section	.text.fn7_a,"ax",@progbits
	.hidden	fn7_a
	.globl	fn7_a
	.type	fn7_a,@function
fn7_a:                                  # @fn7_a
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push3=, 0
	i32.load16_u	$push1=, d($pop3)
	i32.div_u	$push2=, $pop1, $0
	i32.store16	d($pop0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end96:
	.size	fn7_a, .Lfunc_end96-fn7_a

	.section	.text.fn8_a,"ax",@progbits
	.hidden	fn8_a
	.globl	fn8_a
	.type	fn8_a,@function
fn8_a:                                  # @fn8_a
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push3=, 0
	i32.load8_u	$push1=, d+2($pop3)
	i32.div_u	$push2=, $pop1, $0
	i32.store8	d+2($pop0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end97:
	.size	fn8_a, .Lfunc_end97-fn8_a

	.section	.text.fn9_a,"ax",@progbits
	.hidden	fn9_a
	.globl	fn9_a
	.type	fn9_a,@function
fn9_a:                                  # @fn9_a
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push3=, 0
	i32.load8_u	$push1=, d+3($pop3)
	i32.div_u	$push2=, $pop1, $0
	i32.store8	d+3($pop0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end98:
	.size	fn9_a, .Lfunc_end98-fn9_a

	.section	.text.fn1_b,"ax",@progbits
	.hidden	fn1_b
	.globl	fn1_b
	.type	fn1_b,@function
fn1_b:                                  # @fn1_b
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push9=, 0
	i32.load	$push8=, b($pop9)
	tee_local	$push7=, $1=, $pop8
	i32.const	$push3=, 63
	i32.and 	$push4=, $pop7, $pop3
	i32.rem_u	$push5=, $pop4, $0
	i32.const	$push1=, -64
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push6=, $pop5, $pop2
	i32.store	b($pop0), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end99:
	.size	fn1_b, .Lfunc_end99-fn1_b

	.section	.text.fn2_b,"ax",@progbits
	.hidden	fn2_b
	.globl	fn2_b
	.type	fn2_b,@function
fn2_b:                                  # @fn2_b
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push13=, 0
	i32.load	$push12=, b($pop13)
	tee_local	$push11=, $1=, $pop12
	i32.const	$push3=, 6
	i32.shr_u	$push4=, $pop11, $pop3
	i32.const	$push5=, 2047
	i32.and 	$push6=, $pop4, $pop5
	i32.rem_u	$push7=, $pop6, $0
	i32.const	$push10=, 6
	i32.shl 	$push8=, $pop7, $pop10
	i32.const	$push1=, -131009
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push9=, $pop8, $pop2
	i32.store	b($pop0), $pop9
                                        # fallthrough-return
	.endfunc
.Lfunc_end100:
	.size	fn2_b, .Lfunc_end100-fn2_b

	.section	.text.fn3_b,"ax",@progbits
	.hidden	fn3_b
	.globl	fn3_b
	.type	fn3_b,@function
fn3_b:                                  # @fn3_b
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, b($pop11)
	tee_local	$push9=, $1=, $pop10
	i32.const	$push3=, 17
	i32.shr_u	$push4=, $pop9, $pop3
	i32.rem_u	$push5=, $pop4, $0
	i32.const	$push8=, 17
	i32.shl 	$push6=, $pop5, $pop8
	i32.const	$push1=, 131071
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	b($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end101:
	.size	fn3_b, .Lfunc_end101-fn3_b

	.section	.text.fn4_b,"ax",@progbits
	.hidden	fn4_b
	.globl	fn4_b
	.type	fn4_b,@function
fn4_b:                                  # @fn4_b
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push9=, 0
	i32.load	$push8=, c($pop9)
	tee_local	$push7=, $1=, $pop8
	i32.const	$push3=, 31
	i32.and 	$push4=, $pop7, $pop3
	i32.rem_u	$push5=, $pop4, $0
	i32.const	$push1=, -32
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push6=, $pop5, $pop2
	i32.store	c($pop0), $pop6
                                        # fallthrough-return
	.endfunc
.Lfunc_end102:
	.size	fn4_b, .Lfunc_end102-fn4_b

	.section	.text.fn5_b,"ax",@progbits
	.hidden	fn5_b
	.globl	fn5_b
	.type	fn5_b,@function
fn5_b:                                  # @fn5_b
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push13=, 0
	i32.load	$push12=, c($pop13)
	tee_local	$push11=, $1=, $pop12
	i32.const	$push3=, 5
	i32.shr_u	$push4=, $pop11, $pop3
	i32.const	$push5=, 1
	i32.and 	$push6=, $pop4, $pop5
	i32.rem_u	$push7=, $pop6, $0
	i32.const	$push10=, 5
	i32.shl 	$push8=, $pop7, $pop10
	i32.const	$push1=, -33
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push9=, $pop8, $pop2
	i32.store	c($pop0), $pop9
                                        # fallthrough-return
	.endfunc
.Lfunc_end103:
	.size	fn5_b, .Lfunc_end103-fn5_b

	.section	.text.fn6_b,"ax",@progbits
	.hidden	fn6_b
	.globl	fn6_b
	.type	fn6_b,@function
fn6_b:                                  # @fn6_b
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, c($pop11)
	tee_local	$push9=, $1=, $pop10
	i32.const	$push3=, 6
	i32.shr_u	$push4=, $pop9, $pop3
	i32.rem_u	$push5=, $pop4, $0
	i32.const	$push8=, 6
	i32.shl 	$push6=, $pop5, $pop8
	i32.const	$push1=, 63
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	c($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end104:
	.size	fn6_b, .Lfunc_end104-fn6_b

	.section	.text.fn7_b,"ax",@progbits
	.hidden	fn7_b
	.globl	fn7_b
	.type	fn7_b,@function
fn7_b:                                  # @fn7_b
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push3=, 0
	i32.load16_u	$push1=, d($pop3)
	i32.rem_u	$push2=, $pop1, $0
	i32.store16	d($pop0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end105:
	.size	fn7_b, .Lfunc_end105-fn7_b

	.section	.text.fn8_b,"ax",@progbits
	.hidden	fn8_b
	.globl	fn8_b
	.type	fn8_b,@function
fn8_b:                                  # @fn8_b
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push3=, 0
	i32.load8_u	$push1=, d+2($pop3)
	i32.rem_u	$push2=, $pop1, $0
	i32.store8	d+2($pop0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end106:
	.size	fn8_b, .Lfunc_end106-fn8_b

	.section	.text.fn9_b,"ax",@progbits
	.hidden	fn9_b
	.globl	fn9_b
	.type	fn9_b,@function
fn9_b:                                  # @fn9_b
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push3=, 0
	i32.load8_u	$push1=, d+3($pop3)
	i32.rem_u	$push2=, $pop1, $0
	i32.store8	d+3($pop0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end107:
	.size	fn9_b, .Lfunc_end107-fn9_b

	.section	.text.fn1_c,"ax",@progbits
	.hidden	fn1_c
	.globl	fn1_c
	.type	fn1_c,@function
fn1_c:                                  # @fn1_c
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, b($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 3
	i32.add 	$push4=, $pop8, $pop3
	i32.const	$push5=, 63
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push1=, -64
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	b($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end108:
	.size	fn1_c, .Lfunc_end108-fn1_c

	.section	.text.fn2_c,"ax",@progbits
	.hidden	fn2_c
	.globl	fn2_c
	.type	fn2_c,@function
fn2_c:                                  # @fn2_c
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, b($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 192
	i32.add 	$push4=, $pop8, $pop3
	i32.const	$push5=, 131008
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push1=, -131009
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	b($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end109:
	.size	fn2_c, .Lfunc_end109-fn2_c

	.section	.text.fn3_c,"ax",@progbits
	.hidden	fn3_c
	.globl	fn3_c
	.type	fn3_c,@function
fn3_c:                                  # @fn3_c
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, b($pop4)
	i32.const	$push2=, 393216
	i32.add 	$push3=, $pop1, $pop2
	i32.store	b($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end110:
	.size	fn3_c, .Lfunc_end110-fn3_c

	.section	.text.fn4_c,"ax",@progbits
	.hidden	fn4_c
	.globl	fn4_c
	.type	fn4_c,@function
fn4_c:                                  # @fn4_c
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, c($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 3
	i32.add 	$push4=, $pop8, $pop3
	i32.const	$push5=, 31
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push1=, -32
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	c($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end111:
	.size	fn4_c, .Lfunc_end111-fn4_c

	.section	.text.fn5_c,"ax",@progbits
	.hidden	fn5_c
	.globl	fn5_c
	.type	fn5_c,@function
fn5_c:                                  # @fn5_c
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, 32
	i32.xor 	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end112:
	.size	fn5_c, .Lfunc_end112-fn5_c

	.section	.text.fn6_c,"ax",@progbits
	.hidden	fn6_c
	.globl	fn6_c
	.type	fn6_c,@function
fn6_c:                                  # @fn6_c
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, 192
	i32.add 	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end113:
	.size	fn6_c, .Lfunc_end113-fn6_c

	.section	.text.fn7_c,"ax",@progbits
	.hidden	fn7_c
	.globl	fn7_c
	.type	fn7_c,@function
fn7_c:                                  # @fn7_c
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, 3
	i32.add 	$push3=, $pop1, $pop2
	i32.store16	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end114:
	.size	fn7_c, .Lfunc_end114-fn7_c

	.section	.text.fn8_c,"ax",@progbits
	.hidden	fn8_c
	.globl	fn8_c
	.type	fn8_c,@function
fn8_c:                                  # @fn8_c
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push6=, 0
	i32.load	$push1=, d($pop6)
	i32.const	$push2=, 196608
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, 16
	i32.shr_u	$push5=, $pop3, $pop4
	i32.store8	d+2($pop0), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end115:
	.size	fn8_c, .Lfunc_end115-fn8_c

	.section	.text.fn9_c,"ax",@progbits
	.hidden	fn9_c
	.globl	fn9_c
	.type	fn9_c,@function
fn9_c:                                  # @fn9_c
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, 50331648
	i32.add 	$push3=, $pop1, $pop2
	i32.store	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end116:
	.size	fn9_c, .Lfunc_end116-fn9_c

	.section	.text.fn1_d,"ax",@progbits
	.hidden	fn1_d
	.globl	fn1_d
	.type	fn1_d,@function
fn1_d:                                  # @fn1_d
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, b($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 57
	i32.add 	$push4=, $pop8, $pop3
	i32.const	$push5=, 63
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push1=, -64
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	b($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end117:
	.size	fn1_d, .Lfunc_end117-fn1_d

	.section	.text.fn2_d,"ax",@progbits
	.hidden	fn2_d
	.globl	fn2_d
	.type	fn2_d,@function
fn2_d:                                  # @fn2_d
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, b($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 130624
	i32.add 	$push4=, $pop8, $pop3
	i32.const	$push5=, 131008
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push1=, -131009
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	b($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end118:
	.size	fn2_d, .Lfunc_end118-fn2_d

	.section	.text.fn3_d,"ax",@progbits
	.hidden	fn3_d
	.globl	fn3_d
	.type	fn3_d,@function
fn3_d:                                  # @fn3_d
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, b($pop4)
	i32.const	$push2=, -917504
	i32.add 	$push3=, $pop1, $pop2
	i32.store	b($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end119:
	.size	fn3_d, .Lfunc_end119-fn3_d

	.section	.text.fn4_d,"ax",@progbits
	.hidden	fn4_d
	.globl	fn4_d
	.type	fn4_d,@function
fn4_d:                                  # @fn4_d
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, c($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 25
	i32.add 	$push4=, $pop8, $pop3
	i32.const	$push5=, 31
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push1=, -32
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	c($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end120:
	.size	fn4_d, .Lfunc_end120-fn4_d

	.section	.text.fn5_d,"ax",@progbits
	.hidden	fn5_d
	.globl	fn5_d
	.type	fn5_d,@function
fn5_d:                                  # @fn5_d
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, 32
	i32.xor 	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end121:
	.size	fn5_d, .Lfunc_end121-fn5_d

	.section	.text.fn6_d,"ax",@progbits
	.hidden	fn6_d
	.globl	fn6_d
	.type	fn6_d,@function
fn6_d:                                  # @fn6_d
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, -448
	i32.add 	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end122:
	.size	fn6_d, .Lfunc_end122-fn6_d

	.section	.text.fn7_d,"ax",@progbits
	.hidden	fn7_d
	.globl	fn7_d
	.type	fn7_d,@function
fn7_d:                                  # @fn7_d
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, 65529
	i32.add 	$push3=, $pop1, $pop2
	i32.store16	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end123:
	.size	fn7_d, .Lfunc_end123-fn7_d

	.section	.text.fn8_d,"ax",@progbits
	.hidden	fn8_d
	.globl	fn8_d
	.type	fn8_d,@function
fn8_d:                                  # @fn8_d
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push6=, 0
	i32.load	$push1=, d($pop6)
	i32.const	$push2=, 16318464
	i32.add 	$push3=, $pop1, $pop2
	i32.const	$push4=, 16
	i32.shr_u	$push5=, $pop3, $pop4
	i32.store8	d+2($pop0), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end124:
	.size	fn8_d, .Lfunc_end124-fn8_d

	.section	.text.fn9_d,"ax",@progbits
	.hidden	fn9_d
	.globl	fn9_d
	.type	fn9_d,@function
fn9_d:                                  # @fn9_d
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, -117440512
	i32.add 	$push3=, $pop1, $pop2
	i32.store	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end125:
	.size	fn9_d, .Lfunc_end125-fn9_d

	.section	.text.fn1_e,"ax",@progbits
	.hidden	fn1_e
	.globl	fn1_e
	.type	fn1_e,@function
fn1_e:                                  # @fn1_e
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, b($pop4)
	i32.const	$push2=, -43
	i32.and 	$push3=, $pop1, $pop2
	i32.store	b($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end126:
	.size	fn1_e, .Lfunc_end126-fn1_e

	.section	.text.fn2_e,"ax",@progbits
	.hidden	fn2_e
	.globl	fn2_e
	.type	fn2_e,@function
fn2_e:                                  # @fn2_e
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, b($pop4)
	i32.const	$push2=, -129665
	i32.and 	$push3=, $pop1, $pop2
	i32.store	b($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end127:
	.size	fn2_e, .Lfunc_end127-fn2_e

	.section	.text.fn3_e,"ax",@progbits
	.hidden	fn3_e
	.globl	fn3_e
	.type	fn3_e,@function
fn3_e:                                  # @fn3_e
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, b($pop4)
	i32.const	$push2=, 2883583
	i32.and 	$push3=, $pop1, $pop2
	i32.store	b($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end128:
	.size	fn3_e, .Lfunc_end128-fn3_e

	.section	.text.fn4_e,"ax",@progbits
	.hidden	fn4_e
	.globl	fn4_e
	.type	fn4_e,@function
fn4_e:                                  # @fn4_e
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, -11
	i32.and 	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end129:
	.size	fn4_e, .Lfunc_end129-fn4_e

	.section	.text.fn5_e,"ax",@progbits
	.hidden	fn5_e
	.globl	fn5_e
	.type	fn5_e,@function
fn5_e:                                  # @fn5_e
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end130:
	.size	fn5_e, .Lfunc_end130-fn5_e

	.section	.text.fn6_e,"ax",@progbits
	.hidden	fn6_e
	.globl	fn6_e
	.type	fn6_e,@function
fn6_e:                                  # @fn6_e
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, 1407
	i32.and 	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end131:
	.size	fn6_e, .Lfunc_end131-fn6_e

	.section	.text.fn7_e,"ax",@progbits
	.hidden	fn7_e
	.globl	fn7_e
	.type	fn7_e,@function
fn7_e:                                  # @fn7_e
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, -65515
	i32.and 	$push3=, $pop1, $pop2
	i32.store	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end132:
	.size	fn7_e, .Lfunc_end132-fn7_e

	.section	.text.fn8_e,"ax",@progbits
	.hidden	fn8_e
	.globl	fn8_e
	.type	fn8_e,@function
fn8_e:                                  # @fn8_e
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, -15335425
	i32.and 	$push3=, $pop1, $pop2
	i32.store	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end133:
	.size	fn8_e, .Lfunc_end133-fn8_e

	.section	.text.fn9_e,"ax",@progbits
	.hidden	fn9_e
	.globl	fn9_e
	.type	fn9_e,@function
fn9_e:                                  # @fn9_e
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, 369098751
	i32.and 	$push3=, $pop1, $pop2
	i32.store	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end134:
	.size	fn9_e, .Lfunc_end134-fn9_e

	.section	.text.fn1_f,"ax",@progbits
	.hidden	fn1_f
	.globl	fn1_f
	.type	fn1_f,@function
fn1_f:                                  # @fn1_f
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, b($pop4)
	i32.const	$push2=, 19
	i32.or  	$push3=, $pop1, $pop2
	i32.store	b($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end135:
	.size	fn1_f, .Lfunc_end135-fn1_f

	.section	.text.fn2_f,"ax",@progbits
	.hidden	fn2_f
	.globl	fn2_f
	.type	fn2_f,@function
fn2_f:                                  # @fn2_f
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, b($pop4)
	i32.const	$push2=, 1216
	i32.or  	$push3=, $pop1, $pop2
	i32.store	b($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end136:
	.size	fn2_f, .Lfunc_end136-fn2_f

	.section	.text.fn3_f,"ax",@progbits
	.hidden	fn3_f
	.globl	fn3_f
	.type	fn3_f,@function
fn3_f:                                  # @fn3_f
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, b($pop4)
	i32.const	$push2=, 2490368
	i32.or  	$push3=, $pop1, $pop2
	i32.store	b($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end137:
	.size	fn3_f, .Lfunc_end137-fn3_f

	.section	.text.fn4_f,"ax",@progbits
	.hidden	fn4_f
	.globl	fn4_f
	.type	fn4_f,@function
fn4_f:                                  # @fn4_f
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, 19
	i32.or  	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end138:
	.size	fn4_f, .Lfunc_end138-fn4_f

	.section	.text.fn5_f,"ax",@progbits
	.hidden	fn5_f
	.globl	fn5_f
	.type	fn5_f,@function
fn5_f:                                  # @fn5_f
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, 32
	i32.or  	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end139:
	.size	fn5_f, .Lfunc_end139-fn5_f

	.section	.text.fn6_f,"ax",@progbits
	.hidden	fn6_f
	.globl	fn6_f
	.type	fn6_f,@function
fn6_f:                                  # @fn6_f
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, 1216
	i32.or  	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end140:
	.size	fn6_f, .Lfunc_end140-fn6_f

	.section	.text.fn7_f,"ax",@progbits
	.hidden	fn7_f
	.globl	fn7_f
	.type	fn7_f,@function
fn7_f:                                  # @fn7_f
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, 19
	i32.or  	$push3=, $pop1, $pop2
	i32.store	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end141:
	.size	fn7_f, .Lfunc_end141-fn7_f

	.section	.text.fn8_f,"ax",@progbits
	.hidden	fn8_f
	.globl	fn8_f
	.type	fn8_f,@function
fn8_f:                                  # @fn8_f
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, 1245184
	i32.or  	$push3=, $pop1, $pop2
	i32.store	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end142:
	.size	fn8_f, .Lfunc_end142-fn8_f

	.section	.text.fn9_f,"ax",@progbits
	.hidden	fn9_f
	.globl	fn9_f
	.type	fn9_f,@function
fn9_f:                                  # @fn9_f
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, 318767104
	i32.or  	$push3=, $pop1, $pop2
	i32.store	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end143:
	.size	fn9_f, .Lfunc_end143-fn9_f

	.section	.text.fn1_g,"ax",@progbits
	.hidden	fn1_g
	.globl	fn1_g
	.type	fn1_g,@function
fn1_g:                                  # @fn1_g
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, b($pop4)
	i32.const	$push2=, 37
	i32.xor 	$push3=, $pop1, $pop2
	i32.store	b($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end144:
	.size	fn1_g, .Lfunc_end144-fn1_g

	.section	.text.fn2_g,"ax",@progbits
	.hidden	fn2_g
	.globl	fn2_g
	.type	fn2_g,@function
fn2_g:                                  # @fn2_g
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, b($pop4)
	i32.const	$push2=, 2368
	i32.xor 	$push3=, $pop1, $pop2
	i32.store	b($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end145:
	.size	fn2_g, .Lfunc_end145-fn2_g

	.section	.text.fn3_g,"ax",@progbits
	.hidden	fn3_g
	.globl	fn3_g
	.type	fn3_g,@function
fn3_g:                                  # @fn3_g
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, b($pop4)
	i32.const	$push2=, 4849664
	i32.xor 	$push3=, $pop1, $pop2
	i32.store	b($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end146:
	.size	fn3_g, .Lfunc_end146-fn3_g

	.section	.text.fn4_g,"ax",@progbits
	.hidden	fn4_g
	.globl	fn4_g
	.type	fn4_g,@function
fn4_g:                                  # @fn4_g
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, 5
	i32.xor 	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end147:
	.size	fn4_g, .Lfunc_end147-fn4_g

	.section	.text.fn5_g,"ax",@progbits
	.hidden	fn5_g
	.globl	fn5_g
	.type	fn5_g,@function
fn5_g:                                  # @fn5_g
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, 32
	i32.xor 	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end148:
	.size	fn5_g, .Lfunc_end148-fn5_g

	.section	.text.fn6_g,"ax",@progbits
	.hidden	fn6_g
	.globl	fn6_g
	.type	fn6_g,@function
fn6_g:                                  # @fn6_g
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, 2368
	i32.xor 	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end149:
	.size	fn6_g, .Lfunc_end149-fn6_g

	.section	.text.fn7_g,"ax",@progbits
	.hidden	fn7_g
	.globl	fn7_g
	.type	fn7_g,@function
fn7_g:                                  # @fn7_g
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, 37
	i32.xor 	$push3=, $pop1, $pop2
	i32.store	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end150:
	.size	fn7_g, .Lfunc_end150-fn7_g

	.section	.text.fn8_g,"ax",@progbits
	.hidden	fn8_g
	.globl	fn8_g
	.type	fn8_g,@function
fn8_g:                                  # @fn8_g
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, 2424832
	i32.xor 	$push3=, $pop1, $pop2
	i32.store	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end151:
	.size	fn8_g, .Lfunc_end151-fn8_g

	.section	.text.fn9_g,"ax",@progbits
	.hidden	fn9_g
	.globl	fn9_g
	.type	fn9_g,@function
fn9_g:                                  # @fn9_g
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, 620756992
	i32.xor 	$push3=, $pop1, $pop2
	i32.store	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end152:
	.size	fn9_g, .Lfunc_end152-fn9_g

	.section	.text.fn1_h,"ax",@progbits
	.hidden	fn1_h
	.globl	fn1_h
	.type	fn1_h,@function
fn1_h:                                  # @fn1_h
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, b($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 63
	i32.and 	$push4=, $pop8, $pop3
	i32.const	$push5=, 17
	i32.div_u	$push6=, $pop4, $pop5
	i32.const	$push1=, -64
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	b($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end153:
	.size	fn1_h, .Lfunc_end153-fn1_h

	.section	.text.fn2_h,"ax",@progbits
	.hidden	fn2_h
	.globl	fn2_h
	.type	fn2_h,@function
fn2_h:                                  # @fn2_h
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i32.load	$push13=, b($pop14)
	tee_local	$push12=, $1=, $pop13
	i32.const	$push3=, 6
	i32.shr_u	$push4=, $pop12, $pop3
	i32.const	$push5=, 2047
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push7=, 17
	i32.div_u	$push8=, $pop6, $pop7
	i32.const	$push11=, 6
	i32.shl 	$push9=, $pop8, $pop11
	i32.const	$push1=, -131009
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push10=, $pop9, $pop2
	i32.store	b($pop0), $pop10
                                        # fallthrough-return
	.endfunc
.Lfunc_end154:
	.size	fn2_h, .Lfunc_end154-fn2_h

	.section	.text.fn3_h,"ax",@progbits
	.hidden	fn3_h
	.globl	fn3_h
	.type	fn3_h,@function
fn3_h:                                  # @fn3_h
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, b($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 2228224
	i32.div_u	$push4=, $pop8, $pop3
	i32.const	$push5=, 17
	i32.shl 	$push6=, $pop4, $pop5
	i32.const	$push1=, 131071
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	b($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end155:
	.size	fn3_h, .Lfunc_end155-fn3_h

	.section	.text.fn4_h,"ax",@progbits
	.hidden	fn4_h
	.globl	fn4_h
	.type	fn4_h,@function
fn4_h:                                  # @fn4_h
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, c($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 31
	i32.and 	$push4=, $pop8, $pop3
	i32.const	$push5=, 17
	i32.div_u	$push6=, $pop4, $pop5
	i32.const	$push1=, -32
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	c($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end156:
	.size	fn4_h, .Lfunc_end156-fn4_h

	.section	.text.fn5_h,"ax",@progbits
	.hidden	fn5_h
	.globl	fn5_h
	.type	fn5_h,@function
fn5_h:                                  # @fn5_h
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, c($pop4)
	i32.const	$push2=, -33
	i32.and 	$push3=, $pop1, $pop2
	i32.store	c($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end157:
	.size	fn5_h, .Lfunc_end157-fn5_h

	.section	.text.fn6_h,"ax",@progbits
	.hidden	fn6_h
	.globl	fn6_h
	.type	fn6_h,@function
fn6_h:                                  # @fn6_h
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, c($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 1088
	i32.div_u	$push4=, $pop8, $pop3
	i32.const	$push5=, 6
	i32.shl 	$push6=, $pop4, $pop5
	i32.const	$push1=, 63
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	c($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end158:
	.size	fn6_h, .Lfunc_end158-fn6_h

	.section	.text.fn7_h,"ax",@progbits
	.hidden	fn7_h
	.globl	fn7_h
	.type	fn7_h,@function
fn7_h:                                  # @fn7_h
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load16_u	$push1=, d($pop4)
	i32.const	$push2=, 17
	i32.div_u	$push3=, $pop1, $pop2
	i32.store16	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end159:
	.size	fn7_h, .Lfunc_end159-fn7_h

	.section	.text.fn8_h,"ax",@progbits
	.hidden	fn8_h
	.globl	fn8_h
	.type	fn8_h,@function
fn8_h:                                  # @fn8_h
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load8_u	$push1=, d+2($pop4)
	i32.const	$push2=, 17
	i32.div_u	$push3=, $pop1, $pop2
	i32.store8	d+2($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end160:
	.size	fn8_h, .Lfunc_end160-fn8_h

	.section	.text.fn9_h,"ax",@progbits
	.hidden	fn9_h
	.globl	fn9_h
	.type	fn9_h,@function
fn9_h:                                  # @fn9_h
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, d($pop4)
	i32.const	$push2=, 285212672
	i32.div_u	$push3=, $pop1, $pop2
	i32.store8	d+3($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end161:
	.size	fn9_h, .Lfunc_end161-fn9_h

	.section	.text.fn1_i,"ax",@progbits
	.hidden	fn1_i
	.globl	fn1_i
	.type	fn1_i,@function
fn1_i:                                  # @fn1_i
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, b($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 63
	i32.and 	$push4=, $pop8, $pop3
	i32.const	$push5=, 19
	i32.rem_u	$push6=, $pop4, $pop5
	i32.const	$push1=, -64
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	b($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end162:
	.size	fn1_i, .Lfunc_end162-fn1_i

	.section	.text.fn2_i,"ax",@progbits
	.hidden	fn2_i
	.globl	fn2_i
	.type	fn2_i,@function
fn2_i:                                  # @fn2_i
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i32.load	$push13=, b($pop14)
	tee_local	$push12=, $1=, $pop13
	i32.const	$push3=, 6
	i32.shr_u	$push4=, $pop12, $pop3
	i32.const	$push5=, 2047
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push7=, 19
	i32.rem_u	$push8=, $pop6, $pop7
	i32.const	$push11=, 6
	i32.shl 	$push9=, $pop8, $pop11
	i32.const	$push1=, -131009
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push10=, $pop9, $pop2
	i32.store	b($pop0), $pop10
                                        # fallthrough-return
	.endfunc
.Lfunc_end163:
	.size	fn2_i, .Lfunc_end163-fn2_i

	.section	.text.fn3_i,"ax",@progbits
	.hidden	fn3_i
	.globl	fn3_i
	.type	fn3_i,@function
fn3_i:                                  # @fn3_i
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push12=, 0
	i32.load	$push11=, b($pop12)
	tee_local	$push10=, $1=, $pop11
	i32.const	$push3=, 17
	i32.shr_u	$push4=, $pop10, $pop3
	i32.const	$push5=, 19
	i32.rem_u	$push6=, $pop4, $pop5
	i32.const	$push9=, 17
	i32.shl 	$push7=, $pop6, $pop9
	i32.const	$push1=, 131071
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push8=, $pop7, $pop2
	i32.store	b($pop0), $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end164:
	.size	fn3_i, .Lfunc_end164-fn3_i

	.section	.text.fn4_i,"ax",@progbits
	.hidden	fn4_i
	.globl	fn4_i
	.type	fn4_i,@function
fn4_i:                                  # @fn4_i
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push9=, c($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.const	$push3=, 31
	i32.and 	$push4=, $pop8, $pop3
	i32.const	$push5=, 19
	i32.rem_u	$push6=, $pop4, $pop5
	i32.const	$push1=, -32
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push7=, $pop6, $pop2
	i32.store	c($pop0), $pop7
                                        # fallthrough-return
	.endfunc
.Lfunc_end165:
	.size	fn4_i, .Lfunc_end165-fn4_i

	.section	.text.fn5_i,"ax",@progbits
	.hidden	fn5_i
	.globl	fn5_i
	.type	fn5_i,@function
fn5_i:                                  # @fn5_i
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i32.load	$push13=, c($pop14)
	tee_local	$push12=, $1=, $pop13
	i32.const	$push3=, 5
	i32.shr_u	$push4=, $pop12, $pop3
	i32.const	$push5=, 1
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push7=, 19
	i32.rem_u	$push8=, $pop6, $pop7
	i32.const	$push11=, 5
	i32.shl 	$push9=, $pop8, $pop11
	i32.const	$push1=, -33
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push10=, $pop9, $pop2
	i32.store	c($pop0), $pop10
                                        # fallthrough-return
	.endfunc
.Lfunc_end166:
	.size	fn5_i, .Lfunc_end166-fn5_i

	.section	.text.fn6_i,"ax",@progbits
	.hidden	fn6_i
	.globl	fn6_i
	.type	fn6_i,@function
fn6_i:                                  # @fn6_i
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push12=, 0
	i32.load	$push11=, c($pop12)
	tee_local	$push10=, $1=, $pop11
	i32.const	$push3=, 6
	i32.shr_u	$push4=, $pop10, $pop3
	i32.const	$push5=, 19
	i32.rem_u	$push6=, $pop4, $pop5
	i32.const	$push9=, 6
	i32.shl 	$push7=, $pop6, $pop9
	i32.const	$push1=, 63
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push8=, $pop7, $pop2
	i32.store	c($pop0), $pop8
                                        # fallthrough-return
	.endfunc
.Lfunc_end167:
	.size	fn6_i, .Lfunc_end167-fn6_i

	.section	.text.fn7_i,"ax",@progbits
	.hidden	fn7_i
	.globl	fn7_i
	.type	fn7_i,@function
fn7_i:                                  # @fn7_i
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load16_u	$push1=, d($pop4)
	i32.const	$push2=, 19
	i32.rem_u	$push3=, $pop1, $pop2
	i32.store16	d($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end168:
	.size	fn7_i, .Lfunc_end168-fn7_i

	.section	.text.fn8_i,"ax",@progbits
	.hidden	fn8_i
	.globl	fn8_i
	.type	fn8_i,@function
fn8_i:                                  # @fn8_i
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load8_u	$push1=, d+2($pop4)
	i32.const	$push2=, 19
	i32.rem_u	$push3=, $pop1, $pop2
	i32.store8	d+2($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end169:
	.size	fn8_i, .Lfunc_end169-fn8_i

	.section	.text.fn9_i,"ax",@progbits
	.hidden	fn9_i
	.globl	fn9_i
	.type	fn9_i,@function
fn9_i:                                  # @fn9_i
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load8_u	$push1=, d+3($pop4)
	i32.const	$push2=, 19
	i32.rem_u	$push3=, $pop1, $pop2
	i32.store8	d+3($pop0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end170:
	.size	fn9_i, .Lfunc_end170-fn9_i

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end1610
	i32.const	$push1=, 0
	i32.const	$push0=, -2147483595
	i32.store	c($pop1), $pop0
	i32.const	$push6=, 0
	i32.const	$push2=, 560051
	i32.store	b($pop6), $pop2
	i32.const	$push5=, 0
	i32.const	$push3=, -1147377476
	i32.store	d($pop5), $pop3
	i32.const	$push4=, 0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end171:
	.size	main, .Lfunc_end171-main

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	3
b:
	.skip	16
	.size	b, 16

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	3
c:
	.skip	16
	.size	c, 16

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	3
d:
	.skip	16
	.size	d, 16


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
