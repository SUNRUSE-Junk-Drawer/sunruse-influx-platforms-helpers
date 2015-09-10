describe "platforms", ->
	describe "helpers", ->
		describe "makeUnary", ->
			makeUnary = undefined
			beforeEach ->
				makeUnary = require "./makeUnary"
			describe "imports", ->
				it "toolchain", ->
					expect(makeUnary.toolchain).toBe require "sunruse-influx-toolchain"
			describe "on calling", ->
				instance = toolchain = undefined
				beforeEach ->
					valueIsPrimitive = makeUnary.valueIsPrimitive
					valuesEquivalent = makeUnary.valuesEquivalent
					makeUnary.toolchain = 
						valueIsPrimitive: jasmine.createSpy()
						valuesEquivalent: jasmine.createSpy()
					instance = makeUnary "Test Name", "Test Input Type", "Test Output Type", ((input) -> if input is "Test Input Value" then "Test Output Value"), "Test GenerateCode"
				afterEach ->
					makeUnary.toolchain = toolchain					
				it "copies the name", ->
					expect(instance.name).toEqual "Test Name"
				it "copies the output type", ->
					expect(instance.output).toEqual "Test Output Type"
				it "copies generateCode", ->
					expect(instance.generateCode).toEqual "Test GenerateCode"
				describe "inputsEqual", ->
					it "defers to valuesEquivalent", ->
						makeUnary.toolchain.valuesEquivalent.and.callFake (platform, a, b) ->
							expect(platform).toEqual "Test Platform"
							expect(a).toEqual "Test Input A"
							expect(b).toEqual "Test Input B"
							"Test Result"
							
						expect instance.inputsEqual "Test Platform", "Test Input A", "Test Input B"
							.toEqual "Test Result" 
				describe "compile", ->
					describe "when the input is not a primitive", ->
						beforeEach ->
							makeUnary.toolchain.valueIsPrimitive.and.callFake (value, name) ->
								expect(value).toEqual "Test Input Value"
								expect(name).toEqual "Test Input Type"
								false
						it "returns falsy", ->
							expect instance.compile "Test Input Value"
								.toBeFalsy()
					describe "when the input is a primitive", ->
						input = undefined
						beforeEach ->
							makeUnary.toolchain.valueIsPrimitive.and.callFake (value, name) ->
								expect(value).toBe input
								expect(name).toEqual "Test Input Type"
								true						
						describe "when the input is a primitive constant", ->
							beforeEach ->
								input = 
									score: 8
									primitive:
										value: "Test Input Value"
							it "returns the computed primitive constant", ->
								expect instance.compile input
									.toEqual 
										score: 9
										primitive:
											type: "Test Output Type"
											value: "Test Output Value"
						describe "when the input is a non-constant", ->
							beforeEach ->
								input = 
									score: 8
									propertyTo: "preserve"							
							it "returns a native value object", ->
								result = instance.compile input
								expect(result).toEqual 
										score: 9
										native:
											function: jasmine.any Object
											input: jasmine.any Object
								expect(result.native.function).toBe instance
								expect(result.native.input).toBe input