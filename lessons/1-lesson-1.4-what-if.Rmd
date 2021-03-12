## What if ... ?

---

## What if data is too big to fit in RAM ?

.pull-right[![](https://image.flaticon.com/icons/png/512/906/906794.png)]

--
.pull-left[
1. do less (filter, sample)
2. buy more/bigger memory
3. do things in chunks (stream, pipeline)
4. distribute the data
]

---

## What if ... ?

---

## What if file is too big for file system ?

.pull-right[![](https://image.flaticon.com/icons/png/512/906/906794.png)]

--
.pull-left[
1. do less (filter, sample)
2. change file system
3. cut file into pieces and process in chunk
4. go on databases, that's what they are made for
5. go on cloud, they take care of the problems for you
]

???

Sometimes you don't have the choice. You get data you have to read before you can filter.

---

## What if file is too big for file system ?

![](img/limit-size-aws.png)

---

## What if file is too big for file system ?

![](img/limit-size-azure.png)

---

## What if file is too big for file system ?

![](img/limit-size-gcp.png)

---

## What if ... ?

---

## What if data is too big to fit on disk ?

.pull-right[![](https://image.flaticon.com/icons/png/512/906/906794.png)]

--
.pull-left[
1. store less (sample, filter)
2. buy bigger physical disk
3. buy a storage server
4. rent storage space in the cloud
5. distribute data yourself on serval nodes
]

---

## What if ... ?

---

## What if computation takes ages ?


.pull-right[![](https://image.flaticon.com/icons/png/512/906/906794.png)]

--
.pull-left[
1. do less (filter, sample), especially in development stages
2. do less (less tests, less formatting)
3. go low-level (compiling ... or building chips!)
4. profile your code (how does it scale ? where are the bottlenecks?)
5. buy bigger or more cores
6. rent cores on the cloud
7. avoid i/o or network operations
8. **parallelize on non-local nodes**

]

???

We have to distinguish between estimation of a statistical model (always the same call, happen seldom, often only once or twice), developement/research (many requests, often very different from each other) and model in production, for instance for prediction (usually lighter computations, but happen possibly very often). It is rare to be in the case where you both want a very intense computation and you wan to perform it often, exceptions being for instance 3D rendering.

Most used statistical procedures (computing a sum, a mean, a median, inversing a matrix...) are already heavily optimised in traditionnal software, so that you will never need to deep to far in algorithmic machinery.

2. Ex: In R, `parse_date_time()` parses an input vector into POSIXct date-time object ; `parse_date_time2()` is a fast C parser of numeric orders. // Caveat. inputs have to be realiably standardized

3. compile and  

7. minimize communication (maybe you can perform part of the computation in the database, like agregation, and only then communicate the result) ; beware of the cost of data transfer!!!!! Especially when using the cloud! // Unless you can perform reading / writings in parallel to earlier / later tasks, aka. pipelining or streaming.

---

## What if ... ?

---

## What if computation / storage is too expensive ?

.pull-right[![](https://image.flaticon.com/icons/png/512/906/906794.png)]

--

.pull-left[
1. store or compute less (filter, sample)
2. consider cloud computing
3. be carefull with databases requests
4. go from RAM to disk
5. use smaller but moany computing units (ex: scientific grids)
]

???

4. stream, caveat: more communication between disk and memory

---

## What if ... ?

---

## What if data i/o is too fast ?

.pull-right[![](https://image.flaticon.com/icons/png/512/906/906794.png)]

--

.pull-left[
1. for computing: stream / pipeline
2. for storage: fast databases
]

???

There are many distinct problems. For instance, you may have data that **arrive** continuously (think financial operations). On the contrary, many users may want to access the same data often (think newspapers / websites). You may want to do both (think Twitter).

And you may want (or not) to guarantee that your solution can scale, i.e. that it does not depend .

Different solutions can cope with this:
-> streamer (on the computing side) => same problem as distribution: the computation has to be made by chunks
-> database solutisions for fast wirte / fast read ; there's alwasy a trade-off between size, durability, fiability (do I correctly get the last bit of information?), huge subject of research and development ; it is more a question of production (you won't necessarily be concerned with this aspect)
