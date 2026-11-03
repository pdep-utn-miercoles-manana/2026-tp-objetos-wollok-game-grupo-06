import wollok.game.*
import pantalla.*
import jugadores.*
import items.*
import partido.*
import estados.*
import niveles.*

object juego {
  var partido = new Partido()
  var nivel = cuartos
  var rivales = []
  var estado = inicio

  method goles() = partido.goles()
  method enCurso() = estado.permiteJugar()
  method puedeActuar() = self.enCurso() and not pelota.enVuelo()
  method rivales() = rivales
  method items() = [mate, copaDelMundo]
  method participantes() = [messi, indicadorMate, indicadorVidaPerdida] + self.rivales() + self.items() + [pelota]

  method cambiarEstado(unEstado) {
    estado = unEstado
    estado.mostrar()
 }

  method mostrarPantallaInicio() {
    self.detenerPartido()
    self.cambiarEstado(inicio)
  }

  method aceptar() { estado.aceptar() }

  method iniciarJuego() {
    messi.reiniciar()
    self.iniciarNivel(cuartos)
  }

  method iniciarNivel(unNivel) {
    self.detenerPartido()
    nivel = unNivel
    partido = new Partido()
    rivales = unNivel.crearRivales()
    messi.volverAlInicio()
    mira.reiniciar()
    self.cambiarEstado(jugando)
    ([messi, mira, marcadorDeGoles, marcadorDeVidas] + rivales).forEach({ unVisual => game.addVisual(unVisual) })
    game.onTick(50, "partido", { self.actualizar(50) })
  }

  method configurarTeclado() {
    keyboard.enter().onPressDo { self.aceptar() }
    keyboard.r().onPressDo { estado.reintentar() }
    keyboard.up().onPressDo { if (self.enCurso()) messi.moverArriba() }
    keyboard.down().onPressDo { if (self.enCurso()) messi.moverAbajo() }
    keyboard.left().onPressDo { if (self.enCurso()) messi.moverIzquierda() }
    keyboard.right().onPressDo { if (self.enCurso()) messi.moverDerecha() }
    keyboard.a().onPressDo { if (self.puedeActuar()) mira.apuntarIzquierda() }
    keyboard.d().onPressDo { if (self.puedeActuar()) mira.apuntarDerecha() }
    keyboard.space().onPressDo { self.patear() }
  }

  method patear() {
    if (self.puedeActuar()) {
      pelota.lanzar(messi.position(), mira.objetivoX())
      game.addVisual(pelota)
    }
  }

  method actualizar(unosMs) { estado.actualizar(unosMs) }

  method actualizarPartido(unosMs) {
      self.participantes().forEach({ unParticipante => unParticipante.actualizar(unosMs) })
      self.revisarContactos()
      if (self.enCurso()) self.revisarPelota()
  }

  method revisarContactos() {
    // Polimorfismo: mismo mensaje, distintos efectos.
    
    (self.rivales() + self.items()).forEach({ unObjeto =>
        if (self.enCurso() and game.hasVisual(unObjeto) and game.onSameCell(messi.position(), unObjeto.position())) {
            unObjeto.chocarCon(messi)
            self.revisarDerrota()
    }
  })
  }

  method revisarPelota() {
     self.rivales().forEach({ unRival =>
    if (pelota.enVuelo() and unRival.estaEn(pelota.position())) unRival.interceptarPelota()
    })
    self.revisarDerrota()
    if (pelota.enVuelo() and pelota.llegoAlArco()) self.registrarGol()
  }

  method registrarGol() {
    partido.registrarGol()
    self.retirarPelota()
    self.cambiarEstado(festejo)
}

  method terminarFestejo() {
    game.removeVisual(cartelDeGol)
    if (partido.gano()) self.terminarCon(nivel.pantallaAlGanar()) else self.reanudar()
}

method reanudar() {
  self.reacomodarJugadores()
  estado = jugando
  }

  method retirarPelota() {
    pelota.detener()
    if (game.hasVisual(pelota)) game.removeVisual(pelota)
  }

  method detenerPartido() {
    game.removeTickEvent("partido")
    self.retirarPelota()
    self.items().forEach({ unItem => unItem.reiniciar() })
  }

  method terminarCon(unEstado) {
      self.detenerPartido()
      self.cambiarEstado(unEstado)
  }

  method reacomodarJugadores() {
    messi.volverAlInicio()
    self.rivales().forEach({ unRival => unRival.volverAlInicio( )})
  }

  method revisarDerrota() {
    if (messi.estaSinVidas()) self.terminarCon(derrota)
  }
}

object cancha {
    // Definimos valores para no olvidarnos que significan en el resto del codigo
    method ultimaColumna() = game.width() - 1
    method filaDelPenal() = 4
    method filaDelArco() = 6
    method paloIzquierdo() = 3
    method paloDerecho() = 8

    method esJugable(unaPosicion) = unaPosicion.x().between(0, self.ultimaColumna()) and unaPosicion.y().between(0, self.filaDelPenal())

    method posicionesLibresParaItems() {
    const posiciones = []
    (0..self.ultimaColumna()).forEach({ unaColumna =>
    (0..self.filaDelPenal()).forEach({ unaFila => posiciones.add(game.at(unaColumna, unaFila)) })
    })
    return posiciones.filter({ unaPosicion => self.estaLibre(unaPosicion) })
    }

    method estaLibre(unaPosicion) = 
        not game.allVisuals().any({ unVisual => game.onSameCell(unaPosicion, unVisual.position()) })

}
