import wollok.game.*
import juego.*
import pantalla.*

object inicio {
    method mostrar() { pantallas.mostrarInicio() }

    method aceptar { juego.cambiarEstado(introduccion) }

    method permiteJugar() = false
}

object introduccion {
  method mostrar() { pantallas.mostrarIntroduccion() }

  method aceptar() { juego.iniciar() }

  method permiteJugar() = false
}

object jugando {
  method mostrar() { pantallas.mostrarCancha() }

  method aceptar() { }

  method permiteJugar() = true
}

object victoria {
    method mostrar() { pantallas.mostrarResultado("victoria.png") }

    method aceptar() { juego.iniciar() }

    method permiteJugar() = false
}

object derrota {
  method mostrar() { pantallas.mostrarResultado("derrota.png") }

  method aceptar() { juego.iniciar() }
  
  method permiteJugar() = false
}