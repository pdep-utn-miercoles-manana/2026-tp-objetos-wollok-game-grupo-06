import wollok.game.*
import juego.*

object messi {
  const posicionInicial = game.at(5, 0)
  var property position = posicionInicial
  const vidasMaximas = 3
  var vidas = 3
  var intervaloMovimiento = 300
  method intervaloMovimiento() = intervaloMovimiento

  
  method vidas() = vidas
  
  method perderVida() {
    vidas -= 1
    if (self.estaSinVidas()) juego.terminar()
    // juego.terminar debería reiniciar el juego desde nivel 1
  }
  
  method estaSinVidas() = vidas == 0
  
  method necesitaVida() = vidas < vidasMaximas
  
  method ganarVida() {
    vidas = (vidas + 1).min(vidasMaximas)
  }
  
  method image() = "messiEspalda.png"
  
  method moverArriba() {
    self.irA(position.up(1))
  }
  
  method moverAbajo() {
    self.irA(position.down(1))
  }
  
  method moverIzquierda() {
    self.irA(position.left(1))
  }
  
  method moverDerecha() {
    self.irA(position.right(1))
  }
  
  method irA(unaPosicion) {
    if (cancha.esJugable(unaPosicion)) {
      position = unaPosicion
    }
  }
  
  method volverAlInicio() {
    position = posicionInicial
  }
  method acelerar() {
    intervaloMovimiento = 150
  }

  method restablecerVelocidad() {
    intervaloMovimiento = 300
  }

  method reiniciar() {
    vidas = vidasMaximas
    self.volverAlInicio()
    self.restablecerVelocidad()
  }

}

object arquero {
  method image() = "arqueroBrasil.png"
}

class Defensor {

  const posicionInicial = game.at(7, 5)
  var property position = posicionInicial

  method volverAlInicio() {
    position = posicionInicial
  }
  
  method image() = "defensorBrasil.png"
  
  method perseguirAMessi() {
    position = game.at(
      position.x() + self.pasoHacia(messi.position().x(), position.x()),
      position.y() + self.pasoHacia(messi.position().y(), position.y())
    )
  }
  
  method chocasteCon(unJugador) {
    unJugador.perderVida()
  }
  
  method pasoHacia(unDestino, unOrigen) = (unDestino - unOrigen).max(-1).min(1)
}