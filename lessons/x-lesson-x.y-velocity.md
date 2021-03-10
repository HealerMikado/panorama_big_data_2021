


## Making of

### Brainstorm of themes

- [ ] Re-schedule online and streaming algorithms in a later module ?
- [ ] Standard Streams
- [ ] Stream-writing in a file as a very sample (open a writing connection and never close it, adding a line at every error for instance, in a logging objective)
- [ ] Data stream: "a stream is a [possibly infinite] sequence of [...] elements made available over time" ; an operation on a stream may be called a "filter"
- [ ] Exemples of connections with 2 computers
- [ ] Synchronous vs asychronous, subscriptions, sockets, pings, etc.
- [ ] Fast write vs. fast read
- [ ] When fast for something means slow for something else
- [ ] Kafka
- [ ] API
- [ ] sed, awk, perl
- [ ] a sink, an abstraction (object, function) that can "listen to" a source
- [ ] Network sockets
- [ ] persistent connection ; connection0based communication vs. connectionless communication
- [ ] Unicast, multicast, broadcast, anycast, geocast
- [ ] data stream as an iterator
- [ ] callbacks
- [ ] necessity to not depend on the order of arrival ; extra care for ultimate consistency and (some data can arrive later, or never) 
- [ ] batch vs. stream ; controlled stream (in order) vs. real life stream (some data may never arrive) ; buffer ; data pipeline
- [ ] databases issues (fast read, fast write) vs. coding issues (fast computation) ; notion of "model distillation" : relearning the output of prediction with a less complex model
- [ ] how to copee with streams: compute using online algoes, compute less often, compute when resources are available, downsample, for supervised learning prefer compromise between METRIC and TIME to compromise between METRIC and NUMBER OF OBS (some algoes may be faster and thus can use more data in the same time than an other more comple algo, and thus reach the same performence in the same time, even though the second one WOULD BE even better if we had enough time to use the whole dataset)
- [ ] Access vs. process ratio. According to Wikipedia, in image processing, operations can use up to 50 times each element read from disk. (https://en.wikipedia.org/wiki/Stream_processing)
- [ ] Dataflow programming: "Traditionally, a program is modelled as a series of operations happening in a specific order; this may be referred to as sequential, procedural, control flow or imperative programming. The program focuses on commands... where data is normally "at rest"." In contrast, dataflow programming emphasizes the movement of data and models programs as a series of connections. ... Thus, dataflow languages are inherently parallel and can work well in large, decentralized systems.
- [ ] Apache Beam, Apache Flink, TensorFlow
- [ ] Notion of "state": an online algo must store past info in a state of reasonable size in order to provide an update version of the statistics.
- [ ] From Kafka doc: 
    
    > examples include:
    >
    > - To process payments and financial transactions in real-time, such as in stock exchanges, banks, and insurances.
    > - To track and monitor cars, trucks, fleets, and shipments in real-time, such as in logistics and the automotive industry.
    > - To continuously capture and analyze sensor data from IoT devices or other equipment, such as in factories and wind parks.
    > - To collect and immediately react to customer interactions and orders, such as in retail, the hotel and travel industry, and mobile applications.
    > - To monitor patients in hospital care and predict changes in condition to ensure timely treatment in emergencies.
    > - To connect, store, and make available data produced by different divisions of a company.
    > - To serve as the foundation for data platforms, event-driven architectures, and microservices.
    
- [ ] From Kafka doc:
    
    > - To publish (write) and subscribe to (read) streams of events, including continuous import/export of your data from other systems.
    > - To store streams of events durably and reliably for as long as you want.
    > - To process streams of events as they occur or retrospectively.
    > 
    > And all this functionality is provided in a distributed, highly scalable, elastic, fault-tolerant, and secure manner. Kafka can be deployed on bare-metal hardware, virtual machines, and containers, and on-premises as well as in the cloud. You can choose between self-managing your Kafka environments and using fully managed services offered by a variety of vendors. [The students should typically be able to understand this at the end of the course.]


### Documents

A checkmark means that the the source has been read and its content has been extracted in the brainstorm section.

**Wikipédia:**

- [x] https://en.wikipedia.org/wiki/Stream_(computing)
- [x] https://en.wikipedia.org/wiki/Multicast
- [x] https://en.wikipedia.org/wiki/Data_stream
- [x] https://en.wikipedia.org/wiki/Stream_processing [completely off-topic, concerned with a limited parallel processing at the chip level]
- [x] https://en.wikipedia.org/wiki/Dataflow_programming [not completely spot-on]
- [ ] https://en.wikipedia.org/wiki/Flow-based_programming
- [x] https://en.wikipedia.org/wiki/State_(computer_science) [very light article]
- [x] https://en.wikipedia.org/wiki/Pipeline_(computing) [modestly interesting]
- [ ] https://en.wikipedia.org/wiki/Throughput
- [ ] https://en.wikipedia.org/wiki/Standard_streams
- [x] https://en.wikipedia.org/wiki/Network_socket [modestly interesting]
- [x] https://en.wikipedia.org/wiki/Connectionless_communication [too technical]
- [x] https://en.wikipedia.org/wiki/Connection-oriented_communication [too technical]
- [ ] https://en.wikipedia.org/wiki/Online_algorithm
- [ ] https://en.wikipedia.org/wiki/Streaming_algorithm

**Other websites:**

- [x] https://kafka.apache.org/documentation/#gettingStarted
- [ ] https://kafka.apache.org/documentation/#design
- [ ] https://towardsdatascience.com/how-to-become-an-expert-in-machine-learning-for-data-streams-3ecbb612b641

**Books:**

- [ ] A book

**Courses:**

- [ ] A course

### Structure

1. When does speed become a problem? [exemples,
2. Where do the speed issues come from?
3. Storage solutions
4. Computational solutions