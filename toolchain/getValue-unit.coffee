require "jasmine-collection-matchers"
rewire = require "rewire"

describe "getValue", ->
	getValue = tokenized = funct = undefined
	beforeEach ->
		getValue = rewire "./getValue"
		tokenized = 
			primitives:
				testPrimitiveA: ->
				testPrimitiveB: ->
				testPrimitiveC: ->
				testPrimitiveD: ->
				testPrimitiveE: ->
				testPrimitiveF: ->
				
		funct =
			declarations:
				testDeclarationA: "Test Declaration A"
				testDeclarationB: "Test Declaration B"
				testDeclarationC: "Test Declaration C"
			
		spyOn(getValue, "compileExpression").and.callFake (_tokenized, _value, _expression, _funct) ->
			expect(_tokenized).toBe tokenized
			expect(_value).toBe "Test Input"
			expect(_expression).toEqual "Test Declaration B"
			expect(_funct).toBe funct
			return "Test Compiled Expression"			

		spyOn(tokenized.primitives, "testPrimitiveA").and.callFake (token) ->
			if token is "Test Literal A"
				false
			
		spyOn(tokenized.primitives, "testPrimitiveB").and.callFake (token) ->
			if token is "Test Literal B"
				"Test Primitive"
		
		spyOn(tokenized.primitives, "testPrimitiveC").and.callFake (token) ->
			if token is "Test Literal C"
				0
				
		spyOn(tokenized.primitives, "testPrimitiveD").and.callFake (token) ->
			if token is "Test Literal D"
				null
				
		spyOn(tokenized.primitives, "testPrimitiveE").and.callFake (token) ->
			if token is "Test Literal E"
				""				
				
		spyOn(tokenized.primitives, "testPrimitiveF").and.callFake (token) ->
			if token is "Test Literal F"
				NaN
						
	it "returns a value object when a primitive literal returning truthy is given", ->
		expect getValue tokenized, "Test Input", "Test Literal B", funct
			.toEqual
				score: 0
				primitive:
					type: "testPrimitiveB"
					value: "Test Primitive"
	it "returns a value object when a primitive literal returning false is given", ->
		expect getValue tokenized, "Test Input", "Test Literal A", funct
			.toEqual
				score: 0
				primitive:
					type: "testPrimitiveA"
					value: false			
	it "returns a value object when a primitive literal returning zero is given", ->
		expect getValue tokenized, "Test Input", "Test Literal C", funct
			.toEqual
				score: 0
				primitive:
					type: "testPrimitiveC"
					value: 0					
	it "returns a value object when a primitive literal returning null is given", ->
		expect getValue tokenized, "Test Input", "Test Literal D", funct
			.toEqual
				score: 0
				primitive:
					type: "testPrimitiveD"
					value: null					
	it "returns a value object when a primitive literal returning empty string is given", ->
		expect getValue tokenized, "Test Input", "Test Literal E", funct
			.toEqual
				score: 0
				primitive:
					type: "testPrimitiveE"
					value: ""					
	it "returns a value object when a primitive literal returning NaN is given", ->
		expect getValue tokenized, "Test Input", "Test Literal F", funct
			.toEqual
				score: 0
				primitive:
					type: "testPrimitiveF"
					value: NaN										
	it "returns the input when 'input' is given", ->
		expect getValue tokenized, "Test Input", "input", funct
			.toEqual "Test Input"
	it "calls compileExpression when the name of a declaration in the same function is given", ->
		expect getValue tokenized, "Test Input", "testDeclarationB", funct
			.toEqual "Test Compiled Expression"		
	it "returns falsy when no value can be resolved", ->
		expect getValue tokenized, "Test Input", "nonsense", funct
			.toBeFalsy()		