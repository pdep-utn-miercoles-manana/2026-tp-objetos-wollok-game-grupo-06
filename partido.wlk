// Reglas de cada nivel, independientes del dibujo y del teclado.
class Partido {
  const property golesParaGanar = 3
  var goles = 0
  
  method goles() = goles
  method gano() = goles >= golesParaGanar

  method registrarGol() {
    if (not self.gano()) goles += 1
  }
  
}
