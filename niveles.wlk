import wollok.game.*
import jugadores.*
import estados.*
import juego.*

class Nivel {   // Lo comun a todo nivel: saber contra quien juega y que pantalla aparece al ganar
    const pais 
    const pantallaAlGanar

    method pantallaAlGanar() = pantallaAlGanar
    
    method crearRivales() = [
        new Defensor(pais = pais, posicionInicial = game.at(7, 3), intervaloDeMovimiento = 650),
        new Arquero(pais = pais, posicionInicial = game.at(5, cancha.filaDelArco()), intervaloDeMovimiento = 900)
    ]
}

class NivelConBarra inherits Nivel {
    override method crearRivales() = super() + [
        new BarraSancor(posicionInicial = game.at(cancha.paloIzquierdo(), cancha.filaDelArco() + 1), intervaloDeMovimiento = 2000)
  ]
}

object cuartos inherits Nivel(pais = "Brasil", pantallaAlGanar = nivel1Superado) {}
object semifinal inherits NivelConBarra(pais = "Inglaterra", pantallaAlGanar = nivel2Superado) {}
object final inherits NivelConBarra(pais = "Alemania", pantallaAlGanar = campeon) {
    override method crearRivales() = super() + [
        new Defensor(pais= pais, posicionInicial = game.at(3, 3), intervaloDeMovimiento = 650)
    ]
}