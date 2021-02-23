/*
 * A group of social scientists is studying American movie watching habits.
 * To help them, select the titles of all films that have never been rented by someone who lives in the United States.
 *
 * HINT:
 * This can be solved either with a LEFT JOIN or with the NOT IN operator.
 * You may choose whichever solution makes the most sense to you.
 */

SELECT title
FROM (
    SELECT title, film_id
    FROM (
        SELECT film.title, rented_inventory.film_id, rented_inventory.rental_id
        FROM film
        LEFT JOIN (
            SELECT inventory.film_id, inventory.inventory_id, rental.rental_id
            FROM rental
            LEFT JOIN inventory ON rental.inventory_id=inventory.inventory_id
        ) AS rented_inventory ON film.film_id=rented_inventory.film_id
    ) AS rented_films
    WHERE film_id IS NOT NULL
) AS rented_films
WHERE title NOT IN (
    SELECT film.title
    FROM (
        SELECT inventory.film_id, rental_country.rental_id, rental_country.country 
        FROM (
            SELECT rental.rental_id, rental.inventory_id, rental.customer_id, customer_country.country
            FROM rental
            LEFT JOIN (
                SELECT customer.customer_id, address_country.country
                FROM customer
                LEFT JOIN (
                    SELECT address.address_id, city_country.country
                    FROM address
                    LEFT JOIN (
                        SELECT city.city_id, country.country
                        FROM city
                        LEFT JOIN country ON city.country_id=country.country_id
                    ) AS city_country ON address.city_id=city_country.city_id
                ) AS address_country ON customer.address_id=address_country.address_id
            ) AS customer_country ON rental.customer_id=customer_country.customer_id
            ORDER BY inventory_id
        ) AS rental_country
        LEFT JOIN inventory ON rental_country.inventory_id=inventory.inventory_id
    ) AS us_rentals
    LEFT JOIN film ON us_rentals.film_id=film.film_id
    WHERE country='United States'
)
GROUP BY title
ORDER BY title;

