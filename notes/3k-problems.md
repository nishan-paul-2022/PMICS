# Networking Problems and Solutions

## Table of Contents

- P52. AIMD Analysis: Fairness of Variants
- P53. AIMD Analysis: Two-Connection Fairness
- P54. AIMD Analysis: TCP Synchronization
- P55. High-Speed TCP Loss Tolerance
- P56. TCP Idle Behavior

## P52. AIMD Analysis: Fairness of Variants

**Task:** Analyze whether a protocol using **Multiplicative Increase, Multiplicative Decrease (MIMD)** would converge to fairness.

---

### Solution

#### Step 1: Define the Algorithm and the Goal

*   **MIMD Algorithm:**
    *   **Increase:** `cwnd = cwnd * α` for `α > 1` (e.g., `α=1.1`) per RTT with no loss.
    *   **Decrease:** `cwnd = cwnd * β` for `β < 1` (e.g., `β=0.5`) upon packet loss.
*   **Goal:** To determine if two competing MIMD connections will converge to a fair share of the bottleneck link capacity (i.e., each gets R/2).

#### Step 2: Set up the Fairness Analysis

Let's consider two connections, Connection 1 and Connection 2, with rates `R1` and `R2`. They share a link with total capacity `R`. An ideal state is `R1 + R2 = R`. A fair state is `R1 = R2`.

We analyze the **ratio** of their throughputs, `R1/R2`. If the protocol is fair, this ratio should converge to 1 over time, regardless of the starting point.

#### Step 3: Analyze the Effect of Increase and Decrease on the Ratio

Let the state at time `t` be `(R1, R2)`.

*   **Increase Phase:** After one RTT, the new rates are `(α * R1, α * R2)`.
    *   The new ratio is `(α * R1) / (α * R2) = R1 / R2`.
    *   **The ratio of throughputs does not change during the increase phase.**

*   **Decrease Phase:** Upon a loss event, the new rates are `(β * R1, β * R2)`.
    *   The new ratio is `(β * R1) / (β * R2) = R1 / R2`.
    *   **The ratio of throughputs does not change during the decrease phase.**

#### Step 4: Conclusion

Since neither the multiplicative increase nor the multiplicative decrease phase changes the ratio of the throughputs between the two connections, the system will never move towards fairness. If Connection 1 starts with twice the throughput of Connection 2, it will maintain that 2:1 advantage indefinitely.

**Why AIMD is Different and Converges to Fairness:**

Let's quickly contrast with **AIMD**:
*   **Increase:** `(R1 + 1, R2 + 1)`. The ratio `(R1+1)/(R2+1)` moves closer to 1. For example, if `(R1, R2) = (4, 2)`, the ratio is 2. After increase, it's `(5, 3)`, and the ratio is ~1.67. The additive increase gently pushes the system towards fairness.
*   **Decrease:** `(β * R1, β * R2)`. The ratio `R1/R2` is unchanged.

Wait, the standard analysis is that Additive Increase moves parallel to the fairness line, and Multiplicative Decrease moves towards the origin, thus improving fairness. Let's re-evaluate.

**Correct AIMD Analysis:**
*   **Additive Increase:** The *difference* `R1 - R2` remains constant. The *ratio* `R1/R2` changes.
*   **Multiplicative Decrease:** The *ratio* `R1/R2` remains constant.

The key is what happens over a full cycle. An unfair state `(R1, R2)` increases until `R1+R2=R`, then decreases. The decrease brings it closer to the `y=x` fairness line. **MIMD lacks this property.**

**Final Conclusion for MIMD:** The protocol is not fair. It preserves the initial ratio of throughputs between competing connections. The combination of a "gentle" additive increase and a "harsh" multiplicative decrease is what allows AIMD to achieve fairness.

## P53. AIMD Analysis: Two-Connection Fairness

**Task:** Explain and show how two competing TCP (AIMD) connections converge to a fair state.

---

### Solution

#### Step 1: Set up the Model

We use the phase-plot diagram where the x-axis is the throughput of Connection 1 (`R1`) and the y-axis is the throughput of Connection 2 (`R2`).

*   **Link Capacity:** The total available bandwidth is `R`. The line `R1 + R2 = R` represents full utilization. Any point above this line is in congestion.
*   **Fairness:** The line `R1 = R2` represents a perfectly fair allocation of bandwidth.
*   **Goal:** The system should converge to the point `(R/2, R/2)`, where the utilization and fairness lines intersect.

#### Step 2: Define the AIMD Algorithm

*   **Additive Increase (AI):** For each RTT without loss, `cwnd` increases by 1 MSS. In our model, this means the state `(R1, R2)` moves to `(R1 + α, R2 + α)`. This is a vector at a 45-degree angle, moving up and to the right.
*   **Multiplicative Decrease (MD):** When a loss occurs (when `R1 + R2 > R`), `cwnd` is halved. The state `(R1, R2)` moves to `(R1/2, R2/2)`. This is a vector pointing from the current state towards the origin (0,0).

#### Step 3: Trace the System from an Unfair State

Let's assume the system starts at an unfair point **A**, where Connection 1 has a much larger share of the bandwidth than Connection 2 (e.g., `R1 > R2`).

1.  **Increase Phase:** From point **A**, both connections increase their rate additively. The system state moves up and to the right, parallel to the fairness line (`R1 = R2`), until it hits the full utilization line at point **B**. At this point, the router's buffer overflows, and a packet is dropped.

2.  **Decrease Phase:** The loss at point **B** triggers a multiplicative decrease for both connections. The state `(R1, R2)` is halved, moving the system to point **C** = `(R1/B / 2, R2/B / 2)`.

#### Step 4: Analyze the Convergence

This is the crucial step. Point **C** is on the line that connects the origin (0,0) to point **B**. Because point **B** was unfair (`R1 > R2`), the line from the origin to **B** has a slope less than 1. This line is **closer to the fairness line (`R1=R2`)** than the path of the additive increase.

*   By moving from **B** to **C**, the system has moved closer to a fair allocation. The absolute difference between the rates has shrunk (`R1/2 - R2/2` is smaller than `R1 - R2`), and the ratio is the same, but the new starting point for the next increase phase is "more fair".

*   From point **C**, the system begins another additive increase phase, moving parallel to the fairness line until it hits the utilization line again at point **D**.

*   At **D**, another loss occurs, and the system jumps to point **E** = `(R1/D / 2, R2/D / 2)`.

Over many such cycles, the multiplicative decrease step repeatedly pulls the system's state vector closer and closer to the central fairness line. The oscillations will eventually center around the optimal, fair point of `(R/2, R/2)`.

**Conclusion:** The combination of an increase that preserves the rate difference and a decrease that scales the rates towards the origin is what forces the system to converge to a fair equilibrium.

## P54. AIMD Analysis: TCP Synchronization

**Task:** Explain the phenomenon of TCP Synchronization.

---

### Solution

#### Step 1: Define the Scenario

TCP Synchronization (also known as the phase effect or global synchronization) is a problem that can occur when multiple TCP flows are competing for bandwidth at a single bottleneck router. The problem is most pronounced when the router uses a simple **drop-tail queue**.

*   **Drop-Tail Queue:** A basic FIFO (First-In, First-Out) queue. When the buffer is full, any new arriving packets are simply dropped.

#### Step 2: Describe the Process

Imagine several TCP flows (let's say 10 of them) all passing through the same router.

1.  **Collective Increase:** All 10 flows are in the congestion avoidance phase, and they all increase their congestion windows (`cwnd`) additively and independently.
2.  **Queue Saturation:** Because all flows are increasing their sending rate, the total arrival rate at the router will eventually exceed the router's outbound link capacity. The router's buffer (queue) begins to fill up.
3.  **Simultaneous Loss:** The buffer becomes completely full. The next packets to arrive from *several different flows* are all dropped at roughly the same time.
4.  **Synchronized Decrease:** Each flow that experienced a packet loss will detect it (either via timeout or fast retransmit) and trigger its multiplicative decrease, halving its `cwnd`. Because the losses happened at the same time, the decreases also happen at the same time.
5.  **Link Underutilization:** Suddenly, all 10 flows have cut their sending rate in half. The total sending rate drops far below the link's capacity, and the link becomes underutilized. The router's queue empties.
6.  **Repeat:** Now that the congestion is gone, all 10 flows begin their additive increase again, and the cycle repeats.

#### Step 3: Explain the Consequences

This global synchronization of the TCP "sawtooth" patterns has several negative effects:

*   **Inefficient Link Utilization:** The network oscillates between periods of being overloaded (full queues, high latency, packet loss) and periods of being underutilized (empty queues, low throughput). The average throughput is lower than it could be.
*   **High Latency and Jitter:** The queuing delay at the router oscillates wildly. When the buffer is full, latency is very high. When it's empty, latency is low. This variation in delay (jitter) is particularly harmful to real-time applications like VoIP and video conferencing.
*   **Unfairness:** Drop-tail queues can be unfair to bursty traffic, and synchronization can exacerbate this.

#### Step 4: The Solution

The solution to TCP synchronization is to avoid the conditions that cause it. This is done by using smarter queue management strategies in the router, known as **Active Queue Management (AQM)**.

*   **Example: Random Early Detection (RED):** Instead of waiting for the queue to be completely full, a RED-enabled router starts dropping packets *probabilistically* as the average queue size grows.
*   **Benefit:** By dropping packets early and from random flows, RED signals congestion to a few flows at a time, causing them to reduce their windows at different times. This **de-synchronizes** their responses, breaks the global sawtooth pattern, and leads to a more stable queue size, lower average latency, and higher overall link utilization.

## P55. High-Speed TCP Loss Tolerance

Derive required loss probability for 10 Gbps and 100 Gbps TCP connections (based on RTT & MSS).

---

### Solution

We use the TCP throughput formula derived in P47:
`Throughput ≈ 1.22 * MSS / (RTT * sqrt(L))`

We need to solve for the loss probability `L`.

`sqrt(L) ≈ 1.22 * MSS / (RTT * Throughput)`
`L ≈ (1.22 * MSS / (RTT * Throughput))^2`

**Given Parameters:**
*   **MSS:** 1500 bytes = 12,000 bits
*   **RTT:** 100 ms = 0.1 sec (a typical value used for these calculations)

#### Case 1: Throughput = 10 Gbps

*   `Throughput = 10 * 10^9` bits/sec

`L ≈ (1.22 * 12000 / (0.1 * 10 * 10^9))^2`
`L ≈ (14640 / 10^9)^2`
`L ≈ (1.464 * 10^{-5})^2`
`L ≈ 2.14 * 10^{-10}`

For a 10 Gbps throughput, the required packet loss rate must be approximately **1 packet loss for every 4.6 billion packets sent**.

#### Case 2: Throughput = 100 Gbps

*   `Throughput = 100 * 10^9` bits/sec

`L ≈ (1.22 * 12000 / (0.1 * 100 * 10^9))^2`
`L ≈ (14640 / 10^{10})^2`
`L ≈ (1.464 * 10^{-6})^2`
`L ≈ 2.14 * 10^{-12}`

For a 100 Gbps throughput, the required packet loss rate must be approximately **1 packet loss for every 460 billion packets sent**.

**Conclusion:**

This demonstrates that standard TCP Reno is extremely sensitive to packet loss at high speeds. The loss rates required to achieve high throughput are incredibly low and often unachievable on real-world networks. This is another major motivation for high-speed TCP variants like CUBIC, which are designed to be more aggressive and can achieve higher throughput even with more realistic loss rates.

## P56. TCP Idle Behavior

If TCP goes idle after sending and resumes later: Should it reuse old `cwnd`/`ssthresh` or reset? Discuss pros/cons and recommend an approach.

---

### Solution

This is a real-world implementation question for TCP. If a connection is idle for a period, the network conditions (available bandwidth, congestion level) may have changed significantly.

#### Option 1: Reuse Old `cwnd` and `ssthresh`

*   **Pros:**
    *   **Aggressive Restart:** If the network conditions haven't changed, the connection can immediately resume sending at its previous high rate, achieving good performance instantly.
*   **Cons:**
    *   **Extremely Dangerous:** If the available bandwidth has *decreased* while the connection was idle, resuming with a large `cwnd` will instantly flood the network, causing a massive burst of packet loss. This is highly disruptive to the connection itself and to other flows on the network.

#### Option 2: Reset `cwnd` and `ssthresh`

*   **Pros:**
    *   **Safe and Conservative:** Resetting `cwnd` to 1 MSS and starting over with slow start is the safest possible approach. It ensures that the sender probes the network for the new available bandwidth from scratch, avoiding the risk of causing a huge congestion event.
*   **Cons:**
    *   **Slow Restart:** If the network conditions are still good, the connection will be unnecessarily slow to ramp up its sending rate again. This can be frustrating for applications that have intermittent bursts of data (e.g., interactive sessions).

#### Recommended Approach (The Real-World Solution)

Modern TCP implementations use a hybrid approach, often called **Congestion Window Validation (CWV)** or a **Restart after Idle** mechanism.

1.  **Define an "Idle Period":** A connection is considered idle if no data is sent for a certain amount of time (e.g., one retransmission timeout).
2.  **The Rule:** If a connection has been idle for more than the defined idle period, it should **not** resume sending with its old, large `cwnd`.
3.  **The Action:** Upon resuming, the sender should reduce its `cwnd`. The exact amount varies, but a common and safe approach is to **reset `cwnd` to the initial window size (IW)**, effectively re-entering slow start. The `ssthresh` value is often maintained, as it represents the last known "safe" point, but the sender must prove it can reach that point again by going through slow start.

**Justification:** The risk of causing a massive congestion event by using a stale, large `cwnd` is far greater than the performance penalty of occasionally restarting from slow start. Network safety and stability are prioritized over the potential for a slightly faster restart. This conservative approach ensures that idle TCP connections behave responsibly when they become active again.