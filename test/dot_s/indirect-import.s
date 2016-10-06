	.text
	.file	"test/dot_s/indirect-import.ll"
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 32
	i32.sub 	$push19=, $pop11, $pop12
	tee_local	$push18=, $1=, $pop19
	i32.store	__stack_pointer($pop13), $pop18
	i32.const	$push0=, extern_fd@FUNCTION
	i32.store	28($1), $pop0
	i32.const	$push1=, extern_vj@FUNCTION
	i32.store	24($1), $pop1
	i64.const	$push2=, 1
	call    	extern_vj@FUNCTION, $pop2
	i32.const	$push3=, extern_v@FUNCTION
	i32.store	20($1), $pop3
	call    	extern_v@FUNCTION
	i32.const	$push4=, extern_ijidf@FUNCTION
	i32.store	16($1), $pop4
	i64.const	$push17=, 1
	i32.const	$push7=, 2
	f64.const	$push6=, 0x1.8p1
	f32.const	$push5=, 0x1p2
	i32.call	$drop=, extern_ijidf@FUNCTION, $pop17, $pop7, $pop6, $pop5
	i32.const	$push8=, extern_struct@FUNCTION
	i32.store	12($1), $pop8
	i32.const	$push9=, extern_sret@FUNCTION
	i32.store	8($1), $pop9
	i32.load	$0=, 28($1)
	i32.const	$push16=, 0
	i32.const	$push14=, 32
	i32.add 	$push15=, $1, $pop14
	i32.store	__stack_pointer($pop16), $pop15
	copy_local	$push20=, $0
                                        # fallthrough-return: $pop20
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.hidden	baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, extern_v@FUNCTION
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	baz, .Lfunc_end1-baz


	.ident	"clang version 4.0.0 (trunk 281345) (llvm/trunk 281343)"
	.functype	extern_fd, f32, f64
	.functype	extern_vj, void, i64
	.functype	extern_v, void
	.functype	extern_ijidf, i32, i64, i32, f64, f32
	.functype	extern_struct, void, i32
	.functype	extern_sret, void, i32
