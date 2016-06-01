	.text
	.file	"indirect-import.ll"
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
	i32.const	$push12=, 16
	i32.sub 	$push17=, $pop11, $pop12
	i32.store	$push20=, __stack_pointer($pop13), $pop17
	tee_local	$push19=, $0=, $pop20
	i32.const	$push0=, extern_fd@FUNCTION
	i32.store	$drop=, 12($pop19), $pop0
	f64.const	$push1=, 0x0p0
	f32.call	$drop=, extern_fd@FUNCTION, $pop1
	f64.const	$push2=, 0x1p0
	f32.call	$drop=, extern_fd@FUNCTION, $pop2
	i32.const	$push3=, extern_vj@FUNCTION
	i32.store	$drop=, 8($0), $pop3
	i64.const	$push4=, 1
	call    	extern_vj@FUNCTION, $pop4
	i32.const	$push5=, extern_v@FUNCTION
	i32.store	$drop=, 4($0), $pop5
	call    	extern_v@FUNCTION
	i32.const	$push6=, extern_ijidf@FUNCTION
	i32.store	$drop=, 0($0), $pop6
	i64.const	$push18=, 1
	i32.const	$push9=, 2
	f64.const	$push8=, 0x1.8p1
	f32.const	$push7=, 0x1p2
	i32.call	$drop=, extern_ijidf@FUNCTION, $pop18, $pop9, $pop8, $pop7
	i32.load	$1=, 12($0)
	i32.const	$push16=, 0
	i32.const	$push14=, 16
	i32.add 	$push15=, $0, $pop14
	i32.store	$drop=, __stack_pointer($pop16), $pop15
	copy_local	$push21=, $1
                                        # fallthrough-return: $pop21
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar


	.ident	"clang version 3.9.0 (trunk 271042) (llvm/trunk 271045)"
	.functype	extern_fd, f32, f64
	.functype	extern_vj, void, i64
	.functype	extern_v, void
	.functype	extern_ijidf, i32, i64, i32, f64, f32
