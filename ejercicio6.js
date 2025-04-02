const fs = require('node:fs')
function leer(error, datos) { 
    if (error) 
        console.log(error) 
    else 
    console.log(datos.toString()
)}
fs.readFile('./archivo1.txt', leer)
console.log('última línea del programa')

