/**** Marketing team would like to know *****/
/**** List of customers who listening to Pop Music to send out promotion email for a Pop new album *****/
SELECT DISTINCT email, first_name, last_name 
FROM customer
JOIN invoice ON customer.customer_id=invoice.customer_id
JOIN invoice_line ON invoice.invoice_id=invoice_line.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track 
	JOIN genre ON track.genre_id=genre.genre_id
	WHERE genre.name LIKE 'Pop'
)
ORDER BY email;

/***** TOP 5 Ideal location to organize a music festival - where the best customers located ******/
SELECT billing_city, SUM(total) AS Invoice_Total 
FROM invoice
GROUP BY billing_city
ORDER BY Invoice_Total DESC 
TOP 5; 

/**** Partnership Team wannts to know the most popolar music genre for each country for future contract*****/
WITH Customer_with_country AS(
								SELECT customer.customer_id, first_name, last_name, billing_country, SUM(total) AS total_spending, 
							ROW_NUMBER() OVER (PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNO 
							 FROM invoice
							 JOIN customer on customer.customer_id=invoice.customer_id
							 GROUP BY 1,2,3,4
							 ORDER BY 4 ASC, 5 DESC)
SELECT * FROM Customer_with_country WHERE RowNO <= 1; 
