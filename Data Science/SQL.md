# SQL 
- List all orders with customer information

ORDER TABLE:
- Orderid
- Customerid
- OrderNumber
- TotalAmount

CUSTOMER TABLE:
- id
- FirstName
- LastName
- City
- Country

```
SELECT OrderNumber, TotalAmount, FirstName, LastName, City, Country
FROM ORDER
JOIN CUSTOMER
ON Order.Customerid = Customer.id
```