class Cronometro {
    const intervalo
    var acumulado = 0

    method avanzar(unosMs, unaAccion) {
        acumulado += unosMs
        if (acumulado >= intervalo) {
            acumulado = 0
            unaAccion.apply()
        }
    }

    method reiniciar() { acumulado = 0}
    
}