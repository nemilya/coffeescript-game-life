class GameLife
  constructor: (options) ->
    @EMPTY_CELL = ''
    @LIVE_CELL = '*'
    @cells = []

    if options['empty_cell']
      @empty_cell = options['empty_cell']
    else
      @empty_cell = @EMPTY_CELL
      
    if !options['live_cell']?
      @live_cell = options['live_cell']
    else
      @live_cell = @LIVE_CELL

    if options["map"]
      @set_generation(options["map"])
    else
      @cols = options["cols"]
      @rows = options["rows"]
      @init_cells()

  init_cells: ->
    for row in [0...@rows]
      @cells[row] = []
      for col in [0...@cols]
        @cells[row][col] = @empty_cell

  screen: ->
    ret = ''
    for row in @cells
      for cell in row
        ret += cell
      ret += "\n"
    ret

  set_life_at: (position) ->
    x = position["row"]
    y = position["col"]
    @cells[x][y] = @live_cell

  max_cols: -> @cols

  max_rows: -> @rows

  set_generation: (map) ->
    rows = map.trim().split /\n/
    @rows = rows.length
    @cols = rows[0].split(//).length
    @init_cells()

    cur_row = 0
    for row in rows
      cur_col = 0
      cells = row.split //
      for cell in cells
        @set_life_at( row: cur_row, col: cur_col ) if cell == @live_cell
        cur_col += 1
      cur_row += 1

  is_cell_life: (location) ->
    c = location["col"]
    r = location["row"]
    if @cells[r] && @cells[r][c]
      return @cells[r][c] == @live_cell
    return false

  neighbour_count_at: (location) ->
    neighbour_vectors = []
    delta_row = [-1, 0, 1]
    delta_col = [-1, 0, 1]
    for d_r in delta_row
      for d_c in delta_col
        continue if d_r == 0 && d_c == 0 # skip own cell
        neighbour_vectors.push [d_r, d_c]

    cnt = 0
    for v in neighbour_vectors
      at_location = {}
      at_location["row"] = location["row"] + v[0]
      at_location["col"] = location["col"] + v[1]
      if @is_cell_life(at_location)
        cnt += 1 
    return cnt

  is_cell_will_be_live: (cell, neighbour_count) ->
    return true if cell == @empty_cell && neighbour_count == 3
    return true if cell == @live_cell && (neighbour_count == 3 || neighbour_count == 2)
    false


  do_step: ->
    new_cells = []
    cur_row = 0
    for row in @cells
      cur_col = 0
      new_row = []
      for cell in row
        new_cell = @empty_cell
        neighbour_cnt = @neighbour_count_at( { row: cur_row, col: cur_col } )
        if @is_cell_will_be_live(cell, neighbour_cnt)
          new_cell = @live_cell
        new_row.push new_cell
        cur_col += 1
      new_cells.push new_row
      cur_row += 1
    @cells = new_cells

exports.GameLife = GameLife