import eslint from "@eslint/js";
import stylistic from "@stylistic/eslint-plugin";
import globals from "globals";
import tseslint from "typescript-eslint";



export default [
	{ignores: ["./build/", "./dist/", "./docs/"]},

	eslint.configs.recommended, // https://github.com/eslint/eslint/blob/v10.2.1/packages/js/src/configs/eslint-recommended.js
	{
		name: "All", // all JS and TS files
		files: ["./{eslint,typedoc}.config.js", "./{src,test}/**/*.{js,ts}"],
		languageOptions: {globals: {...globals.node}},
		linterOptions: {reportUnusedDisableDirectives: "error"},
		plugins: {"@stylistic": stylistic},

		rules: {
			/* # File Conventions (should be consistent with `/.editorconfig` file) */
			"@stylistic/eol-last": "error",
			"@stylistic/linebreak-style": "error",
			"@stylistic/no-trailing-spaces": "error",

			/* # Layout & Formatting */
			/* ## Indentation, Spacing, and Alignment */
			"@stylistic/arrow-spacing": "error",
			"@stylistic/block-spacing": "error",
			"@stylistic/comma-spacing": "error",
			"@stylistic/dot-location": ["error", "property"],
			"@stylistic/function-call-spacing": "error",
			"@stylistic/indent": ["error", "tab", {
				SwitchCase: 1,
				flatTernaryExpressions: true,
			}],
			"@stylistic/key-spacing": "error",
			"@stylistic/keyword-spacing": "error",
			"@stylistic/no-mixed-spaces-and-tabs": "error",
			"@stylistic/semi-spacing": "error",
			"@stylistic/space-before-blocks": "error",
			"@stylistic/space-before-function-paren": ["error", {named: "never"}],
			"@stylistic/space-infix-ops": "error",
			"@stylistic/space-unary-ops": "error",
			"@stylistic/spaced-comment": "error",
			"@stylistic/type-annotation-spacing": "error",

			/* ## Grouping Structure Style */
			"@stylistic/array-bracket-newline": ["error", "consistent"],
			"@stylistic/array-bracket-spacing": "error",
			"@stylistic/array-element-newline": ["error", "consistent"],
			"arrow-body-style": "error",
			"@stylistic/brace-style": ["error", "1tbs", {allowSingleLine: true}],
			"@stylistic/computed-property-spacing": "error",
			curly: "error",
			"@stylistic/function-call-argument-newline": ["error", "consistent"],
			"@stylistic/function-paren-newline": "error",
			"func-style": ["error", "declaration", {allowArrowFunctions: true}],
			"@stylistic/lines-between-class-members": ["error", "always", {exceptAfterSingleLine: true}],
			"@stylistic/member-delimiter-style": ["error", {
				overrides: {
					interface: {singleline: {requireLast: true}},
					typeLiteral: {
						multiline: {delimiter: "comma"},
						singleline: {delimiter: "comma"},
					},
				},
			}],
			"no-useless-computed-key": "error",
			"@stylistic/object-curly-newline": ["error", {
				ObjectExpression: {multiline: true},
				ObjectPattern: {multiline: true},
				ImportDeclaration: "always",
				ExportDeclaration: {multiline: true},
				TSTypeLiteral: {multiline: true},
				TSInterfaceBody: "always",
				TSEnumBody: "always",
			}],
			"@stylistic/object-curly-spacing": "error",
			"@stylistic/object-property-newline": ["error", {allowAllPropertiesOnSameLine: true}],
			"object-shorthand": ["error", "properties", {avoidQuotes: true}],
			"@stylistic/padded-blocks": ["error", "never"],
			"@stylistic/quote-props": ["error", "as-needed"],
			"@stylistic/space-in-parens": "error",

			/* ## Operator Style */
			"@stylistic/arrow-parens": "error",
			"@stylistic/comma-dangle": ["error", "always-multiline"],
			"@stylistic/comma-style": "error",
			"dot-notation": "error",
			"@stylistic/implicit-arrow-linebreak": "error",
			"@stylistic/new-parens": "error",
			"@stylistic/quotes": "error",
			"@stylistic/semi": "error",
			"@stylistic/semi-style": "error",
			"@stylistic/wrap-iife": ["error", "inside", {functionPrototypeMethods: true}],

			/* # Best Practices */
			/* ## Preferred Operators & Methods */
			eqeqeq: "error",
			"no-lonely-if": "error",
			"no-unneeded-ternary": ["error", {defaultAssignment: false}],
			"no-useless-concat": "error",
			"operator-assignment": "error",
			"prefer-object-spread": "error",
			"prefer-template": "error",

			/* ## Variable Declarations */
			"init-declarations": "error",
			"no-shadow": "error",
			"no-use-before-define": "error",
			"one-var": ["error", "never"],
			"prefer-const": "error",

			/* ## Function & Module Design */
			"default-param-last": "error",
			"func-names": ["error", "never"],
			"prefer-arrow-callback": ["error", {allowUnboundThis: false}],
		},
	},
	{
		...tseslint.configs.eslintRecommended, // https://github.com/typescript-eslint/typescript-eslint/blob/v8.59.1/packages/eslint-plugin/src/configs/flat/eslint-recommended.ts
		files: ["./{src,test}/**/*.ts"],
	},
	{
		name: "TypeScript Only", // rules that break on JS files, and rules that need TSConfig to work
		files: ["./{src,test}/**/*.ts"],
		languageOptions: {
			globals: {...globals.node},
			parser: tseslint.parser,
			parserOptions: {project: ["./tsconfig.json", "./test/tsconfig.json"]},
		},
		plugins: {"@typescript-eslint": tseslint.plugin},

		rules: {
			"@typescript-eslint/ban-ts-comment": ["error", {"ts-expect-error": false}],

			/* # Layout & Formatting */
			/* ## Operator Style */
			"@typescript-eslint/array-type": ["error", {
				default: "array-simple",
				readonly: "array",
			}],
			"dot-notation": "off",
			"@typescript-eslint/dot-notation": "error",
			"@typescript-eslint/no-unnecessary-condition": "error",

			/* # Best Practices */
			/* ## Variable Declarations */
			"init-declarations": "off",
			"@typescript-eslint/init-declarations": "error",
			"no-shadow": "off",
			"@typescript-eslint/no-shadow": "error",
			"no-unused-vars": "off",
			"@typescript-eslint/no-unused-vars": ["error", {
				argsIgnorePattern: "^_",
				destructuredArrayIgnorePattern: "^_",
				ignoreRestSiblings: true,
				reportUsedIgnorePattern: true,
			}],
			"no-use-before-define": "off",
			"@typescript-eslint/no-use-before-define": "error",

			/* ## Function & Module Design */
			"@typescript-eslint/consistent-type-imports": "error",
			"default-param-last": "off",
			"@typescript-eslint/default-param-last": "error",
			"@typescript-eslint/no-import-type-side-effects": "error",

			/* ## Strictness */
			"@typescript-eslint/explicit-member-accessibility": ["error", {accessibility: "no-public"}],
			"@typescript-eslint/no-deprecated": "warn",
			"@typescript-eslint/prefer-readonly": "error",
		},
	},
];
