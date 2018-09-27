# SQL Tutorial
## Tutorial based upon the *Hieracium* database

_See SQL-exercise-sequenceAnnotations.docx for info_

## Part 1a - Setting up the database

Firstly, the database needs to be created: `sqlite3 hieracium.db`

Then, we need to create the tables, taking care to ensure that pre-requisites as defined by `FOREIGN KEY` statements are entered before those which depend upon them.

```
# Create sample table, note id is integer and primary key

CREATE TABLE sample (
	id integer PRIMARY KEY,
	name text,
	species text,
	description text
);
```

```
# Create seqgroup TABLE

CREATE TABLE seqgroup (
	id integer PRIMARY KEY,
	name text,
	description text
);
```

```
# Create seqtype TABLE

CREATE TABLE seqtype (
	id integer PRIMARY KEY,
	type text
);
```

```
# Create sequence table, noting foreign keys which mean those tables need importing first

CREATE TABLE sequence (
	id integer PRIMARY KEY,
	name text,
	length integer,
	belongsGroup integer,
	isSample integer,
	isType integer,
	FOREIGN KEY (belongsGroup) REFERENCES seqgroup(id),
	FOREIGN KEY (isSample) REFERENCES sample(id),
	FOREIGN KEY (isType) REFERENCES seqtype(id)
);
```

```
# Create seqrelation TABLE

CREATE TABLE seqrelation (
	id integer PRIMARY KEY,
	parentSeq integer,
	childSeq integer,
	strand boolean,
	pStart integer,
	pEnd integer,
	cStart integer,
	cEnd integer,
	method text,
	FOREIGN KEY (parentSeq) REFERENCES sequence(id),
	FOREIGN KEY (childSeq) REFERENCES sequence(id)
);
```

```
# Create alignedannot TABLE

CREATE TABLE alignedannot (
	id integer PRIMARY KEY,
	onSequence integer,
	start integer,
	end integer,
	strand boolean,
	name text,
	annotation text,
	species text,
	source text,
	method text,
	score text,
	FOREIGN KEY (onSequence) REFERENCES sequence(id)
);
```

If we now run `.tables`, we should see the six tables listed.

## Part 1b - Importing the data
Assuming all has gone well above, we should now be able to import data to the six tables within the database. it is important to note that as with the tables themselves, data must be imported in an order that respects dependencies and prerequisites.

Firstly, tell SQLite that it needs to see the files as tab-delimited, using the `.separator "\t"` command.

Then, import the data into the tables. Here, by using the `|tail -n +2` command, we're asking SQLite to only import from the second row down, i.e. skipping headers (which of course are what was set up in Part 1a above.

```
.import "|tail -n +2 samples1.txt" sample
.import "|tail -n +2 seqgroups1.txt" seqgroup
.import "|tail -n +2 seqtypes.txt" seqtype
.import "|tail -n +2 sequences1-D18-genomic.txt" sequence
.import "|tail -n +2 sequences2-D36-RNA.txt" sequence
.import "|tail -n +2 sequences3-D18-augustusGenePredict.txt" sequence
.import "|tail -n +2 seqrelations1-D18augPred-vs-D18g.txt" seqrelation
.import "|tail -n +2 seqrelations2-D36rna-vs-D18g.txt" seqrelation
.import "|tail -n +2 alignedannot1-D18augPred-vs-NCBI-nr.txt" alignedannot
```
Run `.mode columns` and `.headers on`, then check whether data is in each table as it should be, simply use `SELECT * from MyInterestingTable limit 10;` to display the first 10 lines of all columns.

## Part 2 - Queries
Here, we're going to probe the `heiracium.db` database for answers to the queries below. Firstly though, we're going to back up our database

```
mkdir backups
cp heiracium.db ./backups/heiracium.db
```
Then re-open the database and set up formatting:

```
sqlite3 heiracium.db
.mode columns
.headers on
```

1.	Can you list all details about all samples?  

```
SELECT * FROM sample;
```

2.	Can you list just the name and species for all samples? 

```
SELECT name, species FROM sample;
```


3.	Can you list details of the first 10 sequences?

```
SELECT * FROM sample limit 10;
```

4.	How many loaded sequences are there?

```
SELECT count(name) FROM sequence;
```

  Answer: 15653
	
5.	How many sequences are of the type “genomeAssembly”?

```
SELECT count(name) FROM sequence JOIN seqtype ON sequence.isType = seqtype.id 
WHERE seqtype.type IS 'genomeAssembly' ;
```
   Answer: 5000
   
6.	How many loaded sequences are there of each different type? 

```
SELECT seqtype.type, count(name) FROM sequence 
JOIN seqtype ON sequence.isType = seqtype.id 
GROUP BY seqtype.type;
```

| Type | Counts |
| --- | --- |
| genomeAssembly | 5000 |
| protein | 9031 |
| trAssembly | 1622 |


7.	How many sequences have a length greater than 1000?

```
SELECT count(name) FROM sequence WHERE length > 1000;
```
   Answer = 7550
   
8.	How many sequences have a length greater than 1000 and are from sample “D36-s2-tr”?

```
SELECT count(sample.name) FROM sequence JOIN sample ON sequence.isSample = sample.id 
WHERE length > 1000 AND sample.name = 'D36-s2-tr';
```
   Answer = 417
   
9.	What is the average length of all sequences?

```
SELECT avg(length) FROM sequence;
```
   Answer = 3682
   
10.	What is the average length of sequences of type “genomeAssembly”?

```
SELECT avg(length) FROM sequence JOIN seqtype ON sequence.isType = seqtype.id 
WHERE seqtype.type IS 'genomeAssembly' ;
```
   Answer = 10008
   
11.	What is the average length of sequences of type “genomeAssembly” AND what is the average length of sequences of type “protein”? 

```
SELECT seqtype.type, avg(length) FROM sequence JOIN seqtype ON sequence.isType = seqtype.id 
WHERE seqtype.type IS 'genomeAssembly' UNION
SELECT seqtype.type, avg(length) FROM sequence JOIN seqtype ON sequence.isType = seqtype.id 
WHERE seqtype.type IS 'protein';
```

| Type | Average Length |
| --- | --- |
| genomeAssembly | 10008 |
| protein | 621 |

12.	How many annotations (alignedannot.annotation) contain the phrase “hypothetical”?

```
SELECT count(*) FROM alignedannot WHERE annotation LIKE '%hypothetical%';
```
   Answer = 1477
   
13.	Can you list details of the sequence named “D18-gDNA-s1638”, replacing the foreign keys with sensible info (e.g. replace ‘isSample’ id with actual sample name)?  


14.	Does the sequence named “D18-gDNA-s1638” have any other sequences that align onto it (it’ll appear in seqRelation.parentSeq)?  List any such sequences. 
Hint: You’ll need to make use of [the ‘AS’ keyword](https://www.w3schools.com/sql/sql_alias.asp).


