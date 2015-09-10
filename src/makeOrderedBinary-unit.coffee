describe "platforms", ->
	describe "helpers", ->
		describe "makeOrderedBinary", ->
			makeOrderedBinary = undefined
			beforeEach ->
				makeOrderedBinary = require "./makeOrderedBinary"
			describe "imports", ->
				it "toolchain", ->
					expect(makeOrderedBinary.toolchain).toBe require "sunruse-influx-toolchain"
			describe "on calling", ->
				instance = toolchain = undefined
				beforeEach ->
					toolchain = makeOrderedBinary.toolchain
					makeOrderedBinary.toolchain = 
						valueIsPrimitive: jasmine.createSpy()
						valuesEquivalent: jasmine.createSpy()
					instance = makeOrderedBinary "Test Name", "Test Input Type", "Test Output Type", ((a, b) -> if a is "Test Input A" and b is "Test Input B" then "Test Output Value"), "Test GenerateCode"
				afterEach ->
					makeOrderedBinary.toolchain = toolchain					
				it "copies the name", ->
					expect(instance.name).toEqual "Test Name"
				it "copies the output type", ->
					expect(instance.output).toEqual "Test Output Type"
				it "copies generateCode", ->
					expect(instance.generateCode).toEqual "Test GenerateCode"
				describe "inputsEqual", ->
					it "defers to valuesEquivalent and returns true when properties in the operands match", ->
						makeOrderedBinary.toolchain.valuesEquivalent.and.callFake (platform, a, b) ->
							expect(platform).toEqual "Test Platform"
							switch a
								when "Test Input AA"
									expect(b).toEqual "Test Input BA"
									return true
								when "Test Input AB"
									expect(b).toEqual "Test Input BB"
									return true									
								else expect(false).toBeTruthy()
						inputA = 
							properties:
								a: "Test Input AA"
								b: "Test Input AB"
						inputB = 
							properties:
								a: "Test Input BA"
								b: "Test Input BB"								
						expect instance.inputsEqual "Test Platform", inputA, inputB
							.toBeTruthy()
							
					it "defers to valuesEquivalent and returns false when properties in the operands do not match", ->
						makeOrderedBinary.toolchain.valuesEquivalent.and.callFake (platform, a, b) ->
							expect(platform).toEqual "Test Platform"
							switch a
								when "Test Input AA"
									expect(b).toEqual "Test Input BA"
									return false
								when "Test Input AB"
									expect(b).toEqual "Test Input BB"
									return false									
								else expect(false).toBeTruthy()
						inputA = 
							properties:
								a: "Test Input AA"
								b: "Test Input AB"
						inputB = 
							properties:
								a: "Test Input BA"
								b: "Test Input BB"								
						expect instance.inputsEqual "Test Platform", inputA, inputB
							.toBeFalsy()
														
					it "defers to valuesEquivalent and returns false when only the first property pair matches", ->
						makeOrderedBinary.toolchain.valuesEquivalent.and.callFake (platform, a, b) ->
							expect(platform).toEqual "Test Platform"
							switch a
								when "Test Input AA"
									expect(b).toEqual "Test Input BA"
									return true
								when "Test Input AB"
									expect(b).toEqual "Test Input BB"
									return false									
								else expect(false).toBeTruthy()
						inputA = 
							properties:
								a: "Test Input AA"
								b: "Test Input AB"
						inputB = 
							properties:
								a: "Test Input BA"
								b: "Test Input BB"								
						expect instance.inputsEqual "Test Platform", inputA, inputB
							.toBeFalsy()
							
					it "defers to valuesEquivalent and returns false when only the second property pair matches", ->
						makeOrderedBinary.toolchain.valuesEquivalent.and.callFake (platform, a, b) ->
							expect(platform).toEqual "Test Platform"
							switch a
								when "Test Input AA"
									expect(b).toEqual "Test Input BA"
									return false
								when "Test Input AB"
									expect(b).toEqual "Test Input BB"
									return true									
								else expect(false).toBeTruthy()
						inputA = 
							properties:
								a: "Test Input AA"
								b: "Test Input AB"
						inputB = 
							properties:
								a: "Test Input BA"
								b: "Test Input BB"								
						expect instance.inputsEqual "Test Platform", inputA, inputB
							.toBeFalsy()							
				describe "compile", ->
					describe "when the input is not a properites object", ->
						it "returns falsy", ->
							expect instance.compile 
									score: 5
									otherProperty: "With Value"
								.toBeFalsy()
					describe "when the input is a properties object", ->
						describe "ignoring primitive type checks", ->
							beforeEach ->
								makeOrderedBinary.toolchain.valueIsPrimitive.and.returnValue true
							describe "when neither property exists", ->
								it "returns falsy", ->
									expect instance.compile 
											score: 5
											properties:
												c: "Test Unneeded Property"
										.toBeFalsy()							
							describe "when the first property is missing", ->
								it "returns falsy", ->
									expect instance.compile 
											score: 5
											properties:
												b: "Test Unneeded Property"
										.toBeFalsy()													
							describe "when the second property is missing", ->
								it "returns falsy", ->
									expect instance.compile 
											score: 5
											properties:
												a: "Test Unneeded Property"
										.toBeFalsy()
						describe "when both properties are present", ->													
							describe "when neither value is the correct primitive type", ->
								it "returns falsy", ->
									makeOrderedBinary.toolchain.valueIsPrimitive.and.callFake (value, name) ->
										expect(name).toEqual "Test Input Type"
										switch value
											when "Test Input A" then return false
											when "Test Input B" then return false
											else expect(false).toBeTruthy()
									input = 
										score: 5
										properties:
											a: "Test Input A"
											b: "Test Input B"
											c: "Test Unneeded"
									expect instance.compile input
										.toBeFalsy()
							describe "when only the first value is the correct primitive type", ->
								it "returns falsy", ->
									makeOrderedBinary.toolchain.valueIsPrimitive.and.callFake (value, name) ->
										expect(name).toEqual "Test Input Type"
										switch value
											when "Test Input A" then return true
											when "Test Input B" then return false
											else expect(false).toBeTruthy()
									input = 
										score: 5
										properties:
											a: "Test Input A"
											b: "Test Input B"
											c: "Test Unneeded"
									expect instance.compile input
										.toBeFalsy()								
							describe "when only the second value is the correct primitive type", ->
								it "returns falsy", ->
									makeOrderedBinary.toolchain.valueIsPrimitive.and.callFake (value, name) ->
										expect(name).toEqual "Test Input Type"
										switch value
											when "Test Input A" then return false
											when "Test Input B" then return true
											else expect(false).toBeTruthy()
									input = 
										score: 5
										properties:
											a: "Test Input A"
											b: "Test Input B"
											c: "Test Unneeded"
									expect instance.compile input
										.toBeFalsy()														
							describe "when both values are the correct primitive type", ->
								input = undefined
								beforeEach ->
									input = 
										score: 8
										properties: 
											a: 
												score: 2
											b:
												score: 3
											c: "Test Unneeded"
									makeOrderedBinary.toolchain.valueIsPrimitive.and.callFake (value, name) ->
										expect(name).toEqual "Test Input Type"
										switch value
											when input.properties.a then return true
											when input.properties.b then return true
											else expect(false).toBeTruthy()
								describe "when both inputs are primitive constants", ->
									beforeEach ->
										input.properties.a.primitive = 
												value: "Test Input A"
										input.properties.b.primitive = 
												value: "Test Input B"												
									it "returns the computed primitive constant", ->
										expect instance.compile input
											.toEqual 
												score: 6
												primitive:
													type: "Test Output Type"
													value: "Test Output Value"
								describe "when only the first input is non-constant", ->
									beforeEach ->
										input.properties.a.anotherNonConstant = "Will be preserved"
										input.properties.b.primitive = 
												value: "Test Input B"												
									it "returns a native value object", ->
										result = instance.compile input
										expect(result).toEqual 
												score: 6
												native:
													function: jasmine.any Object
													input: 
														score: 5
														properties:
															a: jasmine.any Object
															b: jasmine.any Object
										expect(result.native.input.properties.a).toBe input.properties.a
										expect(result.native.input.properties.b).toBe input.properties.b									
								describe "when only the second input is non-constant", ->
									beforeEach ->
										input.properties.a.primitive = 
												value: "Test Input A"										
										input.properties.b.anotherNonConstant = "Will be preserved"												
									it "returns a native value object", ->
										result = instance.compile input
										expect(result).toEqual 
												score: 6
												native:
													function: jasmine.any Object
													input: 
														score: 5
														properties:
															a: jasmine.any Object
															b: jasmine.any Object
										expect(result.native.input.properties.a).toBe input.properties.a
										expect(result.native.input.properties.b).toBe input.properties.b																			
								describe "when both inputs are non-constant", ->
									beforeEach ->
										input.properties.a.anotherNonConstant = "Will be preserved"
										input.properties.b.aNonConstant = "is presevered"												
									it "returns a native value object", ->
										result = instance.compile input
										expect(result).toEqual 
												score: 6
												native:
													function: jasmine.any Object
													input: 
														score: 5
														properties:
															a: jasmine.any Object
															b: jasmine.any Object
										expect(result.native.input.properties.a).toBe input.properties.a
										expect(result.native.input.properties.b).toBe input.properties.b