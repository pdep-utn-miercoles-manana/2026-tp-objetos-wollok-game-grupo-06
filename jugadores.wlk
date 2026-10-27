object messi {
  var energy = 100
  var property position = game.origin()

  method energy() = energy

  method image() = "messiEspalda.png"

  method fly(minutes) {
    energy = energy - minutes * 3
  }
}

object arquero {

}

object defensor {

}
