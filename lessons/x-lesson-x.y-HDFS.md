
## Making of HDFS

### Brainstorm of themes

- [x] Distributed file system
- [x] Hadoop ecosystem (teaser of map reduce and spark)
- [x] Google papers, hadoop 1 with hdfs + map reduce, then hadoop 2 and 3
- [x] Main workers architecture 
- [x] Write once read many
- [x] block size, replication
- [x] NameNode keep in memory the block/file/localisation mapping.
- [ ] Write on disk logs and filesystem image (too much ?)
- [x] How to get a file
- [ ] How to write a file
- [x] Name node single point of failure
- [x] How to use hadoop (level 0)
  - [ ] CLI
  - [ ] Java
  - [ ] Rest API
  - [ ] HUE
- [ ] How to use hadoop code example ? Live example ?
- [x] Pros
  - [x] Resilient to datanode failure
  - [x] NameNode failure is a bigger issue but is ok
  - [x] Throughput
  - [x] Scale easly
- [x] Cons 
  - [x] No real time
  - [x] Small files are bad !
  - [x] No concurrent write
  - [x] Only append to file
- [x] Good choice
- [x] Bad choice

### Documents

A checkmark means that the the source has been read and its content has been extracted in the brainstorm section.

**Wikipédia:**

- [ ] A page

**Other websites:**

- [ ] hdfs user guide  : https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/WebHDFS.html

**Books:**

- [x] Hadoop The definitive Book (chapters 3, 5)

**Courses:**

- [x] Last year course

### Structure