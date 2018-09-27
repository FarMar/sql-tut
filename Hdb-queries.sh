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

# 7.	How many sequences have a length greater than 1000?

SELECT count(name) FROM sequence WHERE length > 1000;

# 8.	How many sequences have a length greater than 1000 and are from sample “D36-s2-tr”?

SELECT count(sample.name) FROM sequence JOIN sample ON sequence.isSample = sample.id 
WHERE length > 1000 AND sample.name = 'D36-s2-tr';

# 9.	What is the average length of all sequences?

SELECT avg(length) FROM sequence;

# 10.	What is the average length of sequences of type “genomeAssembly”?

SELECT avg(length) FROM sequence JOIN seqtype ON sequence.isType = seqtype.id 
WHERE seqtype.type IS 'genomeAssembly' ;

# 11.	What is the average length of sequences of type “genomeAssembly” 
#       AND what is the average length of sequences of type “protein”? 

SELECT seqtype.type, avg(length) FROM sequence JOIN seqtype ON sequence.isType = seqtype.id 
WHERE seqtype.type IS 'genomeAssembly' UNION
SELECT seqtype.type, avg(length) FROM sequence JOIN seqtype ON sequence.isType = seqtype.id 
WHERE seqtype.type IS 'protein';

# 12.	How many annotations (alignedannot.annotation) contain the phrase “hypothetical”?

SELECT count(*) FROM alignedannot WHERE annotation LIKE '%hypothetical%';

# 13.	Can you list details of the sequence named “D18-gDNA-s1638”, 
#       replacing the foreign keys with sensible info (e.g. replace ‘isSample’ 
#       id with actual sample name)? 

## looks like JOIN is required - see Andrew's example:

## name            seqgroup    sample      type            length    
## --------------  ----------  ----------  --------------  ----------
## D18-gDNA-s1638  D18-gDNA    D18-gDNA    genomeAssembly  17213   
##

SELECT sequence.id, sequence.name, sequence.length, seqgroup.name, seqtype.type, sample.name 
FROM sequence 
JOIN sample ON sequence.isSample = sample.id
JOIN seqtype ON sequence.isType = seqtype.id  
JOIN seqgroup ON sequence.belongsGroup = seqgroup.id
WHERE sequence.name = 'D18-gDNA-s1638';

## just needs cleaning up 

