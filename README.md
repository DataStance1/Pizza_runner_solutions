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
