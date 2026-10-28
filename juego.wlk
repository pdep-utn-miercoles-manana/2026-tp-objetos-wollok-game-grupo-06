import wollok.game.*
import pantalla.*
import jugadores.*
import items.*

object juego {

    const defensores = []

    
    
    method mostrarPantallaInicio() {
        game.addVisual(pantallaInicio)
        keyboard.enter().onPressDo {self.iniciar()}
    }

    method iniciar() {
        if (game.hasVisual(pantallaInicio)) {
            game.removeVisual(pantallaInicio)
            game.addVisual(messi)
            self.configurarTeclado()
        }

        game.onCollideDo(messi, { unObjeto => unObjeto.tocarAMessi() })
    }

    method configurarTeclado() {
        keyboard.up().onPressDo    { messi.moverArriba() }
        keyboard.down().onPressDo  { messi.moverAbajo() }
        keyboard.left().onPressDo  { messi.moverIzquierda() }
        keyboard.right().onPressDo { messi.moverDerecha() }
    }
}

object cancha {
    method esJugable(unaPosicion) = 
        unaPosicion.x().between(0, game.width() - 1) and 
        unaPosicion.y().between(0, game.height() - 2) // Dejamos una fila para el marcador

}