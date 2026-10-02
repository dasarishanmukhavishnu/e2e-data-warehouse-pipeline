/*
========================================================
PAYMENT ANALYSIS
========================================================

Purpose:
Understand payment behavior and payment methods.

Source:
warehouse.fact_payments
========================================================
*/

/*
--------------------------------------------------------
1. Payment Method Analysis
--------------------------------------------------------

Business Question:
How do customers pay and what is the payment value?

Result Grain:
One row = one payment type.
*/

select
    payment_type,count(*) as payment_transactions,count(distinct order_id) as orders,
    sum(payment_value) as payment_value,
    round(
        avg(payment_value),
        2
    ) as average_payment_value
from warehouse.fact_payments
group by payment_type
order by payment_value desc;

/*
--------------------------------------------------------
2. Installment Analysis
--------------------------------------------------------

Business Question:
How does payment value vary with installments?

Result Grain:
One row = one installment count.
*/

select
    installments,count(*) as payment_transactions,sum(payment_value) as payment_value,
    round(avg(payment_value), 2) as average_payment_value
from warehouse.fact_payments
group by installments
order by installments;
