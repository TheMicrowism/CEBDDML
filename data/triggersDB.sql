DROP TRIGGER IF EXISTS disqualification_Sp;/
CREATE TRIGGER disqualification_Sp
BEFORE DELETE ON V0_LesSportifsEQ
FOR EACH ROW
BEGIN
	
	DELETE FROM LesParticipantsEq
	WHERE numEq IN (SELECT numEq FROM RepartitionEq WHERE numSp = OLD.numSp);
	
	DELETE FROM ParticiperAEq
	WHERE numEq IN (SELECT numEq FROM RepartitionEq WHERE numSp = OLD.numSp);
	
	SELECT "SPORTIF SUPPRIME";
END;
/
DROP TRIGGER IF EXISTS disqualification_EP;/
CREATE TRIGGER disqualification_Ep
AFTER DELETE ON V0_LesSportifsEQ
FOR EACH ROW
BEGIN
	DELETE FROM V0_LesEpreuves
	WHERE numEp IN (SELECT numEp FROM (SELECT numEp, count(*) as nbParticipant FROM ParticiperAIndi GROUP BY numEp) WHERE nbParticipant < 3);
		
	DELETE FROM V0_LesEpreuves
	WHERE numEp IN (SELECT numEp FROM (SELECT numEp, count(*) as nbParticipant FROM ParticiperAEq GROUP BY numEp) WHERE nbParticipant < 3);
END;