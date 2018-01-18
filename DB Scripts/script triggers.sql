/* Relance pour les personnes dont l'abonnement mensuel va arriver à expiration demain
Lancée chaque jour (non testée)*/
Create or replace function relance_mensuelle_abo() returns trigger as $$
DECLARE
temprow s_abonne%ROWTYPE;
begin
	For temprow in 
    	Select iduserenregistre 
        from s_abonne join abonnement 
        	on s_abonne.idabonnement = abonnement.idabonnement
        where ((s_abonne.date_debut+abonnement.duree) - current_date) = 1 
    Loop 
    	raise notice 'Je dois envoyer un mail à cet utilisateur: %', s_abonne.iduserenregistre;
    End loop;
 end;
$$ language plpgsql;

/** Lancée à chaque update de achète_une*/
Create or replace function relance_carte() returns trigger as $$
Declare
idUsr int;
nbPlacesRestantes int;
begin
	Select new.iduserenregistre into idUsr;
    Select count(nbseancerestante) into nbPlacesRestantes;
    if nbPlacesRestantes == 1 THEN
    	raise notice 'Envoi du mail a utilisateur % pour le prévenir quil arrive à la fin de ses titres', idUsr;
    END IF; 
 end;
$$ language plpgsql;

Create trigger trigger_depense_seance before update on achete_une
for each row execute procedure relance_carte();

/* Trigger qui va insérer dans l'historique des séances de chaque adhérent les séances auquel il a participé
Parcours pour toutes les séances d'adj (current_date = date de la séance) les tables s_inscrit et reserve
Insère dans l'historique les séances auquel l'adhérent à participé*/
Create or replace function insertion_historique() returns trigger as $$
DECLARE
temprow s_abonne%ROWTYPE;
idAdherent int;
begin

	/* Table d'inscription */
	For temprow in 
    	Select iduserenregistre 
        from s_inscrit join seance 
        	on s_inscrit.id_seance = seance.id_seance
        where (est_active = true 
               AND jour = current_date) /* On récupère les séances ayant eu lieu aujourd'hui */
    Loop 
    	insert into historiqueseance values (Default, s_inscrit.iduserenregistre, s_inscrit.id_adherent,seance.typeactivite, seance.dateseance, s_inscrit.coach_demande,s_inscrit.id_seance);
    End loop;
    
    /* Table de réservation */
    For temprow in
    	Select iduserenregistre 
        from reserve join seance 
        	on reserve.id_seance = seance.id_seance
        where (est_active = true 
               AND jour = current_date) /* On récupère les séances ayant eu lieu aujourd'hui */
   		Loop 
    	insert into historiqueseance values (Default, s_inscrit.iduserenregistre, s_inscrit.id_adherent,seance.typeactivite, seance.dateseance, False,s_inscrit.id_seance);
    End loop;
 end;
$$ language plpgsql;