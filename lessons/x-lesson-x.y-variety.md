##

## Making of

### Brainstorm of themes

A checkmark means that the idea has been added to the course core.

- [ ] Key-value store (distributed dictionnary)
- [ ] Document-oriented databases / document store / NoSQL databse: "The difference [with a key-value store] lies in the way the data is processed; in a key-value store, the data is considered to be inherently opaque to the database, whereas a document-oriented system relies on internal structure in the document in order to extract metadata that the database engine uses for further optimization."
- [ ] Same operations as classical databases (CRUD)
- [ ] The key is fundamentally similar to the "path" in a file system, just a way to uniquely identify a document. Usually, you would embed some information in the key for efficient search, in the same way that the path `/projects/big-data/lesson1/tp1.md` is more informative than `/i5hxld09985u.md`.
- [ ] Some user-interface features include : collections, tags and path.
- [ ] Exemples of document-oriented databases
    [ ] MongoDB
    [ ] Amazon DynamoDB / Azure Cosmos DB / Google Data Store (old) Firestore (new)
    [ ] Cassandra ?
- [ ] Exemples of wide-columns stores
    [ ] Bigtable
    [ ] Cassandra
- [ ] Exemples of unstructured formats: XML (and HTML), YAML, JSON
- [ ] What is a structured vs. unstructured document?
- [ ] Why can one not use a relational database everywhere?
- [ ] Challenges with using un-structured databases?
- [ ] Graph databases / object-based databases / GraphQL
- [ ] ElasticSearch is at the border between search engines and document store
- [ ] Search optimization
- [ ] From Wikipedia:
    
    > The advantages of [semi-structured models] are the following:
    >
    > - It can represent the information of some data sources that cannot be constrained by schema.
    > - It provides a flexible format for data exchange between different types of databases.
    > - It can be helpful to view structured data as semi-structured (for browsing purposes).
    > - The schema can easily be changed.
    > - The data transfer format may be portable.
    > 
    > [But] queries cannot be made as efficiently[.] Typically the records in a semi-structured database are stored with unique IDs that are referenced with pointers to their location on disk. This makes navigational or path-based queries quite efficient, but ... searches over many records [requires] to seek around the disk following pointers.
    
    > In semi-structured data, the entities belonging to the same class may have different attributes even though they are grouped together, and the attributes' order is not important.
    
    > Advantages
    > - Programmers persisting objects from their application to a database do not need to worry about object-relational impedance mismatch, but can often serialize objects via a light-weight library.
    > - Support for nested or hierarchical data often simplifies data models representing complex relationships between entities.
    > - Support for lists of objects simplifies data models by avoiding messy translations of lists into a relational data model.
    > 
    > Disadvantages
    > - The traditional relational data model has a popular and ready-made query language, SQL.
    > - Prone to "garbage in, garbage out"; by removing restraints from the data model, there is less fore-thought that is necessary to operate a data application.
    
- [ ] Unstructrured data:
    
    > 1. Structure, while not formally defined, can still be implied.
    > 1. Data with some form of structure may still be characterized as unstructured if its structure is not helpful for the processing task at hand.
    > 1. Unstructured information might have some structure (semi-structured) or even be highly structured but in ways that are unanticipated or unannounced.
    
- [ ] g2.com uses these categories:
    
    1. Key-value stores
    2. Document databases
    3. Graph databases
    4. Object-oriented databases
    5. Column-oriented or columnar databases
    
- [ ] From Wikipédia: The term NoSQL was used by the person Carlo Strozzi in 1998, [but with a different meaning of "relational databse without SQL queries abilities"] ; for the meaning of "distributed, non relational databases" one must wait to 2009 (Johan Oskarsson, organizing the conference "open-source distributed, non-relational databases")
- [ ] SQL database  vs. Document oriented database ; table vs. collection ; record vs. document
    

### Documents

A checkmark means that the the source has been read and its content has been extracted in the brainstorm section.

**Wikipédia:**

- [x] https://en.wikipedia.org/wiki/Document-oriented_database
- [x] https://en.wikipedia.org/wiki/Semi-structured_model
- [x] https://en.wikipedia.org/wiki/Semi-structured_data
- [x] https://en.wikipedia.org/wiki/Unstructured_data
- [x] https://en.wikipedia.org/wiki/NoSQL

**Other websites:**

- [x] https://www.g2.com/categories/document-databases
- [ ] https://www.guru99.com/nosql-tutorial.html
- [ ] https://datascience.stackexchange.com/questions/125/how-to-learn-nosql-databases-and-how-to-know-when-sql-or-nosql-is-better

**Books:**

- [ ] _NoSQL Distilled: A Brief Guide to the Emerging World of Polyglot Persistence_, Pramod Sadalage and Martin Fowler

**Courses:**

- [ ] https://www.christof-strauch.de/nosqldbs.pdf

### Structure

