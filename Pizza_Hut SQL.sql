use Pizza_hut

--Basic 
--1) --Retrieve the total number of orders placed.

select 
	count(order_id) as Total_orders
from 
	orders;


--2)--Calculate the total revenue generated from pizza sales.

select 
	round(SUM(order_details.quantity * pizzas.price),2) as total_revenue
from 
	order_details join pizzas
on 
	order_details.pizza_id = pizzas.pizza_id


--3) Identify the highest-priced pizza.

select top 1
	pizza_types.Pizza_name, pizzas.price
from 
	pizza_types join pizzas
on
	pizza_types.pizza_type_id = pizzas.pizza_type_id
order by
	pizzas.price desc


--4) Identify the most common pizza size ordered.

select
	pizzas.size, sum(order_details.quantity) as Total_quantity
from
	pizzas join order_details
on 
	pizzas.pizza_id = order_details.pizza_id
group by
	pizzas.size
order by
	Total_quantity desc


--5) List the top 5 most ordered pizza types along with their quantities.

select  
	top 5 pizza_types.Pizza_name, sum(order_details.quantity) as Total_quntity
from 
	pizza_types join pizzas
on
	pizza_types.pizza_type_id = pizzas.pizza_type_id
join
	order_details 
on 
	order_details.pizza_id = pizzas.pizza_id
group by 
	pizza_types.Pizza_name 
order by
	Total_quntity desc


--Intermediate:

--6) Join the necessary tables to find the total quantity of each pizza category ordered.

select 
	pizza_types.category, SUM(order_details.quantity) as Total_quantity
from 
	pizza_types join pizzas
on 
	pizza_types.pizza_type_id = pizzas.pizza_type_id
join
	order_details
on 
	order_details.pizza_id = pizzas.pizza_id
group by
	pizza_types.category 


--7)Join relevant tables to find the category-wise distribution of pizzas.

  select
	pizza_types.category, count(order_details.order_id) as count_orders
from 
	pizza_types join pizzas
on 
	pizza_types.pizza_type_id = pizzas.pizza_type_id
join 
	order_details
on 
	order_details.pizza_id = pizzas.pizza_id
group by
	pizza_types.category


--8)Group the orders by date and calculate the average number of pizzas ordered per day.

select  
	avg(Total) as total_average 
from 
	(select orders.order_date, SUM(order_details.quantity) as Total
from
	orders join order_details
on
	orders.order_id = order_details.order_id
group by 
	orders.order_date) as order_quantity


--9) Determine the top 3 most ordered pizza types based on revenue.

select
	top 3 pizza_types.pizza_name, round(sum(order_details.quantity * pizzas.price),0) as total_revenue
from 
	pizza_types join pizzas
on 
	pizza_types.pizza_type_id = pizzas.pizza_type_id
join 
	order_details
on
	order_details.pizza_id = pizzas.pizza_id
group by 
	pizza_types.pizza_name
order by
	total_revenue desc


--Advanced

--10)Calculate the percentage contribution of each pizza type to total revenue.

select pizza_types.category,
round(sum(order_details.quantity * pizzas.price)/(select round(sum(order_details.quantity * pizzas.price),2) 
as
	total_sale
from 
	order_details join pizzas
on
	pizzas.pizza_id = order_details.pizza_id) *100,2) as revenue
from
	pizza_types join pizzas
on 
	pizza_types.pizza_type_id = pizzas.pizza_type_id
join 
	order_details
on
	order_details.pizza_id = pizzas.pizza_id
group by 
	pizza_types.category
order  by
	revenue desc