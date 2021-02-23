/*
 * Select the titles of all films that the customer with customer_id=1 has rented more than 1 time.
 *
 * HINT:
 * It's possible to solve this problem both with and without subqueries.
 */

SELECT film.title
FROM film
RIGHT JOIN (
    SELECT rental.customer_id, count(inventory.film_id) as num_rented, inventory.film_id
    FROM rental
    LEFT JOIN inventory ON rental.inventory_id=inventory.inventory_id
    WHERE rental.customer_id=1
    GROUP BY customer_id, film_id
) AS customer_films ON film.film_id=customer_films.film_id
WHERE customer_films.num_rented > 1;
