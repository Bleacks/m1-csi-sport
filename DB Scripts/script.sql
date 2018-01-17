/*==============================================================*/
/* Nom de SGBD :  PostgreSQL 8                                  */
/* Date de création :  04/01/2018 14:55:23  
test modif bidon                    */
/*==============================================================*/


drop index ABONNEMENT_PK;

drop table ABONNEMENT;

drop index ACHETE_UNE2_FK;

drop index ACHETE_UNE_FK;

drop index ACHETE_UNE_PK;

drop table ACHETE_UNE;

drop index HERITAGE_5_FK;

drop index ADHERENT_PK;

drop table ADHERENT;

drop index HERITAGE_3_FK;

drop index ADMINISTRATEUR_PK;

drop table ADMINISTRATEUR;

drop index CARTE_PK;

drop table CARTE;

drop index HERITAGE_1_FK;

drop index COACH_PK;

drop table COACH;

drop index HERITAGE_4_FK;

drop index EMPLOYE_PK;

drop table EMPLOYE;

drop index DISPOSE_FK;

drop index HISTORIQUESEANCE_PK;

drop table HISTORIQUESEANCE;

drop table INFORMATIONTARIFAIRE;

drop index HERITAGE_2_FK;

drop index PERSONNELACCUEIL_PK;

drop table PERSONNELACCUEIL;

drop index RESERVE2_FK;

drop index RESERVE_FK;

drop index RESERVE_PK;

drop table RESERVE;

drop index SALLE_PK;

drop table SALLE;

drop index ANIME_FK;

drop index A_LIEU_DANS_FK;

drop index SEANCE_PK;

drop table SEANCE;

drop index S_ABONNE2_FK;

drop index S_ABONNE_FK;

drop index S_ABONNE_PK;

drop table S_ABONNE;

drop index S_INSCRIT2_FK;

drop index S_INSCRIT_FK;

drop index S_INSCRIT_PK;

drop table S_INSCRIT;

drop index UTILISATEURENREGISTRE_PK;

drop table UTILISATEURENREGISTRE;

/*==============================================================*/
/* Table : ABONNEMENT                                           */
/*==============================================================*/
create table ABONNEMENT (
   IDABONNEMENT         SERIAL,
   NOM                  TEXT                 null,
   DESCRIPTION          TEXT                 null,
   DUREE                INT4                 null,
   PRIX                 NUMERIC              null,
   constraint PK_ABONNEMENT primary key (IDABONNEMENT)
);

/*==============================================================*/
/* Index : ABONNEMENT_PK                                        */
/*==============================================================*/
create unique index ABONNEMENT_PK on ABONNEMENT (
IDABONNEMENT
);

/*==============================================================*/
/* Table : ACHETE_UNE                                           */
/*==============================================================*/
create table ACHETE_UNE (
   IDCARTE              INT4				 not null,
   IDUSERENREGISTRE     INT4                 not null,
   ID_ADHERENT          INT4                 not null,
   IDACHETE             SERIAL,
   NBSEANCERESTANTE     INT4                 null,
   constraint PK_ACHETE_UNE primary key (IDCARTE, IDUSERENREGISTRE, ID_ADHERENT, IDACHETE)
);

/*==============================================================*/
/* Index : ACHETE_UNE_PK                                        */
/*==============================================================*/
create unique index ACHETE_UNE_PK on ACHETE_UNE (
IDCARTE,
IDUSERENREGISTRE,
ID_ADHERENT,
IDACHETE
);

/*==============================================================*/
/* Index : ACHETE_UNE_FK                                        */
/*==============================================================*/
create  index ACHETE_UNE_FK on ACHETE_UNE (
IDCARTE
);

/*==============================================================*/
/* Index : ACHETE_UNE2_FK                                       */
/*==============================================================*/
create  index ACHETE_UNE2_FK on ACHETE_UNE (
IDUSERENREGISTRE,
ID_ADHERENT
);

/*==============================================================*/
/* Table : ADHERENT                                             */
/*==============================================================*/
create table ADHERENT (
   IDUSERENREGISTRE     INT4                 not null,
   ID_ADHERENT          SERIAL,
   SOUHAITERECEVOIRNOTIF BOOL                 null,
   DATE_SOUMISSION      DATE                 null,
   DATE_PAIEMENT        DATE                 null,
   DERNIERE_CO			DATE				 null,
   constraint PK_ADHERENT primary key (IDUSERENREGISTRE, ID_ADHERENT)
);

/*==============================================================*/
/* Index : ADHERENT_PK                                          */
/*==============================================================*/
create unique index ADHERENT_PK on ADHERENT (
IDUSERENREGISTRE,
ID_ADHERENT
);

/*==============================================================*/
/* Index : HERITAGE_5_FK                                        */
/*==============================================================*/
create  index HERITAGE_5_FK on ADHERENT (
IDUSERENREGISTRE
);

/*==============================================================*/
/* Table : ADMINISTRATEUR                                       */
/*==============================================================*/
create table ADMINISTRATEUR (
   IDUSERENREGISTRE     INT4                 not null,
   EMP_ID               INT4                 not null,
   ADMIN_ID             SERIAL,
   constraint PK_ADMINISTRATEUR primary key (IDUSERENREGISTRE, EMP_ID, ADMIN_ID)
);

/*==============================================================*/
/* Index : ADMINISTRATEUR_PK                                    */
/*==============================================================*/
create unique index ADMINISTRATEUR_PK on ADMINISTRATEUR (
IDUSERENREGISTRE,
EMP_ID,
ADMIN_ID
);

/*==============================================================*/
/* Index : HERITAGE_3_FK                                        */
/*==============================================================*/
create  index HERITAGE_3_FK on ADMINISTRATEUR (
IDUSERENREGISTRE,
EMP_ID
);

/*==============================================================*/
/* Table : CARTE                                                */
/*==============================================================*/
create table CARTE (
   IDCARTE              SERIAL,
   NOM                  TEXT                 null,
   NBSEANCE             INT4                 null,
   PRIX                 NUMERIC              null,
   constraint PK_CARTE primary key (IDCARTE)
);

/*==============================================================*/
/* Index : CARTE_PK                                             */
/*==============================================================*/
create unique index CARTE_PK on CARTE (
IDCARTE
);

/*==============================================================*/
/* Table : COACH                                                */
/*==============================================================*/
create table COACH (
   IDUSERENREGISTRE     INT4                 not null,
   EMP_ID               INT4                 not null,
   COACH_ID             SERIAL,
   SPECIALITE           TEXT                 null,
   constraint PK_COACH primary key (IDUSERENREGISTRE, EMP_ID, COACH_ID)
);

/*==============================================================*/
/* Index : COACH_PK                                             */
/*==============================================================*/
create unique index COACH_PK on COACH (
IDUSERENREGISTRE,
EMP_ID,
COACH_ID
);

/*==============================================================*/
/* Index : HERITAGE_1_FK                                        */
/*==============================================================*/
create  index HERITAGE_1_FK on COACH (
IDUSERENREGISTRE,
EMP_ID
);

/*==============================================================*/
/* Table : EMPLOYE                                              */
/*==============================================================*/
create table EMPLOYE (
   IDUSERENREGISTRE     INT4                 not null,
   EMP_ID               SERIAL,
   NUMSS                TEXT                 null,
   RIB                  TEXT                 null,
   constraint PK_EMPLOYE primary key (IDUSERENREGISTRE, EMP_ID)
);

/*==============================================================*/
/* Index : EMPLOYE_PK                                           */
/*==============================================================*/
create unique index EMPLOYE_PK on EMPLOYE (
IDUSERENREGISTRE,
EMP_ID
);

/*==============================================================*/
/* Index : HERITAGE_4_FK                                        */
/*==============================================================*/
create  index HERITAGE_4_FK on EMPLOYE (
IDUSERENREGISTRE
);

/*==============================================================*/
/* Table : HISTORIQUESEANCE                                     */
/*==============================================================*/
create table HISTORIQUESEANCE (
   IDHISTOSEANCE        SERIAL,
   IDUSERENREGISTRE     INT4                 not null,
   ID_ADHERENT          INT4                 not null,
   TYPEACTIVITE         TEXT                 null,
   DATESEANCE           DATE                 null,
   COACHDEMANDE         BOOL                 null,
   constraint PK_HISTORIQUESEANCE primary key (IDHISTOSEANCE)
);

/*==============================================================*/
/* Index : HISTORIQUESEANCE_PK                                  */
/*==============================================================*/
create unique index HISTORIQUESEANCE_PK on HISTORIQUESEANCE (
IDHISTOSEANCE
);

/*==============================================================*/
/* Index : DISPOSE_FK                                           */
/*==============================================================*/
create  index DISPOSE_FK on HISTORIQUESEANCE (
IDUSERENREGISTRE,
ID_ADHERENT
);

/*==============================================================*/
/* Table : INFORMATIONTARIFAIRE                                 */
/*==============================================================*/
create table INFORMATIONTARIFAIRE (
   BASETARIFAIRE        INT4                 null,
   SURCOUTCOACH         INT4                 null
);

/*==============================================================*/
/* Table : INVITE                                               */
/*==============================================================*/
create table INVITE (
   IDINVITE             SERIAL,
   IDPROVENANCE		    INT4                 not null,
   IDSALLE          	INT4                 not null,
   NOM                  TEXT                 null,
   PRENOM               TEXT                 null,
   MAIL					TEXT				 null,
   constraint PK_INVITE primary key (IDPROVENANCE, IDSALLE)
);

/*==============================================================*/
/* Index : INVITE_PK                                        	*/
/*==============================================================*/
create unique index INVITE_PK on INVITE (
IDPROVENANCE,
IDSALLE
);

/*==============================================================*/
/* Index : INVITE_FK                                       		*/
/*==============================================================*/
create  index INVITE_FK on INVITE (
IDSALLE
);

/*==============================================================*/
/* Table : PERSONNELACCUEIL                                     */
/*==============================================================*/
create table PERSONNELACCUEIL (
   IDUSERENREGISTRE     INT4                 not null,
   EMP_ID               INT4                 not null,
   PERSONNEL_ID         SERIAL,
   constraint PK_PERSONNELACCUEIL primary key (IDUSERENREGISTRE, EMP_ID, PERSONNEL_ID)
);

/*==============================================================*/
/* Index : PERSONNELACCUEIL_PK                                  */
/*==============================================================*/
create unique index PERSONNELACCUEIL_PK on PERSONNELACCUEIL (
IDUSERENREGISTRE,
EMP_ID,
PERSONNEL_ID
);

/*==============================================================*/
/* Index : HERITAGE_2_FK                                        */
/*==============================================================*/
create  index HERITAGE_2_FK on PERSONNELACCUEIL (
IDUSERENREGISTRE,
EMP_ID
);

/*==============================================================*/
/* Table : RESERVE                                              */
/*==============================================================*/
create table RESERVE (
   ID_SEANCE            INT4                 not null,
   IDUSERENREGISTRE     INT4                 not null,
   ID_ADHERENT          INT4                 not null,
   DATERESERVATION      DATE                 not null DEFAULT current_date,
   STATUT               TEXT                 not null DEFAULT 'prise en compte',
   ID_PARRAIN           INT4                 null,
   constraint PK_RESERVE primary key (ID_SEANCE, IDUSERENREGISTRE, ID_ADHERENT)
);

/*==============================================================*/
/* Index : RESERVE_PK                                           */
/*==============================================================*/
create unique index RESERVE_PK on RESERVE (
ID_SEANCE,
IDUSERENREGISTRE,
ID_ADHERENT
);

/*==============================================================*/
/* Index : RESERVE_FK                                           */
/*==============================================================*/
create  index RESERVE_FK on RESERVE (
ID_SEANCE
);

/*==============================================================*/
/* Index : RESERVE2_FK                                          */
/*==============================================================*/
create  index RESERVE2_FK on RESERVE (
IDUSERENREGISTRE,
ID_ADHERENT
);

/*==============================================================*/
/* Table : SALLE                                                */
/*==============================================================*/
create table SALLE (
   IDSALLE              SERIAL,
   ADRESSE              TEXT                 null,
   TEL                  TEXT                 null,
   constraint PK_SALLE primary key (IDSALLE)
);

/*==============================================================*/
/* Index : SALLE_PK                                             */
/*==============================================================*/
create unique index SALLE_PK on SALLE (
IDSALLE
);

/*==============================================================*/
/* Table : SEANCE                                               */
/*==============================================================*/
create table SEANCE (
   ID_SEANCE            SERIAL,
   IDUSERENREGISTRE	    INT4                 null,
   EMP_ID               INT4                 null,
   COACH_ID             INT4                 null,
   IDSALLE              INT4                 not null,
   DESCRIPTION          TEXT                 null,
   TYPEACTIVITE         TEXT                 null,
   NBINSCMAX            INT4                 null,
   NBINSCACTUEL         INT4                 null,
   ESTCOLLECTIVE        BOOL                 null,
   JOUR                 DATE                 null,
   NECESSITERES         BOOL                 null,
   EN_ACTIVITE               BOOL                 null DEFAULT TRUE,
   constraint PK_SEANCE primary key (ID_SEANCE)
);

/*==============================================================*/
/* Index : SEANCE_PK                                            */
/*==============================================================*/
create unique index SEANCE_PK on SEANCE (
ID_SEANCE
);

/*==============================================================*/
/* Index : A_LIEU_DANS_FK                                       */
/*==============================================================*/
create  index A_LIEU_DANS_FK on SEANCE (
IDSALLE
);

/*==============================================================*/
/* Index : ANIME_FK                                             */
/*==============================================================*/
create  index ANIME_FK on SEANCE (
IDUSERENREGISTRE,
EMP_ID,
COACH_ID
);

/*==============================================================*/
/* Table : S_ABONNE                                             */
/*==============================================================*/
create table S_ABONNE (
   IDABONNEMENT         INT4				 not null,
   IDUSERENREGISTRE     INT4                 not null,
   ID_ADHERENT          INT4                 not null,
   IDABONNE             SERIAL,
   DATE_DEBUT           DATE                 null,
   constraint PK_S_ABONNE primary key (IDABONNEMENT, IDUSERENREGISTRE, ID_ADHERENT, IDABONNE)
);

/*==============================================================*/
/* Index : S_ABONNE_PK                                          */
/*==============================================================*/
create unique index S_ABONNE_PK on S_ABONNE (
IDABONNEMENT,
IDUSERENREGISTRE,
ID_ADHERENT,
IDABONNE
);

/*==============================================================*/
/* Index : S_ABONNE_FK                                          */
/*==============================================================*/
create  index S_ABONNE_FK on S_ABONNE (
IDABONNEMENT
);

/*==============================================================*/
/* Index : S_ABONNE2_FK                                         */
/*==============================================================*/
create  index S_ABONNE2_FK on S_ABONNE (
IDUSERENREGISTRE,
ID_ADHERENT
);

/*==============================================================*/
/* Table : S_INSCRIT                                            */
/*==============================================================*/
create table S_INSCRIT (
   ID_SEANCE            INT4                 not null,
   IDUSERENREGISTRE     INT4                 not null,
   ID_ADHERENT          INT4                 not null,
   DEMANDECOACH         BOOL                 null,
   constraint PK_S_INSCRIT primary key (ID_SEANCE, IDUSERENREGISTRE, ID_ADHERENT)
);

/*==============================================================*/
/* Index : S_INSCRIT_PK                                         */
/*==============================================================*/
create unique index S_INSCRIT_PK on S_INSCRIT (
ID_SEANCE,
IDUSERENREGISTRE,
ID_ADHERENT
);

/*==============================================================*/
/* Index : S_INSCRIT_FK                                         */
/*==============================================================*/
create  index S_INSCRIT_FK on S_INSCRIT (
ID_SEANCE
);

/*==============================================================*/
/* Index : S_INSCRIT2_FK                                        */
/*==============================================================*/
create  index S_INSCRIT2_FK on S_INSCRIT (
IDUSERENREGISTRE,
ID_ADHERENT
);

/*==============================================================*/
/* Table : UTILISATEURENREGISTRE                                */
/*==============================================================*/
create table UTILISATEURENREGISTRE (
   IDUSERENREGISTRE     SERIAL,
   NOM                  TEXT                 null,
   PRENOM               TEXT                 null,
   DATEDENAISSANCE      DATE                 null,
   NUMEROTELEPHONE      TEXT                 null,
   MAIL                 TEXT                 null,
   MDP                  TEXT                 null,
   EN_ACTIVITE			BOOL				 null DEFAULT TRUE,
   constraint PK_UTILISATEURENREGISTRE primary key (IDUSERENREGISTRE),
   unique(MAIL)
);

/*==============================================================*/
/* Index : UTILISATEURENREGISTRE_PK                             */
/*==============================================================*/
create unique index UTILISATEURENREGISTRE_PK on UTILISATEURENREGISTRE (
IDUSERENREGISTRE
);

alter table ACHETE_UNE
   add constraint FK_ACHETE_U_ACHETE_UN_CARTE foreign key (IDCARTE)
      references CARTE (IDCARTE)
      on delete restrict on update restrict;

alter table ACHETE_UNE
   add constraint FK_ACHETE_U_ACHETE_UN_ADHERENT foreign key (IDUSERENREGISTRE, ID_ADHERENT)
      references ADHERENT (IDUSERENREGISTRE, ID_ADHERENT)
      on delete restrict on update restrict;

alter table ADHERENT
   add constraint FK_ADHERENT_HERITAGE__UTILISAT foreign key (IDUSERENREGISTRE)
      references UTILISATEURENREGISTRE (IDUSERENREGISTRE)
      on delete restrict on update restrict;

alter table ADMINISTRATEUR
   add constraint FK_ADMINIST_HERITAGE__EMPLOYE foreign key (IDUSERENREGISTRE, EMP_ID)
      references EMPLOYE (IDUSERENREGISTRE, EMP_ID)
      on delete restrict on update restrict;

alter table COACH
   add constraint FK_COACH_HERITAGE__EMPLOYE foreign key (IDUSERENREGISTRE, EMP_ID)
      references EMPLOYE (IDUSERENREGISTRE, EMP_ID)
      on delete restrict on update restrict;

alter table EMPLOYE
   add constraint FK_EMPLOYE_HERITAGE__UTILISAT foreign key (IDUSERENREGISTRE)
      references UTILISATEURENREGISTRE (IDUSERENREGISTRE)
      on delete restrict on update restrict;

alter table HISTORIQUESEANCE
   add constraint FK_HISTORIQ_DISPOSE_ADHERENT foreign key (IDUSERENREGISTRE, ID_ADHERENT)
      references ADHERENT (IDUSERENREGISTRE, ID_ADHERENT)
      on delete restrict on update restrict;

alter table PERSONNELACCUEIL
   add constraint FK_PERSONNE_HERITAGE__EMPLOYE foreign key (IDUSERENREGISTRE, EMP_ID)
      references EMPLOYE (IDUSERENREGISTRE, EMP_ID)
      on delete restrict on update restrict;

alter table RESERVE
   add constraint FK_RESERVE_RESERVE_SEANCE foreign key (ID_SEANCE)
      references SEANCE (ID_SEANCE)
      on delete restrict on update restrict;

alter table RESERVE
   add constraint FK_RESERVE_RESERVE2_ADHERENT foreign key (IDUSERENREGISTRE, ID_ADHERENT)
      references ADHERENT (IDUSERENREGISTRE, ID_ADHERENT)
      on delete restrict on update restrict;

alter table SEANCE
   add constraint FK_SEANCE_ANIME_COACH foreign key (IDUSERENREGISTRE, EMP_ID, COACH_ID)
      references COACH (IDUSERENREGISTRE, EMP_ID, COACH_ID)
      on delete restrict on update restrict;

alter table SEANCE
   add constraint FK_SEANCE_A_LIEU_DA_SALLE foreign key (IDSALLE)
      references SALLE (IDSALLE)
      on delete restrict on update restrict;

alter table S_ABONNE
   add constraint FK_S_ABONNE_S_ABONNE_ABONNEME foreign key (IDABONNEMENT)
      references ABONNEMENT (IDABONNEMENT)
      on delete restrict on update restrict;

alter table S_ABONNE
   add constraint FK_S_ABONNE_S_ABONNE2_ADHERENT foreign key (IDUSERENREGISTRE, ID_ADHERENT)
      references ADHERENT (IDUSERENREGISTRE, ID_ADHERENT)
      on delete restrict on update restrict;

alter table S_INSCRIT
   add constraint FK_S_INSCRI_S_INSCRIT_SEANCE foreign key (ID_SEANCE)
      references SEANCE (ID_SEANCE)
      on delete restrict on update restrict;

alter table S_INSCRIT
   add constraint FK_S_INSCRI_S_INSCRIT_ADHERENT foreign key (IDUSERENREGISTRE, ID_ADHERENT)
      references ADHERENT (IDUSERENREGISTRE, ID_ADHERENT)
      on delete restrict on update restrict;

alter table INVITE
   add constraint FK_SALLE_INVITE foreign key (IDSALLE)
      references SALLE (IDSALLE)
      on delete restrict on update restrict;