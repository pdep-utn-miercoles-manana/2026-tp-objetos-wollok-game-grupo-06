import wollok.game.*
import jugadores.*
import juego.*
import cronometro.*

// Lo común a todo item: cuando Messi lo toca, aplica su efecto y desaparece
class Item {
    var property position = game.origin()
    const frecuenciaDeAparicion
    const cronometroDeAparicion = new Cronometro(intervalo = frecuenciaDeAparicion)

    method image()
    method aplicarEfecto(unJugador) 

    method puedeAparecer() = true // Por defecto
    method alAparecer() {} 

    method aparecer() {
        const posiciones = cancha.posicionesLibresParaItems()
        if (self.puedeAparecer() and not game.hasVisual(self) and not posiciones.isEmpty()) {
            position = posiciones.anyOne()
            game.addVisual(self)
            self.alAparecer()
        }
    }

    method chocarCon(unJugador) {
        self.aplicarEfecto(unJugador)
        self.desaparecer()
    }

    method desaparecer() {
        if (game.hasVisual(self)) game.removeVisual(self)
    }

    method actualizar(unosMs) { cronometroDeAparicion.avanzar(unosMs, { self.aparecer() }) }

    method reiniciar() {
        self.desaparecer()
        cronometroDeAparicion.reiniciar()
    }
}
object mate inherits Item(frecuenciaDeAparicion = 5000) {
  const cronometroDeVida = new Cronometro(intervalo = 6000)

  override method image() = "mate.png"
  override method aplicarEfecto(unJugador) { unJugador.acelerar() }

  override method alAparecer() { cronometroDeVida.reiniciar() }

  override method actualizar(unosMs) {
    super(unosMs)
    if (game.hasVisual(self)) cronometroDeVida.avanzar(unosMs, { self.desaparecer() })
  }
}

object copaDelMundo inherits Item(frecuenciaDeAparicion = 8000) {
  override method image() = "copaDelMundo.png"
  override method aplicarEfecto(unJugador) { unJugador.ganarVida() }

  override method puedeAparecer() = messi.necesitaVida()
}
