blockTravel = (editor, direction) ->
  pos = editor.getCursorBufferPosition()
  row = pos.row

  loop
    if direction == "up"
      row -= 1
    else
      row += 1

    if row < 0
      editor.setCursorBufferPosition([0, 0])
      return

    if row >= editor.getLineCount()
      editor.setCursorBufferPosition([editor.getLineCount(), 0])
      return

    range = editor.bufferRangeForBufferRow(row)
    text  = editor.getTextInBufferRange(range)
    text  = text.replace /^\s+|\s+$/g, ""

    if text == ""
      editor.setCursorBufferPosition([row, 0])
      break

module.exports =
  activate: ->
    atom.workspaceView.command 'block-travel:move-up', ->
      blockTravel(atom.workspaceView.getActivePaneItem(), "up")

    atom.workspaceView.command 'block-travel:move-down', ->
      blockTravel(atom.workspaceView.getActivePaneItem(), "down")

  blockTravel: blockTravel
