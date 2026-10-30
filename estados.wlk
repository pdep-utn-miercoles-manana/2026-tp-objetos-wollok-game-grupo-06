import wollok.game.*
import juego.*
import pantalla.*

class PantallaDeEspera {
    const imagen
    method mostrar() { pantallas.mostrarFondo(imagen) }
    method permiteJugar() = false
    method aceptar()
}

object inicio inherits PantallaDeEspera(imagen = "inicio.png") {
    override method aceptar () { juego.cambiarEstado(introduccion) }
}

object introduccion inherits PantallaDeEspera(imagen = "cancha.png") { //CAMBIAR
  override method aceptar() { juego.iniciar() }
}

object derrota inherits PantallaDeEspera(imagen = "inicio.png") { //CAMBIAR
  override method aceptar() { juego.iniciar() }
}

object campeon inherits PantallaDeEspera(imagen = "inicio.png") { //CAMBIAR
  override method aceptar() { juego.mostrarPantallaInicio() }
}

object jugando {
  method mostrar() { pantallas.mostrarFondo("cancha.png") }
  method aceptar() { }
  method permiteJugar() = true
}