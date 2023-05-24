SELECT *
FROM pizza_runner.customer_orders;

--  Part one: Pizza Metrics

-- Question one: How many pizzas were ordered?

SELECT COUNT(order_id) AS num_of_pizza_order
FROM pizza_runner.customer_orders;

-- Question two: How many unique customer orders were made?

SELECT COUNT (DISTINCT order_id) AS num_of_unique_orders
from pizza_runner.customer_orders;

-- Question three: How many successful orders were delivered by each runner

SELECT runner_id, 
	   COUNT(order_id) AS successful_deliveries
FROM pizza_runner.runner_orders
WHERE cancellation isnull
GROUP BY runner_id

-- Question four: How many of each type of pizza was delivered?

SELECT c.pizza_id AS type_of_pizza, 
	   COUNT(c.order_id) AS num_delivered
FROM pizza_runner.customer_orders c
JOIN pizza_runner.runner_orders r
	ON c.order_id = r.order_id
	AND r.cancellation isnull
GROUP BY type_of_pizza

-- Questions five: How many Vegetarian and Meatlovers were ordered by each customer?

WITH CTE AS 
(
	SELECT customer_id, 
		CASE
			WHEN pizza_id = 1 THEN 'yes' END meat_lovers, 
		CASE 
			WHEN pizza_id = 2 then 'yes' end vegetarian
	FROM pizza_runner.customer_orders
)
SELECT 
	customer_id, 
	COUNT (meat_lovers) as qty_meat_lover,
	COUNT (vegetarian) as qty_vegetarian
FROM CTE
GROUP BY customer_id;

--Question six: What was the maximum number of pizzas delivered in a single order?

SELECT DISTINCT c.order_id, 
				COUNT(c.pizza_id) pizza_per_order
FROM pizza_runner.customer_orders c
JOIN pizza_runner.runner_orders r
	ON c.order_id = r.order_id
	AND r.cancellation ISNULL
GROUP BY c.order_id
ORDER BY pizza_per_order DESC
limit 1;

--Question seven: For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
--the is one of the questions that points towards having a different kind of pizza- 

WITH CTE as (
	SELECT c.customer_id,
		CASE 
			WHEN c.exclusions isnull AND c.extras isnull THEN 'yes' END no_alteration,
		CASE 
			WHEN (c.exclusions is not NULL AND c.extras is not NULL) 
				OR (c.exclusions isnull AND c.extras is not NULL) 
				OR (c.extras isnull AND c.exclusions is not NULL) THEN 'yes' END altered
	FROM pizza_runner.customer_orders c
	JOIN pizza_runner.runner_orders r
	ON c.order_id = r.order_id
	AND r.cancellation ISNULL
)
SELECT customer_id, 
	   COUNT(no_alteration) num_of_unchanged,
	   COUNT(altered) num_of_changed
FROM CTE
GROUP BY customer_id

-- Question eight: How many pizzas were delivered that had both exclusions and extras?

SELECT COUNT (c.order_id) AS delivered_with_both_exclusions_and_extras
FROM pizza_runner.customer_orders c
JOIN pizza_runner.runner_orders r
	ON c.order_id = r.order_id
	AND r.cancellation ISNULL
WHERE exclusions is not NULL 
	  AND extras is not NULL
	  
-- Question nine: What was the total volume of pizzas ordered for each hour of the day?

SELECT EXTRACT(HOUR FROM order_time) AS hour_of_day, 
	   COUNT(order_id) as vol_of_pizza
FROM pizza_runner.customer_orders 
GROUP BY hour_of_day

-- Question ten: What was the volume of orders for each day of the week?

SELECT EXTRACT (dow FROM order_time) AS day_of_the_week,
	   COUNT(order_id) as vol_of_pizza
FROM pizza_runner.customer_orders
GROUP BY day_of_the_week


--Insights
-- Meat_lovers sells more than vegetarian
-- Wednesdays and saturdays are the days with the highest sales
-- customers order pizzas more into the day and in the evening than early morning hours
-- Many of the pizzas ordered had either exclusions or extras perhaps it is time to add another type of pizza with a different ingredients

