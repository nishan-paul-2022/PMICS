# Networking Problems and Solutions

## Table of Contents

- P22. Go-Back-N (GBN) Protocol
- P23. Selective Repeat (SR) Protocol
- P24. GBN vs SR Window Sizes
- P25. GBN Receiver Window Size
- P26. Pipelined Protocol Efficiency

## P22. Go-Back-N (GBN) Protocol

Consider the Go-Back-N protocol with a sender window size of 4. Suppose the receiver has a buffer that can hold only 2 packets. Illustrate the operation of this protocol with a timeline trace that shows what happens when the 4th packet is lost during transmission.

---

### Solution

#### Protocol Overview

*   **Sender Window Size:** 4 packets (can send up to 4 unacknowledged packets).
*   **Receiver Buffer:** Can hold only 2 packets.
*   **Scenario:** The 4th packet is lost.

#### Timeline Trace

```
      SENDER                                     RECEIVER
      ------                                     --------

      [send_base=0, nextseqnum=0]
      sends pkt0
      sends pkt1
      sends pkt2
      sends pkt3
      [nextseqnum=4]

      // All 4 packets are in flight.

         -------------------- pkt0 ------------------->
                                                   [rcv_base=0]
                                                   rcv pkt0, buffer it
                                                   sends ACK0
         <-------------------- ACK0 -------------------

      rcv ACK0
      [send_base=1]
      // Window slides, can send pkt4

      sends pkt4
      [nextseqnum=5]

         -------------------- pkt1 ------------------->
                                                   rcv pkt1, buffer it
                                                   sends ACK1
         <-------------------- ACK1 -------------------

      rcv ACK1
      [send_base=2]
      sends pkt5
      [nextseqnum=6]

         -------------------- pkt2 ------------------->
                                                   rcv pkt2, buffer it
                                                   sends ACK2
         <-------------------- ACK2 -------------------

      rcv ACK2
      [send_base=3]
      sends pkt6
      [nextseqnum=7]

         ----------------- pkt3 (lost) X ------------>
                                                   // Receiver doesn't get pkt3
                                                   // It has pkt0, pkt1, pkt2 buffered
                                                   // But can't deliver any because pkt3 is missing
                                                   // Receiver sends ACK2 (last correctly received)

         <-------------------- ACK2 -------------------

      rcv ACK2
      // ACK2 is a duplicate (send_base=3, so expecting ACK3)
      // Sender ignores it and continues waiting

      ...timeout for pkt3!
      // Sender's timer for pkt3 expires.
      retransmits pkt3
      retransmits pkt4
      retransmits pkt5
      retransmits pkt6
      [nextseqnum=7]  // No new packets sent

         -------------------- pkt3 ------------------->
                                                   rcv pkt3, buffer it
                                                   // Now has pkt0,1,2,3
                                                   delivers pkt0,1,2,3 to app
                                                   sends ACK3
         <-------------------- ACK3 -------------------

      rcv ACK3
      [send_base=4]
      sends pkt7
      [nextseqnum=8]

         -------------------- pkt4 ------------------->
                                                   rcv pkt4, buffer it
                                                   sends ACK4
         <-------------------- ACK4 -------------------

      rcv ACK4
      [send_base=5]
      sends pkt8

         -------------------- pkt5 ------------------->
                                                   rcv pkt5, buffer it
                                                   sends ACK5
         <-------------------- ACK5 -------------------

      rcv ACK5
      [send_base=6]
      sends pkt9

         -------------------- pkt6 ------------------->
                                                   rcv pkt6, buffer it
                                                   sends ACK6
         <-------------------- ACK6 -------------------

      rcv ACK6
      [send_base=7]
      sends pkt10

         -------------------- pkt7 ------------------->
                                                   rcv pkt7, buffer it
                                                   sends ACK7
         <-------------------- ACK7 -------------------

      // And so on...
```

#### Key Points

*   When pkt3 is lost, the receiver buffers pkt0, pkt1, and pkt2 but cannot deliver them because GBN requires in-order delivery.
*   The receiver continues to send ACK2 for each subsequent packet it receives (since pkt2 is the last in-order packet).
*   When the sender times out on pkt3, it retransmits pkt3, pkt4, pkt5, and pkt6.
*   Upon receiving pkt3, the receiver can now deliver all four packets and send ACK3.
*   The sender then slides its window and continues.

## P23. Selective Repeat (SR) Protocol

Consider the Selective Repeat protocol with a sender window size of 4. Suppose the receiver has a buffer that can hold only 2 packets. Illustrate the operation of this protocol with a timeline trace that shows what happens when the 4th packet is lost during transmission.

---

### Solution

#### Protocol Overview

*   **Sender Window Size:** 4 packets (can send up to 4 unacknowledged packets).
*   **Receiver Buffer:** Can hold only 2 packets.
*   **Scenario:** The 4th packet is lost.

#### Timeline Trace

```
      SENDER                                     RECEIVER
      ------                                     --------

      [send_base=0, nextseqnum=0]
      sends pkt0
      sends pkt1
      sends pkt2
      sends pkt3
      [nextseqnum=4]

      // All 4 packets are in flight.

         -------------------- pkt0 ------------------->
                                                   [rcv_base=0]
                                                   rcv pkt0, deliver it
                                                   sends ACK0
         <-------------------- ACK0 -------------------

      rcv ACK0
      [send_base=1]
      // Window slides, can send pkt4

      sends pkt4
      [nextseqnum=5]

         -------------------- pkt1 ------------------->
                                                   rcv pkt1, deliver it
                                                   sends ACK1
         <-------------------- ACK1 -------------------

      rcv ACK1
      [send_base=2]
      sends pkt5
      [nextseqnum=6]

         -------------------- pkt2 ------------------->
                                                   rcv pkt2, deliver it
                                                   sends ACK2
         <-------------------- ACK2 -------------------

      rcv ACK2
      [send_base=3]
      sends pkt6
      [nextseqnum=7]

         ----------------- pkt3 (lost) X ------------>
                                                   // Receiver doesn't get pkt3
                                                   // It has delivered pkt0,1,2
                                                   // Receiver sends ACK2

         <-------------------- ACK2 -------------------

      rcv ACK2
      // ACK2 is a duplicate (send_base=3, so expecting ACK3)
      // Sender ignores it and continues waiting

      ...timeout for pkt3!
      // Sender's timer for pkt3 expires.
      retransmits pkt3 only
      [nextseqnum=7]  // No new packets sent

         -------------------- pkt3 ------------------->
                                                   rcv pkt3, deliver it
                                                   sends ACK3
         <-------------------- ACK3 -------------------

      rcv ACK3
      [send_base=4]
      sends pkt7
      [nextseqnum=8]

      // The protocol continues normally.
      // pkt4, pkt5, pkt6 are still in flight and will be ACKed when they arrive.
```

#### Key Points

*   When pkt3 is lost, the receiver continues to deliver pkt0, pkt1, and pkt2 as they arrive.
*   The sender only retransmits pkt3 when its timer expires.
*   Upon receiving pkt3, the receiver delivers it and sends ACK3.
*   The sender slides its window and continues.
*   Unlike GBN, SR does not retransmit packets that have already been acknowledged.

## P24. GBN vs SR Window Sizes

In protocol rdt3.0, the alternating-bit protocol, the sender window size is 1. What are the minimum sender and receiver window sizes for:
*   Go-Back-N protocol?
*   Selective Repeat protocol?

---

### Solution

#### Go-Back-N (GBN) Protocol

*   **Minimum Sender Window Size:** 1. (The sender must be able to send at least one packet to start the protocol.)
*   **Minimum Receiver Window Size:** 1. (The receiver must be able to accept at least one packet. In GBN, the receiver window is effectively 1 because it only accepts the next expected packet in sequence.)

In GBN, the receiver window size is typically 1, but the protocol can work with larger receiver windows. The standard GBN assumes a receiver window of 1 (cumulative ACKs only).

#### Selective Repeat (SR) Protocol

*   **Minimum Sender Window Size:** 1. (Same as GBN.)
*   **Minimum Receiver Window Size:** The receiver window must be at least as large as the sender window to handle out-of-order packets. For SR to work correctly, the receiver window size must be greater than or equal to the sender window size. So, minimum is 1, but practically, it should be at least equal to the sender window size.

For SR, to avoid sequence number ambiguity, the total window sizes (sender + receiver) must be less than or equal to the sequence number space (typically 2^k for k-bit sequence numbers).

## P25. GBN Receiver Window Size

In Go-Back-N, can the receiver window size be greater than 1? Explain.

---

### Solution

**Yes, the receiver window size can be greater than 1 in Go-Back-N.**

In standard GBN, the receiver window is 1, meaning it only accepts the next expected packet in sequence. However, the protocol can be modified to allow the receiver to buffer out-of-order packets and send cumulative ACKs, effectively making the receiver window larger than 1.

**Benefits:**
*   If the receiver can buffer packets, it can acknowledge packets that arrive out of order, but still deliver them in order.
*   This reduces the number of retransmissions if packets are delayed but not lost.

**Drawbacks:**
*   Requires more buffer space at the receiver.
*   The sender still retransmits all packets from the lost one onward, so the benefit is limited.

In practice, GBN receivers often have a window size of 1, but larger windows are possible.

## P26. Pipelined Protocol Efficiency

Consider a pipelined protocol supporting bidirectional data transfer. The sender’s window size is N, and the channel is reliable with a propagation delay of d_prop seconds. Packets are L bits, and the transmission rate is R bps. Ignore processing and queuing delays.

What is the maximum achievable utilization U of the link? Express U in terms of N, d_prop, L, and R.

---

### Solution

#### Understanding Utilization

Utilization U is the fraction of time the link is busy transmitting useful data.

In a pipelined protocol, the sender can have up to N packets in flight. The time to transmit one packet is `L / R` seconds.

The round-trip time (RTT) is `2 * d_prop` seconds (since propagation delay is one-way).

The maximum number of packets that can be "in flight" without the sender stalling is limited by the bandwidth-delay product: `BDP = R * RTT = R * 2 * d_prop`.

The sender window size N should be at least `BDP / L` for full utilization.

#### Maximum Utilization

The maximum utilization occurs when the sender can keep the pipe full, i.e., when `N >= BDP / L`.

In this case, `U = 1` (100% utilization).

If `N < BDP / L`, then the utilization is limited by the window size: `U = (N * L) / (R * RTT) = (N * L) / (R * 2 * d_prop)`.

The maximum achievable utilization is `min(1, (N * L) / (R * 2 * d_prop))`.

**Final Answer:** `U = min(1, (N * L) / (2 * R * d_prop))`