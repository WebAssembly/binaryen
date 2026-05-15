// # Preprocess # //
import Binaryen from "#binaryen-raw";



/** The main object provided by Emscripten. This is what gets wrapped. It is not exposed to the consumer. */
export const BinaryenObj = await Binaryen();



export const {
	_free,
	_malloc,
	HEAP8,
	HEAPU8,
	HEAP32,
	HEAPU32,
	UTF8ToString,
	getExceptionMessage,
	stackAlloc,
	stackRestore,
	stackSave,
	stringToAscii,
	stringToUTF8OnStack,
} = BinaryenObj;
