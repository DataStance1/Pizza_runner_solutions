-- Section D. Pricing and Ratings

--Question 1
-- If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes 
-- how much money has Pizza Runner made so far if there are no delivery fees?

SELECT 
	SUM(CASE WHEN pizza_id = 1 THEN 12 ELSE 10 END) total_amount_$
FROM pizza_runner.customer_orders c
JOIN pizza_runner.runner_orders r
	ON c.order_id = r.order_id
WHERE r.cancellation ISNULL

-- Question 2
-- What if there was an additional $1 charge for any pizza extras?
-- example Add cheese is $1 extra

WITH CTE1 AS (
	SELECT 
		SUM(CASE WHEN pizza_id = 1 THEN 12 ELSE 10 END) pizza_amount_$
	FROM pizza_runner.customer_orders c
	JOIN pizza_runner.runner_orders r
		ON c.order_id = r.order_id
	WHERE r.cancellation ISNULL
),
CTE2 AS (
	SELECT	unique_id, 
	   		order_id,
	   		UNNEST(STRING_TO_ARRAY(extras, ',')) AS extras	   
	FROM  pizza_runner.customer_orders
),
CTE3 AS (
	SELECT 
		SUM(CASE WHEN extras isnull THEN 0 ELSE 1 END) AS extra_amount_$ 
	FROM CTE2
	JOIN pizza_runner.runner_orders r
		ON CTE2.order_id = r.order_id
	WHERE r.cancellation ISNULL
)
SELECT 
	pizza_amount_$ + extra_amount_$
FROM CTE1, CTE3
	
-- Question 3
-- The Pizza Runner team now wants to add an additional ratings system that allows customers
-- to rate their runner, how would you design an additional table for this new dataset 
-- generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

DROP TABLE IF EXISTS runner_ratings;
CREATE TABLE pizza_runner.runner_ratings (
  order_id INT,
  rating INT
);

INSERT INTO pizza_runner.runner_ratings (order_id, rating)
VALUES 
  (1,2),
  (2,4),
  (3,3),
  (4,1),
  (5,4),
  (7,2),
  (8,4),
  (10,2);

SELECT * FROM pizza_runner.runner_ratings;


--Question 4
-- Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
-- customer_id
-- order_id
-- runner_id
-- rating
-- order_time
-- pickup_time
-- Time between order and pickup
-- Delivery duration
-- Average speed
-- Total number of pizzas

SELECT 
    c.customer_id,
    c.order_id,
    ro.runner_id,
    rr.rating,
    c.order_time,
    ro.pickup_time,
    ro.pickup_time - c.order_time AS times_difference,
    ro.duration_min,
    ROUND(AVG(ro.distance_km / ro.duration_min), 2) AS avg_speed_km_min,
    COUNT(c.order_id) AS num_of_pizza
FROM 
    pizza_runner.customer_orders c
JOIN 
    pizza_runner.runner_orders ro ON ro.order_id = c.order_id
JOIN 
    pizza_runner.runner_ratings rr ON rr.order_id = c.order_id
GROUP BY 
    c.customer_id,
    c.order_id,
    ro.runner_id,
    rr.rating,
    c.order_time,
    ro.pickup_time, 
    ro.duration_min;

-- Question 5
-- If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled 
-- how much money does Pizza Runner have left over after these deliveries?

WITH Income AS ( 
    SELECT 
        SUM(CASE WHEN pizza_id = 1 THEN 12 ELSE 10 END) AS income
    FROM pizza_runner.customer_orders c
    JOIN pizza_runner.runner_orders r ON c.order_id = r.order_id
    WHERE r.cancellation IS NULL
),
Expenses AS (
    SELECT 
        SUM(0.30 * distance_km) AS expenses
    FROM pizza_runner.runner_orders
)
SELECT 
    income - expenses AS net_income_$
FROM Income, Expenses;