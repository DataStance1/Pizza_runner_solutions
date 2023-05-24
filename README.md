# Pizza_runner_solutions
My solutions to Danny Ma's week two SQL challenge
![image](https://github.com/DataStance1/Pizza_runner_solutions/assets/114801619/2dcb4d32-d68d-466d-9df2-898b5527f29c)
## Introduction

Pizza Runner is Danny’s idea of uberizing pizza delivery. He has provided me, the data analyst, with data from the business to analyze and give him insights. But the data provided is messy and needs some cleaning.

## Problem Statement
Danny has prepared an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimize Pizza Runner’s operations.
## Available data
Danny Ma provided 6 tables
### Entity Relationship Diagram
![image](https://github.com/DataStance1/Pizza_runner_solutions/assets/114801619/51ac0762-e09d-4bdd-a254-e7ce58c9b202)
### Table 1: runners
The runners table shows the registration_date for each new runner
### Table 2: customer_orders
Customer pizza orders are captured in the customer_orders table with one row for each individual pizza that is part of the order.
### Table 3: runner_orders
After each order is received through the system, they are assigned to a runner; however, not all orders are fully completed and can be cancelled by the restaurant or the customer.
### Table 4: pizza_names
At the moment, Pizza Runner only offers two types of pizza: meat lovers and vegetarians.
### Table 5: pizza_recipes
Eachpizza_id has a standard set of toppings which are used as part of the pizza recipe.
### Table 6: pizza_toppings
This table contains all of the topping_name values with their corresponding topping_id value
## INSIGHT
* Meat_lovers sells more than vegetarian
* Wednesdays and saturdays are the days with the highest sales
* customers order pizzas more into the day and in the evening than early morning hours
* Many of the pizzas ordered had either exclusions or extras perhaps it is time to add another type of pizza with a different ingredients
*  Bacon is the most commonly added extra
* Cheese is the most common exclusion
* Meat lovers orders have more alteration to their ingredients than vegetarian orders with cheese being excluded most and bacon being added most.
* The most used ingredients is Bacon
## RECOMMENDATIONS
* Danny Ma's runners travelled long distance to deliver the pizza which is not very ideal for a starting business. Danny Ma should consider creating an advert to target people closer to the pizza factory
* Since there is always and alteration in the pizza ingredients, it is quite about time to introduce a new pizza type with a different recipe based on the popular alterations 
* Danny ma should develop an effective way of collecting customer feedback as this very important for a budding business
* Since Bacon is the commonly used ingredients, danny ma should ensure not run out of it.
* Danny should look into the preparation and delivery time of the ordered pizza. Pizza with Order_id 8 took a long time to deliver
* Introduction of the new pizza type - Supreme should be followed with advertisement
* Danny should have a discount or loyalty program for repeated customers
## CONCLUSION
Danny should implement these recommendations to keep the business afloat. So far, the business is performing well for a start but more work need to be done to unlock the limitless possibilities of the business. Thank you and happy pizza day!
