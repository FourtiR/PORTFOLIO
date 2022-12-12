DELIMITER !

CREATE PROCEDURE CA_VENDEURS()
        BEGIN
                DESC vendeur;

                ALTER TABLE vendeur ADD COLUMN
                CA_Annuel_HT DECIMAL(9,2) DEFAULT 0;

                ALTER TABLE vendeur ADD COLUMN
                Nb_Commandes INTEGER DEFAULT 0;

                UPDATE vendeur SET
                CA_Annuel_HT =
                (
                        SELECT SUM(total_ht)
                        FROM commande
                        WHERE code_v = vendeur.code_v
                ),
                Nb_Commandes =
                (
                        SELECT COUNT(code_v)
                        FROM commande
                        WHERE code_v = vendeur.code_v
                );

                SELECT * FROM vendeur;
        END!
DELIMITER ;

DELIMITER @

CREATE PROCEDURE pairimpair (madate DATE)
        BEGIN
                DECLARE jour INTEGER;
                SET jour = DAY (madate);
                SELECT jour as jj;
                if jour % 2 = 0
                    THEN SELECT 'le jour est pair ' as parite;
                    else SELECT 'le jour est impaire' as parite;
                end if;
        END 
@   
DELIMITER;

call pairimpair (current_date());

DELIMITER @

CREATE trigger ajoutcommande after INSERT on commande
for each row
        BEGIN
                UPDATE vendeur;
                SET Nb_Commandes = Nb_Commandes -1;
                CA_Annuel = CA_Annuel -old.total_ht;
                if jour % 2 = 0
                    THEN SELECT 'le jour est pair ' as parite;
                    else SELECT 'le jour est impaire' as parite;
                end if;
        END 
@   
DELIMITER;


