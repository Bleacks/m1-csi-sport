<<<<<<< HEAD
/**
 * @Author: Maxime Dolet <bleacks>
 * @Date:   2018-01-16T22:50:43+01:00
 * @Email:  maximed.contact@gmail.com
 * @Last modified by:   bleacks
 * @Last modified time: 2018-01-18T16:18:01+01:00
 */

/* Instruction pour �viter que tous les r�les puissent ex�cuter toutes les fonctions*/
ALTER default privileges revoke execute on functions from public; 

/* Renvoie un string sous la forme 'idUser;roleUser' exemple : auth('moi@mail.com','mdp') renverra 1;adherent si cet user

est un adh�rent */


drop function auth(character varying,character varying);

CREATE OR REPLACE FUNCTION auth(mailP varchar, mdpP varchar) RETURNS varchar SECURITY DEFINER AS $$

DECLARE

mdpTmp VARCHAR;

idRes int;

activite bool;

nomRole varchar;

nbOccurence int;

stringRes varchar;

BEGIN

    select mdp, iduserenregistre, en_activite into mdpTmp, idRes, activite

    from utilisateurenregistre

	where mailP = mail;



    IF mdpTmp = mdpP AND activite = True THEN

    	raise notice'Je cherche une occurence pr %',idRes;

        select count(*) into nbOccurence from adherent where iduserenregistre = idRes and date_paiement is not null;

        IF nbOccurence = 1 THEN

        	stringRes = idRes || ';User';

        	return stringRes;

        END IF;

        select count(*) into nbOccurence from adherent where iduserenregistre = idRes and date_paiement is null;

		 IF nbOccurence = 1 THEN

        	stringRes = idRes || ';Unpayed';

            return stringRes;

        END IF;

        select count(*) into nbOccurence from administrateur where iduserenregistre = idRes;

         IF nbOccurence = 1 THEN

        	stringRes = idRes || ';Admin';

            return stringRes;

        END IF;

        select count(*) into nbOccurence from coach where iduserenregistre = idRes;

         IF nbOccurence = 1 THEN

        	stringRes = idRes || ';Coach';

            return stringRes;

        END IF;

        select count(*) into nbOccurence from personnelaccueil where iduserenregistre = idRes;

         IF nbOccurence = 1 THEN

        	stringRes = idRes || ';Employee';

            return stringRes;

        END IF;

        stringRes = idRes || 'Visitor';

    	Return stringRes;

    END IF;

    Return False;

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

/* V�rificiation pour que le mail soit unique */

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

select count(*) into nbOccurenceUser from adherent where idUsr = iduserenregistre; /*V�rification que l'utilisatuer est bien dans adh�rent**/

select date_paiement into datePaiement from adherent where idUsr = iduserenregistre; /* V�rificaiton qu'il n'a pas d�j� pay�*/



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

Si un abonnement est d�j� en cours, on refuse l'abonnement demand�*/

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

$$ language plpgsql;

/* Achat carte: Ins�re simplement une ligne qui indique que l'utilisatuer � achet� une carte

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



/* cr�e un compte coach */

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

$$ language plpgsql;



/* cr�e un compte coach */

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



<<<<<<< HEAD
/* Fonction admin / personnel accueil: permet d'ajouter une s�ance, avec un coach ou non.*/

CREATE OR REPLACE FUNCTION ajouter_seance(idUsr int, idsalle int,description varchar, typeactivite varchar, nbinscmax int, estcollective bool, jour date, heure date, necessiteres bool) RETURNS
=======
/* Fonction admin / personnel accueil: permet d'ajouter une s�ance, avec un coach ou non.
idUsr d�signe l'idUtilisateur du d*/

CREATE OR REPLACE FUNCTION ajouter_seance(idUsr int, idsalle int,description varchar, typeactivite varchar, nbinscmax int, estcollective bool, jour date) RETURNS
>>>>>>> 0f1962d71df62c62557d5cdee05fa60c1f090f54

boolean SECURITY DEFINER AS $$

DECLARE
    idEmp int;
    idCoach int;
<<<<<<< HEAD



=======
>>>>>>> 0f1962d71df62c62557d5cdee05fa60c1f090f54
BEGIN

	select emp_id, coach_id into idEmp, idCoach from coach where iduserenregistre = idUsr;
	if nbinscmax != -1 OR idUsr is not null THEN
    	insert into seance values (Default,idUsr,idEmp,idCoach,idsalle,description,typeactivite,nbinscmax,0,estcollective,jour,True);/* C'est une s�ance n�cessitant r�servation*/
	Else
    	insert into seance values (Default,idUsr,idEmp,idCoach,idsalle,description,typeactivite,nbinscmax,0,estcollective,jour,False);
	End if;
    Return TRUE;

END;
$$ language plpgsql;



<<<<<<< HEAD
/* Passe le statut d'une s�ance en inactif */
=======


/* Passe le statut d'une s�ance en inactif */
>>>>>>> 0f1962d71df62c62557d5cdee05fa60c1f090f54

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



/* Recherche les comptes pouvant �tre pass�s en inactif */

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

/* Fonction pour VERIFIER UNIQUEMENT si on peut inscrire un adh�rent � une s�ance
Dispo pour: Adh�rent / Personnel Accueil */
CREATE OR REPLACE FUNCTION verif_inscription_seance(idUsr int, idSeance int, demandeCoach bool, paiementSurPlace bool) RETURNS boolean SECURITY DEFINER AS $$
DECLARE
occurenceSeance int;
idAdherent int;
dureeAbo int;
dateDebut date;
idCartePrelevee int;
idAchetev int;
nbSeanceRestantev int;
coutSeance int;
necessiteReservation bool;
BEGIN
<<<<<<< HEAD

	/* V�rification qu'on peut bien s'inscrire � cette s�ance:
    Rappel sujet:  Une partie des activit�s n�cessite une r�servation, dont celles avec un
	coach et celles � capacit�/effectif limit�.
    Dans le cas d'une inscription on � le droit de s'inscrire qu'aux s�ances sans coach / capacit� limit�e */
	select count(*) into occurenceSeance from seance where id_seance = idSeance;
    if occurenceSeance != 1 THEN
    	Return false;
    END IF;

    select nbinscmax, coach_id into nbInscMaxv, coachPresent
    from seance
    where id_seance = idSeance;
    IF nbInscMaxv != -1 /*S�ance � capacit� limit�*/ OR coachPresent is not Null /*S�ance coach�e*/THEN
=======

    select necessiteRes into necessiteReservation
    from seance
    where id_seance = idSeance;
    IF necessiteReservation = TRUE THEN
>>>>>>> 0f1962d71df62c62557d5cdee05fa60c1f090f54
    	Return False;
    End if;

	select id_adherent into idAdherent from adherent where iduserenregistre = idUsr;

    /* V�rification que l'adh�rent paie sur place*/

    if paiementSurPlace = true then
    	return True;
    End if;
    /* V�rification qu'on ai un abonnement en cours */
    select date_debut, duree into dateDebut,dureeAbo
    from s_abonne
    	join abonnement on s_abonne.idabonnement = abonnement.idabonnement
    where idUsr = s_abonne.iduserenregistre
    Order by s_abonne.date_debut DESC;

    /* L'utilisateur peut s'inscrire sans soucis */
    If (dateDebut + dureeAbo) >= current_date THEN
        return True;
    END IF;

    if demandeCoach = true THEN
    	coutSeance = 2;
    else
    	coutSeance = 1;
    END IF;

    select idachete, nbseancerestante into idAchetev, nbSeanceRestantev
    from achete_une
    where nbseancerestante >= coutSeance
    And iduserenregistre = idUsr
    order by nbseancerestante asc;
<<<<<<< HEAD

    If idCartePreleve is not Null THEN
    	Update achete
        Set nbseancerestante = nbSeanceRestantev - coutSeance /* Pour une inscription simple qui ne coute qu'une s�ance */
=======

    If idachetev is not Null THEN
    	Update achete_une
        Set nbseancerestante = nbSeanceRestantev - coutSeance /* Pour une inscription simple qui ne coute qu'une s�ance */
>>>>>>> 0f1962d71df62c62557d5cdee05fa60c1f090f54
        Where idachete = idAchetev;
        RETURN TRUE;
    ELSE
    	/* On ne peut ni payer avec l'abonnement ni avec nos titres donc on ne peut pas s'inscrire */
    	return False;
    END IF;
END;
$$ language plpgsql;

/* Fonction pour INSCRIRE UNIQUEMENT si on peut inscrire un adh�rent � une s�ance
Dispo pour: Adh�rent / Personnel Accueil */
CREATE OR REPLACE FUNCTION effectue_inscription_seance(idUsr int, idSeance int, demandeCoach bool) RETURNS boolean SECURITY DEFINER AS $$
DECLARE
idAdherent int;
BEGIN

	select id_adherent into idAdherent from adherent where iduserenregistre = idUsr;
	insert into s_inscrit values (idSeance,idUsr,idAdherent,demandeCoach);
	update seance set nbinscactuel = nbinscactuel + 1 where id_seance = idSeance;
	Return True;
END;
$$ language plpgsql;

<<<<<<< HEAD
/* Fonction pour VERIFIER UNIQUEMENT si on peut r�server pour un adh�rent � une s�ance
Dispo pour: Adh�rent / Personnel Accueil */
=======
/* Fonction pour verifier si on peut r�server pour un adh�rent � une s�ance
Dispo pour: Adh�rent / Personnel Accueil */
>>>>>>> 0f1962d71df62c62557d5cdee05fa60c1f090f54
CREATE OR REPLACE FUNCTION verif_reservation_seance(idUsr int, idSeance int, paiementSurPlace bool) RETURNS boolean SECURITY DEFINER AS $$
DECLARE
occurenceSeance int;
idAdherent int;
dureeAbo int;
dateDebut date;
idCartePrelevee int;
idAchetev int;
nbSeanceRestantev int;
coutSeance int;
nbinscmaxv int;
nbinscactuelv int;
coachPresent int;
necessiteReservation bool;
BEGIN
<<<<<<< HEAD
	/* V�rif assez de place */
	select nbinscmax, nbinscactuel into nbInscMaxv,nbinscactuelv
    from seance
=======
	/* V�rif qu'il faut bien r�server */
    select necessiteres into necessiteReservation from seance where id_seance = idSeance;
    If necessiteReservation = FALSE THEN
    	Return false;
    End if;

	/* V�rif assez de place */
	select nbinscmax, nbinscactuel into nbInscMaxv,nbinscactuelv
    from seance
>>>>>>> 0f1962d71df62c62557d5cdee05fa60c1f090f54
    where id_seance = idSeance;
    IF nbinscmaxv < nbinscactuelv + 1 THEN
    	Return False; /* Plus de place: on annule */
    End if;

    select id_adherent into idAdherent from adherent where iduserenregistre = idUsr;

    /* V�rificiation qu'il est possible de s'inscrire � la dite s�ance */
    if paiementSurPlace = true THEN
    	return True;
    End if;
    /* V�rification qu'on ai un abonnement en cours */
    select date_debut, duree into dateDebut,dureeAbo
    from s_abonne
    	join abonnement on s_abonne.idabonnement = abonnement.idabonnement
    where idUsr = s_abonne.iduserenregistre
    Order by s_abonne.date_debut DESC;

    /* L'utilisateur peut s'inscrire sans soucis */
    If (dateDebut + dureeAbo) >= current_date THEN
        return True;
    END IF;

    select idachete, nbseancerestante into idAchetev, nbSeanceRestantev
    from achete_une
    where nbseancerestante >= 1
    And iduserenregistre = idUsr
    order by nbseancerestante asc;

    If idCartePreleve is not Null THEN
<<<<<<< HEAD
    	Update achete
        Set nbseancerestante = nbSeanceRestantev - 1 /* Pour une inscription simple qui ne coute qu'une s�ance */
=======
    	Update achete_une
        Set nbseancerestante = nbSeanceRestantev - 1 /* Pour une inscription simple qui ne coute qu'une s�ance */
>>>>>>> 0f1962d71df62c62557d5cdee05fa60c1f090f54
        Where idachete = idAchetev;
        RETURN TRUE;
    ELSE
    	/* On ne peut ni payer avec l'abonnement ni avec nos titres donc on ne peut pas s'inscrire */
    	return False;
    END IF;
END;
$$ language plpgsql;

<<<<<<< HEAD
/* Note l'insertion de la demande de r�servation dans la base. */
=======
>>>>>>> 0f1962d71df62c62557d5cdee05fa60c1f090f54
CREATE OR REPLACE FUNCTION effectue_reservation_seance(idUsr int, idSeance int, idUsrParrain int) RETURNS boolean SECURITY DEFINER AS $$
DECLARE
idAdherent int;
BEGIN
	select id_adherent into idAdherent from adherent where iduserenregistre = idUsr;
	insert into reserve values (idSeance,idUsr,idAdherent,current_date,DEFAULT,idUsrParrain); /* id reserve ne nous sert pas */
	update seance set nbinscactuel = nbinscactuel + 1 where id_seance = idSeance;
END;
$$ language plpgsql;


<<<<<<< HEAD
/* Note l'insertion de la demande de r�servation dans la base. */
CREATE OR REPLACE FUNCTION accepte_invitation_seance(idUsr int, idSeance int, idUsrParrain int) RETURNS boolean SECURITY DEFINER AS $$
DECLARE
idAdherent int;
peutSinscrire bool;
BEGIN
    select verif_reservation_seance(idUsr, idSeance, FALSE) into peutSinscrire;
    if peutSinscrire = TRUE Then
		select effectue_reservation_seance(idUsr, idSeance, idUsrParrain);
		Return true;
    Else
    	return False;
    End if;
END;
$$ language plpgsql;

/* Annule une s�ance � venir: N'est possible que si la s�ance n'est pas encore pass�e.
D�clenche un envoi de mail � tous les inscrits / r�serv�s � cette s�ance + le coach*/
=======
/* Annule une s�ance � venir: N'est possible que si la s�ance n'est pas encore pass�e.
D�clenche un envoi de mail � tous les inscrits / r�serv�s � cette s�ance + le coach
Non fonctionnelle*/
>>>>>>> 0f1962d71df62c62557d5cdee05fa60c1f090f54

CREATE OR REPLACE FUNCTION annule_seance(idSeance int) RETURNS boolean SECURITY DEFINER AS $$
DECLARE
dateSeance date;
nbInscMaxv int;
active bool;
r record;
BEGIN
    select jour, en_activite, nbInscMaxv into dateSeance, active, nbInscMaxv from seance where id_seance = idSeance;
    if active = True AND dateSeance > current_date THEN
    	/* On regarde si on va devoir pr�venir des adh�rents dans inscrit ou r�serve */
        If nbInscMaxv = -1 THEN/* On regarde la table s'inscrit */
        	For R in
            	Select iduserenregistre from s_inscrit where id_seance = idSeance
                LOOP
                	raise notice 'Bonjour adh�rent n�% la s�ance n�% du % est annul�e',iduserenregistre, idSeance, dateSeance;
                END LOOP;
        Else
        	For r in
            	Select iduserenregistre from reserve where id_seance = idSeance
                LOOP
                	raise notice 'Bonjour adh�rent n�% la s�ance n�% du % est annul�e',iduserenregistre, idSeance, dateSeance;
                END LOOP;
        End if;
        update seance set en_activite = False where id_seance = idSeance;
        Return True;
    Else
    	return False;
    End if;

END;
$$ language plpgsql;
<<<<<<< HEAD
=======


>>>>>>> 0f1962d71df62c62557d5cdee05fa60c1f090f54
