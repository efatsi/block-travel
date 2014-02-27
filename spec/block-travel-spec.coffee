{blockTravel} = require '../lib/block-travel'

describe "BlockTravel", ->
  describe "blockTravel(editor, direction)", ->
    [editor, buffer] = []

    beforeEach ->
      waitsForPromise ->
        atom.packages.activatePackage('language-javascript')

      runs ->
        editor = atom.project.openSync()
        buffer = editor.getBuffer()
        editor.setText """
          console.log("Hello World");

          console.log("Hello World");

          console.log("Hello 'World'");
        """
        editor.setGrammar(atom.syntax.selectGrammar('test.js'))

    describe "with a down direction", ->
      it "goes to the next empty row", ->
        editor.setCursorBufferPosition([1, 0])
        blockTravel(editor, "down")
        expect(editor.getCursorBufferPosition()).toEqual([3, 0])

    describe "with an up direction", ->
      it "goes to the next empty row", ->
        editor.setCursorBufferPosition([3, 0])
        blockTravel(editor, "up")
        expect(editor.getCursorBufferPosition()).toEqual([1, 0])
