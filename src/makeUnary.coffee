module.exports = (name, inputType, outputType, forConstants, generateCode) ->
	instance = 
		name: name
		output: outputType
		compile: (value) ->
			if not module.exports.toolchain.valueIsPrimitive value, inputType then return null
			if value.primitive
				return unused =
					score: value.score + 1
					primitive:
						type: outputType
						value: forConstants value.primitive.value
			else
				return unused = 
					score: value.score + 1
					native:
						function: instance
						input: value
		inputsEqual: (platform, a, b) ->
			module.exports.toolchain.valuesEquivalent platform, a, b
		generateCode: generateCode
module.exports.toolchain = require "sunruse-influx-toolchain"