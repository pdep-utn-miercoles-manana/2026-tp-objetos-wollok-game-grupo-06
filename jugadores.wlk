import wollok.game.*
import juego.*

object messi {
  const posicionInicial = game.at(5, 0)
  var property position = posicionInicial
  const vidasMaximas = 3
  var vidas = vidasMaximas
  var esperaMovimiento = 0
  var tiempoAcelerado = 0

  method vidas() = vidas
  method estaSinVidas() = vidas <= 0
  method necesitaVida() = vidas < vidasMaximas
  method estaAcelerado() = tiempoAcelerado > 0
  method intervaloMovimiento() = if (self.estaAcelerado()) 120 else 240
  method image() = if (pelota.enVuelo()) "messiPateando.png" else "messiEspalda.png"

  method perderVida() { vidas = (vidas - 1).max(0) }
  method ganarVida() { vidas = (vidas + 1).min(vidasMaximas) }
  method moverArriba() { self.irA(position.up(1)) }
  method moverAbajo() { self.irA(position.down(1)) }
  method moverIzquierda() { self.irA(position.left(1)) }
  method moverDerecha() { self.irA(position.right(1)) }

  method irA(destino) {
    if (esperaMovimiento == 0 and cancha.esJugable(destino)) {
      position = destino
      esperaMovimiento = self.intervaloMovimiento()
    }
  }
  method actualizar(milisegundos) {
    esperaMovimiento = (esperaMovimiento - milisegundos).max(0)
    tiempoAcelerado = (tiempoAcelerado - milisegundos).max(0)
  }
  method volverAlInicio() { position = posicionInicial }
  method acelerar() { tiempoAcelerado = 5000 }
  method restablecerVelocidad() { tiempoAcelerado = 0 }
  method reiniciar() {
    vidas = vidasMaximas
    esperaMovimiento = 0
    self.volverAlInicio()
    self.restablecerVelocidad()
  }
}

// Una sola instancia en cuartos. Nunca cambia su coordenada vertical.
class Defensor {
  const property posicionInicial = game.at(7, 3)
  var property position = posicionInicial
  var direccion = 1

  method image() = "defensorBrasil.png"
  method mover() {
    if (position.x() >= 9) direccion = -1
    if (position.x() <= 2) direccion = 1
    position = position.right(direccion)
  }
  method chocasteCon(jugador) {
    jugador.perderVida()
    jugador.volverAlInicio()
  }
  method volverAlInicio() {
    position = posicionInicial
    direccion = 1
  }
}

object arquero {
  var property position = game.at(5, 6)
  var direccion = 1
  method image() = "arqueroBrasil.png"
  method mover() {
    if (position.x() >= 8) direccion = -1
    if (position.x() <= 3) direccion = 1
    position = position.right(direccion)
  }
  method reiniciar() {
    position = game.at(5, 6)
    direccion = 1
  }
}

object pelota {
  var property position = game.at(5, 0)
  var origen = game.at(5, 0)
  var destinoX = 5
  var enVuelo = false
  method image() = "pelota.png"
  method enVuelo() = enVuelo

  method lanzar(desde, haciaX) {
    origen = desde
    position = desde
    destinoX = haciaX
    enVuelo = true
  }
  method avanzar() {
    if (enVuelo and position.y() < 6) {
      const nuevaY = position.y() + 1
      const progreso = (nuevaY - origen.y()) / (6 - origen.y())
      position = game.at((origen.x() + (destinoX - origen.x()) * progreso).round(), nuevaY)
    }
  }
  method detener() { enVuelo = false }
  method llegoAlArco() = position.y() == 6
}

object mira {
  var objetivoX = 5
  method position() = game.at(objetivoX, 6)
  method image() = "mira.png"
  method objetivoX() = objetivoX
  method apuntarIzquierda() { objetivoX = (objetivoX - 1).max(3) }
  method apuntarDerecha() { objetivoX = (objetivoX + 1).min(8) }
  method reiniciar() { objetivoX = 5 }
}
