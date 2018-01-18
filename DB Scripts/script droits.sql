Create role droits_de_base;
grant select on seance to droits_de_base;
grant select on salle to droits_de_base;
grant select on carte to droits_de_base;
grant select on abonnement to droits_de_base;

Create role inscrit_adherent;
Create role inscrit_non_adherent;
Create role administrateur;
Create role personnel_accueil;
Create role coach;
Create role salle_partenaire;

Grant droits_de_base to inscrit_adherent;
Grant droits_de_base to inscrit_non_adherent;
Grant droits_de_base to administrateur;
Grant droits_de_base to personnel_accueil;
Grant droits_de_base to coach;
Grant droits_de_base to salle_partenaire;

Alter role inscrit_adherent CONNECTION LIMIT 100 PASSWORD 'a';
Grant execute on function accepte_invitation_seance(idUsr int, idSeance int, idUsrParrain int) to inscrit_adherent;
Grant execute on function achat_abonnement(idUsr int, idAboAchat int) to inscrit_adherent;
Grant execute on function achat_carte(idUsr int, idCarteAchat int) to inscrit_adherent;
Grant execute on function effectue_inscription_seance(idUsr int, idSeance int, demandeCoach bool) to inscrit_adherent;
Grant execute on function effectue_reservation_seance(idUsr int, idSeance int, idUsrParrain int) to inscrit_adherent;
Grant execute on function verif_inscription_seance(idUsr int, idSeance int, demandeCoach bool, paiementSurPlace bool) to inscrit_adherent;
Grant execute on function verif_reservation_seance(idUsr int, idSeance int, paiementSurPlace bool) to inscrit_adherent;

Alter role inscrit_non_adherent CONNECTION LIMIT 100 PASSWORD 'a';
Grant execute on function paiement_adherent(idUsr int) to inscrit_non_adherent

/* Fonctions admin */
Grant execute on function ajouter_compte_coach(nom varchar, prenom varchar, ddn date, num varchar, mailP varchar, mdp varchar, rib varchar, numss varchar, specialite varchar) to administrateur;
Grant execute on function ajouter_compte_personnelaccueil(nom varchar, prenom varchar, ddn date, num varchar, mailP varchar, mdp varchar, rib varchar, numss varchar) to administrateur;
Grant execute on function ajouter_seance(idUsr int, idsalle int,description varchar, typeactivite varchar, nbinscmax int, estcollective bool, jour date) to administrateur;
Grant execute on function annule_seance(idSeance int) to administrateur;
Grant execute on function clore_compte_inactif(idUsr int) to administrateur;

/* Fonctions personnel_accueil */
Grant execute on function effectue_inscription_seance(idUsr int, idSeance int, demandeCoach bool) to personnel_accueil;
Grant execute on function effectue_reservation_seance(idUsr int, idSeance int, idUsrParrain int) to personnel_accueil;
Grant execute on function verif_inscription_seance(idUsr int, idSeance int, demandeCoach bool, paiementSurPlace bool) to personnel_accueil;
Grant execute on function verif_reservation_seance(idUsr int, idSeance int, paiementSurPlace bool) to personnel_accueil;

/* Fonctions coach */
Grant execute on function consulter_son_planning(idUsr int) to coach;
Grant execute on function accepter_coacher(idUsr int, idSeance int) to coach;

/* Fonctions pour les visiteurs */
grant execute on function auth(mailP varchar, mdpP varchar) to public;
grant execute on function inscription_adherent(nom varchar, prenom varchar, ddn date, tel varchar, mailP varchar, mdp varchar) to public;

/* Création de rôles pour le test */
Create role coach_1 with password 'a' connection limit 1;
Create role admin_1 with password 'a' connection limit 1;
Create role personnel_accueil_1 with password 'a' connection limit 1;

/* Attribution des droits à nos utilisateurs */
Grant coach to coach_1;
Grant administrateur to admin_1;
Grant personnel_accueil to personnel_accueil_1;





