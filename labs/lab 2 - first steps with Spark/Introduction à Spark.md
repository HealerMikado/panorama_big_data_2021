---

---

# Outline

1. Launching a Spark cluster on AWS
3. First steps with Spark

# Création d'un cluster Spark sur AWS

- [ ] Une fois connecté à la console AWS cherchez le service EMR pour *Elastic Map Reduce*. C'est la *Plateforme as a Service* qui permet de créer un cluster Hadoop dans AWS. Vous allez juste choisir la configuration de votre cluster, et AWS va créer toutes les VM, les mettre en réseau et installer toutes les applications choisie pour vous. Créer un cluster Hadoop à la main est laborieux et n'est pas réellement intéressant, c'est pourquoi les divers fournisseurs de services cloud proposent de telles PaaS 

- [ ] Vous allez arriver sur un écran similaire à celui-ci
  ![](img/emr_premiere_co.png)
  Les fois suivantes il ressemblera à cela
  ![](img/emr_accueil.png)
  Dans tous les cas cliquez sur `Créer un cluster`
  
- [ ] Sur la page suivante voici les configurations à saisir :

  - [ ] Nom du cluster : le nom que vous souhaitez. Le nom par défaut convient très bien

  - [ ] Journalisation : décochez ce paramètre. Il permet de sauvegarder les *log* (journaux) de votre cluster pour ensuite allez chercher la source d'une erreur. Mais pour ce TP cela ne sera pas utile

  - [ ] Mode de lancement : `Cluster`. La différence entre `Cluster` et `Exécution d'étape` est que `Cluster` permet interagir avec le cluster, alors que qu'`Exécution d'étape` créer un cluster, réalise lance un ou plusieurs scripts et s'arrête.  C'est parfait quand vous voulez lancer un "job" sur vos données. Le cluster se lance, fait les calculs puis va exporter les résultats et s'éteindre tout seul.

  - [ ] Libérée (Release en VO) : `emr-5.31.0`, donc l'avant dernière version 5.XX. La dernière à des problèmes pour l'utilisation de notebook.

  - [ ] Type d'instance : des `m5.xlarge` conviennent parfaitement. Si vous voulez vous pouvez essayer des machines plus puissantes, mais cela ne va pas impacter fortement les temps de calculs.

  - [ ] Nombre d'instance :  `3`, mais vous pouvez essayer avec plus d'instance (limitez vous à 6). 

    Pour vous donner une idée des prix unitaire des machines voici un tableau des instance m5.XX. Pour le prix du cluster, multipliez par le nombre de machine

    | Instance   | Prix unitaire par heure |
    | ---------- | ----------------------- |
    | m5.xlarge  | 0.24$                   |
    | m5.2xlarge | 0.48$                   |
    | m5.4xlarge | 0.96$                   |
    | m5.8xlarge | 1.86$                   |

  - [ ] Paire de clé EC2 : sélectionnez la clé du TP 0. Si vous n'en avez pas sélectionnez `Sans paire de clé EC2`. 

  - [ ] Puis cliquez sur `Créer un cluster`

    Voici ce à quoi vous devez arrivez :

    ![](img/emr_config.png)

    It's possible you get an error like this one :
    
    > Résilié avec des erreursThe requested instance type m5.xlarge is not supported in the requested  availability zone. Learn more at  https://docs.aws.amazon.com/console/elasticmapreduce/ERROR_noinstancetype
    
    The physical resources of AWS's datacenters are not unlimited, and AWS keeps some room for manoeuvre for top priority users. So sometimes we, low priority users, cannot use some resources. If this problem happens, just recreate a cluster with a less powerful machin, like m4.xlarge
    
    La création d'un cluster prend plus de temps que la création d'une machine unique (de l'ordre de quelques minutes). Car AWS doit lancer X machines avec des configurations lourdes, les mettre en réseau etc.

- [ ] Une fois le cluster passer en "En attente" ou "Stand by", allez dans blocs-notes, puis cliquez sur `Créer un bloc-notes`
  ![](img/bloc_note_accueil.png)

- [ ] Sur l'écran suivant vous allez devoir spécifier :

  - [ ] Un nom pour votre *notebook*
  - [ ] Le cluster que vous souhaitez utiliser. Noter que vous pouvez créer à la volée un cluster si vous le souhaitez
  - [ ] Le rôle de sécurité et les groupes associés au service. Nous allons garder les paramètres par défaut
  - [ ] L'endroit où sera stocké votre notebook sur S3. Cela peut servir à recharger un *notebook* fait plus tôt.
  - [ ] Un dépôt git si vous souhaitez versionner votre code.

  Voilà quoi devrait ressembler votre écran avant validation.

  ![](img/notebook_creation.png)

- [ ] La création du *notebook* doit être rapide. Une fois votre *notebook*  prêt cliquez sur `Ouvrir dans JupyterLab`. Cela ouvrira une interface JupyterLab pour rédiger des *notebooks*. Par défaut vous pouvez faire des *notebooks* :

  - [ ] Python3
  - [ ] PySpark : Spark avec python
  - [ ] Spark : Spark en Scala
  - [ ] SparkR : Spark en R.

  Créez un *notebook* pyspark et exécutez dans un cellule la ligne suivante :

  ```
  spark
  ```

  cela devrait produire la résultat suivant.
  ![](img/notebook_spark.png)

Pour des questions de sécurité, les liens vers l'interface Spark (*Spark UI*) et les journaux du driver (*Driver log*) ne fonctionnent pas. Il faut pour y accéder réaliser une connexion SSH + un transfert de port.

# First steps with Spark

👋 **3.1  Your first DataFrame —** Spark's main object class is the DataFrame, which is a distributed table. It is analogous to R's or Python's data frames: one row represents an observation, one column represents a variable. But contrary to R or Python, Spark's DataFrames can be distributed over hundred of nodes.

### Data importation

Spark support multiple data formats, and ways to load them.

- data format : csv, json, parquet (an open source column oriented format)
- can read archive files
- schema detection or user defined schema. For static data, like a json file, schema detection can be use with good results.

Spark has multiple syntaxes to import data. Some are simple with no customisation, others are more complexes but you can specify options.

The simplest syntaxes to load a json or a csv file are :

```python
# JSON
json_df. = spark.read.json([location of the file])
# csv
csv_df = spark.read.csv([location of the file])

```

---

**✍Hands-on 1 ** 

- Load the json file store here : `s3://mon-super-bucket-06042021/tweets/tweets20210414-142842.jsonl.gz` and name you data frame `df_tweet_small`
- It's possible to load multiple file a unique DF. It's useful when you have daily files and want to process them all. It's the same syntax as the previous one, just specify a folder. Like `s3://mon-super-bucket-06042021/tweets/`. name you data frame `df_tweet_big`

---

Now you have two dataframes 🎉. 

You can print them with the `show()` function, and print their schema with `printSchema()`. Do you have any concern about this importation ?

Data frames are **immutable**: there is no method to alter one specific value once one is created. Also, data frames are **distributed**: they are split into blocks, ill-named **partitions**[^3], that are stored separately in the memory of the workers nodes. Spark is based on lazy evaluation, so your dataframes are keep in memory only when your data are processed. But the data are stored on a distant storage system and we do not want to request them for every computation. Do you have a solution 

### DataFrame basic manipulations

 Data frames are immutable, but they can be **_transformed_** in other data frames. Such **transformations** include: filtering, sampling, dropping columns, selecting columns, adding new columns...

First, you can get information about the columns with:

```python
df.columns       # get the column names
df.schema        # get the column names and their respective type
df.printSchema() # same, but human-readable
```

You can select columns with the `select()` function. It takes as argument a list of column name. For example 

```python
passengers_per_month = flights\
  .select("PASSENGERS","YEAR","MONTH")\
```

You can get nested columns easily by doing :

```
df.select("parentField.nestedFiel")
```

To filter data you could use the `filter()` function. It take as input a expression evaluate as a boolean for each line. And you can sample with the `sample()` function. For example :

```python
flights_from_2018 = flights\
  .sample(fraction=0.001)\
  .filter(flights.YEAR==2018)\
  .limit(100)
```

---

**✍Hands-on 2 ** 

- Define a dataframe `tweet_author_hashtags`  with only the `auteur` and `hashtags` columns
- Print a dataframe with only the `auteur`, `mentions`, and `cashtags` columns. `mentions`, and `cashtags` are both nested columns in `entities`
- Filter your first dataframe and only keep tweets with more than 1 like . Save this new dataframe and print it.

---

### Lazy evaluation

- What happens when you run `df_tweet_small`, like you would do in Python or R? Why?
- When you defined `tweet_author_hashtags` did you get any result at all? Did any of the instructions cause computation to actually happen? 

This is because Spark has what is known as **lazy evaluation**, in the sense that it will wait as much as it can before performing the actual computation. Said otherwise, when you run an instruction such as:

```python
tweet_author_hashtags = df_tweet_big.select("auteur","hashtags")
```

... you are not executing anything! Rather, you are building an **execution plan**, to be realised later.

Spark is quite extreme in its lazyness, since only a handful of methods called **actions**, by opposition to **transformations**, will trigger an execution. The most notable are:

1. `collect()`, explicitly asking Spark to fetch the resulting rows instead of to lazily wait for more instructions,
2. `take(n)`, asking for `n` first rows
3. `first()`, an alias for `take(1)`
4. `show()` and `show(n)`, human-friendly alternatives[^5]
5. `count()`, asking for the numbers of rows
6. all the "write" methods (write on file, write to database)

[^5]: `first()` is exactly `take(1)` ([ref]( https://stackoverflow.com/questions/37495039/difference-between-spark-rdds-take1-and-first)) and show prints the result instead of returning it as a list of rows ([ref](https://stackoverflow.com/questions/53884994/what-is-the-difference-between-dataframe-show-and-dataframe-take-in-spark-t))

**This has advantages:** on huge data, you don't want to accidently perform a computation that is not needed. Also, Spark can optimize each **stage** of the execution in regard to what comes next. For instance, filters will be executed as early as possible, since it diminishes the number of rows on which to perform later operations. On the contrary, joins are very computation-intense and will be executed as late as possible. The resulting **execution plan** consists in a **directed acyclic graph** (DAG) that contains the tree of all required actions for a specific computation, ordered in the most effective fashion.

**This has also drawbacks.** Since the computation is optimized for the end result, the intermediate stages are discarded by default. For instance, in the following:

### Basic DataFrame column manipulation 

You can add/update/rename column of a dataframe with spark :

- Drop : `df.drop(columnName : str )`
- Rename : `df.withColumnRenamed(oldName : str, newName : str)`
- Add/update : `df.withColumn(columnName : str, columnExpression)` 

For example

```python
overconfident_carriers = flights\
  .withColumn(        # computes new variable
    "OVERCONFIDENCE", # called "OVERCONFIDENCE"
    (flights.DEPARTURES_SCHEDULED - flights.DEPARTURES_PERFORMED)/flights.DEPARTURES_PERFORMED
   )

```

The column created by `withColumn()` can have multiple values for the same line. For example you can split an array of values to have one value per line. To do that you should use the `explode()` function. For instance :

```python
df.withColumn("new column", explode("array"))
```

**✍Hands-on 3** 

- Define a dataframe with a column names `interaction_count`. This column is the sum of like_count, reply_count and retweet_count.
- Update the dataframe you imported at the begining of this lab and drop the `other` column
- Advance DataFrame column manipulation 

#### Array manipulation

Columns with array need special functions :

- Array creation : you can create an array from a text with the `split(text : string, delimiter : string)` function
- to get the size to an array you should use the `size(array : Array)` function
- to create from an array column on row per value in this column (with the rest duplicates) use the `explode(array : Array)` function
- To check if an array contains a value use `array_contains(inputArray : Array, value)`

All this function must be imported first :

```python
from pyspark.sal.functions import split, explode, size, array_contains
```

**✍Hands-on 4** 

- Filter all the tweets without hashtags and for each remained lines, split its hashtag to only get one hashtag by line. 
- Create a new column with the number of words of the `contenu` column (split + size)
- Count how many tweet contain the COVID19 hashtag.

#### User definied function

 For more advanced column manipulation you will need spark udf (user defined function). For instance, with only the previous syntax you cannot run complex process like natural language processing over your tweets. Eve if you already have you function defined in python. For instance :

```python
def to_lower_case(string):
	return string.lower()
	
df.withColumn("tweet_lower_case", to_lower_case(df.contenu))
```

will just crash. Keep in mind that spark is a distributed system. All the pure python functions are only executed in the driver node. We need to specify to Spark the function send to executors.

But, it's easy to make it work. Just to the following :

```python
# some import 
from pyspark.sql.functions import udf
from pyspark.sql.types import StringType

# pure python functions
def minimise(string):
    return string.lower()

# user definid function
minimise_udf = udf(lambda x: minimise(x), StringType()) #we use a lambda function to create the udf.

# df manipulation
tweet_df\
  .select("auteur","hashtags")\
  .filter("size(hashtags)!=0")\
  .withColumn("hashtag", explode("hashtags"))\
  .withColumn("hashtag", minimise_udf("hashtag")).show(10)
```

---

**✍Hands-on 5** 

- Create an udf that count how many words a tweet contains.

### Aggregation functions

Spark offer a variety of aggregation function :

- `count(column : string)` will count every not null value of the specify column. You cant use `count(1)` of `count("*")` to count every line (even row with only null values)

- `counDisctinct(column : string)` and `approx_count_distinct(column : string, percent_error: float)`. If the exact number is irrelevant, `approx_count_distinct()`should be preferred

  ```python
  from pyspark.sql.function import count, countDistinct, approx_count_distinct
  
  df.select(count("col1")).show()
  df.select(countDistinct("col1")).show()
  df.select(approx_count_distinct("col1")).show()
  ```

- You have access to all other common functions `min()`, `max()`, `first()`, `last()`, `sum()`, `sumDistinct()`, `avg()` etc

---

**✍Hands-on 6**

- What is the min, max, average of `interaction_count`
- How many tweets have hashtags ? Distinct hashtags ? Try the approximative count with 0.1, 0.01 and 0.001 as maximum estimation error allowed.

### Grouping functions

Like SQL you can group row by a criteria with Spark. Just use the `groupBy(column : string)` method. Then you can compute some aggregation over those groups.

```python
df.groupBy("col1").agg(
	count("col2").alias("quantity")).show() #alias is use to specify the name of the new column
```

The `agg()` method can take multiples argument to compute multiple aggregation at once.

```python
df.groupBy("col1").agg(
	count("col2").alias("quantity"), min("col2").alias("min"), avg("col3").alias("avg3") ).show()
```

---

**✍Hands-on 6**

- Compute a daframe with the min, max and average retweet of each auteur. Then sort it (using the `sort(column : string)` method) and print it.