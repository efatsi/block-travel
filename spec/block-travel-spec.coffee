{blockTravel} = require '../lib/block-travel'

describe "BlockTravel", ->
  describe "blockTravel(editor, direction)", ->
    [editor] = []

    beforeEach ->
      waitsForPromise ->
        atom.packages.activatePackage('language-javascript')

      waitsForPromise ->
        atom.workspace.open()

      runs ->
        editor = atom.workspace.getActiveTextEditor()

        editor.setText """
          console.log("Hello World");

          console.log("Hello World");

          console.log("Hello 'World'");
        """
        editor.setGrammar(atom.grammars.selectGrammar('test.js'))

    describe "with a down direction", ->
      it "goes to the next empty row", ->
        editor.setCursorBufferPosition([1, 0])
        blockTravel(editor, "down", false)
        expect(editor.getCursorBufferPosition()).toEqual([3, 0])

    describe "with an up direction", ->
      it "goes to the next empty row", ->
        editor.setCursorBufferPosition([3, 0])
        blockTravel(editor, "up", false)
        expect(editor.getCursorBufferPosition()).toEqual([1, 0])

    describe "with folded rows", ->
      beforeEach ->
        editor = atom.workspace.getActiveTextEditor()
        editor.setText """
          var quicksort = function () {
            var sort = function(items) {
              if (items.length <= 1) return items;
              var pivot = items.shift(), current, left = [], right = [];

              while(items.length > 0) {
                current = items.shift();
                current < pivot ? left.push(current) : right.push(current);
              }

              return sort(left).concat(pivot).concat(sort(right));
            };

            return sort(Array.apply(this, arguments));
          };
        """
        editor.foldBufferRow(5)

      it "properly handles jumping over folded blocks", ->
        editor.setCursorBufferPosition([1, 0])
        blockTravel(editor, "down", false)
        expect(editor.getCursorBufferPosition()).toEqual([4, 0])

        blockTravel(editor, "down", false)
        expect(editor.getCursorBufferPosition()).toEqual([9, 0])
        expect(editor.getCursorScreenPosition()).toEqual([6, 0])

    describe "with soft wrapped rows", ->
      beforeEach ->
        editor = atom.workspace.getActiveTextEditor()
        editor.setSoftWrapped(true)
        editor.setEditorWidthInChars(80)
        editor.setDefaultCharWidth(8)
        editor.setText """
          Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

          Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

          Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
        """

      it "properly handles jumping over soft wrapped blocks", ->
        editor.setCursorBufferPosition([0, 0])
        blockTravel(editor, "down", false)
        expect(editor.getCursorBufferPosition()).toEqual([1, 0])

        blockTravel(editor, "down", false)
        expect(editor.getCursorBufferPosition()).toEqual([3, 0])
        expect(editor.getCursorScreenPosition()).toEqual([7, 0])

        blockTravel(editor, "up", false)
        expect(editor.getCursorBufferPosition()).toEqual([1, 0])

        blockTravel(editor, "up", false)
        expect(editor.getCursorBufferPosition().row).toEqual(0)

    describe "with multiple cursors", ->
      beforeEach ->
        editor = atom.workspace.getActiveTextEditor()
        editor.setText """
          console.log("Hello World");

          console.log("Hello World");
          console.log("Hello World");

        """

      it "properly moves each cursor independently", ->
        editor.setCursorBufferPosition([0, 0])
        editor.addCursorAtBufferPosition([2, 0])
        blockTravel(editor, "down", false)
        expect(editor.getCursors()[0].getBufferRow()).toEqual(1)
        expect(editor.getCursors()[1].getBufferRow()).toEqual(4)

      it "merges cursors that end up in the same place", ->
        editor.setCursorBufferPosition([2, 0])
        editor.addCursorAtBufferPosition([3, 0])
        blockTravel(editor, "down", false)
        expect(editor.getCursors().length).toEqual(1)
        expect(editor.getCursorBufferPosition()).toEqual([4, 0])
