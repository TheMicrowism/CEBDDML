DROP VIEW IF EXISTS LesAgesSportifs;
CREATE VIEW LesAgesSportifs as
	SELECT 
		numSp, 
		nomSP, 
		prenomSp, 
		pays, 
		categorieSp, 
		dateNaisSp,
		(strftime('%Y', 'now') - strftime('%Y', dateNaisSp)) - (strftime('%m-%d', 'now') < strftime('%m-%d', dateNaisSp)) AS ageSp
	FROM
	V0_LesSportifsEQ;

DROP VIEW IF EXISTS LesNbsEquipiers;
CREATE VIEW LesNbsEquipiers as
	SELECT
		numEq,
		COUNT(*) AS nbEquipiersEq
	FROM
	RepartitionEq
	GROUP BY numEq;
	
DROP VIEW IF EXISTS AgeMoyEqOR;
CREATE VIEW AgeMoyEqOR AS
	SELECT 
		numEq, 
		AgeMoy
	FROM
		(SELECT 
			numEq, 
			CAST(AVG(ageSp) as INT) as AgeMoy 
		FROM 
			RepartitionEq 
		JOIN 
			LesAgesSportifs 
		USING 
			(numSp) 
		GROUP BY 
			numEq)
	JOIN 
		ParticiperAEq 
	USING 
		(numEq)
	WHERE 
		medaille = 'gold';
	
DROP VIEW IF EXISTS ClassementPays;
CREATE VIEW ClassementPays AS
	SELECT 
		pays, 
		SUM(medaille ='gold') AS nbOr, 
		SUM(medaille='silver') AS nbArgent, 
		SUM(medaille='bronze') AS nbBronze
	FROM
		(SELECT 
			pays,
			medaille
		FROM 
			ParticiperAIndi 
		JOIN 
			V0_LesSportifsEQ 
		USING 
			(numSp)
	UNION ALL
		SELECT 
			pays, 
			medaille
		FROM
			(SELECT 
				DISTINCT numEq, 
				pays
			FROM
				RepartitionEq 
			JOIN 
				V0_LesSportifsEQ 
			USING 
				(numSp))
		JOIN 
			ParticiperAEq 
		USING 
			(numEq))
		GROUP BY 
			pays;
	

