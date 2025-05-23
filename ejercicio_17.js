const http = require('node:http')
const fs = require('node:fs/promises')
const mysql = require('mysql2/promise')

async function conectarMysql() {
    const conexion = await mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: '',
        database: 'base1'
    })
    await conexion.connect()
    return conexion
}

const mime = {
    'html': 'text/html',
    'css': 'text/css',
    'jpg': 'image/jpg',
    'ico': 'image/x-icon',
    'mp3': 'audio/mpeg3',
    'mp4': 'video/mp4'
}

const servidor = http.createServer((pedido, respuesta) => {
    const url = new URL('http://localhost:8888' + pedido.url)
    let camino = 'public' + url.pathname
    if (camino == 'public/')
        camino = 'public/index.html'
    encaminar(pedido, respuesta, camino)
    })
    servidor.listen(8888)
    async function encaminar(pedido, respuesta, camino) {
        switch (camino) {
            case 'public/creartabla': {
                crear(respuesta)
                break
            }
            case 'public/alta': {
                alta(pedido, respuesta)
                break
            }
            case 'public/listado': {
                listado(respuesta)
                break
            }
            case 'public/consultaporcodigo': {
                consulta(pedido, respuesta)
                break
            }
            default: {
                try {
                    contenido = await fs.readFile(camino)
                    const vec = camino.split('.')
                    const extension = vec[vec.length - 1]
                    const mimearchivo = mime[extension]
                    respuesta.writeHead(200, { 'Content-Type': mimearchivo })
                    respuesta.write(contenido)
                    respuesta.end()
                    } catch (error) {
                        paginaError(respuesta, "Pagina inexistente")
                    }
                }
            }
        }
        async function crear(respuesta) {
            try {
                const conexion = await conectarMysql()
                await conexion.query('drop table if exists articulos')
                await conexion.query(`create table articulos (
                    codigo int primary key auto_increment,
                    descripcion varchar(50),
                    precio float
                )`)
                respuesta.writeHead(200, { 'Content-Type': 'text/html' })
                respuesta.write(`<!doctype html><html><head></head><body>
                Se creo la tabla<br><a href="index.html">Retornar</a></body></html>`)
                respuesta.end()
                conexion.end()
                } catch (error) {
                    paginaError(respuesta, "Problemas en la creacion de la tabla")
                }
            }
            async function alta(pedido, respuesta) {
                let info = ''
                pedido.on('data', datosparciales => {
                    info += datosparciales;
                })
                pedido.on('end', async () => {
                     const formulario = new URLSearchParams(info)
                    const registro = {
                        descripcion: formulario.get('descripcion'),
                        precio: formulario.get('precio')
                    }
                    const conexion = await conectarMysql()
                    await conexion.query('insert into articulos set ?', registro)
                    respuesta.writeHead(200, { 'Content-Type': 'text/html' })
                    respuesta.write(`<!doctype html><html><head></head><body>
                    Se cargo el articulo<br><a href="index.html">Retornar</a></body></html>`)
                    respuesta.end()
                    conexion.end()
                    }
                )
            }
            async function listado(respuesta) {
                const conexion = await conectarMysql()
                const [filas] = await conexion.query('select codigo,descripcion,precio from articulos')
                respuesta.writeHead(200, { 'Content-Type': 'text/html' })
                let datos = ''
                for (let f = 0; f < filas.length; f++) {
                    datos += 'Codigo:' + filas[f].codigo + '<br>'
                    datos += 'Descripcion:' + filas[f].descripcion + '<br>'
                    datos += 'Precio:' + filas[f].precio + '<hr>'
                }
                respuesta.write('<!doctype html><html><head></head><body>')
                respuesta.write(datos)
                respuesta.write('<a href="index.html">Retornar</a>')
                respuesta.write('</body></html>')
                respuesta.end()
                conexion.end()
            }
            function consulta(pedido, respuesta) {
                let info = ''
                pedido.on('data', datosparciales => {
                    info += datosparciales
                })
                pedido.on('end', async () => {
                    const formulario = new URLSearchParams(info)
                    const dato = [formulario.get('codigo')]
                    const conexion = await conectarMysql()
                    const [filas] = await conexion.query('select descripcion,precio from articulos where codigo=?', dato)
                    respuesta.writeHead(200, { 'Content-Type': 'text/html' })
                    let datos = ''
                    if (filas.length > 0) {
                        datos += 'Descripcion:' + filas[0].descripcion + '<br>'
                        datos += 'Precio:' + filas[0].precio + '<hr>'
                    } else {
                        datos = 'No existe un artículo con dicho codigo.'
                    }
                    respuesta.write('<!doctype html><html><head></head><body>')
                    respuesta.write(datos)
                    respuesta.write('<a href="index.html">Retornar</a>')
                    respuesta.write('</body></html>')
                    respuesta.end()
                    conexion.end()
                })
            }
            function paginaError(respuesta, error) {
                respuesta.writeHead(200, { 'Content-Type': 'text/html' })
                respuesta.write(`<!doctype html><html><head></head><body>
                ${error}</body></html>`)
                respuesta.end()
            }
console.log('Servidor web iniciado')