import wollok.game.*
import juego.*
import cronometro.*
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

class Rival { // Comun a todo rival de Messi
  const posicionInicial
  const intervaloDeMovimiento
  const cronometro = new Cronometro(intervalo = intervaloDeMovimiento)
  var property position = posicionInicial
  
  method image()  
  method mover()

  method actualizar(unosMs) { cronometro.avanzar(unosMs, { self.mover() }) }

  method volverAlInicio() {
    position = posicionInicial
    cronometro.reiniciar()
  }

  method chocarCon(unJugador) {} // por defecto no hace nada

  method estaEn(unaPosicion) = game.onSameCell(position, unaPosicion)

  method interceptarPelota() { juego.retirarPelota() }
}
class Defensor inherits Rival {
  const pais
  override method image() = "defensor" + pais + ".png"

  override method mover() {
    const distanciaX = messi.position().x() - position.x()
    const distanciaY = messi.position().y() - position.y()
    if (distanciaX.abs() >= distanciaY.abs())
    position = position.right(self.pasoHacia(distanciaX))
   else
    position = position.up(self.pasoHacia(distanciaY))
  }

  // 1 si Messi esta adelante, -1 si esta atras o 0 si esta en la misma linea 
  method pasoHacia(unaDistancia) = if (unaDistancia > 0) 1 else if (unaDistancia < 0) -1 else 0

  override method chocarCon(unJugador) {
    unJugador.perderVida()
    juego.reacomodarJugadores()
    juego.retirarPelota()
  }
}

class Arquero inherits Rival {
  const pais
  var direccion = 1
  var atajando = false
  const cronometroDeAtajada = new Cronometro(intervalo = 500)

  override method image() = 
    if (not atajando) "arquero" + pais + ".png"
    else if (direccion > 0) "atajadaDerecha" + pais + ".png"
    else "atajadaIzquierda" + pais + ".png"

  override method mover() {
    if (position.x() >= cancha.paloDerecho()) direccion = -1
    if (position.x() <= cancha.paloIzquierdo()) direccion = 1
    position = position.right(direccion)
  }

  override method volverAlInicio() {
    super() // Hace primero lo que hace Rival y después agrega lo propio
    direccion = 1
    self.dejarDeAtajar()
  }

  override method interceptarPelota() {
    super()
    atajando = true
    cronometroDeAtajada.reiniciar()
  }

  override method actualizar(unosMs) {
    if (atajando) cronometroDeAtajada.avanzar(unosMs, { self.dejarDeAtajar( ) })
    else super(unosMs)
  }

  method dejarDeAtajar() { atajando = false} 

}

class BarraSancor inherits Rival {
  override method image() = "barraSancor.png"

  override method mover() {
    if (position.y() == cancha.filaDelArco()) position = position.up(1)
    else position = position.down(1)
  }

  override method estaEn(unaPosicion) = 
    unaPosicion.y() == position.y() and unaPosicion.x().between(cancha.paloIzquierdo(), cancha.paloDerecho())

}

object pelota {
  var property position = game.at(5, 0)
  var origen = game.at(5, 0)
  var destinoX = 5
  var enVuelo = false
  const cronometro = new Cronometro(intervalo = 150)

  method image() = "pelota.png"

  method enVuelo() = enVuelo

  method actualizar(unosMs) {
    if (enVuelo) cronometro.avanzar(unosMs, { self.avanzar() })
  }

  method lanzar(unOrigen, unaColumnaDestino) {
    origen = unOrigen
    position = unOrigen
    destinoX = unaColumnaDestino
    enVuelo = true
    cronometro.reiniciar()
  }

  method avanzar() {
    if (enVuelo and position.y() < cancha.filaDelArco()) {
      const nuevaY = position.y() + 1
      const progreso = (nuevaY - origen.y()) / (cancha.filaDelArco() - origen.y())
      position = game.at((origen.x() + (destinoX - origen.x()) * progreso).round(), nuevaY)
    }
  }

  method detener() { enVuelo = false }
  
  method llegoAlArco() = position.y() == cancha.filaDelArco()
}

object mira {
  var objetivoX = 5
  method position() = game.at(objetivoX, cancha.filaDelArco())

  method image() = "mira.png"

  method objetivoX() = objetivoX

  method apuntarIzquierda() { objetivoX = (objetivoX - 1).max(cancha.paloIzquierdo()) }
  method apuntarDerecha() { objetivoX = (objetivoX + 1).min(cancha.paloDerecho()) }

  method reiniciar() { objetivoX = 5 }
}
