/*
 * Management wants to send coupons to customers who have previously rented one of the top-5 most profitable movies.
 * Your task is to list these customers.
 *
 * HINT:
 * In problem 16 of pagila-hw1, you ordered the films by most profitable.
 * Modify this query so that it returns only the film_id of the top 5 most profitable films.
 * This will be your subquery.
 * 
 * Next, join the film, inventory, rental, and customer tables.
 * Use a where clause to restrict results to the subquery.
 */

SELECT customer_id
FROM (
    SELECT rental.customer_id, rental.rental_id, rental.inventory_id, inventory.film_id
    FROM rental
    LEFT JOIN inventory ON rental.inventory_id=inventory.inventory_id
) AS customer_films
WHERE film_id IN (
    SELECT film_id
    FROM (
        SELECT film_id, sum(amount) as profit
        FROM (
            SELECT payment.payment_id, payment.amount, rental_title.film_id
            FROM PAYMENT
            LEFT JOIN (
                SELECT rental.rental_id, inventory_title.film_id
                FROM rental
                LEFT JOIN (
                    SELECT inventory.inventory_id, film.film_id
                    FROM inventory
                    LEFT JOIN film ON inventory.film_id=film.film_id
                ) AS inventory_title ON rental.inventory_id=inventory_title.inventory_id
            ) AS rental_title ON payment.rental_id=rental_title.rental_id
        ) AS payment_title
        GROUP BY film_id
        ORDER BY profit DESC
        LIMIT 5
    ) AS top_films
)
GROUP BY customer_id
ORDER BY customer_id;

