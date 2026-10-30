import wollok.game.*
import jugadores.*
import juego.*

object mate {
  var property position = game.origin()
  var tiempoRestante = 0
  method image() = "mate.png"
  method aparecer() {
    const posiciones = cancha.posicionesLibresParaItems()
    if (not game.hasVisual(self) and not posiciones.isEmpty()) {
      position = posiciones.anyOne()
      tiempoRestante = 3000
      game.addVisual(self)
    }
  }
  method actualizar(milisegundos) {
    if (game.hasVisual(self)) {
      tiempoRestante = (tiempoRestante - milisegundos).max(0)
      if (tiempoRestante == 0) self.desaparecer()
    }
  }
  method chocarCon(unJugador) {
    unJugador.acelerar()
    self.desaparecer()
  }
  method desaparecer() {
    tiempoRestante = 0
    if (game.hasVisual(self)) game.removeVisual(self)
  }
}

object copaDelMundo {
  var property position = game.origin()
  method image() = "copaDelMundo.png"
  method intentarAparecer() {
    const posiciones = cancha.posicionesLibresParaItems()
    if (messi.necesitaVida() and not game.hasVisual(self) and not posiciones.isEmpty()) {
      position = posiciones.anyOne()
      game.addVisual(self)
    }
  }
  method chocarCon(unJugador) {
    unJugador.ganarVida()
    self.desaparecer()
  }
  
  method desaparecer() {
    if (game.hasVisual(self)) game.removeVisual(self)
  }
}
