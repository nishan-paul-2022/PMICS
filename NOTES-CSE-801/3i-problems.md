# Networking Problems and Solutions

## Table of Contents

- P42. TCP Reno In-depth Analysis
- P43. Flow Control Limits
- P44. TCP AIMD
- P45. TCP Reno In-depth Analysis
- P46. TCP CUBIC In-depth Analysis

## P42. TCP Reno In-depth Analysis

**Task:** Describe the behavior of TCP Reno's congestion window (`cwnd`) over time, specifically its reaction to different types of packet loss. Explain the phases of slow start, congestion avoidance, fast retransmit, and fast recovery from scratch.

---

### Solution

TCP Reno is a foundational version of TCP's congestion control mechanism. Its goal is to use available network bandwidth efficiently without causing persistent congestion. It achieves this by dynamically adjusting its congestion window (`cwnd`), which limits the amount of unacknowledged data a sender can have in flight. The behavior of `cwnd` can be broken down into three main phases.

#### Phase 1: Slow Start

- **Purpose:** To quickly probe for available bandwidth at the beginning of a connection or after a connection has been idle. Despite its name, this phase is one of exponential growth and is very aggressive.
- **Mechanism:**
  1.  The connection begins with a small `cwnd`, typically 1 to 10 MSS (Maximum Segment Size). Let's assume it starts at 1 MSS.
  2.  For every ACK received, the sender increases `cwnd` by 1 MSS.
  3.  Since a sender with `cwnd=N` will send `N` segments and receive `N` ACKs in one RTT, this effectively doubles the `cwnd` every RTT.
      - RTT 1: `cwnd` = 1 MSS. Sends 1 segment.
      - RTT 2: `cwnd` = 2 MSS. Sends 2 segments.
      - RTT 3: `cwnd` = 4 MSS. Sends 4 segments.
      - RTT 4: `cwnd` = 8 MSS. Sends 8 segments.
- **Exiting Slow Start:** The exponential growth continues until one of two things happens:
  1.  A packet loss is detected (either by timeout or duplicate ACKs).
  2.  The `cwnd` reaches a predefined **slow start threshold (`ssthresh`)**. This threshold is a "memory" of the last known good network capacity. When `cwnd` reaches `ssthresh`, the growth must slow down to avoid overshooting the link capacity. The protocol then transitions to the Congestion Avoidance phase.

#### Phase 2: Congestion Avoidance (AIMD)

- **Purpose:** Once the connection has found a rough estimate of the available bandwidth (the `ssthresh`), it needs to probe for more bandwidth gently and additively.
- **Mechanism (Additive Increase):**
  1.  Instead of doubling every RTT, the `cwnd` is increased by approximately **1 MSS per RTT**.
  2.  This results in a linear, steady increase in the sending rate. The sender is carefully "filling the pipe" to find the exact point of congestion.
- **Exiting Congestion Avoidance:** This phase continues until a packet loss is detected. TCP Reno has two different reactions depending on how the loss is detected.

#### Phase 3: Reaction to Loss

This is where TCP Reno's specific implementation shines.

**Scenario A: Loss Detected by Timeout**

This is considered a major congestion event. The network is likely in bad shape, as no packets (or their ACKs) are getting through.

1.  **Set `ssthresh`:** The slow start threshold is set to half of the current `cwnd`.
    - `ssthresh = cwnd / 2`. This records a new, lower estimate of the network's capacity.
2.  **Reset `cwnd`:** The congestion window is reset to its initial small value, `cwnd = 1 MSS`.
3.  **Re-enter Slow Start:** The protocol goes all the way back to Phase 1 (Slow Start) and begins the exponential growth process again until it reaches the new, lower `ssthresh`.

**Scenario B: Loss Detected by 3 Duplicate ACKs (Fast Retransmit and Fast Recovery)**

Receiving three duplicate ACKs is a weaker signal of congestion. It implies that a single packet was lost, but subsequent packets are still getting through, so the network is not completely dead. TCP Reno can recover without going all the way back to slow start.

1.  **Fast Retransmit:** Upon receiving the 3rd duplicate ACK, the sender immediately retransmits the missing segment without waiting for its timer to expire.
2.  **Set `ssthresh` and `cwnd` (Multiplicative Decrease):**
    - `ssthresh = cwnd / 2`.
    - `cwnd = ssthresh`. (In some variants, `cwnd = ssthresh + 3 MSS` to account for the segments that have left the network).
3.  **Fast Recovery:** The protocol now enters a special state. For every additional duplicate ACK that arrives, it increases `cwnd` by 1 MSS. This "inflates" the window to account for the fact that packets are still leaving the network.
4.  **Exit Fast Recovery:** When an ACK finally arrives for the retransmitted data (a "new ACK"), the sender deflates the `cwnd` back down to `ssthresh` and immediately enters **Congestion Avoidance** (Phase 2), resuming its gentle, linear growth.

**Conclusion:**

TCP Reno's behavior is a cycle: it uses **Slow Start** to rapidly find bandwidth, switches to **Congestion Avoidance** to carefully probe for more, and reacts to loss with either a harsh **Timeout** (resetting to `cwnd=1`) or a more graceful **Fast Recovery** (halving `cwnd` and avoiding slow start). This AIMD (Additive Increase, Multiplicative Decrease) strategy allows it to be both efficient and fair to other network traffic.

## P43. Flow Control Limits

A → B over perfect TCP (no loss). A’s app rate `S = 10×R`, send buffer = 1% of file, recv buffer large. What prevents continuous `10×R` sending? Flow control? Congestion control? Something else? Explain.

---

### Solution

In this scenario, the mechanism that prevents Host A from continuously sending at `10*R` is **TCP's Flow Control**.

Let's break down why:

- **Application Rate (S):** The application at Host A is generating data at a massive rate (`10 * R`), far exceeding the network capacity.
- **TCP Send Buffer:** This buffer sits between the application and the TCP sender. The application writes data into this buffer. Its size is finite (1% of the file size).
- **Network Link (R):** The physical link between A and B has a capacity of `R`. This is the absolute maximum rate at which TCP can physically transmit segments.
- **Congestion Control:** The problem states the connection is "perfect TCP (no loss)". In a no-loss environment, TCP's congestion control window (`cwnd`) will grow very large (in theory, indefinitely, but in practice, it's capped by the receiver's window). So, congestion control will **not** be the limiting factor.
- **Receiver Buffer:** The receiver's buffer is stated to be large, implying it's not the bottleneck.

**The Limiting Process:**

1.  The application at A starts dumping data into the TCP send buffer at rate `10*R`.
2.  TCP starts taking data from this buffer and sending it over the network at the maximum possible link rate, `R`.
3.  Since the application is filling the buffer (at `10*R`) much faster than TCP is draining it (at `R`), the send buffer will **fill up very quickly**.
4.  Once the send buffer is full, the `send()` socket call made by the application will **block**. The operating system will not allow the application to write any more data into the buffer until space becomes available.
5.  Space only becomes available when TCP successfully transmits data and receives an ACK for it, at which point it can remove the acknowledged data from the buffer.
6.  The rate at which data is removed from the buffer is limited by the network link speed, `R`.

**Conclusion:**

It is neither flow control (which is about the receiver's capacity) nor congestion control (which is about network capacity and loss) that is the primary limiter in this specific setup.

The limiting factor is the **finite size of the sender's buffer** combined with the **blocking behavior of the send socket call**. This is a fundamental mechanism of the socket API. The application is effectively "rate-limited" by how fast TCP can drain the send buffer, and that rate is capped by the physical link speed `R`.

If the question implies a choice between the two TCP mechanisms, **Flow Control** is the closer answer, as the entire system of buffers and windows is part of TCP's overall flow management. The sender is prevented from sending faster than the receiver can handle, and in this case, the "receiver" is effectively the network link itself. However, the most precise answer is the sender-side buffer limitation.

## P44. TCP AIMD

a. If `cwnd` increases by 1 MSS per RTT, how long to grow from 6 to 12 MSS?

b. Average throughput up to 6 RTTs?

---

### Solution

This question describes the **Congestion Avoidance** phase of TCP, where the congestion window (`cwnd`) increases additively.

#### a. Time to Grow from 6 to 12 MSS

- **Starting `cwnd`:** 6 MSS
- **Target `cwnd`:** 12 MSS
- **Increase required:** 12 - 6 = 6 MSS
- **Increase rate:** 1 MSS per RTT

The time required is simply the total increase needed divided by the rate of increase.

`Time = (Total Increase) / (Increase Rate)`
`Time = 6 MSS / (1 MSS / RTT) = **6 RTTs**`

It will take 6 RTTs for the congestion window to grow from 6 MSS to 12 MSS.

#### b. Average Throughput up to 6 RTTs

We need to calculate the total data sent over the 6 RTTs and divide by the total time.

- **RTT 1:** `cwnd` is 6 MSS. 6 segments are sent.
- **RTT 2:** `cwnd` is 7 MSS. 7 segments are sent.
- **RTT 3:** `cwnd` is 8 MSS. 8 segments are sent.
- **RTT 4:** `cwnd` is 9 MSS. 9 segments are sent.
- **RTT 5:** `cwnd` is 10 MSS. 10 segments are sent.
- **RTT 6:** `cwnd` is 11 MSS. 11 segments are sent.

(At the _end_ of the 6th RTT, the window grows to 12 MSS for the next round).

**Total Segments Sent:**
`Total = 6 + 7 + 8 + 9 + 10 + 11 = 51 MSS`

**Total Time:**
`Time = 6 * RTT`

**Average Throughput:**
`Avg Throughput = Total Data / Total Time`
`Avg Throughput = 51 MSS / (6 * RTT)`
`Avg Throughput = **8.5 MSS / RTT**`

The average throughput over this period is 8.5 segments (MSS) per RTT.

## P45. TCP Reno In-depth Analysis

**Task:** Describe the behavior of TCP Reno's congestion window (`cwnd`) over time, specifically its reaction to different types of packet loss. Explain the phases of slow start, congestion avoidance, fast retransmit, and fast recovery from scratch.

---

### Solution

TCP Reno is a foundational version of TCP's congestion control mechanism. Its goal is to use available network bandwidth efficiently without causing persistent congestion. It achieves this by dynamically adjusting its congestion window (`cwnd`), which limits the amount of unacknowledged data a sender can have in flight. The behavior of `cwnd` can be broken down into three main phases.

#### Phase 1: Slow Start

- **Purpose:** To quickly probe for available bandwidth at the beginning of a connection or after a connection has been idle. Despite its name, this phase is one of exponential growth and is very aggressive.
- **Mechanism:**
  1.  The connection begins with a small `cwnd`, typically 1 to 10 MSS (Maximum Segment Size). Let's assume it starts at 1 MSS.
  2.  For every ACK received, the sender increases `cwnd` by 1 MSS.
  3.  Since a sender with `cwnd=N` will send `N` segments and receive `N` ACKs in one RTT, this effectively doubles the `cwnd` every RTT.
      - RTT 1: `cwnd` = 1 MSS. Sends 1 segment.
      - RTT 2: `cwnd` = 2 MSS. Sends 2 segments.
      - RTT 3: `cwnd` = 4 MSS. Sends 4 segments.
      - RTT 4: `cwnd` = 8 MSS. Sends 8 segments.
- **Exiting Slow Start:** The exponential growth continues until one of two things happens:
  1.  A packet loss is detected (either by timeout or duplicate ACKs).
  2.  The `cwnd` reaches a predefined **slow start threshold (`ssthresh`)**. This threshold is a "memory" of the last known good network capacity. When `cwnd` reaches `ssthresh`, the growth must slow down to avoid overshooting the link capacity. The protocol then transitions to the Congestion Avoidance phase.

#### Phase 2: Congestion Avoidance (AIMD)

- **Purpose:** Once the connection has found a rough estimate of the available bandwidth (the `ssthresh`), it needs to probe for more bandwidth gently and additively.
- **Mechanism (Additive Increase):**
  1.  Instead of doubling every RTT, the `cwnd` is increased by approximately **1 MSS per RTT**.
  2.  This results in a linear, steady increase in the sending rate. The sender is carefully "filling the pipe" to find the exact point of congestion.
- **Exiting Congestion Avoidance:** This phase continues until a packet loss is detected. TCP Reno has two different reactions depending on how the loss is detected.

#### Phase 3: Reaction to Loss

This is where TCP Reno's specific implementation shines.

**Scenario A: Loss Detected by Timeout**

This is considered a major congestion event. The network is likely in bad shape, as no packets (or their ACKs) are getting through.

1.  **Set `ssthresh`:** The slow start threshold is set to half of the current `cwnd`.
    - `ssthresh = cwnd / 2`. This records a new, lower estimate of the network's capacity.
2.  **Reset `cwnd`:** The congestion window is reset to its initial small value, `cwnd = 1 MSS`.
3.  **Re-enter Slow Start:** The protocol goes all the way back to Phase 1 (Slow Start) and begins the exponential growth process again until it reaches the new, lower `ssthresh`.

**Scenario B: Loss Detected by 3 Duplicate ACKs (Fast Retransmit and Fast Recovery)**

Receiving three duplicate ACKs is a weaker signal of congestion. It implies that a single packet was lost, but subsequent packets are still getting through, so the network is not completely dead. TCP Reno can recover without going all the way back to slow start.

1.  **Fast Retransmit:** Upon receiving the 3rd duplicate ACK, the sender immediately retransmits the missing segment without waiting for its timer to expire.
2.  **Set `ssthresh` and `cwnd` (Multiplicative Decrease):**
    - `ssthresh = cwnd / 2`.
    - `cwnd = ssthresh`. (In some variants, `cwnd = ssthresh + 3 MSS` to account for the segments that have left the network).
3.  **Fast Recovery:** The protocol now enters a special state. For every additional duplicate ACK that arrives, it increases `cwnd` by 1 MSS. This "inflates" the window to account for the fact that packets are still leaving the network.
4.  **Exit Fast Recovery:** When an ACK finally arrives for the retransmitted data (a "new ACK"), the sender deflates the `cwnd` back down to `ssthresh` and immediately enters **Congestion Avoidance** (Phase 2), resuming its gentle, linear growth.

**Conclusion:**

TCP Reno's behavior is a cycle: it uses **Slow Start** to rapidly find bandwidth, switches to **Congestion Avoidance** to carefully probe for more, and reacts to loss with either a harsh **Timeout** (resetting to `cwnd=1`) or a more graceful **Fast Recovery** (halving `cwnd` and avoiding slow start). This AIMD (Additive Increase, Multiplicative Decrease) strategy allows it to be both efficient and fair to other network traffic.

## P46. TCP CUBIC In-depth Analysis

**Task:** Describe the behavior of TCP CUBIC's congestion window (`cwnd`) growth. Explain how and why it differs from TCP Reno, particularly in high-speed, long-latency networks.

---

### Solution

TCP CUBIC is the default congestion control algorithm in Linux and many other modern operating systems. It was designed specifically to overcome the performance limitations of TCP Reno in **high-speed, long-latency networks** (also known as "Long Fat Networks" or LFNs).

#### Step 1: The Problem with TCP Reno in LFNs

As shown in P50, TCP Reno's linear growth of "1 MSS per RTT" is extremely slow. On a 10 Gbps link, recovering from a single packet loss can take hours. This is because Reno's growth rate is independent of the link's capacity; it always increases by the same small, constant amount. For an LFN with a massive BDP, this is like trying to fill a swimming pool with a teaspoon.

#### Step 2: The CUBIC Growth Function

CUBIC's core innovation is to change the window growth function. Instead of being linear, the `cwnd` growth is governed by a **cubic function of time**.

- **Formula:** `W(t) = C * (t - K)^3 + W_max`
  - `W(t)`: The target `cwnd` at time `t` since the last loss event.
  - `W_max`: The `cwnd` value just before the last loss event occurred. This is CUBIC's "memory" of the last known network capacity.
  - `C`: A scaling constant.
  - `K`: The time it would take for the window to grow from its current size back to `W_max` if it were using standard TCP's growth rate. `K = cuberoot(W_max * β / C)`. `β` is the multiplicative decrease factor.

#### Step 3: The Three Phases of CUBIC's Growth

The shape of the cubic function gives CUBIC three distinct growth phases after a packet loss.

1.  **Concave Growth (Stabilization):**
    - **Behavior:** Immediately after a loss, the `cwnd` is reduced. The cubic function is initially in its concave region, meaning the window grows very **slowly** at first and then gradually accelerates.
    - **Why:** This is a network-friendly phase. CUBIC is being cautious, ensuring the network has stabilized after the previous congestion event before it starts ramping up its sending rate aggressively.

2.  **Linear-like Growth (Approaching `W_max`):**
    - **Behavior:** As time `t` approaches `K`, the cubic function flattens out around its inflection point. In this region, the window growth becomes almost **linear**, closely mimicking the behavior of TCP Reno.
    - **Why:** This ensures that CUBIC coexists fairly with standard TCP Reno flows if they are sharing the same bottleneck link. This is known as "TCP-friendliness".

3.  **Convex Growth (Probing for Bandwidth):**
    - **Behavior:** Once the `cwnd` surpasses the old `W_max`, the cubic function enters its convex region. The window growth becomes very **fast and aggressive**, accelerating as it moves further from `W_max`.
    - **Why:** This is the key to CUBIC's high performance. Instead of Reno's slow linear probing (1 MSS per RTT), CUBIC rapidly expands its window to discover new, unused bandwidth on the link. It is actively and quickly searching for the new network ceiling.

#### Step 4: Reaction to Loss

CUBIC's reaction to a loss event is similar to Reno's but sets up the next growth cycle.

1.  **Loss Detected:** A packet loss is detected (usually via 3 duplicate ACKs).
2.  **Set `W_max`:** The current `cwnd` is saved as the new `W_max`. This becomes the new target for the next cycle.
3.  **Multiplicative Decrease:** The `cwnd` is reduced by a factor `β` (e.g., `cwnd = cwnd * 0.7`).
4.  **Restart Growth:** The algorithm immediately enters the concave growth phase of the next cubic cycle, with the new `W_max` as its target.

#### Step 5: Conclusion - Reno vs. CUBIC

| Feature              | TCP Reno                                         | TCP CUBIC                                                                  |
| -------------------- | ------------------------------------------------ | -------------------------------------------------------------------------- |
| **Growth Model**     | Linear (Additive Increase)                       | Cubic function of time                                                     |
| **Growth Rate**      | Constant (1 MSS per RTT)                         | Variable (slow, then linear-like, then fast)                               |
| **Dependency**       | Growth is independent of RTT.                    | Growth is primarily dependent on **time** between loss events, not RTT.    |
| **High-Speed Perf.** | Very poor. Takes hours to recover on fast links. | Excellent. Recovers very quickly by aggressively probing for bandwidth.    |
| **Fairness**         | Can be unfair to connections with longer RTTs.   | More fair to connections with different RTTs because growth is time-based. |

In summary, TCP CUBIC is a more intelligent and aggressive algorithm that is "aware" of its distance from the last known network capacity. Its three-phase growth allows it to be stable and fair when needed, but also to rapidly expand and capitalize on the high bandwidth available in modern networks, solving the critical performance bottleneck of TCP Reno.
