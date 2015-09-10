module.exports = (primitiveType, generateCode) ->
	instance = 
		name: "switch"
		output: primitiveType
		compile: (value) ->
			if not value.properties then return null
			if not value.properties.a then return null
			if not value.properties.b then return null
			if not value.properties.on then return null
			if not module.exports.toolchain.valueIsPrimitive value.properties.a, primitiveType then return null
			if not module.exports.toolchain.valueIsPrimitive value.properties.b, primitiveType then return null
			if not module.exports.toolchain.valueIsPrimitive value.properties.on, "bool" then return null
			if value.properties.on.primitive
				cloned = {}
				source = if value.properties.on.primitive.value then value.properties.b else value.properties.a
				cloned[propertyName] = source[propertyName] for propertyName of source
				cloned.score = value.properties.a.score + value.properties.b.score + value.properties.on.score + 1 
				return cloned
			else
				return unused =
					score: value.properties.a.score + value.properties.b.score + value.properties.on.score + 1
					native:
						function: instance
						input:
							score: value.properties.a.score + value.properties.b.score + value.properties.on.score
							properties:
								a: value.properties.a
								b: value.properties.b
								on: value.properties.on
		inputsEqual: (platform, a, b) ->
			(module.exports.toolchain.valuesEquivalent platform, a.properties.on, b.properties.on) and (module.exports.toolchain.valuesEquivalent platform, a.properties.a, b.properties.a) and (module.exports.toolchain.valuesEquivalent platform, a.properties.b, b.properties.b)
		generateCode: generateCode
	
module.exports.toolchain = require "sunruse-influx-toolchain"