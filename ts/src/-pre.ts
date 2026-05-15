// # Preprocess # //
import Binaryen from "#binaryen-raw";



/** The main object provided by Emscripten. This is what gets wrapped. It is not exposed to the consumer. */
export const BinaryenObj = await Binaryen();



export const {
	_malloc,
	_free,
	out,
	err,
	HEAP8,
	HEAPU8,
	HEAP32,
	HEAPU32,
	stackSave,
	stackRestore,
	stackAlloc,
	UTF8ToString,
	stringToAscii,
	stringToUTF8OnStack,
	getExceptionMessage,
} = BinaryenObj;
