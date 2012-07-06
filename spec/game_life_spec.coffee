{GameLife} = require('../lib/game_life')

describe "describe GameLife", ->

  # get map based on specified cols and rows count 
  it "указывается размер карты - столбцы и ячейки, получаем поле", ->
    game = new GameLife( {cols: 3, rows: 2, empty_cell: '.'} )
    expect(game.screen()).toEqual "
...\n
...\n
"

  it "#set_life_at", ->
    game = new GameLife( {cols: 3, rows: 2, empty_cell: '.', live_cell: '*'})
    game.set_life_at( col: 2, row: 1 )

    expect(game.screen()).toEqual "
...\n
..*\n
"


  it "#set_generation2", ->
    game = new GameLife( { empty_cell: '.', live_cell: '*' })
    game.set_generation("
....\n
.*..\n
....\n
")



    expect(game.max_cols()).toEqual 4
    expect(game.max_rows()).toEqual 3

    expect(game.screen()).toEqual "
....\n
.*..\n
....\n
"


  it "#initialize by options :map", ->
    map = "
..*..\n
..*..\n
..*..\n
"

    game = new GameLife( { empty_cell: '.', live_cell: '*', map: map } )
    expect(game.max_cols()).toEqual 5
    expect(game.max_rows()).toEqual 3
    expect(game.screen()).toEqual map


  it "#neighbour_count_at", ->
    generation = "
....\n
.*..\n
...*\n
"
    game = new GameLife( { empty_cell: '.', live_cell: '*', map: generation } )

    expect(game.neighbour_count_at( {col: 0, row: 0} )).toEqual 1
    expect(game.neighbour_count_at( {col: 0, row: 1} )).toEqual 1
    expect(game.neighbour_count_at( {col: 1, row: 1} )).toEqual 0
    expect(game.neighbour_count_at( {col: 3, row: 0} )).toEqual 0
    expect(game.neighbour_count_at( {col: 2, row: 1} )).toEqual 2


 describe "жизнь и смерть", ->

    describe "#is_cell_will_be_live?", ->

      # if cell empty, it become life if there is 3 neighbours
      it "если ячейка пустая, то жизнь появится если есть 3 соседа", ->
        empty_cell = '.'
        game = new GameLife( {empty_cell: empty_cell} )

        neighbour_count = 3
        expect(game.is_cell_will_be_live(empty_cell, neighbour_count)).toEqual true


      # if cell life, it keep life if there is 2 or 3 neighbours
      it "если ячейка заполнена, то жизнь продолжается если есть 2 или 3 соседа", ->
        empty_cell = '.'
        live_cell = '*'

        game = new GameLife( {empty_cell: empty_cell, live_cell: live_cell} )

        neighbour_count = 2
        expect(game.is_cell_will_be_live(live_cell, neighbour_count)).toEqual true

        neighbour_count = 3
        expect(game.is_cell_will_be_live(live_cell, neighbour_count)).toEqual true



      # if cell life, it become empty if < 2 neighbours
      it "если ячейка заполнена, то ячейка освобождается если менее 2 соседей - одиночество", ->
        empty_cell = '.'
        live_cell = '*'

        game = new GameLife( {empty_cell: empty_cell, live_cell: live_cell} )

        neighbour_count = 0
        expect(game.is_cell_will_be_live(live_cell, neighbour_count)).toEqual false

        neighbour_count = 1
        expect(game.is_cell_will_be_live(live_cell, neighbour_count)).toEqual false


      # if cell life, it become empty if > 3 neighbours
      it "если ячейка заполнена, то ячейка освобождается если более 3х соседей - перенаселённость", ->
        empty_cell = '.'
        live_cell = '*'

        game = new GameLife( {empty_cell: empty_cell, live_cell: live_cell} )

        neighbour_count = 4
        expect(game.is_cell_will_be_live(live_cell, neighbour_count)).toEqual false

        neighbour_count = 5
        expect(game.is_cell_will_be_live(live_cell, neighbour_count)).toEqual false
      
        neighbour_count = 6
        expect(game.is_cell_will_be_live(live_cell, neighbour_count)).toEqual false

        neighbour_count = 7
        expect(game.is_cell_will_be_live(live_cell, neighbour_count)).toEqual false

        neighbour_count = 8
        expect(game.is_cell_will_be_live(live_cell, neighbour_count)).toEqual false

    describe "#do_step", ->
      it "делаем шаг жизни", ->
        first_generation = "
....\n
....\n
....\n
"
        game = new GameLife( { empty_cell:'.', live_cell: '*', map: first_generation } )
        game.do_step()
        expect(game.screen()).toEqual "
....\n
....\n
....\n
"

      it "светофор", ->
        first_generation = "
..*...\n
..*...\n
..*...\n
"
        game = new GameLife( {empty_cell: '.', live_cell: '*', map: first_generation } )
        game.do_step()
        expect(game.screen()).toEqual "
......\n
.***..\n
......\n
"

        game.do_step()
        expect(game.screen()).toEqual "
..*...\n
..*...\n
..*...\n
"
