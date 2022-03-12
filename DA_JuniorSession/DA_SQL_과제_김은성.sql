/* 1. 국가별 office, employee 수 */
select o.country, count(o.officecode) 'office_num', count(e.employeenumber) 'employee_num'
from offices o join employees e on o.officecode=e.officecode
group by o.country;

/* 2.customerfirstname이 'R'로 시작하는 고객 리스트 */
select * from customers
where contactFirstname like 'R%';

/* 3. order상태가 'Cancelled' 나 'On Hold'인 미국 고객의 주문 건수 */
select * from orders o join customers c on o.customerNumber =c.customernumber
where o.status in ('Cancelled', 'On Hold') and c.country='USA';

/* 4. 가장 많은 고객 담당한 office code */
select o.* 
from offices o
	join
	(select e.employeenumber, e.officecode, count(c.customernumber) cust_num
	from employees e join customers c on e.employeenumber=c.salesRepEmployeeNumber
	group by e.employeenumber, e.officecode
    order by cust_num desc limit 1) tab1
	on o.officecode=tab1.officecode;
    
/* 5. 2004.11 최다 금액 결제 고객 정보 */
select c.*
from customers c join
(select customernumber, sum(amount) sum_pay from payments p
where paymentdate like '2004-11%'
group by customernumber order by sum_pay desc limit 1) tab2 on c.customernumber=tab2.customernumber;

/* 6. 2005.1 orderDate와 shippedDate 사이 기간 최대, 최솟값 */
select max(ship_days) max_days, min(ship_days) min_days
from
(select datediff(shippeddate, orderdate) ship_days from orders o
where o.orderdate like '2005-01%') tab3;

/* 7. 2004년 1년간 최다 금액 결제한 고객의 담당 employee정보 */
select e.* from
(select customernumber, sum(amount) sum_pay from payments p
where paymentdate like '2004%'
group by customernumber order by sum_pay desc limit 1) tab4 
join customers c on tab4.customernumber = c.customernumber
join employees e on e.employeenumber = c.salesRepemployeenumber;