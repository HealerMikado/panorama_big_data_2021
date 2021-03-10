---
title: "Introduction to Big Data — Lesson 1.1 What is big data?"
author: "Arthur Katossky & Rémi Pépin"
date: "10/03
/2021"
output: 
  xaringan::moon_reader:
    nature:
      highlightLines: 
      ratio: 16:10
      scroll: false
      countIncrementalSlides: false
    css: ["css/xaringan-themer.css", "css/mine.css"]
---

# From "Big Data" to "Large Scale"

<!-- intro sur la quantié de données produites -->

---

## What is "Big Data" ?

--
.pull-right[![](https://image.flaticon.com/icons/png/512/906/906794.png)]

---

## What is "Big Data" ?

The term started to be used in the 1990's and is a ill-defined notion.

**Big Data** broadly refers to data that **cannot be managed by commonly-used software**.

???

(It is inherenly relative to **who** and is using it. What is a common software for someone may not be for someone else. Think relational databases for someone used to use spreadsheet software.)

---

## What is "Big Data" ?

.pull-left[

_Line and row limits of Microsoft's Excel tablesheet_

```
           Version      Lines  Columns
until 1995     7.0     16 384      256
until 2003    11.0     65 536      256
from  2007    12.0  1 048 576   16 384
```
]

.pull-right[

_Max. number of items stored in one tablesheet_

```{r, echo=FALSE, fig.height=2.5, fig.width=3.5, out.width="100%"}
breaks <- 10^(1:10)
tibble(
  measurement = "Excel (number of cells)",
  year        = c(1999,2003,2007),
  lines       = c(16384,65536,1048576),
  columns     = c(256,256,16384)
) %>%
  ggplot() +
  geom_line(aes(x=year,y=lines*columns, group="measurement")) +
  scale_y_log10(name=NULL, breaks=breaks) + # ,labels =scales::label_number()
  scale_x_continuous(name=NULL, breaks=1999:2010, minor_breaks = NULL) +
  expand_limits(y=1000000) +
  theme(axis.text.x = element_text(angle = -45, hjust = 0))
```

]

???

Target constantly moving as the performance of machines and software continues to increase.

For instance Excel, Microsoft's widely used tablesheet programme, can only cope with a limited number of lines and columns.

---

## What is "Big Data" ?

Size is **not** the only thing that matters.

--

.pull-left[In a tablesheet program, what kind of information can't you store properly?]
.pull-right[![](https://image.flaticon.com/icons/png/512/906/906794.png)]

--
- relationnal data

--
- images, long texts

--
- unstructured data (ex: web page)

--
- rapidly varying data (ex: tweeter feed)

???

Neither is it only a question of size. Since we talk about Excel, it is clear that many different kind of data cannot be stored (or can difficultly be stored) in Excel, for instance:

In a tablesheet program, what kind of information can't you store properly? (ask audience)

---

## What is "Big Data" ?

You will often find the reference to the "3 V's of Big Data"

- **V**olume
- **V**elocity
- **V**ariety¹

.footnote[¹: not really treated in this course]

???

- **V**olume (massive, taking place)
- **V**elocity (fast, updated constantly)
- **V**ariety (tabular, structured, unstructured, of unknown nature, mixed)

Each of these aspects generates specific challenges, and we are often confronted to two or three of them simultaneously! In this large-scale machine-learning course, we will tackle the *volume* and *velocity* aspect.

Marketers and management gurus like to add V's to the V's. You will have **Value**, **Veracity**... and more. You will here about the "5 V's".

---

## How big is "Big Data" ?

<!-- Find some graphics and figures about the size of files.-->

???

Let have a specific attention to volume. Data volume is measured in bits (FR: bit) the basal 1/0 unit in digital storage. One bit can store only 2 states / values. There are multiples of bits, the first one being the byte (FR: octet), equal to 8 bits and able to store as many as $2^8=256$ states / values.

---

## Large-scale computing

<!-- Find some graphics and figures about the computation power of machines.-->

???

Note that what characterises the *data* does not necesserily say anything about the computation you perfom **on** the data. Machine-learning tasks (in the learning phase as well as the prediction phase) can be challenging even with modest amount of data, since some algorithms (typically involving matrix inversion) do not scale well at all. **Scaling** computation will be in the focus of this course. (Of course all this is linked: if we want to update a predicion model on a rapidly arriving massive dataset, we need clever fast computation! Think Spotify's weekly recommandations for their millions of users.)

---

## The limits to storage and computing

???

There are many limits to our ability to store and compute.

A last (but important) dimension is cost. Data can be said to become "big" whenever storing data or computing statistics become so resource-intensive that their price become non negligeable. Imagine when you consider to buy an extra computer only for to perform a given opertion.

Ethical, ecological, political (autonomy) considerations are also at stake and we will spend some time discussing them.

Before we dig into the details and discuss exemples of large-scale machine-learning challenges, a detour to how a typical desktop computer works is needed.

---
