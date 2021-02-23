/*
 * This problem is the same as 06.sql,
 * but instead of using the NOT IN operator, you are to use a LEFT JOIN.
 */

SELECT film.title
FROM film
LEFT JOIN inventory ON film.film_id=inventory.film_id
WHERE inventory.film_id IS NULL;
