// # Library # //
// Project-agnostic library artifacts for TypeScript development.



/** @deprecated use `BinaryenObj.printWarn`. */
export function consoleWarn(...args: any[]): void {
	// eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
	return (console?.warn ?? console?.log)?.call(undefined, ...args);
}



/**
 * Mark a method as deprecated by logging a warning in the console.
 * @example
 * class Module {
 * 	\@replacedBy("`this.global.addExport`")
 * 	addGlobalExport(...args) {
 * 		return this.global.addExport(...args);
 * 	}
 * }
 *
 * @param replacement the name or signature of the new method replacing the deprecated one
 * @returns a method decorator
 */
export function replacedBy<This, Params extends unknown[], Return>(replacement: string = ""): (
	method: (this: This, ...args: Params) => Return,
	context: ClassMethodDecoratorContext<This, typeof method>,
) => (typeof method) | void {
	return (method, context) => function (...args) {
		const message = `WARNING: ${ context.static ? "Static" : "Instance" } method \`${ String(context.name) }\` is deprecated${ replacement && `; use ${ replacement } instead` }.`;
		consoleWarn(message);
		return method.call(this, ...args);
	};
}
