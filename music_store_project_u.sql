--  Q1: who is the senior most employ

select * from ms_db.employee

order by levels desc

limit 1

-- ---------------------------------------------------------------------------------------------------------------------------------------

--  Q2: list top 5 country has the most number of sales along with total revenue genrated?

select count(*) as number_of_orders, billing_country, sum(total) as Revenue from ms_db.invoice

group by billing_country

order by number_of_orders desc

limit 5

-- ---------------------------------------------------------------------------------------------------------------------------------------
/* Q3: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money.
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */


select count(*) as number_of_orders, billing_city, sum(total) as Revenue from ms_db.invoice
group by billing_city
order by number_of_orders desc
limit 2 

-- ---------------------------------------------------------------------------------------------------------------------------------------
/*  Q4: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money. */

SELECT 
    customer.customer_id, 
    customer.first_name, 
    customer.last_name,
    SUM(invoice.total) as total
FROM 
    ms_db.customer
JOIN 
    ms_db.invoice ON ms_db.customer.customer_id = ms_db.invoice.customer_id
GROUP BY 
    ms_db.customer.customer_id, 
    first_name, 
    last_name
order by
	total desc
limit 5

-- ---------------------------------------------------------------------------------------------------------------------------------------
/*  Q5: Write query to return the email, first name, last name, & Genre of all Rock Music listeners.
Return your list ordered alphabetically by email starting with A */


SELECT 
    customer.email, 
    customer.first_name, 
    customer.last_name

FROM 
    ms_db.customer
    
JOIN ms_db.invoice ON ms_db.customer.customer_id = ms_db.invoice.customer_id
JOIN ms_db.invoice_line ON ms_db.invoice.invoice_id = ms_db.invoice_line.invoice_id
JOIN ms_db.track ON ms_db.invoice_line.track_id = ms_db.track.track_id
JOIN ms_db.genre ON ms_db.track.genre_id = ms_db.genre.genre_id

where ms_db.genre.name like 'Rock'

group by
	customer.email, 
    customer.first_name, 
    customer.last_name

order by ms_db.customer.email

-- ---------------------------------------------------------------------------------------------------------------------------------------
/*  Q6: Store wants to invite top selling artists  whe have genrated the most revenue  to their 
annual event. write a quary to get the names of top 3 artistis and their total sales.
 */

SELECT 
	ms_db.artist.artist_id,
    ms_db.artist.name,
    sum(invoice.total) as sales_revenue
FROM 
    ms_db.invoice

JOIN ms_db.invoice_line ON ms_db.invoice.invoice_id = ms_db.invoice_line.invoice_id
JOIN ms_db.track ON ms_db.invoice_line.track_id = ms_db.track.track_id
JOIN ms_db.album_2 ON ms_db.track.album_id = ms_db.album_2.album_id
JOIN  ms_db.artist ON ms_db.album_2.artist_id = ms_db.artist.artist_id

group by
	ms_db.artist.artist_id,
    ms_db.artist.name
    
order by sales_revenue desc

limit 5

-- ---------------------------------------------------------------------------------------------------------------------------------------

/* Q7: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */



WITH popular_genre AS (
    SELECT 
        invoice.billing_country AS Country, 
        COUNT(invoice.invoice_id) AS TotalInvoices, 
        genre.name AS Genre,
        ROW_NUMBER() OVER(PARTITION BY invoice.billing_country ORDER BY COUNT(invoice.invoice_id) DESC) AS RowNo
    FROM 
        ms_db.invoice
        JOIN ms_db.invoice_line ON invoice.invoice_id = invoice_line.invoice_id
        JOIN ms_db.track ON invoice_line.track_id = track.track_id
        JOIN ms_db.genre ON track.genre_id = genre.genre_id
    GROUP BY 1, 3
)
SELECT 
    Country, 
    TotalInvoices, 
    Genre
FROM 
    popular_genre
WHERE 
    RowNo = 1
ORDER BY TotalInvoices DESC;