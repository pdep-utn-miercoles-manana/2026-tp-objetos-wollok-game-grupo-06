// Objetos que aparecen a lo largo de la partida
import wollok.game.*
import jugadores.*
import juego.*

object mate {
    var property position = game.origin()
    const tiempoVisible = 3000

    method image() = "mate.png"

    method aparecer() {
        if (!game.hasVisual(self)) {
            position = cancha.posicionAlAzar()
            game.addVisual(self)

            game.schedule(tiempoVisible, {
                self.desaparecer()
            })
        }
    }

    method chocasteCon(unJugador) {
        unJugador.acelerar()
        self.desaparecer()
    }

    method desaparecer() {
        if (game.hasVisual(self)) {
            game.removeVisual(self)
        }
    }
}

object copaDelMundo { 
    var property position = game.origin()

    method image() = "copaDelMundo.png"

    method intentarAparecer() {
        if (messi.necesitaVida() and not game.hasVisual(self)) self.aparecer()
    }

    method aparecer(){
        position = cancha.posicionAlAzar()
        game.addVisual(self)
    }

    method chocasteCon(jugador) {
    jugador.ganarVida()
    game.removeVisual(self)
  }
}

object logoSancor {

}

