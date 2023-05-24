--E. Bonus Questions
--If Danny wants to expand his range of pizzas 
--how would this impact the existing data design? 
--Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?

--insert the new pizza name and id into the pizza_names table
INSERT INTO pizza_runner.pizza_names (pizza_id, pizza_name)
VALUES (3, 'Supreme');
SELECT *
FROM pizza_runner.pizza_names;

--insert the pizza ingredients into the pizza_recipes tables
WITH CTE AS (
	SELECT pizza_id
	FROM pizza_runner.pizza_names
	WHERE pizza_name = 'Supreme'
)
INSERT INTO pizza_runner.pizza_recipes (pizza_id, toppings)
SELECT (SELECT pizza_id FROM CTE), 
	    string_agg(pt.topping_id::text, ', ')
FROM pizza_runner.pizza_toppings pt;

SELECT *
FROM pizza_runner.pizza_recipes

-- END

