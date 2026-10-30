import wollok.game.*
import jugadores.*
import juego.*

object pantallas {
  method limpiar() {
    // allVisuals devuelve una copia; se pueden quitar visuales al recorrerla.
    game.allVisuals().forEach({ unVisual => game.removeVisual(unVisual) })
  }

  method mostrarFondo(unaImagen) {
    self.limpiar()
    game.boardGround(unaImagen)
  }
}

object marcador {
  method position() = game.at(5.5, 7)
  method textColor() = "FFFFFFFF"
  method text() = "ARG " + juego.goles() + "/" + juego.golesParaGanar() + " | Vidas " + messi.vidas()
}


