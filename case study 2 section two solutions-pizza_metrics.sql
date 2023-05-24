-- SECTION B- Runner and Customer Experience

SELECT *
FROM pizza_runner.runner_orders;

--Question one: 
--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT	DATE_PART('week', registration_date + INTERVAL '3 DAYS') as week,
		COUNT (runner_id) as num_of_signed_runners	   
FROM	pizza_runner.runners
GROUP BY week;
--Because postgres's week starts on Mondays, which is the 4th and woulD excludE sign ups from earlier, I added the "INTERVAL '3 days'" to ensure that signups within a 3-day period are included in the same week

-- Question two: 
--What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
-- first, I need to get a table with three columns, order_id, runner_id, wait_time(time it takes the runner to pickup the package), then take an averge of the wait time for each runner.

WITH CTE AS 
(
		SELECT r.order_id,
			   r.runner_id, 
			   r.pickup_time - c.order_time AS wait_time
		FROM pizza_runner.customer_orders c
		JOIN pizza_runner.runner_orders r
		ON c.order_id = r.order_id
		WHERE r.cancellation isNULL
)
SELECT runner_id,
	   AVG(wait_time)
FROM CTE
GROUP BY runner_id;

-- Question three: 
--Is there any relationship between the number of pizzas and how long the order takes to prepare?
-- Here I need to get the order_id, the number of pizzas and the preparation time(prep time) and order by the number of pizzas

WITH CTE AS 
(
SELECT c.order_id,
	   COUNT (c.order_id) AS num_of_pizza,
	   r.pickup_time - c.order_time AS prep_time
FROM pizza_runner.customer_orders c
JOIN pizza_runner.runner_orders r
	ON c.order_id = r.order_id
	WHERE r.cancellation isNULL
GROUP BY c.order_id, prep_time
ORDER BY num_of_pizza DESC
)
SELECT avg(prep_time) AS preparation_time,
	   num_of_pizza
FROM CTE
GROUP BY num_of_pizza
ORDER BY preparation_time DESC;
-- Yes there is a relationship between the number of pizza ordered and how long the order takes to prepared. Also there are other factors to be considered like the type of pizza ordered.

-- Question four: 
--What was the average distance travelled for each customer?
SELECT	c.customer_id, 
		ROUND(AVG(r.distance_km), 2) AS avg_distance_km
FROM pizza_runner.customer_orders c
JOIN pizza_runner.runner_orders r
	ON c.order_id = r.order_id
WHERE r.cancellation isnull
GROUP BY c.customer_id 
ORDER BY avg_distance_km desc;

--Question five: 
--What was the difference between the longest and shortest delivery times for all orders?

SELECT MAX(duration_min) - MIN(duration_min) AS difference_min
FROM pizza_runner.runner_orders;

-- Question six: 
--What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT	runner_id,
	  	ROUND (AVG(distance_km/duration_min), 2) AS avg_speed_Km_per_min
FROM pizza_runner.runner_orders
GROUP BY runner_id 
ORDER BY avg_speed_km_per_min desc;
-- No trend was seen

-- Question seven: 
--What is the successful delivery percentage for each runner?
-- come up with a table with columns: runner_id, successful deliveries, failed deliveries, total_deliveries, and percentage succesful deliveries

SELECT runner_id, COUNT(runner_id) as successful_del
FROM pizza_runner.runner_orders
WHERE cancellation isnull
GROUP BY runner_id;

SELECT runner_id, count(runner_id) as failed_del
FROM pizza_runner.runner_orders
WHERE cancellation is not NULL
GROUP BY runner_id;

SELECT runner_id, COUNT(runner_id) as total_del
FROM pizza_runner.runner_orders
GROUP BY runner_id;

SELECT a.*, 
	   b.failed_del, 
	   c.total_del,
	   (a.successful_del * 100)/c.total_del AS percent_suc_del
FROM (SELECT runner_id, COUNT(runner_id) as successful_del
	  FROM pizza_runner.runner_orders
	  WHERE cancellation isnull
	  GROUP BY runner_id) a
FULL JOIN (SELECT runner_id, count(runner_id) as failed_del
	  FROM pizza_runner.runner_orders
	  WHERE cancellation is not NULL
	  GROUP BY runner_id) b 
		ON a.runner_id = b.runner_id
FULL JOIN (SELECT runner_id, COUNT(runner_id) as total_del
		FROM pizza_runner.runner_orders
		GROUP BY runner_id) c
		ON a.runner_id = c.runner_id; 

