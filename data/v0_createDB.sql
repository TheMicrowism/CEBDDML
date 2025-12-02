CREATE TABLE V0_LesSportifsEQ
(
  numSp NUMBER(4) PRIMARY KEY,
  nomSp VARCHAR2(20),
  prenomSp VARCHAR2(20),
  pays VARCHAR2(20),
  categorieSp VARCHAR2(10),
  dateNaisSp DATE,
  CONSTRAINT SP_CK1 CHECK(numSp > 0),
  CONSTRAINT SP_CK2 CHECK(categorieSp IN ('feminin','masculin'))
);

CREATE TABLE V0_LesEpreuves
(
  numEp NUMBER(3),
  nomEp VARCHAR2(20),
  formeEp VARCHAR2(13),
  nomDi VARCHAR2(25),
  categorieEp VARCHAR2(10),
  nbSportifsEp NUMBER(2),
  dateEp DATE,
  CONSTRAINT EP_PK PRIMARY KEY (numEp),
  CONSTRAINT EP_CK1 CHECK (formeEp IN ('individuelle','par equipe','par couple')),
  CONSTRAINT EP_CK2 CHECK (categorieEp IN ('feminin','masculin','mixte')),
  CONSTRAINT EP_CK3 CHECK (numEp > 0),
  CONSTRAINT EP_CK4 CHECK (nbSportifsEp > 0)
);

CREATE TABLE LesParticipantsIndi
(
  numSp NUMBER(4),
  FOREIGN KEY(numSp) REFERENCES V0_LesSportifsEQ(numSp)
);

CREATE TABLE LesParticipantsEq
(
  numSp NUMBER(4),
  numEq NUMBER(4) NOT NULL,
  FOREIGN KEY(numSp) REFERENCES V0_LesSportifsEQ(numSp),
  CONSTRAINT LPE_CK1 CHECK(numEq > 0)
);

CREATE TABLE ParticiperAIndi
(
  numSp NUMBER(4),
  numEp NUMBER(3),
  medaille VARCHAR2(7),
  CONSTRAINT PAI_CK1 CHECK (medaille IN ('gold', 'silver','bronze','null')),
  FOREIGN KEY(numSp) REFERENCES LesParticipantsIndi(numSp),
  FOREIGN KEY(numEp) REFERENCES V0_LesEpreuves(numEp)
);

CREATE TABLE ParticiperAEq
(
  numEq NUMBER(4),
  numEp NUMBER(3),
  medaille VARCHAR2(7),
  CONSTRAINT PAI_CK1 CHECK (medaille IN ('gold', 'silver','bronze','null')),
  FOREIGN KEY(numEq) REFERENCES LesParticipantsEq(numEq),
  FOREIGN KEY(numEp) REFERENCES V0_LesEpreuves(numEp)
);