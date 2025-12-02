# **Projet: A propos de la Gestion des Jeux Olympiques**
# Duy Minh LE, 12315392

## 1. Conception UML et Normalisation

### Question 1  
On rappelle le schéma relationnel fourni:  
>**LesEpreuves** (numEp, nomEp, formeEp, categorieEp, nbSportifsEp, dateEp, nomDi)  
 /* *<no, n, f, c, nb, da, di>* ∈ LesEpreuves ⇐⇒ no est le numéro d'épreuve du nom n, forme (individuelle, par equipe ou par couple), catégorie c (féminin, masculin ou mixte), un nombre de sportifs nb et une date d. L'épreuve fait partie de la discipline di \*/  
 **LesSportifsEQ** (numSp, nomSp, prenomSp, pays, categorieSp, dateNaisSp, numEq)  
 /* *<no, n, p, pa, d, c, ne>* ∈ LesSportifs ⇐⇒ no est le numéro de sportif, avec un nom n, un prénom p, un pays pa une date de naissaince d et une catégorie c (feminin ou masculin). Il est inscrit dans l'équipe ne. \*/

On peut en suite en deduire les depandances fonctionnelles  


- **LesEpreuves** (numEp, nomEp, formeEp, categorieEp, nbSportifsEp, dateEp, nomDi)  
<p style="text-align: center;"> 
<strong> numEp </strong> &rarr; nomEp, formeEP, categorieEP, nbSportifsEp, dateEp, nomDi
</p>
&ensp; &ensp; &ensp; On voit bien que <strong> nomEp </strong> determine tous les autres attributs, donc une clé. C'est en fait, la seule clé, on détermine bien que cette relation est de forme <strong> BCNF </strong>. <br> <br>

- **LesSportifsEQ** (numSp, nomSp, prenomSp, pays, categorieSp, dateNaisSp, numEq)  
<p style="text-align: center;"> 
    <strong> numSp </strong> &rarr; nomSp, prenomSp, pays, categorieSp, dateNaisSp <br>  
    <strong> numEq </strong> &rarr; pays
</p>
&ensp; &ensp;&ensp; Ici on a <strong> numEq </strong> qui ne determine que pays, donc via la regle d'augmentation, <Strong> (numSp, numEq) </strong> est une clé. Vu que tous les attributs sauf numEq sont dependants a numSp, cette relation est de forme <strong>1NF</strong>.
 <br> <br>

*Ici le numero d'équipe numEq est dans la clé, bien qu'il y aie des sportifs sans équipe. On va ultimativement attaquer ce problème en transformant le schéma*

On transforme donc la relation **LesSportifsEQ** en la coupant par 2:  
- **LesSportifs** (numSp, nomSp, prenomSp, pays, categorieSp, dateNaisSp) 

<p style="text-align: center;"> 
<strong> numSp </strong> &rarr; nomSp, prenomSp, pays, categorieSp, dateNaisSp
</p>
&ensp; &ensp; &ensp; <strong> numSp </strong> est facilement la clé dans ce cas, et cette relation est de forme <strong> BCNF </strong> .<br> <br>

- **LesParticipants** (numSp, numEQ)  
 Pas de DF donc <strong> BCNF </strong>.<br> <br>


### Question 2  

On va maintenant modifier le schema obtenu a la question precedante pour completer la BD.

&ensp; &ensp;&ensp;&ensp; &ensp;&ensp;&ensp; &ensp;&ensp;&ensp; &ensp;&ensp; ![alt text](<CEBD1 (1).svg>)



  
## 2. Implementation
### Question 3

**Schema propose**

- **LesEpreuves** (<u>numEp</u>, nomEp, formeEp, categorieEp, nbSportifsEp, dateEp, nomDi)  
- **LesSportifs** (<u>numSP</u>, nomSp, prenomSp, pays, categorieSp, dateNaisSp)
- **LesParticipantsIndi**(<u>numSp</u>)
- **LesParticipantsEq**(<u>numSp</u>, numEq)
- **ParticiperAIndi**(<u>numSp, numEp</u>, medaille)
- **ParticiperAEq**(<u>numEq, numEp</u>, medaille)

**Domaines**  
- domaine (dateNaisSp) = date(dateEp) = Date  
- domaine (formeEp) = {'individuelle', 'par equipe', 'par couple'}  
- domaine (categorieEp) = {'feminin', 'masculin', 'mixte'}  
- domaine (categorieSp) = {'feminin', 'masculin'}  
- domaine (medaille) = {'Gold', 'Silver', 'Bronze'}
- domaine (nomDi) = domaine (nomEp) = domaine (nomSp) = domaine (prenomSp) = domaine (pays) = chaines de caracteres
- domaine (numSp) = domaine (numEp) = domaine (nbSportifsEp) = entier > 0
  
**Constraintes d'integralite**

- LesparticipantsIndi[numSp] ⊆ LesSportifs[numSp]  
- LesparticipantsEq[numSp] ⊆ LesSportifs[numSp]  
- LesParticipantsIndi[numSp] ⋃ LesParticipantsEq[numSp] = LesSportifs[numSp]  
- ParticiperAIndi[numSp] = Lesparticipantsindi[numSP]
- ParticiperAIndi[numEp] ⊆ LesEpreuves[numEp]
- ParticiperAEq[numEq] = LesParticipantsEq[numEq]
- ParticiperAEq[numEp] ⊆ LesEpreuves[numEp]
- ParticiperAEq[numEp] ⋂ ParticiperAIndi[numEp] = ∅  