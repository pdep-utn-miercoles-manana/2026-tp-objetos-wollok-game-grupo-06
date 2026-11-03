import wollok.game.*
import jugadores.*
import juego.*
import cronometro.*

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

object indicadorVidaPerdida {
    const cronometro = new Cronometro(intervalo = 1000)

    method position() = game.at(9,6)
    method image() = "menosUnaVida.png"

    method mostrar() {
        cronometro.reiniciar()
        if (not game.hasVisual(self)) game.addVisual(self)
    }

    method actualizar(unosMs) {
        if (game.hasVisual(self)) cronometro.avanzar(unosMs, { game.removeVisual(self) })
    }
 }

 object hinchadaDeFondo {
    const audio = game.sound("hinchada.mp3")

    method sonar() {
        if (audio.paused()) audio.resume()
        else if (not audio.played()) {
            audio.shouldLoop(true)
            audio.volume(0.5)
            audio.play()
        }
    }

    method pausar() {
         if (audio.played() and not audio.paused()) audio.pause()
    }
 }

