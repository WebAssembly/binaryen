// # Preprocess # //
import Binaryen from "#binaryen-raw";



/** The main object provided by Emscripten. This is what gets wrapped. It is not exposed to the consumer. */
export const BinaryenObj = await Binaryen({
	// eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
	print: (...args: readonly any[]): void => console?.log?.(...args),
	// eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
	printWarn: (...args: readonly any[]): void => (console?.warn ?? console?.log)?.(...args),
	// eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
	printErr: (...args: readonly any[]): void => (console?.error ?? console?.log)?.(...args),
});



export const {
	_malloc,
	_free,
	out,
	err,
	stackSave,
	stackRestore,
	stackAlloc,
	UTF8ToString,
	stringToAscii,
	stringToUTF8OnStack,
	getExceptionMessage,
} = BinaryenObj;
