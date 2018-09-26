sqlite3 hieracium.db

.mode columns
.headers on

# 1.	Can you list all details about all samples? 

SELECT * FROM sample;

# 2.	Can you list just the name and species for all samples? 

SELECT name, species FROM sample;