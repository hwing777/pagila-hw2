/*
 * A film's rating can be either G, PG, PG-13, etc.
 * First, generate a query that returns the two most popular ratings.
 * Then, use a subquery to select the film_id and title columns
 * for all films whose rating is one of the two most popular.
 * Use the film table and order by title.
 */

SELECT film_id, title
FROM film
WHERE rating IN (
    SELECT rating
    FROM (
        SELECT rating, count(film_id) as popularity
        FROM film
        GROUP BY rating
        ORDER BY popularity DESC
        LIMIT 2
    ) AS top_ratings
)
ORDER BY title;
