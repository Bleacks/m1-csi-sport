/* Retourne -1 si la combinaison n'existe pas ou si l'utilisateur n'est plus en activité,
sinon renvoie de l'utilsiateur enregistré associé au couple mdp/mail*/
CREATE OR REPLACE FUNCTION auth(mailP varchar, mdpP varchar) RETURNS INT SECURITY DEFINER AS $$
DECLARE
mdpTmp VARCHAR;
idRes int;
activite bool;
BEGIN
    select mdp, iduserenregistre,en_activite into mdpTmp, idRes, activite 
    from utilisateurenregistre 
	where mailP = mail;
    
    IF mdpTmp = mdpP AND activite = True THEN
        Return idRes;
    ELSE
    	Return -1;
    END IF;
END;
$$ language plpgsql;

/** inscription_adherent
Retourne TRUE si l'inscription est bonne
Faux sinon
**/
CREATE OR REPLACE FUNCTION inscription_adherent(nom varchar, prenom varchar, ddn date, tel varchar, mailP varchar, mdp varchar) RETURNS boolean SECURITY DEFINER AS $$
DECLARE
occurenceMail int;
idGenere int;
BEGIN
/* Vérificiation pour que le mail soit unique */
	select count(*) into occurenceMail from utilisateurenregistre where mailP = mail;
    if occurenceMail != 0 THEN
    	return false;
    else
    	insert into utilisateurenregistre values (DEFAULT,nom,prenom,ddn,tel,mailP,mdp,DEFAULT);
        select iduserenregistre into idGenere from utilisateurenregistre where mail = mailP;
        insert into adherent values (idGenere, DEFAULT, True, current_date, NULL);
        return True;
    END IF;
END;
$$ language plpgsql;

/* Paiement_adherent */
CREATE OR REPLACE FUNCTION paiement_adherent(idUsr int) RETURNS boolean SECURITY DEFINER AS $$
DECLARE
nbOccurenceUser int;
datePaiement date;
BEGIN
select count(*) into nbOccurenceUser from adherent where idUsr = iduserenregistre; /*Vérification que l'utilisatuer est bien dans adhérent**/
select date_paiement into datePaiement from adherent where idUsr = iduserenregistre; /* Vérificaiton qu'il n'a pas déjà payé*/

if nbOccurenceUser = 1 AND datePaiement is NULL THEN
	UPDATE adherent set date_paiement = current_date Where iduserenregistre = idUsr;
    return True;
ELSE
	return false;
END IF;
END;
$$ language plpgsql;

/* Achat abonnement 
 Achat abonne: renvoie true si abonnement possible, false sinon
Si un abonnement est déjà en cours, on refuse l'abonnement demandé*/
CREATE OR REPLACE FUNCTION achat_abonnement(idUsr int, idAboAchat int) RETURNS boolean SECURITY DEFINER AS $$
DECLARE
    idAdherent int;
    idAboTmp int;
    dureeTmp int;
    r RECORD;

BEGIN
select id_adherent into idAdherent from adherent where idUsr = iduserenregistre; 
FOR r IN 
		SELECT idabonnement, date_debut FROM s_abonne WHERE idAdherent = id_adherent
    LOOP
        Select duree into dureeTmp
        from abonnement 
        where abonnement.idabonnement = idabonnement;
        IF ((r.date_debut + dureeTmp) > current_date) THEN
        	/* On a encore un abonnement en cours...*/
            return False;
        END IF;
        insert into s_abonne values (idAboAchat, idUsr, idAdherent,DEFAULT,current_date);
        Return true;
    END LOOP;
insert into s_abonne values (idAboAchat, idUsr, idAdherent,DEFAULT,current_date);
Return true; /* Atteint si il y a 0 enr dans la table s_abonne */
END;
$$ language plpgsql
/* Achat carte: Insère simplement une ligne qui indique que l'utilisatuer à acheté une carte 
*/
CREATE OR REPLACE FUNCTION achat_carte(idUsr int, idCarteAchat int) RETURNS boolean SECURITY DEFINER AS $$

DECLARE
    idAdherent int;
	nbSeances int;
BEGIN
select nbseance into nbSeances from carte where idcarte = idCarteAchat;
select id_adherent into idAdherent from adherent where idUsr = iduserenregistre; 
insert into achete_une values (idCarteAchat, idUsr, idAdherent,DEFAULT,nbSeances);

Return true; 

END;

$$ language plpgsql;

/* Fonction pour coach uniquement */
CREATE OR REPLACE FUNCTION consulter_son_planning(idUsr int) RETURNS 
table (
    adresse text,
    typeactivite text,
    nbinscactuel int,
    jour date,
    heure date
    )
    SECURITY DEFINER AS $$
DECLARE
    idCoach int;
BEGIN
	Select coach_id into idCoach from coach where idUsr = iduserenregistre;
    raise notice 'id coach: %',idCoach;
	Return query 
    	SELECT seance.typeactivite, salle.adresse, seance.nbinscactuel, seance.jour, seance.heure
        from seance 
        	join coach on seance.coach_id = coach.coach_id
        	join salle on salle.idsalle=seance.idsalle
        where seance.coach_id = idCoach
        And seance.jour >= current_date
		And en_activite = True;
    
END;
$$ language plpgsql;

/*Fonction pour coach uniquement*/
CREATE OR REPLACE FUNCTION accepter_coacher(idUsr int, idSeance int) RETURNS 
boolean SECURITY DEFINER AS $$
DECLARE
    idCoach int;
    idEmp int;
    idCoachActuel int;
BEGIN

	Select emp_id, coach_id into idEmp, idCoach 
    from coach 
    where iduserenregistre = idusr;
    
    Select coach_id into idCoachActuel
    from seance
    where id_seance = idSeance;
    
    IF idCoachActuel is null THEN
    	Update seance set iduserenregistre=idUsr, emp_id = idEmp , coach_id = idCoach
        where seance.id_seance = idSeance;
    	return True;
    ELSE
    	return False;
    END IF;
    
END;
$$ language plpgsql;

/* crée un compte coach */
CREATE OR REPLACE FUNCTION ajouter_compte_coach(nom varchar, prenom varchar, ddn date, num varchar, mailP varchar, mdp varchar, rib varchar, numss varchar, specialite varchar) RETURNS 
boolean SECURITY DEFINER AS $$
DECLARE
    idNvlUser int;
    idNvlEmp int;
    occurenceMemeMail int;
BEGIN
	select count(*) into occurenceMemeMail from utilisateurEnregistre where utilisateurEnregistre.mail = mailP;
    if occurenceMemeMail != 0 THEN
    	Return False;
   	End if;
	insert into utilisateurEnregistre values (Default,nom,prenom,ddn,num,mailP,mdp,DEFAULT);
    select currval('utilisateurenregistre_iduserenregistre_seq') into idNvlUser;
    insert into employe values (idNvlUser, Default, rib, numss);
    select currval('employe_emp_id_seq') into idNvlEmp;
    insert into coach values (idNvlUser,idNvlEmp,Default,specialite);
    Return TRUE;
END;
$$ language plpgsql

/* crée un compte coach */
CREATE OR REPLACE FUNCTION ajouter_compte_personnelaccueil(nom varchar, prenom varchar, ddn date, num varchar, mailP varchar, mdp varchar, rib varchar, numss varchar) RETURNS 
boolean SECURITY DEFINER AS $$
DECLARE
    idNvlUser int;
    idNvlEmp int;
    occurenceMemeMail int;
BEGIN
	select count(*) into occurenceMemeMail from utilisateurEnregistre where utilisateurEnregistre.mail = mailP;
    if occurenceMemeMail != 0 THEN
    	Return False;
   	End if;
	insert into utilisateurEnregistre values (Default,nom,prenom,ddn,num,mailP,mdp,DEFAULT);
    select currval('utilisateurenregistre_iduserenregistre_seq') into idNvlUser;
    insert into employe values (idNvlUser, Default, rib, numss);
    select currval('employe_emp_id_seq') into idNvlEmp;
    insert into personnelaccueil values (idNvlUser,idNvlEmp,Default);
    Return TRUE;
END;
$$ language plpgsql;

/* Fonction admin / personnel accueil: permet d'ajouter une séance, avec un coach ou non.*/
CREATE OR REPLACE FUNCTION ajouter_seance(idUsr int, idsalle int,description varchar, typeactivite varchar, nbinscmax int, estcollective bool, jour date, heure date, necessiteres bool) RETURNS 
boolean SECURITY DEFINER AS $$
DECLARE
    idEmp int;
    idCoach int;
    
BEGIN
	select emp_id, coach_id into idEmp, idCoach from coach where iduserenregistre = idUsr;
	insert into seance values (Default,idUsr,idEmp,idCoach,idsalle,description,typeactivite,nbinscmax,0,estcollective,jour,heure,necessiteres,DEFAULT);
    Return TRUE;
END;
$$ language plpgsql;

/* Passe le statut d'une séance en inactif */
CREATE OR REPLACE FUNCTION supprimer_seance(idSeance int) RETURNS 
boolean SECURITY DEFINER AS $$
DECLARE
etatActuel bool;
BEGIN
	select en_activite into etatActuel from seance where id_seance = idSeance;
    if etatActuel = false then
    	return False;
    else
		update seance set en_activite = false where id_seance = idSeance;
        return True;
    end if;
END;
$$ language plpgsql;
select * from seance;

/* Passe le statut d'un compte en inactif */
CREATE OR REPLACE FUNCTION clore_compte_inactif(idUsr int) RETURNS 
boolean SECURITY DEFINER AS $$
DECLARE
etatActuel bool;
derniereActivite date;
delai1an boolean;
BEGIN
	select en_activite into etatActuel from utilisateurenregistre where iduserenregistre = idUsr;
    select derniere_co into derniereActivite from adherent
    join utilisateurenregistre 
    	on utilisateurenregistre.iduserenregistre = adherent.iduserenregistre;
    if DATE_PART('year', current_date) - DATE_PART('year', derniereActivite) >= 1 THEN
    	delai1an = true;
    else
    	delai1an =false;
    end if;
    
    if etatActuel = true AND delai1an = true then
    	update utilisateurenregistre set en_activite = false where iduserenregistre = idUsr;
        return True;
    else
		return False;
    end if;
END;
$$ language plpgsql;

/* Recherche les comptes pouvant être passés en inactif */
CREATE OR REPLACE FUNCTION recherche_compte_inactif() RETURNS 
table (
    idUsrInactif int
    )
    SECURITY DEFINER AS $$
DECLARE
BEGIN
    Return Query
        Select utilisateurenregistre.iduserenregistre
        from utilisateurenregistre join adherent on utilisateurenregistre.iduserenregistre = adherent.iduserenregistre
        Where DATE_PART('year', current_date) - DATE_PART('year', derniere_co) >= 1
        and utilisateurenregistre.en_activite = True;

END;
$$ language plpgsql;



