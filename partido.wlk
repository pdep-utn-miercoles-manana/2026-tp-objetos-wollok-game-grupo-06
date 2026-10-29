// Reglas de cuartos, independientes del dibujo y del teclado.
class Partido {
  const property golesParaGanar = 3
  const property fallosMaximos = 3
  var goles = 0
  var fallos = 0

  method goles() = goles
  method fallos() = fallos
  method gano() = goles >= golesParaGanar
  method perdio() = fallos >= fallosMaximos
  method termino() = self.gano() or self.perdio()

  method registrarGol() {
    if (not self.termino()) goles += 1
  }
  method registrarFallo() {
    if (not self.termino()) fallos += 1
  }
  method reiniciar() {
    goles = 0
    fallos = 0
  }
}
