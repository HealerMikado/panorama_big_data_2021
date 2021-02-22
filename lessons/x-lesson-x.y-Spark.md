


## Making of Spark

### Brainstorm of themes

- [ ] data processing framework. 
- [ ] Part of the hadoop ecosystem (But can run outside)
- [ ] Can be oversimplified as "In memory MapReduce"
  - [ ] Maps tasks read data from disk process them, then send the result to the Reduce tasks which process them and write the result on HDFS. If you want to process the result you have to read it from hdfs
  - [ ] Spark load the data in memory (RAM) and keep them in until the user said otherwise
- [ ] 3 main API :
  - [ ] Java
  - [ ] Scala
  - [ ] Python (pyspark)
- [ ] SparkSQL : You can directly write sql requests to process your data 
- [ ] Main concepts :
  - [ ] Dataframes : runtime typed tabular data (like R). Spark come with its own type. There are just classical type optimized for serialization and garbage collection.
  - [ ] Transformation : process a dataframe and return another dataframe (can chain the transformation)
  - [ ] Action : compute a dataframe and print it/write it/cache it etc.
- [ ]  DAG : Directed acyclic graph to optimise the process. All the transformation are kept in mind and optimized when an action is performed. For example your last transformation is a filter. Spark will filter the dataframe as early as he can so speed up the process. We ca ask to see the dag.
- [ ] Lazy loading. Without any action, no computation. Why ? On large data if each transformation was compute it will take forever. It's more efficient to compute only when asked.
- [ ] Example : your parent ask you to do the dishes. 
  - And because you do not like doing the dishes (like anybody) you just respond with an "yeah no problem". For you it's mean the task will be done, just not know. 
  - But your parent became impatient, and said "Can you do it now ?".
  - And so you do.
  - Spark do the same !
  - To make a parallel, the input are the dirty dishes
  - The spark transformation are the cleaning
  - Without anything else, Spark don't do anything. It just keep the transformation in mind
  - Then you perform an *action* (like print the result, write the result to file etc) and spark will process the data.
- [ ] Anatomy of a Spark job (it's really hard, but just to show it's not "magic", there is a real process under the hood)
- [ ] Show some basics commands in another video ?
  - [ ] Import data
  - [ ] some basics transformations
  - [ ] export data
  - [ ] From interactive shell and from script

### Documents

A checkmark means that the the source has been read and its content has been extracted in the brainstorm section.

**Wikipédia:**

- [ ] A page

**Other websites:**

**Books:**

- [x] Hadoop The definitive Book (chapters 19)
- [ ] Spark The definitive Book 

**Courses:**

- [x] Last year course

  

### Structure