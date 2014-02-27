blockTravel = (editor, direction, select) ->
  pos = editor.getCursorBufferPosition()
  row = pos.row

  loop
    if direction == "up"
      row -= 1
    else
      row += 1

    if row < 0
      if select
        editor.selectUp(pos.row)
      else
        editor.setCursorBufferPosition([0, 0])

      return

    lineCount = editor.getLineCount()
    if row >= lineCount
      if select
        editor.selectDown(lineCount - pos.row)
      else
        editor.setCursorBufferPosition([lineCount, 0])

      return

    range = editor.bufferRangeForBufferRow(row)
    text  = editor.getTextInBufferRange(range)
    text  = text.replace /^\s+|\s+$/g, ""

    if text == ""
      editor.setCursorBufferPosition([row, 0]) unless select
      break

  if select
    if direction == "up"
      editor.selectUp(pos.row - row)
    else
      editor.selectDown(row - pos.row)

module.exports =
  activate: ->
    atom.workspaceView.command 'block-travel:move-up', ->
      blockTravel(atom.workspaceView.getActivePaneItem(), "up", false)

    atom.workspaceView.command 'block-travel:move-down', ->
      blockTravel(atom.workspaceView.getActivePaneItem(), "down", false)

    atom.workspaceView.command 'block-travel:select-up', ->
      blockTravel(atom.workspaceView.getActivePaneItem(), "up", true)

    atom.workspaceView.command 'block-travel:select-down', ->
      blockTravel(atom.workspaceView.getActivePaneItem(), "down", true)

  blockTravel: blockTravel
