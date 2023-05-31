SELECT 
	("createdAt" AT TIME zone 'America/Mazatlan')::DATE AS "FECHA", 
	COUNT(CASE WHEN flag = 0 THEN flag END) AS "ENC ENVIADAS",
	COUNT(CASE WHEN flag = 1 AND respuesta BETWEEN 1 AND 5 THEN flag END) AS "ENC CONTESTADAS",
	(COUNT(CASE WHEN flag = 1 AND respuesta BETWEEN 1 AND 5 THEN 1 END)::FLOAT / COUNT(CASE WHEN flag = 0 THEN 0 END)::FLOAT)::decimal(5,4) AS "PROM DE CONTESTACIÓN",
	COUNT(CASE WHEN respuesta = 1 THEN respuesta END) + (COUNT(CASE WHEN respuesta = 2 THEN respuesta END) * 2) + (COUNT(CASE WHEN respuesta = 3 THEN respuesta END) * 3) + (COUNT(CASE WHEN respuesta = 4 THEN respuesta END) * 4) + (COUNT(CASE WHEN respuesta = 5 THEN respuesta END) * 5) AS "PUNT TOTAL OBTENIDA",
	COUNT(CASE WHEN flag = 1 AND respuesta BETWEEN 1 AND 5 THEN flag END) * 5 AS "PUNT TOTAL IDEAL",
	(((COUNT(CASE WHEN respuesta = 1 THEN respuesta END) + (COUNT(CASE WHEN respuesta = 2 THEN respuesta END) * 2) + (COUNT(CASE WHEN respuesta = 3 THEN respuesta END) * 3) + (COUNT(CASE WHEN respuesta = 4 THEN respuesta END) * 4) + (COUNT(CASE WHEN respuesta = 5 THEN respuesta END) * 5)) * 100)::FLOAT / (COUNT(CASE WHEN flag = 1 AND respuesta BETWEEN 1 AND 5 THEN flag END) * 5)::FLOAT)::NUMERIC(18,2)  AS "CALIFI PROM (SOBRE 100)",
	COUNT(CASE WHEN respuesta = 1 THEN respuesta END) AS "⭐",
	COUNT(CASE WHEN respuesta = 2 THEN respuesta END) AS "⭐⭐",
	COUNT(CASE WHEN respuesta = 3 THEN respuesta END) AS "⭐⭐⭐",
	COUNT(CASE WHEN respuesta = 4 THEN respuesta END) AS "⭐⭐⭐⭐",
	COUNT(CASE WHEN respuesta = 5 THEN respuesta END) AS "⭐⭐⭐⭐⭐",
	COUNT(CASE WHEN sugerencia IS NOT NULL THEN 1 END) AS "Comentarios"
		FROM (
			SELECT *, 0::SMALLINT AS flag FROM resultado_encuesta
			WHERE ("createdAt" AT TIME zone 'America/Mazatlan')::DATE BETWEEN TO_CHAR(CURRENT_DATE, 'YYYY-MM-01')::DATE AND ((TO_CHAR(CURRENT_DATE, 'YYYY-MM-01')::DATE + INTERVAL '1 month') - INTERVAL '1 day')::DATE
				AND encuesta = 10
				AND respuesta = 0
				AND pregunta NOT IN (1,2)
			UNION ALL
			SELECT *, 1::SMALLINT AS flag FROM resultado_encuesta
			WHERE ("createdAt" AT TIME zone 'America/Mazatlan')::DATE BETWEEN TO_CHAR(CURRENT_DATE, 'YYYY-MM-01')::DATE AND ((TO_CHAR(CURRENT_DATE, 'YYYY-MM-01')::DATE + INTERVAL '1 month') - INTERVAL '1 day')::DATE
				AND encuesta = 10
				AND respuesta BETWEEN 0 AND 5) t1
	GROUP BY ("createdAt" AT TIME zone 'America/Mazatlan')::DATE;