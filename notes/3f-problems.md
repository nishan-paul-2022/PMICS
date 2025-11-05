# Networking Problems and Solutions

## Table of Contents

- P27. TCP Reno Throughput Formula
- P28. TCP Tahoe vs Reno
- P29. TCP Fast Retransmit/Fast Recovery
- P30. TCP Congestion Control Phases
- P31. TCP Congestion Window Analysis

## P27. TCP Reno Throughput Formula

Derive the TCP Reno throughput formula: `Throughput ≈ (1.22 * MSS) / (RTT * sqrt(L))`

---

### Solution

The derivation is based on the "sawtooth" model of TCP Reno's congestion avoidance phase.

#### Step 1: Model the Congestion Window

In steady state, TCP Reno's `cwnd` oscillates between `W/2` and `W`, where `W` is the maximum window size when a loss occurs.

*   The average window size is `(W/2 + W) / 2 = 3W/4`.

#### Step 2: Loss Rate (L)

The loss rate `L` is the probability that a packet is lost. In the cycle, exactly one packet is lost out of the total packets sent.

The total packets sent in one cycle is the area under the `cwnd` graph: `(W/2) * (average window) = (W/2) * (3W/4) = 3W^2/8`.

So, `L = 1 / (3W^2/8) = 8/(3W^2)`.

#### Step 3: Throughput

Throughput = (Average window size * MSS) / RTT = (3W/4 * MSS) / RTT.

From the loss rate equation: `W^2 = 8/(3L)` => `W = sqrt(8/(3L))`.

Substitute: `Throughput = (3/4) * sqrt(8/(3L)) * MSS / RTT = (3/4) * sqrt(8/3) * sqrt(1/L) * MSS / RTT`.

Calculate the constant: `(3/4) * sqrt(8/3) ≈ 1.22`.

Thus, `Throughput ≈ 1.22 * MSS / (RTT * sqrt(L))`.

## P28. TCP Tahoe vs Reno

Compare TCP Tahoe and TCP Reno in terms of their congestion control mechanisms. Illustrate with a diagram how each reacts to a single packet loss.

---

### Solution

#### TCP Tahoe

*   **Reaction to Loss:** Upon detecting a loss (via timeout), Tahoe halves the `cwnd` and sets `ssthresh = cwnd/2`, then enters slow start.
*   **Fast Retransmit:** Tahoe does not have fast retransmit; it waits for timeouts.
*   **Behavior:** More conservative, leads to longer recovery times.

#### TCP Reno

*   **Reaction to Loss:** 
    *   Timeout: Same as Tahoe (halve `cwnd`, set `ssthresh`, slow start).
    *   3 Duplicate ACKs: Halves `cwnd`, sets `ssthresh = cwnd`, enters fast recovery (retransmits lost packet without slow start).
*   **Advantage:** Faster recovery from isolated losses.

#### Diagram

```
Tahoe (Timeout):
cwnd: /\/ (sharp drop to slow start)

Reno (3 Dup ACKs):
cwnd: /\ (gentle drop, fast recovery)
```

## P29. TCP Fast Retransmit/Fast Recovery

Explain how TCP Reno's fast retransmit and fast recovery mechanisms work. Why are they beneficial?

---

### Solution

#### Fast Retransmit

*   When the sender receives 3 duplicate ACKs, it assumes the packet has been lost and retransmits it immediately, without waiting for a timeout.

#### Fast Recovery

*   After retransmitting, the sender halves `cwnd` but does not enter slow start. It continues sending new packets (if available) at the reduced rate.

#### Benefits

*   Faster recovery from isolated losses, avoiding the long timeout delays.
*   Maintains higher throughput in networks with occasional packet losses.

## P30. TCP Congestion Control Phases

Describe the four phases of TCP congestion control: Slow Start, Congestion Avoidance, Fast Retransmit, and Fast Recovery.

---

### Solution

#### 1. Slow Start

*   `cwnd` starts at 1 MSS, doubles each RTT until it reaches `ssthresh`.
*   Exponential growth.

#### 2. Congestion Avoidance

*   `cwnd` increases by 1 MSS per RTT.
*   Linear growth.

#### 3. Fast Retransmit

*   Upon 3 duplicate ACKs, retransmit the lost packet immediately.

#### 4. Fast Recovery

*   Halve `cwnd`, set `ssthresh = cwnd`, continue sending at reduced rate.

## P31. TCP Congestion Window Analysis

A TCP connection has an MSS of 1460 bytes, RTT of 100 ms, and a loss rate of 10^-5. What is the average congestion window size and throughput?

---

### Solution

Using the throughput formula: `Throughput ≈ 1.22 * MSS / (RTT * sqrt(L))`

*   `MSS = 1460 bytes`
*   `RTT = 0.1 s`
*   `L = 10^-5`

`Throughput ≈ 1.22 * 1460 / (0.1 * sqrt(10^-5)) ≈ 1.22 * 1460 / (0.1 * 0.003162) ≈ 1.22 * 1460 / 0.0003162 ≈ 1.22 * 1460 * 3162 ≈ 1.22 * 4.62e6 ≈ 5.64e6 bps ≈ 5.64 Mbps`

From `W^2 = 8/(3L)`, `W ≈ sqrt(8/(3*10^-5)) ≈ sqrt(2.67e5) ≈ 516`

Average `cwnd = 3W/4 ≈ 387 MSS`