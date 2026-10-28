// Objetos que aparecen a lo largo de la partida
import wollok.game.*
import jugadores.*
import juego.*

object mate {

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

