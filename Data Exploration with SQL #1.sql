/*
1. My partner and I want to come by each of the stores in person and meet the managers. Please send over the managers’ names at each store, 
with the full address of each property (street address, district, city, and country please).

*/
SELECT staff.first_name, staff.last_name, address.address, address.district, city.city, country.country, concat(address.address, ', ',  address.district, ', ', city.city, ', ',  country.country) AS "Full Address"
FROM staff
		INNER JOIN store ON staff.store_id = store.store_id AND staff.staff_id = store.manager_staff_id
        INNER JOIN address ON store.address_id = address.address_id
        INNER JOIN city ON city.city_id = address.city_id
        INNER JOIN country ON country.country_id = city.country_id;
/*
2. I would like to get a better understanding of all of the inventory that would come along with the business. Please pull together a list of 
each inventory item you have stocked, including the store_idnumber, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/
SELECT inventory.store_id, inventory.inventory_id, film.title, film.rating, film.rental_rate, film.replacement_cost 
	FROM inventory
		INNER JOIN film ON film.film_id = inventory.film_id;
/*
3. From the same list of films you just pulled, please roll that data up and provide a summary level overview of your inventory. 
We would like to know how many inventory items you have with each rating at each store. 
*/
SELECT film.rating, inventory.store_id, count(distinct inventory.inventory_id) AS "Inventory" 
	FROM inventory
		INNER JOIN film ON film.film_id = inventory.film_id
	GROUP BY film.rating, inventory.store_id
    ORDER BY store_id ASC;
/*
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to see how big of a hit it would be if a certain category of 
film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, sliced by store and film category. 
*/
SELECT inventory.store_id, category.name AS "Category Name", COUNT(film.film_id) as "Number of films", ROUND(AVG(film.replacement_cost), 2) AS "Average Replacement Cost", SUM(film.replacement_cost) AS "Total Replacement Cost"
FROM film
	INNER JOIN inventory ON inventory.film_id = film.film_id
    INNER JOIN film_category ON film_category.film_id = inventory.film_id
    INNER JOIN category ON category.category_id = film_category.category_id
GROUP BY inventory.store_id, category.name
ORDER BY category.name ASC;
/*
5. We want to make sure you folks have a good handle on who your customers are. 
Please provide a list of all customer names, which store they go to, whether or not they are currently active,  and their full addresses –street address, city, and country
*/
SELECT customer.first_name, customer.last_name, 
	concat(customer.first_name, ' ', customer.last_name) AS "Full Name", customer.store_id, address.address, city.city, country.country, 
				CASE WHEN customer.active = 0 THEN 'Inactive'
                ELSE 'Active'
                END AS "Customer Status"
FROM customer 
		INNER JOIN address ON customer.address_id = address.address_id
        INNER JOIN city ON city.city_id = address.city_id
        INNER JOIN country ON country.country_id = city.country_id
	ORDER BY customer.active;
/*
6. We would like to understand how much your customers are spending with you, and also to know who your most valuable customers are. 
Please pull together a list of customer names, their total lifetime rentals, and the sum of all payments you have collected from them. 
It would be great to see this ordered on total lifetime value, with the most valuable customers at the top of the list.
*/
SELECT customer.first_name, customer.last_name, COUNT(rental.rental_id) AS 'Lifetime Rentals', SUM(payment.amount) AS 'Sum of Payments'
FROM customer
	INNER JOIN rental ON customer.customer_id = rental.customer_id
    INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY customer.first_name, customer.last_name
ORDER BY SUM(payment.amount) DESC;
/*
7. My partner and I would like to get to know your board of advisors and any current investors. Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, it would be good to include which company they work with.
*/
SELECT first_name, last_name, 'Advisor' AS "Position", 'N/A' AS Company FROM advisor
UNION
SELECT first_name, last_name, 'Investor',company_name FROM investor;
/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film? 
And how about for actors with two types of awards? Same questions. Finally, how about actors with just one award?
*/
SELECT 
		CASE 
			WHEN awards = 'Emmy, Oscar, Tony ' THEN 'Three Awards' 
            WHEN awards IN ('Emmy, Tony', 'Emmy, Oscar','Oscar, Tony') THEN 'Two Awards'
            ELSE 'One Award'
            END AS Awards_Group, COUNT(actor_id)/COUNT(actor_award_id) AS Percentage_Carried
            FROM actor_award	
	GROUP BY 
    CASE 
			WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN 'Three Awards' 
            WHEN actor_award.awards IN ('Emmy, Tony', 'Emmy, Oscar','Oscar, Tony') THEN 'Two Awards'
            ELSE 'One Award'
            END;