/* Relance pour les personnes dont l'abonnement mensuel va arriver � expiration demain
Lanc�e chaque jour (non test�e)*/
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
    	raise notice 'Je dois envoyer un mail � cet utilisateur: %', s_abonne.iduserenregistre;
    End loop;
 end;
$$ language plpgsql;

/** Lanc�e � chaque update de ach�te_une*/
Create or replace function relance_carte() returns trigger as $$
Declare
idUsr int;
nbPlacesRestantes int;
begin
	Select new.iduserenregistre into idUsr;
    Select count(nbseancerestante) into nbPlacesRestantes;
    if nbPlacesRestantes == 1 THEN
    	raise notice 'Envoi du mail a utilisateur % pour le pr�venir quil arrive � la fin de ses titres', idUsr;
    END IF; 
 end;
$$ language plpgsql;

Create trigger trigger_depense_seance before update on achete_une
for each row execute procedure relance_carte();

/* Trigger qui va ins�rer dans l'historique des s�ances de chaque adh�rent les s�ances auquel il a particip�
Parcours pour toutes les s�ances d'adj (current_date = date de la s�ance) les tables s_inscrit et reserve
Ins�re dans l'historique les s�ances auquel l'adh�rent � particip�*/
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
               AND jour = current_date) /* On r�cup�re les s�ances ayant eu lieu aujourd'hui */
    Loop 
    	insert into historiqueseance values (Default, s_inscrit.iduserenregistre, s_inscrit.id_adherent,seance.typeactivite, seance.dateseance, s_inscrit.coach_demande,s_inscrit.id_seance);
    End loop;
    
    /* Table de r�servation */
    For temprow in
    	Select iduserenregistre 
        from reserve join seance 
        	on reserve.id_seance = seance.id_seance
        where (est_active = true 
               AND jour = current_date) /* On r�cup�re les s�ances ayant eu lieu aujourd'hui */
   		Loop 
    	insert into historiqueseance values (Default, s_inscrit.iduserenregistre, s_inscrit.id_adherent,seance.typeactivite, seance.dateseance, False,s_inscrit.id_seance);
    End loop;
 end;
$$ language plpgsql;