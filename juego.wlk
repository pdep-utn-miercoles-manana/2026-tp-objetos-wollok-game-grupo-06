import wollok.game.*
import pantalla.*
import jugadores.*
import items.*
import partido.*

object juego {
  var partido = new Partido()
  const defensor = new Defensor()
  var estado = "inicio"
  var tiempoDefensor = 0
  var tiempoArquero = 0
  var tiempoPelota = 0
  var tiempoMate = 0
  var tiempoCopa = 0
  var mensaje = "A / D: apuntar | Espacio: patear"

  method goles() = partido.goles()
  method fallos() = partido.fallos()
  method mensaje() = mensaje
  method enCurso() = estado == "jugando"
  method puedeActuar() = self.enCurso() and not pelota.enVuelo()

  method mostrarPantallaInicio() {
    self.detenerPartido()
    estado = "inicio"
    pantallas.mostrarInicio()
  }

  method aceptar() {
    if (estado == "inicio") {
      estado = "introduccion"
      pantallas.mostrarIntroduccion()
    } else if (estado == "introduccion" or estado == "resultado") {
      self.iniciar()
    }
  }

  method iniciar() {
    if (not self.enCurso()) {
      self.detenerPartido()
      pantallas.mostrarCancha()
      partido = new Partido()
      messi.reiniciar()
      defensor.volverAlInicio()
      arquero.reiniciar()
      mira.reiniciar()
      tiempoDefensor = 0
      tiempoArquero = 0
      tiempoPelota = 0
      tiempoMate = 0
      tiempoCopa = 0
      mensaje = "A / D: apuntar | Espacio: patear"
      estado = "jugando"
      [messi, defensor, arquero, mira, marcador, ayuda].forEach({ visual => game.addVisual(visual) })
      game.onTick(50, "partido", { self.actualizar(50) })
    }
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
      tiempoPelota = 0
      game.addVisual(pelota)
      mensaje = "Pelota en juego..."
    }
  }

  method actualizar(milisegundos) {
    if (self.enCurso()) {
      messi.actualizar(milisegundos)
      mate.actualizar(milisegundos)
      tiempoDefensor += milisegundos
      tiempoArquero += milisegundos
      tiempoMate += milisegundos
      tiempoCopa += milisegundos
      if (tiempoDefensor >= 650) {
        defensor.mover()
        tiempoDefensor = 0
      }
      if (tiempoArquero >= 900) {
        arquero.mover()
        tiempoArquero = 0
      }
      self.revisarContactos()
      if (self.enCurso()) {
        self.actualizarDisparo(milisegundos)
        if (self.enCurso()) self.actualizarItems()
      }
    }
  }

  method actualizarItems() {
    if (tiempoMate >= 5000) {
      mate.aparecer()
      tiempoMate = 0
    }
    if (tiempoCopa >= 8000) {
      copaDelMundo.intentarAparecer()
      tiempoCopa = 0
    }
  }

  method revisarContactos() {
    // Polimorfismo: mismo mensaje, distintos efectos.
    
    [defensor, mate, copaDelMundo].forEach({ unObjeto =>
        if (self.enCurso() and game.hasVisual(unObjeto) and game.onSameCell(messi.position(), unObjeto.position())) {
            unObjeto.chocarCon(messi)
            if (messi.estaSinVidas()) self.terminar()
    }
  })
  }

  method actualizarDisparo(milisegundos) {
    if (pelota.enVuelo()) {
      // Revisar antes y despues detecta un rival que se movio hacia la pelota.
      self.revisarPelota()
      if (pelota.enVuelo()) {
        tiempoPelota += milisegundos
        if (tiempoPelota >= 150) {
          pelota.avanzar()
          tiempoPelota = 0
          self.revisarPelota()
        }
      }
    }
  }

  method revisarPelota() {
    if (game.onSameCell(pelota.position(), defensor.position())) {
      self.registrarFallo("El defensor bloqueo el tiro")
    } else if (game.onSameCell(pelota.position(), arquero.position())) {
      self.registrarFallo("El arquero atajo")
    } else if (pelota.llegoAlArco()) {
      partido.registrarGol()
      mensaje = "GOOOL! A / D para apuntar otra vez"
      self.retirarPelota()
      if (partido.gano()) self.terminar()
    }
  }

  method registrarFallo(unMotivo) {
    partido.registrarFallo()
    self.interrumpirJugada(unMotivo + ". Cambia la mira y proba de nuevo. ")
    if (partido.perdio()) self.terminar()
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
    mate.desaparecer()
    copaDelMundo.desaparecer()
  }

  method terminar() {
    if (self.enCurso()) {
      self.detenerPartido()
      estado = "resultado"
      pantallas.mostrarResultado(partido.gano(), partido.goles(), partido.fallos())
    }
  }
}

object cancha {
  method esJugable(posicion) = posicion.x().between(0, 11) and posicion.y().between(0, 4)
  method posicionesLibresParaItems() {
    const posiciones = []
    (0..11).forEach({ x =>
      (0..2).forEach({ y => posiciones.add(game.at(x, y)) })
    })
    return posiciones.filter({ posicion =>
      not game.allVisuals().any({ visual => game.onSameCell(posicion, visual.position()) })
    })
  }
}
