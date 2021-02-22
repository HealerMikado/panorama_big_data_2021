


## Making of Computer Science survival kit

### Brainstorm of themes

- [ ] awk (pronounced *hawk*) : super fast line by line processing unix command.
- [ ] Code profiling
- [ ] Good programming practices/tips :
  - [ ] Python :
    - [ ] Multithreading/multiprocessing are not so hard
    - [ ] Use queue to pass data from one thread to another
    - [ ] Do not append to pandas dataframes ! Append to list then generate a DF from it
    - [ ] Do not open your resource once !
  - [ ] Do I really need all those 150 columns  ?
  - [ ] Filter before any computation
  - [ ] Proceed a very large dataset but I have independent problem ? Parallelization 
  - [ ] On big request to a db is better than 1000 small ()
  - [ ] Do not download data If you do not need them. For example if your data are on a distance server, run the computation on the server THEN download the result. If you download the data on your computer then run the computation :
    - [ ] The downloading slow down the process
    - [ ] Your computer is likely to be less powerful than the distant server.
  - [ ] Low level language (like C/C++) are faster than high level one (python, java, R). But, there are more difficult to learn and usually code optimization is enough. But for easy tasks, knowing a little of bash is a good thing.

### Documents

A checkmark means that the the source has been read and its content has been extracted in the brainstorm section.

**Wikipédia:**

- [ ] awk : https://en.wikipedia.org/wiki/AWK

**Other websites:**

- [ ] A website

**Books:**

- [ ] Hadoop the definitive guide (Chapter 2, analysing data with unix tools)

**Courses:**

- [ ] A course

### Structure