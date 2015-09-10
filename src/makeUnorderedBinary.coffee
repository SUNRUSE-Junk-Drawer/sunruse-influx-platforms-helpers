module.exports = (name, inputType, outputType, forConstants, generateCode) ->
	instance = 
		name: name
		output: outputType
		compile: (value) ->
			if not value.properties then return null
			if not value.properties.a or not value.properties.b then return null
			if not module.exports.toolchain.valueIsPrimitive value.properties.a, inputType then return null
			if not module.exports.toolchain.valueIsPrimitive value.properties.b, inputType then return null
			if value.properties.a.primitive and value.properties.b.primitive
				return unused =
					score: value.properties.a.score + value.properties.b.score + 1
					primitive:
						type: outputType
						value: forConstants value.properties.a.primitive.value, value.properties.b.primitive.value
			else
				return unused = 
					score: value.properties.a.score + value.properties.b.score + 1
					native:
						function: instance
						input: 
							score: value.properties.a.score + value.properties.b.score
							properties:
								a: value.properties.a
								b: value.properties.b
		inputsEqual: (platform, a, b) ->
			((module.exports.toolchain.valuesEquivalent platform, a.properties.a, b.properties.a) and (module.exports.toolchain.valuesEquivalent platform, a.properties.b, b.properties.b)) or ((module.exports.toolchain.valuesEquivalent platform, a.properties.a, b.properties.b) and (module.exports.toolchain.valuesEquivalent platform, a.properties.b, b.properties.a))
		generateCode: generateCode
module.exports.toolchain = require "sunruse-influx-toolchain"