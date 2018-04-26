	.text
	.file	"conversion.c"
	.section	.text.u2f,"ax",@progbits
	.hidden	u2f                     # -- Begin function u2f
	.globl	u2f
	.type	u2f,@function
u2f:                                    # @u2f
	.param  	i32
	.result 	f32
# %bb.0:                                # %entry
	f32.convert_u/i32	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	u2f, .Lfunc_end0-u2f
                                        # -- End function
	.section	.text.u2d,"ax",@progbits
	.hidden	u2d                     # -- Begin function u2d
	.globl	u2d
	.type	u2d,@function
u2d:                                    # @u2d
	.param  	i32
	.result 	f64
# %bb.0:                                # %entry
	f64.convert_u/i32	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	u2d, .Lfunc_end1-u2d
                                        # -- End function
	.section	.text.u2ld,"ax",@progbits
	.hidden	u2ld                    # -- Begin function u2ld
	.globl	u2ld
	.type	u2ld,@function
u2ld:                                   # @u2ld
	.param  	i32, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$2=, $pop4, $pop6
	i32.const	$push7=, 0
	i32.store	__stack_pointer($pop7), $2
	call    	__floatunsitf@FUNCTION, $2, $1
	i32.const	$push0=, 8
	i32.add 	$push1=, $2, $pop0
	i64.load	$push2=, 0($pop1)
	i64.store	8($0), $pop2
	i64.load	$push3=, 0($2)
	i64.store	0($0), $pop3
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $2, $pop8
	i32.store	__stack_pointer($pop10), $pop9
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	u2ld, .Lfunc_end2-u2ld
                                        # -- End function
	.section	.text.s2f,"ax",@progbits
	.hidden	s2f                     # -- Begin function s2f
	.globl	s2f
	.type	s2f,@function
s2f:                                    # @s2f
	.param  	i32
	.result 	f32
# %bb.0:                                # %entry
	f32.convert_s/i32	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	s2f, .Lfunc_end3-s2f
                                        # -- End function
	.section	.text.s2d,"ax",@progbits
	.hidden	s2d                     # -- Begin function s2d
	.globl	s2d
	.type	s2d,@function
s2d:                                    # @s2d
	.param  	i32
	.result 	f64
# %bb.0:                                # %entry
	f64.convert_s/i32	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	s2d, .Lfunc_end4-s2d
                                        # -- End function
	.section	.text.s2ld,"ax",@progbits
	.hidden	s2ld                    # -- Begin function s2ld
	.globl	s2ld
	.type	s2ld,@function
s2ld:                                   # @s2ld
	.param  	i32, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$2=, $pop4, $pop6
	i32.const	$push7=, 0
	i32.store	__stack_pointer($pop7), $2
	call    	__floatsitf@FUNCTION, $2, $1
	i32.const	$push0=, 8
	i32.add 	$push1=, $2, $pop0
	i64.load	$push2=, 0($pop1)
	i64.store	8($0), $pop2
	i64.load	$push3=, 0($2)
	i64.store	0($0), $pop3
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $2, $pop8
	i32.store	__stack_pointer($pop10), $pop9
                                        # fallthrough-return
	.endfunc
.Lfunc_end5:
	.size	s2ld, .Lfunc_end5-s2ld
                                        # -- End function
	.section	.text.fnear,"ax",@progbits
	.hidden	fnear                   # -- Begin function fnear
	.globl	fnear
	.type	fnear,@function
fnear:                                  # @fnear
	.param  	f32, f32
	.result 	i32
# %bb.0:                                # %entry
	f32.sub 	$1=, $0, $1
	block   	
	f32.const	$push0=, 0x0p0
	f32.ne  	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %lor.end
	i32.const	$push5=, 1
	return  	$pop5
.LBB6_2:                                # %lor.rhs
	end_block                       # label0:
	f32.div 	$push2=, $0, $1
	f32.const	$push3=, 0x1.e848p19
	f32.gt  	$push4=, $pop2, $pop3
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end6:
	.size	fnear, .Lfunc_end6-fnear
                                        # -- End function
	.section	.text.dnear,"ax",@progbits
	.hidden	dnear                   # -- Begin function dnear
	.globl	dnear
	.type	dnear,@function
dnear:                                  # @dnear
	.param  	f64, f64
	.result 	i32
# %bb.0:                                # %entry
	f64.sub 	$1=, $0, $1
	block   	
	f64.const	$push0=, 0x0p0
	f64.ne  	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %lor.end
	i32.const	$push5=, 1
	return  	$pop5
.LBB7_2:                                # %lor.rhs
	end_block                       # label1:
	f64.div 	$push2=, $0, $1
	f64.const	$push3=, 0x1.6bcc41e9p46
	f64.gt  	$push4=, $pop2, $pop3
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end7:
	.size	dnear, .Lfunc_end7-dnear
                                        # -- End function
	.section	.text.ldnear,"ax",@progbits
	.hidden	ldnear                  # -- Begin function ldnear
	.globl	ldnear
	.type	ldnear,@function
ldnear:                                 # @ldnear
	.param  	i64, i64, i64, i64
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push11=, 0
	i32.load	$push10=, __stack_pointer($pop11)
	i32.const	$push12=, 32
	i32.sub 	$5=, $pop10, $pop12
	i32.const	$push13=, 0
	i32.store	__stack_pointer($pop13), $5
	i32.const	$push17=, 16
	i32.add 	$push18=, $5, $pop17
	call    	__subtf3@FUNCTION, $pop18, $0, $1, $2, $3
	i32.const	$push19=, 16
	i32.add 	$push20=, $5, $pop19
	i32.const	$push22=, 8
	i32.add 	$push0=, $pop20, $pop22
	i64.load	$2=, 0($pop0)
	i64.load	$3=, 16($5)
	i32.const	$4=, 1
	block   	
	i64.const	$push1=, 0
	i64.const	$push21=, 0
	i32.call	$push2=, __eqtf2@FUNCTION, $3, $2, $pop1, $pop21
	i32.eqz 	$push24=, $pop2
	br_if   	0, $pop24       # 0: down to label2
# %bb.1:                                # %lor.rhs
	call    	__divtf3@FUNCTION, $5, $0, $1, $3, $2
	i64.load	$push7=, 0($5)
	i32.const	$push23=, 8
	i32.add 	$push3=, $5, $pop23
	i64.load	$push4=, 0($pop3)
	i64.const	$push6=, 8070450532247928832
	i64.const	$push5=, 4641306360700491489
	i32.call	$push8=, __gttf2@FUNCTION, $pop7, $pop4, $pop6, $pop5
	i32.const	$push9=, 0
	i32.gt_s	$4=, $pop8, $pop9
.LBB8_2:                                # %lor.end
	end_block                       # label2:
	i32.const	$push16=, 0
	i32.const	$push14=, 32
	i32.add 	$push15=, $5, $pop14
	i32.store	__stack_pointer($pop16), $pop15
	copy_local	$push25=, $4
                                        # fallthrough-return: $pop25
	.endfunc
.Lfunc_end8:
	.size	ldnear, .Lfunc_end8-ldnear
                                        # -- End function
	.section	.text.test_integer_to_float,"ax",@progbits
	.hidden	test_integer_to_float   # -- Begin function test_integer_to_float
	.globl	test_integer_to_float
	.type	test_integer_to_float,@function
test_integer_to_float:                  # @test_integer_to_float
	.result 	i32
	.local  	i32
# %bb.0:                                # %if.end103
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end9:
	.size	test_integer_to_float, .Lfunc_end9-test_integer_to_float
                                        # -- End function
	.section	.text.ull2f,"ax",@progbits
	.hidden	ull2f                   # -- Begin function ull2f
	.globl	ull2f
	.type	ull2f,@function
ull2f:                                  # @ull2f
	.param  	i64
	.result 	f32
# %bb.0:                                # %entry
	f32.convert_u/i64	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end10:
	.size	ull2f, .Lfunc_end10-ull2f
                                        # -- End function
	.section	.text.ull2d,"ax",@progbits
	.hidden	ull2d                   # -- Begin function ull2d
	.globl	ull2d
	.type	ull2d,@function
ull2d:                                  # @ull2d
	.param  	i64
	.result 	f64
# %bb.0:                                # %entry
	f64.convert_u/i64	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end11:
	.size	ull2d, .Lfunc_end11-ull2d
                                        # -- End function
	.section	.text.ull2ld,"ax",@progbits
	.hidden	ull2ld                  # -- Begin function ull2ld
	.globl	ull2ld
	.type	ull2ld,@function
ull2ld:                                 # @ull2ld
	.param  	i32, i64
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$2=, $pop4, $pop6
	i32.const	$push7=, 0
	i32.store	__stack_pointer($pop7), $2
	call    	__floatunditf@FUNCTION, $2, $1
	i32.const	$push0=, 8
	i32.add 	$push1=, $2, $pop0
	i64.load	$push2=, 0($pop1)
	i64.store	8($0), $pop2
	i64.load	$push3=, 0($2)
	i64.store	0($0), $pop3
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $2, $pop8
	i32.store	__stack_pointer($pop10), $pop9
                                        # fallthrough-return
	.endfunc
.Lfunc_end12:
	.size	ull2ld, .Lfunc_end12-ull2ld
                                        # -- End function
	.section	.text.sll2f,"ax",@progbits
	.hidden	sll2f                   # -- Begin function sll2f
	.globl	sll2f
	.type	sll2f,@function
sll2f:                                  # @sll2f
	.param  	i64
	.result 	f32
# %bb.0:                                # %entry
	f32.convert_s/i64	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end13:
	.size	sll2f, .Lfunc_end13-sll2f
                                        # -- End function
	.section	.text.sll2d,"ax",@progbits
	.hidden	sll2d                   # -- Begin function sll2d
	.globl	sll2d
	.type	sll2d,@function
sll2d:                                  # @sll2d
	.param  	i64
	.result 	f64
# %bb.0:                                # %entry
	f64.convert_s/i64	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end14:
	.size	sll2d, .Lfunc_end14-sll2d
                                        # -- End function
	.section	.text.sll2ld,"ax",@progbits
	.hidden	sll2ld                  # -- Begin function sll2ld
	.globl	sll2ld
	.type	sll2ld,@function
sll2ld:                                 # @sll2ld
	.param  	i32, i64
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$2=, $pop4, $pop6
	i32.const	$push7=, 0
	i32.store	__stack_pointer($pop7), $2
	call    	__floatditf@FUNCTION, $2, $1
	i32.const	$push0=, 8
	i32.add 	$push1=, $2, $pop0
	i64.load	$push2=, 0($pop1)
	i64.store	8($0), $pop2
	i64.load	$push3=, 0($2)
	i64.store	0($0), $pop3
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $2, $pop8
	i32.store	__stack_pointer($pop10), $pop9
                                        # fallthrough-return
	.endfunc
.Lfunc_end15:
	.size	sll2ld, .Lfunc_end15-sll2ld
                                        # -- End function
	.section	.text.test_longlong_integer_to_float,"ax",@progbits
	.hidden	test_longlong_integer_to_float # -- Begin function test_longlong_integer_to_float
	.globl	test_longlong_integer_to_float
	.type	test_longlong_integer_to_float,@function
test_longlong_integer_to_float:         # @test_longlong_integer_to_float
	.result 	i32
	.local  	i32
# %bb.0:                                # %if.end96
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end16:
	.size	test_longlong_integer_to_float, .Lfunc_end16-test_longlong_integer_to_float
                                        # -- End function
	.section	.text.f2u,"ax",@progbits
	.hidden	f2u                     # -- Begin function f2u
	.globl	f2u
	.type	f2u,@function
f2u:                                    # @f2u
	.param  	f32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	f32.const	$push0=, 0x1p32
	f32.lt  	$push1=, $0, $pop0
	f32.const	$push2=, 0x0p0
	f32.ge  	$push3=, $0, $pop2
	i32.and 	$push4=, $pop1, $pop3
	br_if   	0, $pop4        # 0: down to label3
# %bb.1:                                # %entry
	i32.const	$push5=, 0
	return  	$pop5
.LBB17_2:                               # %entry
	end_block                       # label3:
	i32.trunc_u/f32	$push6=, $0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end17:
	.size	f2u, .Lfunc_end17-f2u
                                        # -- End function
	.section	.text.d2u,"ax",@progbits
	.hidden	d2u                     # -- Begin function d2u
	.globl	d2u
	.type	d2u,@function
d2u:                                    # @d2u
	.param  	f64
	.result 	i32
# %bb.0:                                # %entry
	block   	
	f64.const	$push0=, 0x1p32
	f64.lt  	$push1=, $0, $pop0
	f64.const	$push2=, 0x0p0
	f64.ge  	$push3=, $0, $pop2
	i32.and 	$push4=, $pop1, $pop3
	br_if   	0, $pop4        # 0: down to label4
# %bb.1:                                # %entry
	i32.const	$push5=, 0
	return  	$pop5
.LBB18_2:                               # %entry
	end_block                       # label4:
	i32.trunc_u/f64	$push6=, $0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end18:
	.size	d2u, .Lfunc_end18-d2u
                                        # -- End function
	.section	.text.ld2u,"ax",@progbits
	.hidden	ld2u                    # -- Begin function ld2u
	.globl	ld2u
	.type	ld2u,@function
ld2u:                                   # @ld2u
	.param  	i64, i64
	.result 	i32
# %bb.0:                                # %entry
	i32.call	$push0=, __fixunstfsi@FUNCTION, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end19:
	.size	ld2u, .Lfunc_end19-ld2u
                                        # -- End function
	.section	.text.f2s,"ax",@progbits
	.hidden	f2s                     # -- Begin function f2s
	.globl	f2s
	.type	f2s,@function
f2s:                                    # @f2s
	.param  	f32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	f32.abs 	$push0=, $0
	f32.const	$push1=, 0x1p31
	f32.lt  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label5
# %bb.1:                                # %entry
	i32.const	$push3=, -2147483648
	return  	$pop3
.LBB20_2:                               # %entry
	end_block                       # label5:
	i32.trunc_s/f32	$push4=, $0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end20:
	.size	f2s, .Lfunc_end20-f2s
                                        # -- End function
	.section	.text.d2s,"ax",@progbits
	.hidden	d2s                     # -- Begin function d2s
	.globl	d2s
	.type	d2s,@function
d2s:                                    # @d2s
	.param  	f64
	.result 	i32
# %bb.0:                                # %entry
	block   	
	f64.abs 	$push0=, $0
	f64.const	$push1=, 0x1p31
	f64.lt  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label6
# %bb.1:                                # %entry
	i32.const	$push3=, -2147483648
	return  	$pop3
.LBB21_2:                               # %entry
	end_block                       # label6:
	i32.trunc_s/f64	$push4=, $0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end21:
	.size	d2s, .Lfunc_end21-d2s
                                        # -- End function
	.section	.text.ld2s,"ax",@progbits
	.hidden	ld2s                    # -- Begin function ld2s
	.globl	ld2s
	.type	ld2s,@function
ld2s:                                   # @ld2s
	.param  	i64, i64
	.result 	i32
# %bb.0:                                # %entry
	i32.call	$push0=, __fixtfsi@FUNCTION, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end22:
	.size	ld2s, .Lfunc_end22-ld2s
                                        # -- End function
	.section	.text.test_float_to_integer,"ax",@progbits
	.hidden	test_float_to_integer   # -- Begin function test_float_to_integer
	.globl	test_float_to_integer
	.type	test_float_to_integer,@function
test_float_to_integer:                  # @test_float_to_integer
	.result 	i32
	.local  	i32
# %bb.0:                                # %if.end182
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end23:
	.size	test_float_to_integer, .Lfunc_end23-test_float_to_integer
                                        # -- End function
	.section	.text.f2ull,"ax",@progbits
	.hidden	f2ull                   # -- Begin function f2ull
	.globl	f2ull
	.type	f2ull,@function
f2ull:                                  # @f2ull
	.param  	f32
	.result 	i64
# %bb.0:                                # %entry
	block   	
	f32.const	$push0=, 0x1p64
	f32.lt  	$push1=, $0, $pop0
	f32.const	$push2=, 0x0p0
	f32.ge  	$push3=, $0, $pop2
	i32.and 	$push4=, $pop1, $pop3
	br_if   	0, $pop4        # 0: down to label7
# %bb.1:                                # %entry
	i64.const	$push5=, 0
	return  	$pop5
.LBB24_2:                               # %entry
	end_block                       # label7:
	i64.trunc_u/f32	$push6=, $0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end24:
	.size	f2ull, .Lfunc_end24-f2ull
                                        # -- End function
	.section	.text.d2ull,"ax",@progbits
	.hidden	d2ull                   # -- Begin function d2ull
	.globl	d2ull
	.type	d2ull,@function
d2ull:                                  # @d2ull
	.param  	f64
	.result 	i64
# %bb.0:                                # %entry
	block   	
	f64.const	$push0=, 0x1p64
	f64.lt  	$push1=, $0, $pop0
	f64.const	$push2=, 0x0p0
	f64.ge  	$push3=, $0, $pop2
	i32.and 	$push4=, $pop1, $pop3
	br_if   	0, $pop4        # 0: down to label8
# %bb.1:                                # %entry
	i64.const	$push5=, 0
	return  	$pop5
.LBB25_2:                               # %entry
	end_block                       # label8:
	i64.trunc_u/f64	$push6=, $0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end25:
	.size	d2ull, .Lfunc_end25-d2ull
                                        # -- End function
	.section	.text.ld2ull,"ax",@progbits
	.hidden	ld2ull                  # -- Begin function ld2ull
	.globl	ld2ull
	.type	ld2ull,@function
ld2ull:                                 # @ld2ull
	.param  	i64, i64
	.result 	i64
# %bb.0:                                # %entry
	i64.call	$push0=, __fixunstfdi@FUNCTION, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end26:
	.size	ld2ull, .Lfunc_end26-ld2ull
                                        # -- End function
	.section	.text.f2sll,"ax",@progbits
	.hidden	f2sll                   # -- Begin function f2sll
	.globl	f2sll
	.type	f2sll,@function
f2sll:                                  # @f2sll
	.param  	f32
	.result 	i64
# %bb.0:                                # %entry
	block   	
	f32.abs 	$push0=, $0
	f32.const	$push1=, 0x1p63
	f32.lt  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label9
# %bb.1:                                # %entry
	i64.const	$push3=, -9223372036854775808
	return  	$pop3
.LBB27_2:                               # %entry
	end_block                       # label9:
	i64.trunc_s/f32	$push4=, $0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end27:
	.size	f2sll, .Lfunc_end27-f2sll
                                        # -- End function
	.section	.text.d2sll,"ax",@progbits
	.hidden	d2sll                   # -- Begin function d2sll
	.globl	d2sll
	.type	d2sll,@function
d2sll:                                  # @d2sll
	.param  	f64
	.result 	i64
# %bb.0:                                # %entry
	block   	
	f64.abs 	$push0=, $0
	f64.const	$push1=, 0x1p63
	f64.lt  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label10
# %bb.1:                                # %entry
	i64.const	$push3=, -9223372036854775808
	return  	$pop3
.LBB28_2:                               # %entry
	end_block                       # label10:
	i64.trunc_s/f64	$push4=, $0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end28:
	.size	d2sll, .Lfunc_end28-d2sll
                                        # -- End function
	.section	.text.ld2sll,"ax",@progbits
	.hidden	ld2sll                  # -- Begin function ld2sll
	.globl	ld2sll
	.type	ld2sll,@function
ld2sll:                                 # @ld2sll
	.param  	i64, i64
	.result 	i64
# %bb.0:                                # %entry
	i64.call	$push0=, __fixtfdi@FUNCTION, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end29:
	.size	ld2sll, .Lfunc_end29-ld2sll
                                        # -- End function
	.section	.text.test_float_to_longlong_integer,"ax",@progbits
	.hidden	test_float_to_longlong_integer # -- Begin function test_float_to_longlong_integer
	.globl	test_float_to_longlong_integer
	.type	test_float_to_longlong_integer,@function
test_float_to_longlong_integer:         # @test_float_to_longlong_integer
	.result 	i32
	.local  	i32
# %bb.0:                                # %if.end172
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end30:
	.size	test_float_to_longlong_integer, .Lfunc_end30-test_float_to_longlong_integer
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end31:
	.size	main, .Lfunc_end31-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
