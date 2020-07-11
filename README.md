# [MIDAS](https://github.com/bhatiasiddharth/MIDAS) implementation in Julia

Anomaly Detection on Dynamic (time-evolving) Graphs in Real-time and Streaming manner.
Detecting intrusions (DoS and DDoS attacks), frauds, fake rating anomalies.

## Installation
```julia
using Pkg
Pkg.add("https://github.com/ashryaagr/MIDAS.jl")
```

## Table of Contents

- [Features](#features)
- [Example](#Example)
- [Online Articles](#online-articles)
- [MIDAS in other Languages](#midas-in-other-languages)
- [Citation](#citation)

## Features

- Finds Anomalies in Dynamic/Time-Evolving Graph: (Intrusion Detection, Fake Ratings, Financial Fraud)
- Detects Microcluster Anomalies (suddenly arriving groups of suspiciously similar edges e.g. DoS attack)
- Theoretical Guarantees on False Positive Probability
- Constant Memory (independent of graph size)
- Constant Update Time (real-time anomaly detection to minimize harm)

## Example
```julia
using MIDAS
using ROC

# Load data and ground truth labels
data, labels = @load_darpa

# scores using midas algorithm
anomaly_score = midas(
    data,
    num_rows=2,
    num_buckets=769
    )

# ROC analysis of scores of midas. This will take some time to run
roc_midas = roc(anomaly_score, labels, 1.0)

# AUC value for midas
println(AUC(roc_midas))


# scores using midasR algorithm.
anomaly_score_R = midasR(
    data,
    num_rows=2,
    num_buckets=769,
    factor=0.4
    )

# ROC analysis for midasR. This will take some time to run
roc_midasR = roc(anomaly_score_R, labels, 1.0)

# AUC value for midasR
println(AUC(roc_midas_R))
```

## Online Articles

1. KDnuggets: [Introducing MIDAS: A New Baseline for Anomaly Detection in Graphs](https://www.kdnuggets.com/2020/04/midas-new-baseline-anomaly-detection-graphs.html)
2. Towards Data Science: [Controlling Fake News using Graphs and Statistics](https://towardsdatascience.com/controlling-fake-news-using-graphs-and-statistics-31ed116a986f)
2. Towards Data Science: [Anomaly detection in dynamic graphs using MIDAS](https://towardsdatascience.com/anomaly-detection-in-dynamic-graphs-using-midas-e4f8d0b1db45)
4. Towards AI: [Anomaly Detection with MIDAS](https://medium.com/towards-artificial-intelligence/anomaly-detection-with-midas-2735a2e6dce8)
5. [AIhub Interview](https://aihub.org/2020/05/01/interview-with-siddharth-bhatia-a-new-approach-for-anomaly-detection/)

## MIDAS in Other Languages

1. [Golang](https://github.com/steve0hh/midas) by [Steve Tan](https://github.com/steve0hh)
2. [Ruby](https://github.com/ankane/midas) by [Andrew Kane](https://github.com/ankane)
3. [Rust](https://github.com/scooter-dangle/midas_rs) by [Scott Steele](https://github.com/scooter-dangle)
4. [R](https://github.com/pteridin/MIDASwrappeR) by [Tobias Heidler](https://github.com/pteridin)
5. [Python](https://github.com/ritesh99rakesh/pyMIDAS) by [Ritesh Kumar](https://github.com/ritesh99rakesh)
6. [Java](https://github.com/jotok/MIDAS-Java) by [Joshua Tokle](https://github.com/jotok)
7. [C++](https://github.com/bhatiasiddharth/MIDAS) by [Siddharth Bhatia](https://github.com/bhatiasiddharth)

Note: This julia implementation is based on the research paper of authors of c++ implementation and the Julia implementation adopts the design from python implementation.

## Citation

If you use this code for your research, please consider citing the paper.
```
@inproceedings{bhatia2020midas,
    title="MIDAS: Microcluster-Based Detector of Anomalies in Edge Streams",
    author="Siddharth {Bhatia} and Bryan {Hooi} and Minji {Yoon} and Kijung {Shin} and Christos {Faloutsos}",
    booktitle="AAAI 2020 : The Thirty-Fourth AAAI Conference on Artificial Intelligence",
    year="2020"
}
```
