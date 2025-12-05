import sqlite3, pandas
from sqlite3 import IntegrityError

# Fonction permettant de lire le fichier Excel des JO et d'insérer les données dans la base
def read_excel_file_V0(data:sqlite3.Connection, file):
    # Lecture de l'onglet du fichier excel LesSportifsEQ, en interprétant toutes les colonnes comme des strings
    # pour construire uniformement la requête
    df_sportifs = pandas.read_excel(file, sheet_name='LesSportifsEQ', dtype=str)
    df_sportifs = df_sportifs.where(pandas.notnull(df_sportifs), 'null')

    cursor = data.cursor()
    for ix, row in df_sportifs.iterrows():
        try:
            query = "insert into V0_LesSportifsEQ values ({},'{}','{}','{}','{}','{}')".format(
                row['numSp'], row['nomSp'], row['prenomSp'], row['pays'], row['categorieSp'], row['dateNaisSp'])
            # On affiche la requête pour comprendre la construction. A enlever une fois compris.
            print(query)
            cursor.execute(query)
        except IntegrityError as err:
            print(err)
        
        if row['numEq'] != 'null':
            try:
                query = "insert or ignore into LesParticipantsEq values ('{}')".format(
                    row['numEq'])
                # On affiche la requête pour comprendre la construction. A enlever une fois compris.
                print(query)
                cursor.execute(query)
                query = "insert into RepartitionEq values ('{}','{}')".format(
                    row['numSp'], row['numEq'])
                # On affiche la requête pour comprendre la construction. A enlever une fois compris.
                print(query)
                cursor.execute(query)
               
            except IntegrityError as err:
                print(err)

    # Lecture de l'onglet LesEpreuves du fichier excel, en interprétant toutes les colonnes comme des string
    # pour construire uniformement la requête
    df_epreuves = pandas.read_excel(file, sheet_name='LesEpreuves', dtype=str)
    df_epreuves = df_epreuves.where(pandas.notnull(df_epreuves), 'null')

    cursor = data.cursor()
    for ix, row in df_epreuves.iterrows():
        try:
            query = "insert into V0_LesEpreuves values ({},'{}','{}','{}','{}',{},".format(
                row['numEp'], row['nomEp'], row['formeEp'], row['nomDi'], row['categorieEp'], row['nbSportifsEp'])

            if row['dateEp'] != 'null':
                query = query + "'{}')".format(row['dateEp'])
            else:
                query = query + "null)"
            # On affiche la requête pour comprendre la construction. A enlever une fois compris.
            print(query)
            cursor.execute(query)
        except IntegrityError as err:
            print(f"{err} : \n{row}")
            
    #Inserer les inscriptions dans les tables ParticiperAEq et ParticiperAIndi, en mettant 'null' comme medaille.            
    df_inscriptions = pandas.read_excel(file, sheet_name='LesInscriptions', dtype=str)
    df_inscriptions = df_inscriptions.where(pandas.notnull(df_inscriptions), 'null')

    cursor = data.cursor()
    for ix, row in df_inscriptions.iterrows():
        #Voir si l'Inscription est d'une equipe ou un sportif individuel
        
        if len(row['numIn']) < 3:   #Cas equipe
            try:
                query = "insert into ParticiperAEq values ({},{},'null')".format(
                    row['numIn'], row['numEp'], 'null')
                # On affiche la requête pour comprendre la construction. A enlever une fois compris.
                print(query)
                cursor.execute(query)
            except IntegrityError as err:
                print(f"{err} : \n{row}")
        else:                   #Cas Individuelle
            try:
                query = "insert into ParticiperAIndi values ({},{},'null')".format(
                    row['numIn'], row['numEp'], 'null')
                # On affiche la requête pour comprendre la construction. A enlever une fois compris.
                print(query)
                cursor.execute(query)
            except IntegrityError as err:
                print(f"{err} : \n{row}")

    
    #Insertion des medailles
    df_medailles = pandas.read_excel(file, sheet_name='LesResultats', dtype=str)
    df_medailles = df_medailles.where(pandas.notnull(df_medailles), 'null')

    cursor = data.cursor()
    for ix, row in df_medailles.iterrows():
        if len(row['gold']) < 3:    #Cas Equipe
            try:
                query = "update ParticiperAEq set Medaille = 'gold' WHERE numEp = {} AND numEq = {}".format(
                    row['numEp'],row['gold'])
                print(query)
                cursor.execute(query)
                query = "update ParticiperAEq set Medaille = 'silver' WHERE numEp = {} AND numEq = {}".format(
                    row['numEp'],row['silver'])
                print(query)
                cursor.execute(query)
                query = "update ParticiperAEq set Medaille = 'bronze' WHERE numEp = {} AND numEq = {}".format(
                    row['numEp'],row['bronze'])
                print(query)
                cursor.execute(query)
            except IntegrityError as err:
                print(f"{err} : \n{row}")
        else:                   #Cas Individuelle
            try:
                query = "update ParticiperAIndi set Medaille = 'gold' WHERE numEp = {} AND numSp = {}".format(
                    row['numEp'],row['gold'])
                print(query)
                cursor.execute(query)
                query = "update ParticiperAIndi set Medaille = 'silver' WHERE numEp = {} AND numSp = {}".format(
                    row['numEp'],row['silver'])
                print(query)
                cursor.execute(query)
                query = "update ParticiperAIndi set Medaille = 'bronze' WHERE numEp = {} AND numSp = {}".format(
                    row['numEp'],row['bronze'])
                print(query)
                cursor.execute(query)
            except IntegrityError as err:
                print(f"{err} : \n{row}")
            
