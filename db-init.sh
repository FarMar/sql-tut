sqlite3 hieracium.db

## Create tables, noting that FOREIGN KEYS dictate prerequisites

# Create sample table, note id is integer and primary key

CREATE TABLE sample (
	id integer PRIMARY KEY,
	name text,
	species text,
	description text
);

# Create seqgroup TABLE

CREATE TABLE seqgroup (
	id integer PRIMARY KEY,
	name text,
	description text
);

# Create seqtype TABLE

CREATE TABLE seqtype (
	id integer PRIMARY KEY,
	type text
);

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
	score text
	FOREIGN KEY (onSequence) REFERENCES sequence(id)
);

