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