# Networking Problems and Solutions

## Table of Contents

- P37. TCP Throughput Calculation
- P38. TCP Window Size for Utilization
- P39. TCP Loss Rate Impact
- P40. TCP Idle Behavior
- P41. TCP Endpoint Authentication

## P37. TCP Throughput Calculation

A TCP connection has MSS=1500 bytes, RTT=200 ms, loss rate L=10^-4. Calculate average throughput.

---

### Solution

Using `Throughput ≈ 1.22 * MSS / (RTT * sqrt(L))`

`Throughput ≈ 1.22 * 1500 / (0.2 * sqrt(10^-4)) ≈ 1.22 * 1500 / (0.2 * 0.01) ≈ 1.22 * 1500 / 0.002 ≈ 1.22 * 750,000 ≈ 915,000 bps ≈ 0.915 Mbps`

## P38. TCP Window Size for Utilization

For 10 Gbps link, RTT=100 ms, MSS=1500 bytes, what window size achieves 95% utilization?

---

### Solution

BDP = R * RTT = 10^10 * 0.1 = 10^9 bits

Packets in BDP = 10^9 / (1500*8) ≈ 83,333 packets

For 95% utilization, window size ≈ 0.95 * 83,333 ≈ 79,166 packets

## P39. TCP Loss Rate Impact

How does loss rate affect TCP throughput? Derive the relationship.

---

### Solution

From the formula, throughput ∝ 1/sqrt(L), so higher loss reduces throughput significantly.

## P40. TCP Idle Behavior

If TCP goes idle, should it reuse old cwnd/ssthresh or reset? Discuss pros/cons.

---

### Solution

*   **Reuse:** Faster restart if conditions unchanged.
*   **Reset:** Safer, avoids flooding if conditions worsened.
*   Modern TCP uses a hybrid approach (congestion window validation).

## P41. TCP Endpoint Authentication

a. UDP spoofing: if client spoofs IP Y as X, where will server send reply?

b. TCP SYN spoof: can server be certain the client is at Y? Explain.

---

### Solution

a. Server sends reply to X (the spoofed IP).

b. No, server cannot be certain based on SYN alone. TCP handshake provides authentication via return routability.