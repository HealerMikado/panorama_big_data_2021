


## Making of MapReduce

### Brainstorm of themes

- [ ] File processing framework. 
- [ ] Part of the hadoop ecosystem
- [ ] Two phases
  - [ ] Map phase : key value -> key value
  - [ ] Reduce : key value -> key value output write on HDFS
  - [ ] So two code to write
- [ ] Theoretically not an obligation hdfs block - map reduce block, but it's the optimum
- [ ] Data locality
- [ ] Example : word count (classic), archive file (only mapper)
- [ ] Written in java, so more effective in java, but Hadoop Streaming make in compatible with *all language* (like python) (*languages that can read and write on the standard output, the language need to be installed on the cluster to be executed). Suited for text processing
- [ ] Parallelisation of task
- [ ] Resilient to failure
  - [ ] If a map task fail (completed or in-progress) : re-execute
  - [ ] If a reduce task fail (in-progress) : re-execute
- [ ] Speculative copy
- [ ] Pro :
  - [ ] Widely used framework
  - [ ] Build on top of HDFS
  - [ ] Resilient to failure
  - [ ] The scheduler try to speed up the process with speculative copy



- [ ] Cons :
  - [ ] Interactive processing
  - [ ] Multi step processing
  - [ ] Need HDFS
  - [ ] No stream compatibility (! hadoop stream is for stream file to standard output)
- [ ] You should use MapReduce if
  - [ ] If you already have an HDFS cluster
  - [ ] Batch processing
  - [ ] "One step" processing
  - [ ] Files processed individually 
  - [ ] Text file with 1 line = 1 data
- [ ] You shouldn't use MapReduce if
  - [ ] You want interactive low latency process
  - [ ] If the output is still big and use as an input of a another MR task
  - [ ] If you do machine learning
  - [ ] Is those 3 cases -> Spark
- [ ] Keep in mind :
  - [ ] Only a file processing framework
  - [ ] On top of HDFS
  - [ ] Write in java, so java offer the most tools
  - [ ] But Hadoop Stream made it possible to use other language (like python)

### Documents

A checkmark means that the the source has been read and its content has been extracted in the brainstorm section.

**Wikipédia:**

- [ ] A page

**Other websites:**

- [ ] hdfs user guide  : https://hadoop.apache.org/docs/stable/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html

**Books:**

- [x] Hadoop The definitive Book (chapters 2)
- [ ] Hadoop The definitive Book (chapters 7, 8 and 9)

**Courses:**

- [x] Last year course
- [x] Shadi's course : http://people.rennes.inria.fr/Shadi.Ibrahim/S.Ibrahim-MapReduce.pdf

### Structure