import wollok.game.*
import juego.*
import pantalla.*
import cronometro.*

class PantallaDeEspera {
    const imagen
    method mostrar() { pantallas.mostrarFondo(imagen) }
    method permiteJugar() = false
    method aceptar()
    method actualizar(unosMs) {}
    method reintentar() {} // r por defecto no hace nada
}

object inicio inherits PantallaDeEspera(imagen = "inicio.png") {
    override method aceptar () { juego.cambiarEstado(introduccion) }
}

object introduccion inherits PantallaDeEspera(imagen = "introduccion.png") { 
  override method aceptar() { juego.iniciar() }
}

object derrota inherits PantallaDeEspera(imagen = "derrota.png") { 
  override method aceptar() {}
  override method reintentar() { juego.cambiarEstado(introduccion) }
}

object campeon inherits PantallaDeEspera(imagen = "campeon.png") { 
  override method aceptar() { juego.mostrarPantallaInicio() }
}

object jugando {
  method mostrar() { pantallas.mostrarFondo("cancha.png") }
  method aceptar() { }
  method permiteJugar() = true
  method actualizar(unosMs) { juego.actualizarPartido(unosMs) }
  method reintentar() {}
}

object nivel1Superado inherits PantallaDeEspera(imagen = "nivel1Superado.png") {
    override method aceptar() { juego.iniciar() }
} // Por ahora vuelve a arrancar el nivel 1 hasta que agreguemos nivel 2

object festejo {    // Muestra el cartel GOL un momento pero mientras tanto no se juega
  const cronometro = new Cronometro(intervalo = 1500)

  method mostrar() {
    cronometro.reiniciar()
    game.addVisual(cartelDeGol)
  }

  method aceptar() { }

  method permiteJugar() = false

  method actualizar(unosMs) { cronometro.avanzar(unosMs, { juego.terminarFestejo() }) }

  method reintentar() {}
}