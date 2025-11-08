# Networking Problems and Solutions

## Table of Contents

- P47. TCP Loss Rate Formula
- P48. TCP Throughput Analysis (Part 1)
- P49. TCP Throughput Analysis (Part 2)
- P50. TCP Throughput Analysis (Part 3)
- P51. AIMD Analysis: T and Throughput

## P47. TCP Loss Rate Formula

a. Show: `L = 1 / (3/8 * W^2 + 3/4 * W)`
b. Hence derive: `Throughput ≈ 1.22 * MSS / (RTT * sqrt(L))`

---

### Solution

This derivation models the average throughput of TCP Reno based on its window size (`W`) and the loss rate (`L`).

#### a. Deriving the Loss Rate (L)

Let `W` be the maximum congestion window size (in segments) when a loss occurs. The window varies from `W/2` to `W`.

1.  **Packets in one cycle:** A "cycle" is the period between two loss events. In this time, the window grows from `W/2` to `W`.
    *   The number of RTTs in this period is `(W/2)`.
    *   The number of packets sent in RTT `i` (where `i` goes from 0 to `W/2 - 1`) is `(W/2 + i)`.
    *   Total packets sent = `Σ_{i=0}^{W/2 - 1} (W/2 + i)`
    *   This is the sum of an arithmetic series. A simpler way is to find the area of the trapezoid on the `cwnd` graph.
    *   Area = `(Number of RTTs) * (Average window size)`
    *   Area = `(W/2) * ( (W/2 + W) / 2 )`
    *   Area = `(W/2) * (3W / 4) = 3W^2 / 8`
    *   We also have to add the packets sent in the initial RTT when the window was `W/2`. Let's use a more standard derivation.

    **Standard Derivation:**
    *   Number of packets in the cycle where `cwnd` grows from `W/2` to `W`:
        `Packets = (W/2) + (W/2 + 1) + ... + W`
        Sum = `(Number of terms / 2) * (First + Last)`
        Number of terms = `W - W/2 + 1 = W/2 + 1`
        Sum = `((W/2 + 1) / 2) * (W/2 + W) = (W/4 + 1/2) * (3W/2) = 3W^2/8 + 3W/4`
    *   **Loss Rate (L):** In this entire cycle, exactly **one** packet is lost (which triggers the end of the cycle).
    *   `L = (Number of lost packets) / (Total packets sent)`
    *   `L = 1 / (3W^2/8 + 3W/4)`

This matches the formula given.

#### b. Deriving the Throughput Formula

1.  **Throughput Definition:** Throughput is the total data sent divided by the total time.
    *   Total data sent in a cycle = `(Number of packets) * MSS`
        `= (3W^2/8 + 3W/4) * MSS`
    *   Total time for a cycle = `(Number of RTTs) * RTT`
        `= (W/2) * RTT` (It takes W/2 RTTs for the window to grow from W/2 to W).
    *   `Throughput = ( (3W^2/8 + 3W/4) * MSS ) / ( (W/2) * RTT )`

2.  **Simplify the Throughput Expression:**
    *   `Throughput = ( (3W^2/8) / (W/2) + (3W/4) / (W/2) ) * MSS / RTT`
    *   `Throughput = ( 3W/4 + 3/2 ) * MSS / RTT`

3.  **Approximation:** For a large window size `W`, the `3/2` term is small compared to `3W/4`.
    *   `Throughput ≈ (3/4) * W * MSS / RTT`

4.  **Relate Throughput to Loss (L):** Now we need to connect this to the loss formula from part (a).
    *   From part (a): `L = 1 / (3W^2/8 + 3W/4)`
    *   For large `W`, we can approximate `3W^2/8 + 3W/4 ≈ 3W^2/8`.
    *   So, `L ≈ 1 / (3W^2/8) = 8 / (3W^2)`
    *   Now, solve for `W`: `W^2 ≈ 8 / (3L)` => `W ≈ sqrt(8 / 3L) = sqrt(8/3) * 1/sqrt(L)`

5.  **Substitute W back into the Throughput formula:**
    *   `Throughput ≈ (3/4) * W * MSS / RTT`
    *   `Throughput ≈ (3/4) * (sqrt(8/3) * 1/sqrt(L)) * MSS / RTT`
    *   `Throughput ≈ (3/4) * sqrt(8/3) * MSS / (RTT * sqrt(L))`

6.  **Calculate the constant:**
    *   `Constant = (3/4) * sqrt(8/3) = (3/4) * (2.828 / 1.732) ≈ (3/4) * 1.633 ≈ 1.2247`

7.  **Final Formula:**
    *   **`Throughput ≈ 1.22 * MSS / (RTT * sqrt(L))`**

This famous formula shows the fundamental trade-off in TCP: to get higher throughput, the protocol must operate with a larger window size `W`, but a larger `W` can only be sustained if the packet loss rate `L` is very low.

## P48. TCP Throughput Analysis (Part 1)

**Scenario:** A TCP connection has a link speed of 10 Mbps, an RTT of 150 ms, and an MSS of 1500 bytes. TCP Reno is in the congestion avoidance phase.

**Task:** Compute the maximum window size the connection can achieve.

---

### Solution

#### Step 1: Understand the Goal

The "maximum window size" a connection can achieve is limited by the physical characteristics of the network path. It represents the maximum amount of data that can be "in flight" (sent but not yet acknowledged) without overwhelming the network. This is determined by the **Bandwidth-Delay Product (BDP)**.

#### Step 2: Identify Given Parameters and Convert Units

We need to make sure all units are consistent (bits, seconds).

*   **Link Rate (R):** 10 Mbps = 10 * 10^6 bits per second.
*   **Round-Trip Time (RTT):** 150 ms = 0.15 seconds.
*   **Maximum Segment Size (MSS):** 1500 bytes. We need this in bits for later calculations:
    *   `MSS_bits = 1500 bytes * 8 bits/byte = 12,000 bits`.

#### Step 3: Calculate the Bandwidth-Delay Product (BDP)

The BDP tells us the capacity of the network "pipe" in bits. It's the number of bits that can be transmitted before the first bit of the transmission reaches the destination and starts its return journey.

*   **Formula:** `BDP = R * RTT`
*   **Calculation:**
    `BDP = (10 * 10^6 bits/sec) * 0.15 sec`
    `BDP = 1,500,000 bits`

This means the network path can hold 1,500,000 bits of data at any given time.

#### Step 4: Convert BDP to Window Size in Segments

The congestion window (`cwnd`) is measured in bytes, but it's often more intuitive to think of it in terms of the number of segments (MSS). To find the maximum window size in segments, we divide the total capacity of the pipe (BDP) by the size of each segment (MSS).

*   **Formula:** `W_max = BDP / MSS_bits`
*   **Calculation:**
    `W_max = 1,500,000 bits / 12,000 bits/segment`
    `W_max = 125 segments`

**Conclusion:** The maximum window size that this TCP connection can achieve to fully utilize the link is **125 segments**. If the window is smaller, the link will be underutilized. If it's larger, it will cause queuing and eventually packet loss at the bottleneck router.

## P49. TCP Throughput Analysis (Part 2)

**Scenario:** Same as P48 (10 Mbps link, 150 ms RTT, 1500-byte MSS).

**Task:** Assuming TCP increases its window until it reaches the maximum size, experiences a loss, and then halves its window, what is the average window size and average throughput of this connection?

---

### Solution

#### Step 1: Understand the TCP Sawtooth Model

This question describes the steady-state behavior of TCP Reno's congestion avoidance. The `cwnd` follows a "sawtooth" pattern:
1.  It increases linearly (additively) by 1 MSS per RTT.
2.  It reaches a maximum value (`W_max`) where a loss occurs.
3.  Upon loss, the window is immediately halved (`W_max / 2`).
4.  The process repeats.

#### Step 2: Determine the Window Size Range

From the previous problem (P48), we know the maximum window size `W_max` is **125 segments**.

*   **Maximum Window (`W`):** 125 segments.
*   **Minimum Window (`W/2`):** `125 / 2 = 62.5` segments.

The congestion window oscillates between 62.5 and 125 segments.

#### Step 3: Calculate the Average Window Size

Since the window increases linearly, the average window size over one cycle is simply the average of the minimum and maximum values.

*   **Formula:** `Average Window = (Minimum Window + Maximum Window) / 2`
    Alternatively: `Average Window = (W/2 + W) / 2 = 3W / 4`
*   **Calculation:**
    `Average Window = (62.5 + 125) / 2 = 187.5 / 2 = 93.75` segments.
    Or: `Average Window = 0.75 * 125 = 93.75` segments.

The average number of segments in flight is **93.75**.

#### Step 4: Calculate the Average Throughput

The average throughput is the average amount of data sent per unit of time. We can calculate this using the average window size. In one RTT, the sender sends, on average, `Average Window` number of segments.

*   **Formula:** `Throughput = (Average Window * MSS_bits) / RTT`
*   **Parameters:**
    *   `Average Window = 93.75` segments
    *   `MSS_bits = 12,000` bits
    *   `RTT = 0.15` seconds
*   **Calculation:**
    `Throughput = (93.75 * 12,000) / 0.15`
    `Throughput = 1,125,000 bits / 0.15 sec`
    `Throughput = 7,500,000 bits/sec`

**Conclusion:** The average throughput of the connection is **7.5 Mbps**. This makes sense, as the throughput is 75% of the link capacity (10 Mbps), which corresponds to the average window size being 75% of the maximum window size.

## P50. TCP Throughput Analysis (Part 3)

**Scenario:** Same as P48 (10 Mbps link, 150 ms RTT, 1500-byte MSS). Now consider a 10 Gbps link.

**Task:**
a. How long would it take for TCP Reno to increase its window size from `W/2` to `W` after a packet loss on this new link?
b. Explain why this is problematic and propose a fix.

---

### Solution

#### Part a: Time to Recover on a 10 Gbps Link

#### Step 1: Calculate the New Maximum Window Size (`W_max`)

First, we must find the BDP for the high-speed link.

*   **Link Rate (R):** 10 Gbps = 10 * 10^9 bits per second.
*   **RTT:** 150 ms = 0.15 seconds.
*   **MSS:** 1500 bytes = 12,000 bits.

*   **Calculate BDP:**
    `BDP = R * RTT = (10 * 10^9 bits/sec) * 0.15 sec = 1.5 * 10^9 bits`

*   **Calculate `W_max` in segments:**
    `W_max = BDP / MSS_bits = (1.5 * 10^9) / 12,000 = 125,000` segments.

#### Step 2: Calculate the Recovery Time

After a single packet loss, TCP Reno halves its window.
*   **Minimum Window (`W/2`):** `125,000 / 2 = 62,500` segments.
*   **Window Increase Needed:** The window must grow from 62,500 back to 125,000.
    `Increase = 125,000 - 62,500 = 62,500` segments.

TCP Reno's congestion avoidance algorithm increases the window by **1 MSS per RTT**.
*   **Formula:** `Time = (Increase Needed) * RTT`
*   **Calculation:**
    `Time = 62,500 RTTs`
    `Time = 62,500 * 0.15 seconds = 9,375 seconds`

*   **Convert to more understandable units:**
    `9,375 sec / 60 ≈ 156.25 minutes`
    `156.25 min / 60 ≈ 2.6 hours`

It would take approximately **2.6 hours** for TCP Reno to recover from a single packet loss.

#### Part b: The Problem and the Fix

**The Problem:**

The linear increase of "1 MSS per RTT" is **far too slow** for networks with a large bandwidth-delay product (often called "Long Fat Networks" or LFNs). On a 10 Gbps link, a single, non-congestive packet loss (e.g., due to a random bit error) would cause the throughput to be cut in half, and the connection would then operate at a fraction of its potential for over two hours while it slowly recovered. This makes TCP Reno extremely inefficient and unable to properly utilize the capacity of modern high-speed networks.

**The Fix:**

The solution is to use a TCP variant designed for high-speed networks. These protocols modify the congestion avoidance algorithm to be more aggressive.

*   **Proposed Fix:** Replace TCP Reno with a modern congestion control algorithm like **TCP CUBIC**.
*   **How it Works:** Instead of a linear increase, CUBIC's window growth follows a cubic function. After a loss, when the window is far from its previous maximum, the growth is very fast (aggressively probing for bandwidth). As the window size gets closer to the previous maximum (where the last loss occurred), the growth slows down to be more cautious. After passing the old maximum, it accelerates again to find the new network ceiling.
*   **Benefit:** This allows CUBIC to recover from a loss and regain full utilization of a high-speed link in a matter of seconds or minutes, rather than hours.

## P51. AIMD Analysis: T and Throughput

**Task:** Analyze the relationship between `T` (the time between loss events) and the average throughput of a TCP connection.

---

### Solution

#### Step 1: Define the Variables

This analysis is based on the simplified "sawtooth" model of TCP's congestion avoidance phase.

*   `W`: The maximum congestion window size (in segments) reached just before a loss event.
*   `RTT`: The round-trip time of the connection.
*   `T`: The time duration of one full "sawtooth" cycle, i.e., the time between two consecutive loss events.
*   `MSS`: The maximum segment size (in bytes or bits).

#### Step 2: Express `T` in terms of `W` and `RTT`

During one cycle, the window grows from `W/2` to `W`. The rate of increase is 1 MSS per RTT.

*   **Total increase needed:** `W - W/2 = W/2` segments.
*   **Time to achieve this increase:** Since the window grows by 1 segment each RTT, the time `T` is simply the total increase multiplied by the RTT.
    `T = (W/2) * RTT`

#### Step 3: Express Average Throughput in terms of `W`

As calculated in P49, the average window size during a cycle is `(3/4) * W`. The average throughput is this average window (in bits) divided by the RTT.

*   `Average Throughput = ( (3/4) * W * MSS ) / RTT`

#### Step 4: Combine the Equations to Relate Throughput and `T`

Our goal is to find a relationship between `Throughput` and `T`. We can do this by eliminating `W` from the equations.

1.  From the equation in Step 2, solve for `W`:
    `W = 2 * T / RTT`

2.  Substitute this expression for `W` into the throughput formula from Step 3:
    `Average Throughput = (3/4) * (2 * T / RTT) * MSS / RTT`

3.  Simplify the expression:
    `Average Throughput = (6/4) * T * MSS / (RTT * RTT)`
    `Average Throughput = (3/2) * T * MSS / RTT^2`

**Conclusion and Insight:**

The final relationship is **`Average Throughput = 1.5 * T * MSS / RTT^2`**.

This shows that the average throughput of a TCP connection is **directly proportional to the time between loss events (`T`)**. This makes intuitive sense: the longer the protocol can go without experiencing packet loss, the longer it can keep its window size large, and thus the higher its average data transfer rate will be. It also shows an inverse square relationship with RTT, highlighting how latency is a major limiting factor for TCP performance.