Игра ЖИЗНЬ на CoffeeScript
==========================

Перевод реализованной на Ruby (https://github.com/nemilya/ruby-game-life) игры,
на CoffeeScript.

На базе BDD.

Демо: http://nemilya.github.com/coffeescript-game-life/html/game.html

Бралась спецификация на Ruby: https://github.com/nemilya/ruby-game-life/blob/master/spec/game_life_spec.rb
и последовательно - переводилась на Jasmin/CoffeeScript.

В папке `_ruby` находится оригинал - спецификация для Руби, и реализация на Руби.

В режиме автотестирования, с параллельным создание класса GameLife в `lib/game_life.coffee`


Про настройку тестирования CoffeeScript - здесь можно прочитать:
https://github.com/nemilya/coffeescript-spec-demo

Для генерации JS команда:

    coffee -c game_life.coffee

Будет сгенерирован `game_life.js`.
Единственное я там поменял 

    exports.GameLife = GameLife;

на:

    this.GameLife = GameLife;

После этого он подключается, весь html код:

    <html>
      <head>
        <title>CoffeeScript Game Life</title>
        <script src="game_life.js"></script>
      </head>
    <body>
    <pre id="generation" style="font-family: Courier;">
    ........
    ..***...
    ........
    </pre>

    <script>
      var game = new GameLife({empty_cell:'.', live_cell:'*'})
      var field = document.getElementById('generation');
      generation = field.innerHTML;
      game.set_generation(generation);

      function do_step(){
        game.do_step();
        new_generation = game.screen();
        field.innerHTML = new_generation;
      }
    </script>

    <button onclick="do_step()" >Step</button>

    </body>
    </html>