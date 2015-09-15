module.exports = (name, inputType, outputType, forConstants, generateCode, fieldNameA, fieldNameB) ->
	fieldNameA = fieldNameA or "a"
	fieldNameB = fieldNameB or "b"
	instance = 
		name: name
		output: outputType
		compile: (value) ->
			if not value.properties then return null
			if not value.properties[fieldNameA] or not value.properties[fieldNameB] then return null
			if not module.exports.toolchain.valueIsPrimitive value.properties[fieldNameA], inputType then return null
			if not module.exports.toolchain.valueIsPrimitive value.properties[fieldNameB, inputType then return null
			if value.properties[fieldNameA].primitive and value.properties[fieldNameB].primitive
				return unused =
					score: value.properties[fieldNameA].score + value.properties[fieldNameB].score + 1
					primitive:
						type: outputType
						value: forConstants value.properties[fieldNameA].primitive.value, value.properties[fieldNameB].primitive.value
			else
				properties = {}
				properties[fieldNameA] = value.properties[fieldNameA]
				properties[fieldNameB] = value.properties[fieldNameB]
				return unused = 
					score: value.properties[fieldNameA].score + value.properties[fieldNameB].score + 1
					native:
						function: instance
						input: 
							score: value.properties[fieldNameA].score + value.properties[fieldNameB].score
							properties: properties
		inputsEqual: (platform, a, b) ->
			(module.exports.toolchain.valuesEquivalent platform, a.properties[fieldNameA], b.properties[fieldNameA]) and (module.exports.toolchain.valuesEquivalent platform, a.properties[fieldNameB], b.properties[fieldNameB])
		generateCode: generateCode
module.exports.toolchain = require "sunruse-influx-toolchain"