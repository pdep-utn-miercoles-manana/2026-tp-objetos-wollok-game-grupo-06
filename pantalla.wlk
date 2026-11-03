import wollok.game.*
import jugadores.*
import juego.*

object pantallas {
  method limpiar() {
    // allVisuals devuelve una copia, se pueden sacar visuales al recorrerla.
    game.allVisuals().forEach({ unVisual => game.removeVisual(unVisual) })
  }

  method mostrarFondo(unaImagen) {
    self.limpiar()
    game.boardGround(unaImagen)
  }
}

object marcadorDeGoles {
    method position() = game.at(0, 7)
    method image() = "goles" + juego.goles() + ".png"
}

object marcadorDeVidas {
    method position() = game.at(9, 7) // Lo ajustamos para que quede bien pegado al borde
    method image() = "vidas" + messi.vidas() + ".png"
}

object cartelDeGol {
    method position() = game.at(3.5, 2.9)
    method image() = "gol.png"
}

object indicadorMate {
    method position() = game.at(8.85, 0)
    method image() = "mateActivo.png"

    method actualizar(unosMs) {
        if (messi.estaAcelerado() and not game.hasVisual(self)) game.addVisual(self)
        if (not messi.estaAcelerado() and game.hasVisual(self)) game.removeVisual(self)
    }
}

