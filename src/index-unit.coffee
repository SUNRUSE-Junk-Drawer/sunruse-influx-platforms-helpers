describe "index", ->
	index = undefined
	beforeEach ->
		index = require "./index"
	describe "imports", ->
		it "makeOrderedBinary", ->
			expect(index.makeOrderedBinary).toBe require "./makeOrderedBinary"
		it "makeUnorderedBinary", ->
			expect(index.makeUnorderedBinary).toBe require "./makeUnorderedBinary"
		it "makeUnary", ->
			expect(index.makeUnary).toBe require "./makeUnary"
		it "makeSwitch", ->
			expect(index.makeSwitch).toBe require "./makeSwitch"