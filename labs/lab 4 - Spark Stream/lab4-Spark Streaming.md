# Lab4- Stream processing with Spark

## Outline

This lab will teach you the basic of s**tream processing with Spark**. As soon as an application compute something with business value  (for instance customer activity), and new inputs arrive continuously, companies will want to compute this result continuously too. Spark makes possible to process stream with the **Structured Streaming API**. This lab will teach you the basics of this Spark's API. Because the Structured Streaming API is based on the DataFrame API most syntaxes of lab 2 are still relevant.

## ⛅​ Spark cluster creation in AWS

First: **DO NOT FORGET TO TURN YOUR CLUSTER OFF A THE END OF THIS TUTORIAL!**

Instructions are at the beginning of lab 2

**DO NOT FORGET TO TURN YOUR CLUSTER OFF A THE END OF THIS TUTORIAL!**

## :gear: Configuration of the notebook


```python
# Configuraion
# The user pay the data transfer
spark._jsc.hadoopConfiguration().set("fs.s3.useRequesterPaysHeader","true")

# Set the number of shufflre partitions
spark.conf.set("spark.sql.shuffle.partitions", 5)

# Import all the needed library
from time import sleep
from pyspark.sql.functions import from_json, window, col, expr
from pyspark.sql.types import StructType,StructField, StringType, IntegerType, ArrayType, TimestampType, BooleanType, LongType, DoubleType

```

**Explications:**
   - `spark._jsc.hadoopConfiguration().set("fs.s3.useRequesterPaysHeader","true")` : like in lab2, you will be charged for the data transfer. without this configuration you can't access the data. 

- `spark.conf.set("spark.sql.shuffle.partitions", 5)` : set the number of partitions for the shuffle phase. A partition is in Spark the name of a bloc of data. By default Spark use 200 partitions to shuffle data. But in this lab, our mini-batch will be small, and to many partitions will lead to performance issues.

  ````
spark.conf.set("spark.sql.shuffle.partitions", 5)
  ````

  > :thinking: The shuffle dispatches data according to their key between a *map* and a *reduce* phase. For instance, if you are counting how many records have each `g` group, the *map* phase involve counting each group member in each Spark partition : `{g1:5, g2:10, g4:1, g5:3}` for one partition, `{g1:1, g2:2, g3:23, g5:12}` for another. The *shuffle* phase dispatch those first results  and group them by key in the same partition, one partition gets `{g1:5, g1:1, g2:10, g2:2}`, the other gets : `{g4:1, g5:3, g3:23, g5:12}` Then each *reduce* can be done efficiently. 

- :package: Import all needed library

  ````python
  from time import sleep
  from pyspark.sql.functions import from_json, window, col, expr
  from pyspark.sql.types import StructType,StructField, StringType, IntegerType, ArrayType, TimestampType, BooleanType, LongType, DoubleType
  ````

## Stream processing

Stream processing is the act to process data in real-time. When a new record is available, it is processed. There is no real beginning nor end to the process, and there is no "result". The result is updated in real time, hence multiple versions of the results exist. For instance, you count how many tweet about cat are posted in twitter every hour. Until the end of an hour you do not have you final result. But event at this moment, your result can change. Maybe some technical problem created some latency and you will get some tweets later. If this case, maybe it's not a big deal, but in some cases it can be.

Some commons use cases of stream processing are :

- **Notifications and alerting :**  real-time bank fraud detection ; electric grid monitoring with smart meters ; medical monitoring with smart meters, etc.
- **Real time reporting:**  traffic in a website updated every minute; impact of a publicity campaign  ; stock option portfolio, etc.
- **Incremental ELT (extract transform load):**  new unstructured data are always available and they need to be processed (cleaned, filter, put in a structured format)  before their integration in the company IT system.
- **Online machine learning :** new data are always available and used by a ML algorithm to improve its performance dynamically.

Unfortunately, Stream processing has some issues. First because there is no end to the process, you cannot keep all the data in memory. Because your memory is limited. Second, process a chain of event can be complex. How do you raise an alert when you receive the value 5, 6 and 3 consecutively ? Don't forget you are in a distributed environment, and there is latency. Hence, the received order can be different from the emitted order.



## 1. ✨ Spark and stream processing :shower:





Stream processing was gradually incorporated in Spark.  In 2012 Spark Streaming and the DStreams API  was added to Spark (it was before an external project). This made it possible to stream processing to use high-level operator like `map` and `reduce`. Because of its implementation this API has some limitations.  Thus, in 2016 a new API was added, the Structured Streaming API. This API is directly build built on DataFrame, unlike DStreams. **This has an advantage, you can process your stream like static data**. Of course there is some limitation, but the core syntaxes is the same. You will chain transformations, because each transformation take a DataFrame as input and produce a DataFrame as output. The big change is there is no action at the end, but a **[output sink](#2.2 How to output a stream ?)**.![data stream](https://databricks.com/wp-content/uploads/2016/07/image01-1.png)

Spark offer two ways to process stream, one **record at a time**, or processing micro batching (processing a small amount of line at once). 

- **one record at a time**  every time a new record is available it's processed. This has a big advantage, the **latency is very low**. But there is a drawback, the system can not handle too much data at the same time (low throughput)
- as for **micro batching** it process new records every `t` seconds. Hence record are not process really in "real-time", **the latency will be higher, and so the throughput**. Unless you really need low latency, make it you first choice option.

> 🧐 To het the best decision between latency / throughput, a good practice is to decrease the micro-batch size until the mini-batch throughput is the same as the input throughput. Then increase the size to have some margin

![](img/spart_latency_requirement.png)

> To understand why processing one record at a time has lower latency an throughput than batch processing, imagine a restaurant. Every time a client order something the chef cooks its order independently of the other current orders. So if two clients order pizza, the chief makes two small doughs, and cook them individually. If clients come slowly, the chief can finish each order before a new client comes. The latency is the lowest possible the chief is idle when a client come. Know imagine restaurant were the chief process the orders by batch. Each time he waits some minutes to gather all the orders than he mutualize the cooking. If there is 5 pizza orders, he only do one big doughs, divide it in five, add the topping then cook all five at once. The latency is higher because the chief wait, but so the throughput because he can cook multiple thing at once.

## 2. The basics of Spark's Structured Streaming

### 2.1. The different sources for stream processing in Spark

In lab 2 you discovered Spark DataFrame, in this lab you will learn about [Structured Streaming](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html), the Spark object to handle stream data. It's a stream processing framewok built on the Spark SQL engine, and it use the existing structured APIs in Spark. So one you define a way to read a stream, you will get a DataFrame. Like in lab2 ! **So all transformations presented in lab2 are still relevant in this lab**.

 Spark Streaming supports several input source for reading in a streaming fashion :

- [Apache Kafka](https://kafka.apache.org/) an open-source distributed event streaming platform (not show in this lab)
- Files on distributed file system like HDFS or S3 (Spark will continuously read new files in a directory)
- A network socket : an end-point in a communication across a network (sort of very simple webservice). It's not recommend for *production* application, because a socket connection doesn't provide any  mechanism to check the consistency of data.

Defining an input source is like loading a DataFrame but, you have to replace `spark.read` by `spark.readStream`. For instance, if I want to open a stream to a folder located in S3 you have to do 

```python
my_first_stream = spark\
.readStream\
.schema(schema_tweet)\
.json("s3//my-awesome-bucket/my-awesome-folder")
```

The major difference with lab2, it is Spark cannot infer the schema of the stream. You have to pass it to Spark. There is two ways :

- A reliable way : you define the schema by yourself and gave it to Spark
- A quick way : you load one file of the folder in a DataFrame,, extract the schema and use it. It works, but the schema can be incomplete. It's a better solution to create the schema by hand and use it. 

For Apache Kafka it's a slightly more complex,  (not used today, it's jute for you personal knowledge):

```python
my_first_stream = spark\
.readStream\
.format("kafka")
.option("kafka.bootstrat.servers", "host1:port1, host2:port2 etc")
.option("subscribePattern", "topic name")
.load()
```

#### Why is a folder a relevant source in stream processing ?

Previously, in lab 2, you load all the files in a folder stored in S3 in Spark. And it worked pretty well. But this folder was static. Its content doesn't change. But in some cases, new data are constantly written into the folder. For instance, here is the complete workflow of the second part of the lab :

![](img/stream_pipeline_twitter.png)

A script python is running in a EC2 machine and constantly add file to a S3 buckets. Every 20 seconds, a new file is added to the bucket. If you use DataFrame like in lab 2, your process cannot proceed new files. You should relaunch your process. But with Structured Streaming Spark will dynamically load new files.

Because cloud providers offer high durability, cheap storage solutions with tools to interact easily with there storage solution, in many cases, it easier to have scripts which write in a bucket and others which read from it that create some complex architectures to stream data.

> The remaining question is, why don't we connect Spark to the twitter webservice directly ? And the answer is : we can't. Spark cannot be connected to a webservice directly. You need some code between Spark and your webservice. There are multiple solutions, but an easy and reliable solution is to write tweet to s3 (because we use AWS services, if you use Microsoft Azure, Google Cloud  Platform or OVH cloud replace S3 by their storage service).

### ✍Hand-on 1 : open a stream

In the first part of this lab, you will use IoT (*Internet of Things*) data. The dataset came from the [Heterogeneity Activity Recognition Data Set](http://archive.ics.uci.edu/ml/datasets/heterogeneity+activity+recognition) and consists of smartphone and smartwatch sensors readings from variety of devices. For example, here is some readings

````js
{"Arrival_Time":1424686735175
,"Creation_Time":1424686733176178965
,"Device":"nexus4_1"
,"Index":35
,"Model":"nexus4"
,"User":"g"
,"gt":"stand"
,"x":0.0014038086
,"y":5.0354E-4
,"z":-0.0124053955}
````

- Define a variable with this schema

  ```python
  StructType()\
      .add('Arrival_Time',  	TimestampType(),   True)\
      .add('Creation_Time', 	TimestampType(),   True)\
      .add('Device',        	StringType(), True)\
      .add('Index',         	LongType(),   True)\
      .add('Model',         	StringType(), True)\
      .add('User',          	StringType(), True)\
      .add('_corrupt_reccord',StringType(), True)\
      .add('gt',            	StringType(), True)\
      .add('x',             	DoubleType(), True)\
      .add('y',             	DoubleType(), True)\
      .add('z',             	DoubleType(), True)
  ```

- Crate a stream to this s3 bucket : `s3://spark-lab-input-data-ensai20202021/Iot/`. Name it  `iot_stream`

  > :thinking: Nothing happen ? It's normal ! Do not forget, Spark use lazy evaluation. It doesn't use data if you don't define an action. For know Spark only know how to get the stream, that's all.

- In a cell just execute `iot_stream`. It should print the type of `iot_stream` and the associated schema. You can see you created a DataFrame like in lab2 !

- To print the size of your DataFrame with this piece of code :

  ```python
  iot_query = iot_stream\
  .writeStream\
  .queryName("iot_stream")\
  .format("memory")\
  .start()
  
  for _ in range(10): # we use an _ because the variable isn't use. You can use i if you prefere
      sleep(3)
      spark.sql("""
      SELECT count(1) FROM iot_stream""").show()
  iot_query.stop() #needed to close the stream
  
  ```
### 2.2 How to output a stream ?

Remember, Spark has two types of methods to process DataFrame:

-  Transformations which take a DataFrame has input and produce an other Dataframe
-  And actions, which effectively run computation and produce something, like a file, or a output in you notebook/console.

Stream processing looks the same as DataFrame processing. Hence, you still have transformations, the exact same one that can be apply on classic DataFrame (with some restriction, for example you can not sample a stream with the `sample()` transformation). The action part is a little different. Because a stream runs continuously, you cannot just print the data at the end of the process, because there is no end by definition, so your output need to be update constantly (or at least periodically). To tackle this issue, Spark proposes different [outputs sinks](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html#output-sinks). An output sink is a possible output for your stream. The different output sink are (this part came from the official Spark [documentation)](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html#output-sinks) : 

- **File sink** - Stores the output to a file. The file can be stored locally (on the cluster), remotely (on S3). The file format can be json, csv etc

```python
writeStream
    .format("parquet")        // can be "json", "csv", etc.
    .option("path", "path/to/destination/dir")
    .start()
```

- **Kafka sink** - Stores the output to one or more topics in Kafka.

- **Foreach sink** - Runs arbitrary computation on the records in the output. It does not produce an DataFrame. Each processed lines lost

```python
writeStream
    .foreach(...)
    .start()
```

- **Console sink (for debugging)** - Prints the output  to the console standard output (stdout) every time there is a trigger. This should be used for debugging  purposes on low data volumes as the entire output is collected and  stored in the driver’s memory after every trigger. *Sadly console sink does not work with jupyter notebook*.

```python
writeStream
    .format("console")
    .start()
```

- **Memory sink (for debugging)** - The output is stored in memory as an in-memory table. This should be used for debugging purposes on low data volumes as the entire output is collected and stored in the driver’s memory. Hence, use it with caution. Because we are in a simple lab, you will use this solution. But keep in mind it's a very bad idea because data must fit in the the ram of the driver node. And in a big data context it's impossible. Because it's not a big data problem if one computer can tackle it.

```python
writeStream
    .format("memory")
    .queryName("tableName") # to resquest the table with spark.sql()
    .start()
```

We just talked where we can output a stream, but there is another question, how ?

To understand why it's a issue, let's talk about two things that spark can do with stream : filter data and group by + aggregation

- **Filter** : you process is really simple. Every time you get a new data you just compute a score and drop the row if the score is less than a threshold. Then you write into a file every kept row. In a nutshell, you just append new data to a file. Spark does not have to read an already written row.
- **Group by + aggregation** : in this case you want to group by your data by key than compute a simple count. Then you want to write the result in a file. But now there is an issue, Spark need to update some existing rows in your file every time. But is your file is stored in HDFS, it's impossible to update in a none append way a file. In a nutshell, it's impossible to output in a file your operation.

To deal with how output stream, Spark proposes 3 mode. And you cannot use every mode with every output sink, with every transformation. The 3 modes are :

- **Append mode (default)** - This is the default mode, where only the  new rows added to the Result Table since the last trigger will be  outputted to the sink. This is supported for only those queries where  rows added to the Result Table is never going to change. Hence, this mode  guarantees that each row will be output only once (assuming  fault-tolerant sink). For example, queries with only `select`,  `where`, `map`, `flatMap`, `filter`, `join`, etc. will support Append mode.
- **Complete mode** - The whole Result Table will be outputted to the sink after every trigger. This is supported for aggregation queries.
- **Update mode** - (*Available since Spark 2.1.1*) Only the rows in the Result Table that were  updated since the last trigger will be outputted to the sink.  More information to be added in future releases.

| Sink                  | Supported Output Modes   |
| --------------------- | ------------------------ |
| **File Sink**         | Append                   |
| **Kafka Sink**        | Append, Update, Complete |
| **Foreach Sink**      | Append, Update, Complete |
| **ForeachBatch Sink** | Append, Update, Complete |
| **Console Sink**      | Append, Update, Complete |
| **Memory Sink**       | Append, Complete         |

**To sum up** : To output a stream you need

- DataFrame (because once load a stream is a DataFrame)
- A format for your output, like console to print in console, memory to keep the Result Table in memory, json to write it to a file etc
- A mode to specify how the Result Table will be updated.

For instance for the memory sink

```python
memory_sink = df\
.writeStream\
.queryName("my_awesome_name")\
.format('memory')\
.outputMode("complete" or "append")\
.start() #needed to start the stream
```

![](img/stream processing.png)



### ✍Hand-on 2 : output a stream

#### 🚵‍♀️ Activity count

- Compute a DataFrame that will group an count data by the `gt` column. Name your DataFrame `activity_count`

- Use this DataFrame to create a output stream with the following configuration :

  - Memory sink
  - Complete mode (because we are doing an agregation)
  - Name you query `activity_count`

- Then past this code

  ````python
  for _ in range(10): # we use an _ because the variable isn't use. You can use i if you prefere
      sleep(3)
      spark.sql("""
      SELECT * FROM activity_count""").show()
  activity_query.stop() #needed to close the stream
  ````

  After 30 seconds, 10 table will appeared in your notebook. Each table are the contain of `activity_count` at a certain time. The `.stop()` method close the stream. 

  In the rest of this tutorial, to will need two steps to print data :

  1. Define a stream with a memory sink
  2. Request this stream with the `spark.sql()` function

  Instead of a for loop, you can just write you `spark.sql()` statement in a cell and rerun it. In this case you will need a third cell with a `stop()` method to close your stream.

  For instance:

 - Cell 1
      ````python
      my_query = my_df\
          .writeStream\
          .format("memory")\
          .queryName("query_table")\
          .start()
      ````
 - Cell 2
      ```python
      spark.sql("SELECT * FROM query_table").show()
      ```
 - Cell 3
      ```python
      iot_data_memory.stop()
      ```

  #### :x: Count row with null value

- Add a column `error` to your DataFrame. This column equal True if `device`, `index`, `model`, `user` and `gt` are all null. Else it's false. Use the `withColumn` transformation to add a column
- Group and count by the `error` column

  - Print some results
## Stream processing basics 

### ✍Hand-on 3 : transformations on stream 🧙‍♂️

- :hocho: Filter stream all row with a null value then group and count data by `gt`.
     - For this filter, you will use the `na.drop("any")` transformation. The `na.drop("any")` drop every line with a null value in at least one column. It's simpler than using a filter() transformation because you don't have to specify all the column. For more precise filter you can use `na.drop("any" or "all", subset=list of col)` (`all` will drop rows with only null value in all columns or in the specified list).
- :small_red_triangle_down: Column creation and filtering : 

  - Define a new column, name `is_stair_activity`. This column is equal to `True` if the `gt` contains "stairs", else it's  equal to`False`. To do so use the `withColumn()` transformation, and the `expr()` function. It take as input a SQL expression. You do not need a full SQL statement (`SELECT ... FROM ... WHERE ...`) but just an SQL expression that return True or False is `gt` contains "stairs" ([for some help](https://www.w3schools.com/sql/sql_like.asp))
  - Only keep `gt`, `model`, `arrival_time`, `creation_time`

### ✍Hand-on 4 : Aggregation and grouping on stream 🧲

- Count the number of different users.

- Group by `user` and compute the average, min and max of `x`, `y` and `z` .

     - Use the `groupBy()` and `agg()` transformations

- Compute the average of `x`, `y` and `z` :

     - across all `gt` and `user`
     - for each `user` across all `gt`
     - for each `gt` across all `user`
     - for each `gt` and each `user`

     To do so, replace the `groupBy()` transformation by the `cube()` one. `cube()` group compute all possible cross between dimensions passed as parameter. You will get something like this

     | gt    | model  | avg(x)     | avg(y)     | avg(z)     |
     | ----- | ------ | ---------- | ---------- | ---------- |
     | sit   | null   | some_value | some_value | some_value |
     | stand | null   | some_value | some_value | some_value |
     | ...   | ...    | ...        | ...        | ...        |
     | walk  | nexus1 | some_value | some_value | some_value |
     | null  | nexus1 | some_value | some_value | some_value |
     | null  | null   | some_value | some_value | some_value |

     A `null`  value mean this dimension wasn't use. For instance, the first row give the average when `gt==sit` independently of the `model`. The before last row give averages when `model==nexus1` independently of the `gt`. And the last row give the averages for the full DataFrame.

     ## Event-time processing ⌛

     Event-time processing consists in processing information with **respect to the time that it was created, not received**. It's a hot topic because sometime you will receive data in an order different from the creation order. For example, you are monitoring servers distributed across the globe. Your main datacentre is located in Paris. Something append in New York, and a few milliseconds after something append in Toulouse. Due to location, the event in Toulouse is likely to show up in your datacentre before the New York one. If you analyse data bases on the received time the order will be different than the event time. Computers and network are unreliable. Hence, when temporality is important, you must consider the creation time of the event and not it's received time.

     Hopefully, Spark will handle all this complexity for you ! If you have a timestamp column with the event creation spark can update data accordingly to the event time. 

     For instance is you process some data with a time window, Spark will update the result based on the event-time not the received time. So previous windows can be updated in the future.

     ![](img/late data handling without watermarks.png)

     

     To work with time windows, Spark offers two type of windows

     - Normal windows. You only consider event in a given windows. All windows are disjoint, and a event is only in one window.
     - Sliding windows. You have a fix window size (for example 1 hour) and a timer (for example 10 minute). Every 10 minute, you will process the data with an event time less than 1h.

     ![](img/time windows.png)

     To create time windows, you need :

     - to define a time window : `window(column_with_time_event : str or col, your_time_window : str, timer_for_sliding_window) : str`

     - grouping row by event-time using your window :  `df.groupeBy(window(...))`

     To produce the above process :

     ```python
     # Need some import
     from pyspark.sql.functions import window, col
     
     # word count + classic time window
     df_with_event_time.groupBy(
     	window(df_with_event_time.event_time, "5 minutes"),
     	df_with_event_time.word).count()
     
     # word count + sliding time window
     df_with_event_time.groupBy(
     	window(df_with_event_time.event_time, "10 minutes", "5 minutes"),
     	df_with_event_time.word).count()
     ```

### ✍Hand-on 4 : Event-time processing :hourglass:

- Count the number of event with a 1 minute time window (use the `Creation_Time` column)
- Count the number of event by user with a 30 secondes time window (use the `Creation_Time` column)
- Count the number of event by user with a  15 seconds time window sliding every 10 seconds (use the `Creation_Time` column)

### Handling late data with watermarks

Processing time event is great, but currently there is one flaw. We neve specified how late we expect to see data. This means, Spark will keep some data in memory forever. Because streams never end, Spark will keep in memory every time windows, to be able to update some previous results. But in some cases, you know that after some time, you don't expect new data, or you don't care about it anymore. In other word, after a certain amount of time you want to freeze old results.

Once again, Spark can handle such process, with watermarks.

![](img/lata data handling with watermarks.png)

To do so, you have to define column as watermark and a the max delay. You have to use the `withWatermark(column, max_delay)` method.

```python
# Need some import
from pyspark.sql.functions import window, col

# word count + classic time window
df_with_event_time.withWatermark(df_with_event_time.event_time, "4 minutes")\
.groupBy(
	window(df_with_event_time.event_time, "5 minutes"),
	df_with_event_time.word).count()

# word count + sliding time window
df_with_event_time.withWatermark(df_with_event_time.event_time, "4 minutes")\
.groupBy(
	window(df_with_event_time.event_time, "10 minutes", "5 minutes"),
	df_with_event_time.word).count()
```

#### ✍Hand-on 5 : Handling late data with watermarks :hourglass_flowing_sand:

- Count the number of event with a 1 minute time window (use the `Creation_Time` column)
- Count the number of event by user with a 30 secondes time window (use the `Creation_Time` column)
- Count the number of event by user with a  15 seconds time window sliding every 10 seconds (use the `Creation_Time` column)

## For more details

- [Spark official documentation](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html#input-sources)
- ZAHARIA, B. C. M. (2018). *Spark: the Definitive Guide*. , O'Reilly Media, Inc. https://proquest.safaribooksonline.com/9781491912201
- https://databricks.com/blog/2018/03/13/introducing-stream-stream-joins-in-apache-spark-2-3.html
- https://databricks.com/blog/2016/07/28/structured-streaming-in-apache-spark.html
- https://databricks.com/blog/2015/07/30/diving-into-apache-spark-streamings-execution-model.html
