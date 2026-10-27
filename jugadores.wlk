object pepita {
  var energy = 100
  var property position = game.origin()

  method energy() = energy

  method image() = "pepita.png"

  method fly(minutes) {
    energy = energy - minutes * 3
  }
}

object messi {

}

