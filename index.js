const config = require('./config.js');
const fs = require('fs').promises;
const { Client } = require('pg');

async function generaReporte(tipoReporte)
{
    let retorno = {
        code: null,
        message: null,
        data: null
    };

    try
    {
        // Obtenemos query del Reporte Resumido
        const sQueryReporte = await fs.readFile("sql/generaReporteResumen.sql", "binary");

        // Inicializamos nuevo cliente PostgreSQL
        const pgclient = new Client(config.connectionData());

        // Abrimos conexión
        await pgclient.connect();

        // Ejecutamos query
        switch(tipoReporte)
        {
            case "resumido":
                retorno.data = await pgclient.query(sQueryReporte);
                break;
            case "otro":
                break;
        }

        // Cerramos conexión
        await pgclient.end();

        // Agregamos retorno
        retorno.code = 0;
        retorno.message = "OK"
    }
    catch(err)
    {
        // Parseamos error
        let er = JSON.parse(JSON.stringify(err, Object.getOwnPropertyNames(err)));

        // Agregamos retorno
        retorno.data = er;
        retorno.code = -1;
        retorno.message = "Error generaReporte(): " + er.message;
    }

    return retorno;
}

/*
generaReporte("resumido").then(value => {
    console.log(value);
  }).catch(err => {
    console.log(err);
  });
*/