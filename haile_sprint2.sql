# Tasca S2.01. Nivel 1 - Exercici 1: "Mostra totes les transaccions realitzades per empreses d'Alemanya."

SELECT transaction.id Transacciones_Compañías_Alemanas
FROM transaction
WHERE company_id IN (
	SELECT company.id
    FROM company
    WHERE country = "germany");
    
    
# Tasca S2.01. Nivel 1 - Exercici 2: "Màrqueting està preparant alguns informes de tancaments de gestió, et demanen que els passis un llistat de les empreses  
# que han realitzat transaccions per una suma superior a la mitjana de totes les transaccions"

SELECT  company.company_name  AS Compañías_con_Transacciones_Superiores
FROM company
WHERE company.id IN (
	SELECT transaction.company_id
    FROM transaction
    WHERE amount > (
		SELECT AVG(amount)
        FROM transaction));
        
# Tasca S2.01. Nivel 1 - Exercici 3: El departament de comptabilitat va perdre la informació de les transaccions realitzades per una empresa, 
#  però no recorden el seu nom, només recorden que el seu nom iniciava amb la lletra c.
# Com els pots ajudar? Comenta-ho acompanyant-ho de la informació de les transaccions. 

SELECT company_name AS Compañía, transaction.id AS Transacción, credit_card_id AS Tarjeta_Utilizada, user_id AS Usuario, amount AS Importe, timestamp AS Fecha_Operación, declined AS Declinada
FROM transaction
JOIN company
ON transaction.company_id = company.id
WHERE company.company_name IN (
	SELECT company.company_name
    FROM company
    WHERE company.company_name LIKE ("C%"));
   
# Tasca S2.01. Nivel 1 - Exercici 4:" Van eliminar del sistema les empreses que no tenen transaccions registrades, lliura el llistat d'aquestes empreses.

SELECT company.company_name AS Empresas_sin_operaciones
FROM company
WHERE NOT EXISTS (
	SELECT *
    FROM transaction
    WHERE company.id = transaction.company_id);

# Tasca S2.01. Nivel 2 - Exercici 1: "En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer 
# competència a la companyia "Non Institute". Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan
# situades en el mateix país que aquesta companyia."

SELECT company.company_name, transaction.*
FROM transaction
JOIN company
ON transaction.company_id = company.id 
WHERE company.country IN (
				SELECT company.country
                FROM company
                WHERE company.company_name = "Non Institute");

# Tasca S2.01. Nivel 2 - Exercici 2:  "El departament de comptabilitat necessita que trobis l'empresa que ha realitzat la transacció de major
# suma en la base de dades."

SELECT company_name AS Compañía_con_transacción_mayor_importe
FROM company
WHERE company.id = (
	SELECT company_id
    FROM transaction
    ORDER BY amount DESC LIMIT 1);
    
# Tasca S2.01 Nivel 3 - Exercici 1: "S'estan establint els objectius de l'empresa per al següent trimestre, per la qual cosa necessiten una base
# sòlida per a avaluar el rendiment i mesurar l'èxit en els diferents mercats. Per a això, necessiten el llistat dels països la mitjana de transaccions
# dels quals sigui superior a la mitjana general.

# Consulta realizada tomando en cuenta la mediana del importe de las operaciones ("amount")

SELECT country AS Países, ROUND(AVG(amount), 2) AS Importe_Transacciones_Medias
FROM company 
JOIN transaction  ON company.id = transaction.company_id
GROUP BY country

HAVING AVG(amount) > (
         SELECT AVG(amount)
		 FROM transaction
                     ) 
ORDER BY Importe_Transacciones_Medias DESC ;

# LISTADO DE PAISES CUYA MEDIA DE (AMOUNT) ES SUPERIOR AL  PROMEDIO (232.21) Y HACIENDO AGRUPACION POR PAIS EN SUBCONSULTA

SELECT country AS Países, ROUND(AVG(amount), 2) AS Importe_Transacciones_Medias
FROM company 
JOIN transaction  ON company.id = transaction.company_id
GROUP BY country
HAVING AVG(amount) > (
        SELECT AVG(transacciones)
        FROM ( SELECT country, AVG(amount) AS transacciones
            FROM company 
            JOIN transaction  ON company.id = transaction.company_id
            GROUP BY country) AS medianas
    )
ORDER BY Importe_Transacciones_Medias DESC;

# Consulta realizada tomando en cuenta la mediana de las transacciones/operaciones(id) NO de los importes (amount)

SELECT country AS Países, COUNT(transaction.id) AS Operaciones_Medias
FROM company 
JOIN transaction ON company.id = transaction.company_id
GROUP BY country
HAVING COUNT(transaction.id) > ( SELECT AVG(transacciones) FROM (
            SELECT country, COUNT(transaction.id) AS transacciones
            FROM company
            JOIN transaction ON company.id = transaction.company_id
            GROUP BY country ) AS medianas
    )
ORDER BY Operaciones_Medias DESC;

# Tasca S2.01 Nivel 3 - Exercici 2: Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, per la qual cosa et demanen la informació
# sobre la quantitat de transaccions que realitzen les empreses, però el departament de recursos humans és exigent i vol un llistat de les empreses
# on especifiquis si tenen més de 4 transaccions o menys."

SELECT company.company_name AS Compañía, COUNT(transaction.id) AS Cantidad_Operaciones,
CASE 
WHEN COUNT(transaction.id) >= 4 THEN "Tiene 4 o más operaciones"
ELSE "Tiene menos de 4 operaciones"
END AS Filtro_Operaciones
FROM company
JOIN transaction
ON company.id = transaction.company_id
GROUP BY company.id
ORDER BY COUNT(transaction.id) DESC
;

