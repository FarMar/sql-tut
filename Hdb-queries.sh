sqlite3 hieracium.db

.mode columns
.headers on

# 1.	Can you list all details about all samples? 

SELECT * FROM sample;

# 2.	Can you list just the name and species for all samples? 

SELECT name, species FROM sample;

# 3.	Can you list details of the first 10 sequences?

SELECT * FROM sample limit 10;

# 4.	How many loaded sequences are there?

SELECT count(name) FROM sequence;

# 5.	How many sequences are of the type “genomeAssembly”?

SELECT count(name) FROM sequence JOIN seqtype ON sequence.isType = seqtype.id 
WHERE seqtype.type IS 'genomeAssembly' ;

# 6.	How many loaded sequences are there of each different type? 

SELECT seqtype.type, count(name) FROM sequence 
JOIN seqtype ON sequence.isType = seqtype.id 
GROUP BY seqtype.type;
