	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/conversion.c"
	.section	.text.u2f,"ax",@progbits
	.hidden	u2f
	.globl	u2f
	.type	u2f,@function
u2f:                                    # @u2f
	.param  	i32
	.result 	f32
# BB#0:                                 # %entry
	f32.convert_u/i32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	u2f, .Lfunc_end0-u2f

	.section	.text.u2d,"ax",@progbits
	.hidden	u2d
	.globl	u2d
	.type	u2d,@function
u2d:                                    # @u2d
	.param  	i32
	.result 	f64
# BB#0:                                 # %entry
	f64.convert_u/i32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	u2d, .Lfunc_end1-u2d

	.section	.text.u2ld,"ax",@progbits
	.hidden	u2ld
	.globl	u2ld
	.type	u2ld,@function
u2ld:                                   # @u2ld
	.param  	i32, i32
	.local  	i64, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	call    	__floatunsitf@FUNCTION, $6, $1
	i64.load	$2=, 0($6)
	i32.const	$push0=, 8
	i32.add 	$push3=, $0, $pop0
	i32.const	$push4=, 8
	i32.add 	$push1=, $6, $pop4
	i64.load	$push2=, 0($pop1)
	i64.store	$discard=, 0($pop3), $pop2
	i64.store	$discard=, 0($0):p2align=4, $2
	i32.const	$5=, 16
	i32.add 	$6=, $6, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return
	.endfunc
.Lfunc_end2:
	.size	u2ld, .Lfunc_end2-u2ld

	.section	.text.s2f,"ax",@progbits
	.hidden	s2f
	.globl	s2f
	.type	s2f,@function
s2f:                                    # @s2f
	.param  	i32
	.result 	f32
# BB#0:                                 # %entry
	f32.convert_s/i32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	s2f, .Lfunc_end3-s2f

	.section	.text.s2d,"ax",@progbits
	.hidden	s2d
	.globl	s2d
	.type	s2d,@function
s2d:                                    # @s2d
	.param  	i32
	.result 	f64
# BB#0:                                 # %entry
	f64.convert_s/i32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end4:
	.size	s2d, .Lfunc_end4-s2d

	.section	.text.s2ld,"ax",@progbits
	.hidden	s2ld
	.globl	s2ld
	.type	s2ld,@function
s2ld:                                   # @s2ld
	.param  	i32, i32
	.local  	i64, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
	call    	__floatsitf@FUNCTION, $6, $1
	i64.load	$2=, 0($6)
	i32.const	$push0=, 8
	i32.add 	$push3=, $0, $pop0
	i32.const	$push4=, 8
	i32.add 	$push1=, $6, $pop4
	i64.load	$push2=, 0($pop1)
	i64.store	$discard=, 0($pop3), $pop2
	i64.store	$discard=, 0($0):p2align=4, $2
	i32.const	$5=, 16
	i32.add 	$6=, $6, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
	return
	.endfunc
.Lfunc_end5:
	.size	s2ld, .Lfunc_end5-s2ld

	.section	.text.fnear,"ax",@progbits
	.hidden	fnear
	.globl	fnear
	.type	fnear,@function
fnear:                                  # @fnear
	.param  	f32, f32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 1
	block
	f32.sub 	$push5=, $0, $1
	tee_local	$push4=, $1=, $pop5
	f32.const	$push0=, 0x0p0
	f32.eq  	$push1=, $pop4, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %lor.rhs
	f32.div 	$push2=, $0, $1
	f32.const	$push3=, 0x1.e848p19
	f32.gt  	$2=, $pop2, $pop3
.LBB6_2:                                # %lor.end
	end_block                       # label0:
	return  	$2
	.endfunc
.Lfunc_end6:
	.size	fnear, .Lfunc_end6-fnear

	.section	.text.dnear,"ax",@progbits
	.hidden	dnear
	.globl	dnear
	.type	dnear,@function
dnear:                                  # @dnear
	.param  	f64, f64
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 1
	block
	f64.sub 	$push5=, $0, $1
	tee_local	$push4=, $1=, $pop5
	f64.const	$push0=, 0x0p0
	f64.eq  	$push1=, $pop4, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %lor.rhs
	f64.div 	$push2=, $0, $1
	f64.const	$push3=, 0x1.6bcc41e9p46
	f64.gt  	$2=, $pop2, $pop3
.LBB7_2:                                # %lor.end
	end_block                       # label1:
	return  	$2
	.endfunc
.Lfunc_end7:
	.size	dnear, .Lfunc_end7-dnear

	.section	.text.ldnear,"ax",@progbits
	.hidden	ldnear
	.globl	ldnear
	.type	ldnear,@function
ldnear:                                 # @ldnear
	.param  	i64, i64, i64, i64
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 32
	i32.sub 	$10=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$10=, 0($6), $10
	i32.const	$8=, 16
	i32.add 	$8=, $10, $8
	call    	__subtf3@FUNCTION, $8, $0, $1, $2, $3
	i32.const	$4=, 1
	i64.load	$push15=, 16($10)
	tee_local	$push14=, $3=, $pop15
	i32.const	$push13=, 8
	i32.const	$9=, 16
	i32.add 	$9=, $10, $9
	block
	i32.add 	$push0=, $9, $pop13
	i64.load	$push12=, 0($pop0)
	tee_local	$push11=, $2=, $pop12
	i64.const	$push1=, 0
	i64.const	$push10=, 0
	i32.call	$push2=, __eqtf2@FUNCTION, $pop14, $pop11, $pop1, $pop10
	i32.const	$push17=, 0
	i32.eq  	$push18=, $pop2, $pop17
	br_if   	0, $pop18       # 0: down to label2
# BB#1:                                 # %lor.rhs
	call    	__divtf3@FUNCTION, $10, $0, $1, $3, $2
	i64.load	$push5=, 0($10)
	i32.const	$push16=, 8
	i32.add 	$push3=, $10, $pop16
	i64.load	$push4=, 0($pop3)
	i64.const	$push7=, 8070450532247928832
	i64.const	$push6=, 4641306360700491489
	i32.call	$push8=, __gttf2@FUNCTION, $pop5, $pop4, $pop7, $pop6
	i32.const	$push9=, 0
	i32.gt_s	$4=, $pop8, $pop9
.LBB8_2:                                # %lor.end
	end_block                       # label2:
	i32.const	$7=, 32
	i32.add 	$10=, $10, $7
	i32.const	$7=, __stack_pointer
	i32.store	$10=, 0($7), $10
	return  	$4
	.endfunc
.Lfunc_end8:
	.size	ldnear, .Lfunc_end8-ldnear

	.section	.text.test_integer_to_float,"ax",@progbits
	.hidden	test_integer_to_float
	.globl	test_integer_to_float
	.type	test_integer_to_float,@function
test_integer_to_float:                  # @test_integer_to_float
	.result 	i32
	.local  	i32
# BB#0:                                 # %fnear.exit178
	return  	$0
	.endfunc
.Lfunc_end9:
	.size	test_integer_to_float, .Lfunc_end9-test_integer_to_float

	.section	.text.ull2f,"ax",@progbits
	.hidden	ull2f
	.globl	ull2f
	.type	ull2f,@function
ull2f:                                  # @ull2f
	.param  	i64
	.result 	f32
# BB#0:                                 # %entry
	f32.convert_u/i64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end10:
	.size	ull2f, .Lfunc_end10-ull2f

	.section	.text.ull2d,"ax",@progbits
	.hidden	ull2d
	.globl	ull2d
	.type	ull2d,@function
ull2d:                                  # @ull2d
	.param  	i64
	.result 	f64
# BB#0:                                 # %entry
	f64.convert_u/i64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end11:
	.size	ull2d, .Lfunc_end11-ull2d

	.section	.text.ull2ld,"ax",@progbits
	.hidden	ull2ld
	.globl	ull2ld
	.type	ull2ld,@function
ull2ld:                                 # @ull2ld
	.param  	i32, i64
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	call    	__floatunditf@FUNCTION, $5, $1
	i64.load	$1=, 0($5)
	i32.const	$push0=, 8
	i32.add 	$push3=, $0, $pop0
	i32.const	$push4=, 8
	i32.add 	$push1=, $5, $pop4
	i64.load	$push2=, 0($pop1)
	i64.store	$discard=, 0($pop3), $pop2
	i64.store	$discard=, 0($0):p2align=4, $1
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
	.endfunc
.Lfunc_end12:
	.size	ull2ld, .Lfunc_end12-ull2ld

	.section	.text.sll2f,"ax",@progbits
	.hidden	sll2f
	.globl	sll2f
	.type	sll2f,@function
sll2f:                                  # @sll2f
	.param  	i64
	.result 	f32
# BB#0:                                 # %entry
	f32.convert_s/i64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end13:
	.size	sll2f, .Lfunc_end13-sll2f

	.section	.text.sll2d,"ax",@progbits
	.hidden	sll2d
	.globl	sll2d
	.type	sll2d,@function
sll2d:                                  # @sll2d
	.param  	i64
	.result 	f64
# BB#0:                                 # %entry
	f64.convert_s/i64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end14:
	.size	sll2d, .Lfunc_end14-sll2d

	.section	.text.sll2ld,"ax",@progbits
	.hidden	sll2ld
	.globl	sll2ld
	.type	sll2ld,@function
sll2ld:                                 # @sll2ld
	.param  	i32, i64
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	call    	__floatditf@FUNCTION, $5, $1
	i64.load	$1=, 0($5)
	i32.const	$push0=, 8
	i32.add 	$push3=, $0, $pop0
	i32.const	$push4=, 8
	i32.add 	$push1=, $5, $pop4
	i64.load	$push2=, 0($pop1)
	i64.store	$discard=, 0($pop3), $pop2
	i64.store	$discard=, 0($0):p2align=4, $1
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
	.endfunc
.Lfunc_end15:
	.size	sll2ld, .Lfunc_end15-sll2ld

	.section	.text.test_longlong_integer_to_float,"ax",@progbits
	.hidden	test_longlong_integer_to_float
	.globl	test_longlong_integer_to_float
	.type	test_longlong_integer_to_float,@function
test_longlong_integer_to_float:         # @test_longlong_integer_to_float
	.result 	i32
	.local  	i32
# BB#0:                                 # %fnear.exit
	return  	$0
	.endfunc
.Lfunc_end16:
	.size	test_longlong_integer_to_float, .Lfunc_end16-test_longlong_integer_to_float

	.section	.text.f2u,"ax",@progbits
	.hidden	f2u
	.globl	f2u
	.type	f2u,@function
f2u:                                    # @f2u
	.param  	f32
	.result 	i32
# BB#0:                                 # %entry
	i32.trunc_u/f32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end17:
	.size	f2u, .Lfunc_end17-f2u

	.section	.text.d2u,"ax",@progbits
	.hidden	d2u
	.globl	d2u
	.type	d2u,@function
d2u:                                    # @d2u
	.param  	f64
	.result 	i32
# BB#0:                                 # %entry
	i32.trunc_u/f64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end18:
	.size	d2u, .Lfunc_end18-d2u

	.section	.text.ld2u,"ax",@progbits
	.hidden	ld2u
	.globl	ld2u
	.type	ld2u,@function
ld2u:                                   # @ld2u
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i32.call	$push0=, __fixunstfsi@FUNCTION, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end19:
	.size	ld2u, .Lfunc_end19-ld2u

	.section	.text.f2s,"ax",@progbits
	.hidden	f2s
	.globl	f2s
	.type	f2s,@function
f2s:                                    # @f2s
	.param  	f32
	.result 	i32
# BB#0:                                 # %entry
	i32.trunc_s/f32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end20:
	.size	f2s, .Lfunc_end20-f2s

	.section	.text.d2s,"ax",@progbits
	.hidden	d2s
	.globl	d2s
	.type	d2s,@function
d2s:                                    # @d2s
	.param  	f64
	.result 	i32
# BB#0:                                 # %entry
	i32.trunc_s/f64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end21:
	.size	d2s, .Lfunc_end21-d2s

	.section	.text.ld2s,"ax",@progbits
	.hidden	ld2s
	.globl	ld2s
	.type	ld2s,@function
ld2s:                                   # @ld2s
	.param  	i64, i64
	.result 	i32
# BB#0:                                 # %entry
	i32.call	$push0=, __fixtfsi@FUNCTION, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end22:
	.size	ld2s, .Lfunc_end22-ld2s

	.section	.text.test_float_to_integer,"ax",@progbits
	.hidden	test_float_to_integer
	.globl	test_float_to_integer
	.type	test_float_to_integer,@function
test_float_to_integer:                  # @test_float_to_integer
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end182
	return  	$0
	.endfunc
.Lfunc_end23:
	.size	test_float_to_integer, .Lfunc_end23-test_float_to_integer

	.section	.text.f2ull,"ax",@progbits
	.hidden	f2ull
	.globl	f2ull
	.type	f2ull,@function
f2ull:                                  # @f2ull
	.param  	f32
	.result 	i64
# BB#0:                                 # %entry
	i64.trunc_u/f32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end24:
	.size	f2ull, .Lfunc_end24-f2ull

	.section	.text.d2ull,"ax",@progbits
	.hidden	d2ull
	.globl	d2ull
	.type	d2ull,@function
d2ull:                                  # @d2ull
	.param  	f64
	.result 	i64
# BB#0:                                 # %entry
	i64.trunc_u/f64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end25:
	.size	d2ull, .Lfunc_end25-d2ull

	.section	.text.ld2ull,"ax",@progbits
	.hidden	ld2ull
	.globl	ld2ull
	.type	ld2ull,@function
ld2ull:                                 # @ld2ull
	.param  	i64, i64
	.result 	i64
# BB#0:                                 # %entry
	i64.call	$push0=, __fixunstfdi@FUNCTION, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end26:
	.size	ld2ull, .Lfunc_end26-ld2ull

	.section	.text.f2sll,"ax",@progbits
	.hidden	f2sll
	.globl	f2sll
	.type	f2sll,@function
f2sll:                                  # @f2sll
	.param  	f32
	.result 	i64
# BB#0:                                 # %entry
	i64.trunc_s/f32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end27:
	.size	f2sll, .Lfunc_end27-f2sll

	.section	.text.d2sll,"ax",@progbits
	.hidden	d2sll
	.globl	d2sll
	.type	d2sll,@function
d2sll:                                  # @d2sll
	.param  	f64
	.result 	i64
# BB#0:                                 # %entry
	i64.trunc_s/f64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end28:
	.size	d2sll, .Lfunc_end28-d2sll

	.section	.text.ld2sll,"ax",@progbits
	.hidden	ld2sll
	.globl	ld2sll
	.type	ld2sll,@function
ld2sll:                                 # @ld2sll
	.param  	i64, i64
	.result 	i64
# BB#0:                                 # %entry
	i64.call	$push0=, __fixtfdi@FUNCTION, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end29:
	.size	ld2sll, .Lfunc_end29-ld2sll

	.section	.text.test_float_to_longlong_integer,"ax",@progbits
	.hidden	test_float_to_longlong_integer
	.globl	test_float_to_longlong_integer
	.type	test_float_to_longlong_integer,@function
test_float_to_longlong_integer:         # @test_float_to_longlong_integer
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end172
	return  	$0
	.endfunc
.Lfunc_end30:
	.size	test_float_to_longlong_integer, .Lfunc_end30-test_float_to_longlong_integer

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end31:
	.size	main, .Lfunc_end31-main


	.ident	"clang version 3.9.0 "
