import wollok.game.*
import pantalla.*
import jugadores.*
import items.*
import partido.*
import estados.*

object juego {
  var partido = new Partido()
  const defensor = new Defensor(posicionInicial = game.at(7, 3), intervaloDeMovimiento = 650)
  const arquero = new Arquero(posicionInicial = game.at(5, cancha.filaDelArco()), intervaloDeMovimiento = 900)
  var estado = inicio
  const mensajeInicial = "A / D: apuntar | Espacio: patear"
  var mensaje = mensajeInicial

  method goles() = partido.goles()
  method golesParaGanar() = partido.golsParaGanar()
  method mensaje() = mensaje
  method enCurso() = estado.permiteJugar()
  method puedeActuar() = self.enCurso() and not pelota.enVuelo()
  method rivales() = [defensor, arquero]
  method items() = [mate, copaDelMundo]
  method participantes() = [messi] + self.rivales() + self.items() + [pelota]

method cambiarEstado(unEstado) {
    estado = unEstado
    estado.mostrar()
}

  method mostrarPantallaInicio() {
    self.detenerPartido()
    self.cambiarEstado(inicio)
  }

  method aceptar() { estado.aceptar() }
  
  method iniciar() {
      self.detenerPartido()
      partido = new Partido()
      messi.reiniciar()
      self.rivales().forEach({ unRival => unRival.volverAlInicio() })
      mira.reiniciar()
      mensaje = mensajeInicial 
      self.cambiarEstado(jugando)
      [messi, defensor, arquero, mira, marcador, ayuda].forEach({ visual => game.addVisual(visual) })
      game.onTick(50, "partido", { self.actualizar(50) })
    
  }

  method configurarTeclado() {
    keyboard.enter().onPressDo { self.aceptar() }
    keyboard.r().onPressDo { self.mostrarPantallaInicio() }
    keyboard.up().onPressDo { if (self.puedeActuar()) messi.moverArriba() }
    keyboard.down().onPressDo { if (self.puedeActuar()) messi.moverAbajo() }
    keyboard.left().onPressDo { if (self.puedeActuar()) messi.moverIzquierda() }
    keyboard.right().onPressDo { if (self.puedeActuar()) messi.moverDerecha() }
    keyboard.a().onPressDo { if (self.puedeActuar()) mira.apuntarIzquierda() }
    keyboard.d().onPressDo { if (self.puedeActuar()) mira.apuntarDerecha() }
    keyboard.space().onPressDo { self.patear() }
  }

  method patear() {
    if (self.puedeActuar()) {
      pelota.lanzar(messi.position(), mira.objetivoX())
      game.addVisual(pelota)
      mensaje = "Pelota en juego..."
    }
  }

  method actualizar(unosMs) {
    if (self.enCurso()) {
      self.participantes().forEach({ unParticipante => unParticipante.actualizar(unosMs) })
      self.revisarContactos()
      if (self.enCurso()) self.revisarPelota()
    }
  }

  method revisarContactos() {
    // Polimorfismo: mismo mensaje, distintos efectos.
    
    [defensor, mate, copaDelMundo].forEach({ unObjeto =>
        if (self.enCurso() and game.hasVisual(unObjeto) and game.onSameCell(messi.position(), unObjeto.position())) {
            unObjeto.chocarCon(messi)
            if (messi.estaSinVidas()) self.terminarCon(derrota)
    }
  })
  }

  method revisarPelota() {
     self.rivales().forEach({ unRival =>
    if (pelota.enVuelo() and unRival.estaEn(pelota.position())) unRival.interceptarPelota()
  })
  if (pelota.enVuelo() and pelota.llegoAlArco()) self.registrarGol()
  }

  method registrarGol() {
    partido.registrarGol()
    self.interrumpirJugada("GOOOL! A / D para apuntar otra vez")
    if (partido.gano()) self.terminarCon(campeon)
}

  method fallarTiro(unMotivo) {
    self.interrumpirJugada(unMotivo + ". Cambia la mira y proba de nuevo. ")
  }

  method interrumpirJugada(unMotivo) {
    self.retirarPelota()
    mensaje = unMotivo
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
    if (self.enCurso()) {
      self.detenerPartido()
      self.cambiarEstado(unEstado)
    }
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
