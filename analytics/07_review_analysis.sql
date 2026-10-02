/*
========================================================
REVIEW ANALYSIS
========================================================

Purpose:
Analyze customer satisfaction.

Source:
warehouse.fact_reviews
========================================================
*/

/*
--------------------------------------------------------
1. Review Score Distribution
--------------------------------------------------------

Business Question:
How are customer reviews distributed?

Result Grain:
One row = one review score.
*/      

select
    review_score,count(*) as review_count,
    round(
        count(*) * 100.0 / 
        sum(count(*)) over (), 
        2
    ) as review_percentage
from warehouse.fact_reviews
group by review_score
order by review_score;

/*
--------------------------------------------------------
2. Average Review Score
--------------------------------------------------------

Business Question:
What is the overall average customer rating?

Result Grain:
One row = entire review dataset.
*/

select 
    round(avg(review_score),2) as average_review_score
from warehouse.fact_reviews;