# Networking Problems and Solutions

## Table of Contents

- P32. TCP AIMD Fairness
- P33. TCP AIMD Convergence
- P34. TCP Synchronization Problem
- P35. TCP AQM Solutions
- P36. TCP High-Speed Variants

## P32. TCP AIMD Fairness

Explain how TCP's Additive Increase Multiplicative Decrease (AIMD) achieves fairness among competing flows.

---

### Solution

AIMD ensures that multiple TCP flows sharing a bottleneck link converge to equal shares of the bandwidth.

- **Additive Increase:** Each flow increases its `cwnd` by 1 MSS per RTT, leading to gradual increases.
- **Multiplicative Decrease:** Upon loss, each flow halves its `cwnd`.
- **Convergence:** Flows that send more data experience more losses, leading to equal rates.

## P33. TCP AIMD Convergence

Show with a diagram how two TCP flows converge to fairness using AIMD.

---

### Solution

```
Initial: Flow1 rate > Flow2 rate
Loss occurs when R1 + R2 > R
Both halve cwnd
New rates: closer to R/2
Repeat until R1 ≈ R2
```

## P34. TCP Synchronization Problem

Describe the TCP synchronization problem and its causes.

---

### Solution

Multiple TCP flows synchronize their congestion windows, leading to periodic bursts of traffic and underutilization.

- **Cause:** Drop-tail queues cause all flows to lose packets simultaneously.
- **Effect:** All flows reduce `cwnd` at the same time, then increase together.

## P35. TCP AQM Solutions

Explain Active Queue Management (AQM) and how RED helps solve TCP synchronization.

---

### Solution

AQM proactively manages queue lengths to avoid synchronization.

- **RED:** Random Early Detection drops packets probabilistically when queue length exceeds a threshold.
- **Benefit:** Prevents synchronized losses, leading to smoother traffic.

## P36. TCP High-Speed Variants

Compare TCP CUBIC and TCP Reno for high-speed networks.

---

### Solution

- **TCP Reno:** Linear increase (1 MSS/RTT) is too slow for high BDP.
- **TCP CUBIC:** Cubic growth function allows faster recovery and better utilization in high-speed, long-delay networks.
