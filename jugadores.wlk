import wollok.game.*
import juego.*

object messi {
  const posicionInicial = game.at(5, 0)
  var property position = posicionInicial

  method image() = "messiEspalda.png" 

  method moverArriba()  { self.irA(position.up(1)) }
  method moverAbajo()   { self.irA(position.down(1)) }
  method moverIzquierda()   { self.irA(position.left(1)) }
  method moverDerecha()   { self.irA(position.right(1)) }

  method irA(unaPosicion) {
    if(cancha.esJugable(unaPosicion)) position = unaPosicion
  }

  method volverAlInicio() {
    position = posicionInicial
  }

}

object arquero {
  method image() = "arqueroParado.png"
}

class defensor {
  method image() = "defensorParado.png"
}