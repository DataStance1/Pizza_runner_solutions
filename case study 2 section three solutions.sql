-- C. INGREDIENT OPTIMIZATION

-- Questions one: 
-- What are the standard ingredients for each pizza?

WITH CTE AS 
(
	SELECT	p.pizza_id, 
			t.topping_name
	FROM pizza_runner.clean_pizza_recipes AS p
	JOIN pizza_runner.pizza_toppings AS t
		ON p.toppings::int = t.topping_id
	ORDER BY pizza_id
)
SELECT pizza_id, 
	   string_agg (topping_name, ', ') AS standard_ingredient
FROM CTE
GROUP BY pizza_id

-- QUESTION TWO: 
-- What was the most commonly added extra?
WITH a AS 
(
	SELECT order_id, 
		   CAST (UNNEST(STRING_TO_ARRAY(extras, ',')) AS INT) AS extras
	FROM pizza_runner.customer_orders
)	  

SELECT t.topping_name as extra_ingredient,
	   COUNT (extras) AS use
FROM a
JOIN pizza_runner.pizza_toppings AS t
	ON a.extras = t.topping_id
GROUP BY extra_ingredient
ORDER BY use DESC
-- Bacon is the most commonly added extra

-- Question three: 
-- What was the most common exclusion?

WITH CTE AS 
(
	SELECT order_id, 
		   CAST (UNNEST(STRING_TO_ARRAY(exclusions, ',')) AS INT) AS exclusions
	FROM pizza_runner.customer_orders
)	  
SELECT t.topping_name as excluded_ingredient,
	   COUNT (exclusions) AS use
FROM CTE
JOIN pizza_runner.pizza_toppings AS t
	ON CTE.exclusions = t.topping_id
GROUP BY excluded_ingredient
ORDER BY use DESC
-- Cheese is the most common exclusion


-- Question 4
-- Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

SELECT *
FROM pizza_runner.customer_orders

 -- Adding a unique_id column because the there was duplicates in the order_id
 
ALTER TABLE pizza_runner.customer_orders
ADD COLUMN unique_id serial PRIMARY KEY

-- creating a temp table, exclusions with columns- unique_id, order_id, exclusions, topping_name

CREATE TEMP TABLE exclusion AS 
WITH cte as
(
	SELECT	unique_id, 
	   		order_id,
	   		UNNEST(STRING_TO_ARRAY(exclusions, ',')) AS exclusions	   
	FROM  pizza_runner.customer_orders
)
SELECT	cte.*,
		t.topping_name
FROM cte
JOIN pizza_runner.pizza_toppings t
	ON exclusions::int = t.topping_id;

SELECT *
FROM exclusion;

-- creating a temp table, extra with columns- unique_id, order_id, extras and topping_name

CREATE TEMP TABLE extra AS 
WITH cte as
(
	SELECT	unique_id, 
	   		order_id,
	   		UNNEST(STRING_TO_ARRAY(extras, ',')) AS extras	   
	FROM  pizza_runner.customer_orders
)
SELECT	cte.*,
		t.topping_name
FROM cte
JOIN pizza_runner.pizza_toppings t
	ON extras::int = t.topping_id;
	
SELECT *
FROM extra;

-- Join the two temp tables with a union to get a single table-

WITH cteExtra AS (
	SELECT	unique_id, 
			order_id,
			CONCAT('Extra- ' , STRING_AGG(topping_name, ', ')) AS order_item
	FROM extra
	GROUP BY unique_id, order_id
),
cteExclusion AS (
	SELECT	unique_id,
			order_id,
			CONCAT('Exclude- ', STRING_AGG(topping_name, ', ')) AS order_item
	FROM exclusion
	GROUP BY unique_id, order_id
),
cteUnion AS ( 
	SELECT * FROM cteExtra
	UNION
	SELECT * FROM cteExclusion
)
SELECT	c.unique_id,
  		c.order_id,
  		c.customer_id,
  		c.pizza_id,
  		c.order_time,
		p.pizza_name,
		CONCAT_WS (' - ', p.pizza_name, STRING_AGG(u.order_item, ', ')) as order_item
FROM pizza_runner.customer_orders c
LEFT JOIN cteUnion u 
	ON c.unique_id = u.unique_id
LEFT JOIN pizza_runner.pizza_names p
	ON c.pizza_id = p.pizza_id
GROUP BY c.unique_id,
  		 c.order_id,
  		 c.customer_id,
  		 c.pizza_id,
  		 c.order_time,
		 p.pizza_name
ORDER BY
	order_id
-- Meat lovers orders have more alteration to their ingredients than vegetarian orders with cheese being excluded most and bacon being added most.

--Question five
-- Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
-- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

-- STEP ONE: Use a CTE to create a table where each line displays the ingredient for the particular order 
--(2x to the extras and exclude the exclusions)

CREATE TEMP TABLE pizza_ingredients AS (
	SELECT	c.pizza_id,
			c.toppings as topping_id,
			t.topping_name
	FROM pizza_runner.clean_pizza_recipes c
	JOIN 	pizza_runner.pizza_toppings t
		ON c.toppings::int = t.topping_id
	ORDER BY pizza_id
);

SELECT *
FROM pizza_ingredients;

WITH orderingredients AS (
	SELECT	c.*,
			n.pizza_name,
			CASE 
				WHEN 
					t.topping_id IN (SELECT extras::int FROM extra e WHERE e.unique_id = c.unique_id)  THEN CONCAT('2x', t.topping_name)
				ELSE t.topping_name
				END ingredients		
	FROM pizza_runner.customer_orders c
	JOIN pizza_runner.pizza_names n
		ON c.pizza_id = n.pizza_id
	JOIN pizza_ingredients t
		ON t.pizza_id = c.pizza_id
		WHERE t.topping_id NOT IN (SELECT exclusions::int FROM exclusion ex WHERE ex.unique_id = c.unique_id)	
)
SELECT	order_id,
		unique_id,
		customer_id,
		pizza_id,
		order_time,
		CONCAT(pizza_name, ': ', STRING_AGG(ingredients, ', ')) as ingredient_list 
FROM orderingredients
GROUP BY order_id,
		 unique_id,
		 customer_id,
		 pizza_id,
		 order_time,
		 pizza_name
ORDER BY  ingredient_list
;

-- Question six
-- What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

WITH A as (
SELECT	c.unique_id,
		c.order_id,
		t.topping_name,
		CASE 
				WHEN 
					t.topping_id IN (SELECT extras::int FROM extra e WHERE e.unique_id = c.unique_id)  THEN 2
				ELSE 1
				END time_used
FROM pizza_runner.customer_orders c
JOIN pizza_runner.runner_orders r
	ON c.order_id = r.order_id
JOIN pizza_ingredients t
		ON t.pizza_id = c.pizza_id
		WHERE t.topping_id NOT IN (SELECT exclusions::int FROM exclusion ex WHERE ex.unique_id = c.unique_id) AND r.cancellation isnull
)
SELECT	topping_name,
		SUM(time_used) as total_qty
FROM A
GROUP BY topping_name
ORDER BY total_qty desc

/* INSIGHTS*/
-- Bacon is the most commonly added extra
-- Cheese is the most common exclusion
-- Meat lovers orders have more alteration to their ingredients than vegetarian orders with cheese being excluded most and bacon being added most.
-- The most used ingredients is Bacon

--End