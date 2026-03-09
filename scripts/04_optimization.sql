-- ==========================================
-- PROJET : Analyse RH - Optimisation
-- OBJECTIF : Réduire le temps d'exécution sur de gros volumes
-- ==========================================

USE employees;

-- 1. ANALYSE AVANT OPTIMISATION
-- Imaginons qu'on cherche souvent les employés par leur nom de famille.
-- On utilise EXPLAIN pour voir comment MySQL cherche.

EXPLAIN SELECT * FROM current_employee_stats 
WHERE last_name = 'Facello';


-- 2. CRÉATION D'UN INDEX
-- On crée un index sur le nom de famille pour accélérer les recherches.

CREATE INDEX idx_lastname ON current_employee_stats(last_name);


-- 3. ANALYSE APRÈS OPTIMISATION
-- On relance le EXPLAIN pour voir la différence.

EXPLAIN SELECT * FROM current_employee_stats 
WHERE last_name = 'Facello';

-- Note : Ici, la colonne 'type' devrait afficher 'ref'. 
-- MySQL va directement à la bonne page, comme dans l'index d'un livre.
