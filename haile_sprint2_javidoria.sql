# Tasca S2.01. Nivel 1 - Exercici 1: "Mostra totes les transaccions realitzades per empreses d'Alemanya."

SELECT *
FROM transaction
WHERE company_id IN (
	SELECT company.id
    FROM company
    WHERE country = "germany");
    
    
# Tasca S2.01. Nivel 1 - Exercici 2: "Màrqueting està preparant alguns informes de tancaments de gestió, et demanen que els passis un llistat de les empreses  
# que han realitzat transaccions per una suma superior a la mitjana de totes les transaccions"

SELECT  *  
FROM company
WHERE company.id IN (
	SELECT company_id
    FROM transaction
    WHERE amount > (
		SELECT AVG(amount)
        FROM transaction));
        
/* Tasca S2.01. Nivel 1 - Exercici 3: El departament de comptabilitat va perdre la informació de les transaccions realitzades per una empresa, 
 però no recorden el seu nom, només recorden que el seu nom iniciava amb la lletra c.
Com els pots ajudar? Comenta-ho acompanyant-ho de la informació de les transaccions. */

# Alias por cuestiones estéticas y de compresión de la información proporcionada

SELECT (
	SELECT company_name 
	FROM company 
	WHERE company.id = transaction.company_id ) AS Compañia, 
transaction.* 
FROM transaction
WHERE company_id IN (
	SELECT id
    FROM company
    WHERE company_name LIKE ("C%"))
;
            
# Tasca S2.01. Nivel 1 - Exercici 4:" Van eliminar del sistema les empreses que no tenen transaccions registrades, lliura el llistat d'aquestes empreses.
   
# Alias por cuestiones estéticas y de compresión de la información proporcionada

SELECT id, company_name
FROM company
WHERE NOT EXISTS (
	SELECT company_id 
	FROM transaction
    )
    ;

/* Tasca S2.01. Nivel 2 - Exercici 1: "En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer 
 competència a la companyia "Non Institute". Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan
 situades en el mateix país que aquesta companyia.*/

# Alias por cuestiones estéticas y de compresión de la información proporcionada

SELECT (
	SELECT company_name 
    FROM company 
    WHERE company.id = transaction.company_id ) AS Compañías,
    transaction.*
FROM transaction
WHERE company_id IN (
				SELECT id 
                FROM company 
                WHERE country = (
					SELECT country FROM company
					WHERE company_name = "Non Institute"));


/* Tasca S2.01. Nivel 2 - Exercici 2:  "El departament de comptabilitat necessita que trobis l'empresa que ha realitzat la transacció de major
suma en la base de dades."*/

SELECT *
FROM company
WHERE company.id = (
	SELECT company_id
    FROM transaction
    ORDER BY amount DESC LIMIT 1);
    

    
# Tasca S2.01 Nivel 3 - Exercici 1: "S'estan establint els objectius de l'empresa per al següent trimestre, per la qual cosa necessiten una base
# sòlida per a avaluar el rendiment i mesurar l'èxit en els diferents mercats. Per a això, necessiten el llistat dels països la mitjana de transaccions
# dels quals sigui superior a la mitjana general.

SELECT company.country AS País, ROUND(AVG(transaction.amount), 2) AS Transacción_Media
FROM company, transaction
WHERE company.id = transaction.company_id
GROUP BY País
HAVING AVG(transaction.amount) > (
  SELECT AVG(amount)
  FROM transaction
)
ORDER BY Transacción_Media DESC
;


/* Tasca S2.01 Nivel 3 - Exercici 2: Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, per la qual cosa et demanen la informació
 sobre la quantitat de transaccions que realitzen les empreses, però el departament de recursos humans és exigent i vol un llistat de les empreses
on especifiquis si tenen més de 4 transaccions o menys."*/

# Alias por cuestiones estéticas y de compresión de la información proporcionada

SELECT company_name AS Compañía, COUNT(transaction.id) AS Cantidad_Operaciones, 
CASE 
	WHEN COUNT(transaction.id) >= 4 THEN "Tiene 4 o más operaciones"
	ELSE "Tiene menos de 4 operaciones"
	END AS Filtro_Operaciones
FROM company, transaction
WHERE company.id = transaction.company_id
GROUP BY company.id
ORDER BY Cantidad_Operaciones DESC
;

