import wollok.game.*
import jugadores.*
import juego.*

// El fondo es una imagen; los textos quedan editables en codigo.
class Texto {
  const property position
  const property text
  method textColor() = "FFFFFFFF"
}

object pantallas {
  method limpiar() {
    // allVisuals devuelve una copia; se pueden quitar visuales al recorrerla.
    game.allVisuals().forEach({ visual => game.removeVisual(visual) })
  }

  method mostrarInicio() {
    self.limpiar()
    game.boardGround("inicio.png")
  }

  method mostrarIntroduccion() {
    self.limpiar()
    game.boardGround("introduccionBrasil.png")
  }

  method mostrarCancha() {
    self.limpiar()
    game.boardGround("cancha.png")
  }

  method mostrarResultado(gano, goles, fallos) {
    self.limpiar()
    game.boardGround(if (gano) "victoriaBrasil.png" else "derrotaBrasil.png")
    self.escribir("Goles: " + goles + " | Tiros fallados: " + fallos, 2)
  }

  method escribir(texto, fila) {
    game.addVisual(new Texto(position = game.at(5.5, fila), text = texto))
  }
}

object marcador {
  method position() = game.at(5.5, 7)
  method textColor() = "FFFFFFFF"
  method text() = "ARG " + juego.goles() + "/3 | Fallos " + juego.fallos() + "/3 | Vidas " + messi.vidas()
}

object ayuda {
  method position() = game.at(5.5, 5)
  method textColor() = "FFFFFFFF"
  method text() = juego.mensaje() + (if (messi.estaAcelerado()) " | MATE ACTIVO" else "")
}
