# Networking Problems and Solutions

## Table of Contents

- P17. Alternating Sender-Receiver FSM
- P18. Selective Repeat (SR) – Send Two at a Time
- P19. Reliable Broadcast: A → B & C
- P20. Alternating Delivery at Receiver C
- P21. Request–Data Protocol

## P17. Alternating Sender-Receiver FSM

Consider two network entities, A and B, which are connected by a perfect bi-directional channel. A and B are to deliver data messages to each other in an alternating manner: A → B → A → B → ...

If an entity is in a state where it should not attempt to deliver a message and there is an event like `rdt_send(data)` from above, this call can simply be ignored with a call to `rdt_unable_to_send(data)`.

**Task:** Draw FSMs for A and B, reflecting strict alternation of sending between them.

---

### Solution

This protocol requires each entity to have two main states: one where it is allowed to send and is waiting for a call from its application, and one where it has just sent something and is now waiting to receive from the other entity.

Since the channel is perfect (no loss, no corruption), we don't need sequence numbers, ACKs, or timers. The arrival of a packet from the other side serves as the "token" or permission to send the next message.

#### FSM for Entity A

*   **Initial State:** `Wait to Send`. In this state, A is allowed to send the first message.
*   **Second State:** `Wait to Receive`. In this state, A has just sent a message and must wait for a message from B before it can send again.

  *(Placeholder for a real diagram)*

**State: `Wait to Send (A)`** (Initial State)
*   **Event:** `rdt_send(data)` from the application above.
    *   **Action:** `packet = make_pkt(data)`, `udt_send(packet)`.
    *   **Transition:** To `Wait to Receive (A)`.
*   **Event:** `rdt_rcv(packet)` from below.
    *   **Action:** This should not happen. An error, or ignore.

**State: `Wait to Receive (A)`**
*   **Event:** `rdt_send(data)` from the application above.
    *   **Action:** `rdt_unable_to_send(data)` (Ignore the request, as it's not A's turn).
    *   **Transition:** Stay in `Wait to Receive (A)`.
*   **Event:** `rdt_rcv(packet)` from below (a packet arrives from B).
    *   **Action:** `extract(packet, data)`, `deliver_data(data)`.
    *   **Transition:** To `Wait to Send (A)`.

#### FSM for Entity B

The FSM for B is symmetrical to A's, but its initial state must be `Wait to Receive`, as A is designated to send first.

*   **Initial State:** `Wait to Receive`.
*   **Second State:** `Wait to Send`.

  *(Placeholder for a real diagram)*

**State: `Wait to Receive (B)`** (Initial State)
*   **Event:** `rdt_send(data)` from the application above.
    *   **Action:** `rdt_unable_to_send(data)`.
    *   **Transition:** Stay in `Wait to Receive (B)`.
*   **Event:** `rdt_rcv(packet)` from below (a packet arrives from A).
    *   **Action:** `extract(packet, data)`, `deliver_data(data)`.
    *   **Transition:** To `Wait to Send (B)`.

**State: `Wait to Send (B)`**
*   **Event:** `rdt_send(data)` from the application above.
    *   **Action:** `packet = make_pkt(data)`, `udt_send(packet)`.
    *   **Transition:** To `Wait to Receive (B)`.
*   **Event:** `rdt_rcv(packet)` from below.
    *   **Action:** Ignore.

This pair of FSMs correctly enforces the strict A -> B -> A -> B alternation. The "turn" to send is passed back and forth by the arrival of a data packet.

## P18. Selective Repeat (SR) – Send Two at a Time

In the generic SR protocol, the sender transmits a message as soon as it is available. Now suppose we want an SR protocol that sends messages **two at a time**. The sender will send a pair of messages and send the next pair only when both messages in the first pair have been received correctly.

Design this protocol:
*   Give **FSM descriptions** of sender and receiver.
*   Describe the **packet format(s)** used.
*   Show with a **timeline trace** how your protocol recovers from a lost packet.

---

### Solution

This protocol is a hybrid. It uses a window of size 2, but advances the window only when the entire window is acknowledged, which is more like Go-Back-N. However, it needs to buffer out-of-order packets at the receiver, which is a feature of Selective Repeat.

Let the sender's window base be `send_base`. The sender can send packets `send_base` and `send_base + 1`.

#### Packet Format

The packet format is standard for a reliable protocol.
`packet = { seq_num, data, checksum }`

The acknowledgment packet also needs to carry the sequence number of the packet it's acknowledging.
`ack_pkt = { ack_num, checksum }`

#### Sender FSM Description

The sender's logic revolves around sending a pair of packets and waiting for both ACKs before moving to the next pair.

**Variables:**
*   `send_base`: The sequence number of the first packet in the current pair.
*   `ack_status[]`: An array or map to track which packets in the pair have been ACKed (e.g., `ack_status[send_base] = false`, `ack_status[send_base+1] = false`).
*   A timer for each packet sent.

**States:**
1.  **Wait for Data Pair:**
    *   Waiting for the application to provide data for `send_base` and `send_base + 1`.
    *   Once both are available, send `pkt(send_base)` and `pkt(send_base + 1)`.
    *   Start timers for both packets.
    *   Set `ack_status` for both to `false`.
    *   Transition to `Wait for Both ACKs`.

2.  **Wait for Both ACKs:**
    *   **Event:** Receive `ACK(n)` where `send_base <= n <= send_base + 1`.
        *   **Action:** Mark `ack_status[n] = true`. Stop the timer for packet `n`.
        *   **Check:** If `ack_status[send_base]` and `ack_status[send_base+1]` are both `true`:
            *   Advance the window: `send_base = send_base + 2`.
            *   **Transition:** To `Wait for Data Pair`.
        *   **Else:** Stay in `Wait for Both ACKs`.
    *   **Event:** Timeout for packet `n`.
        *   **Action:** Retransmit `pkt(n)`. Restart the timer for packet `n`.
        *   **Transition:** Stay in `Wait for Both ACKs`.

#### Receiver FSM Description

The receiver needs to buffer out-of-order packets within the pair.

**Variables:**
*   `rcv_base`: The sequence number of the first packet in the pair it is expecting.
*   `buffer[]`: A buffer to hold an out-of-order packet.

**Logic (State is implicit):**
*   **Event:** Receive `pkt(n)`.
    *   **If `n == rcv_base` (the expected in-order packet):**
        1.  Send `ACK(n)`.
        2.  Deliver `pkt(n)`'s data to the application.
        3.  Check if `pkt(rcv_base + 1)` is in the buffer.
        4.  If yes, deliver its data, clear the buffer, and advance the base: `rcv_base = rcv_base + 2`.
        5.  If no, simply advance the expectation: `rcv_base` is now effectively `rcv_base + 1` (conceptually, we are now waiting for the second packet of the pair).
    *   **If `n == rcv_base + 1` (the out-of-order packet):**
        1.  Send `ACK(n)`.
        2.  Buffer `pkt(n)`. Do not deliver to the application yet.
    *   **If `n < rcv_base` (a duplicate from a previous pair):**
        1.  Send `ACK(n)`. (This is crucial to stop sender retransmissions).
    *   **Otherwise:** Ignore the packet.

#### Timeline Trace (Recovery from Lost Packet)

**Scenario:** Sender sends `pkt0` and `pkt1`. `pkt0` is lost.

```
      SENDER                                     RECEIVER
      ------                                     --------

      [send_base=0]
      sends pkt0
      starts timer0
      sends pkt1
      starts timer1
         ----------------- pkt0 (lost) X ------------>

         -------------------- pkt1 ------------------->
                                                   [rcv_base=0]
                                                   rcv pkt1 (out of order)
                                                   sends ACK1
                                                   buffers pkt1
         <-------------------- ACK1 -------------------

      rcv ACK1
      marks pkt1 as ACKed
      // acks[0]=false, acks[1]=true. Does not advance window.

      ...timer0 for pkt0 expires!
      retransmits pkt0
      restarts timer0
         -------------------- pkt0 ------------------->
                                                   [rcv_base=0]
                                                   rcv pkt0 (now in order)
                                                   sends ACK0
                                                   delivers data from pkt0
                                                   // checks buffer for pkt1
                                                   delivers data from pkt1
                                                   // both delivered, advance base
                                                   // rcv_base becomes 2
         <-------------------- ACK0 -------------------

      rcv ACK0
      marks pkt0 as ACKed
      // acks[0]=true, acks[1]=true. Both ACKed.
      advances window: send_base becomes 2
      // Ready to send pkt2 and pkt3.
```

The protocol successfully recovers. The receiver's buffering prevents `pkt1` from being delivered early, and the sender's individual timers ensure that only the lost packet (`pkt0`) is retransmitted.

## P19. Reliable Broadcast: A → B & C

Host A wants to send packets to Hosts B and C via a **broadcast channel** that can lose or corrupt packets independently. Design a **stop-and-wait-like** protocol for reliable transfer so that A will not send new data until both B and C acknowledge the current packet.

Give FSMs for A and C (FSM for B is same as C) and describe packet format(s).

---

### Solution

This is a variation of the alternating-bit protocol (`rdt3.0`) where the sender must collect ACKs from multiple receivers before proceeding.

#### Packet Formats

*   **Data Packet (from A):** `pkt = {seq_num, data, checksum}`. `seq_num` will be 0 or 1.
*   **ACK Packet (from B or C):** `ack = {ack_num, checksum}`. `ack_num` will be 0 or 1.

#### Sender (A) FSM

The sender needs to track ACKs from both B and C for the current packet.

**Variables:**
*   `seq`: Current sequence number (0 or 1).
*   `ack_B_received`: Boolean flag for ACK from B.
*   `ack_C_received`: Boolean flag for ACK from C.

**States:**
1.  **Wait for Call:** Waiting for data from the application.
    *   **Event:** `rdt_send(data)`.
    *   **Action:**
        *   `pkt = make_pkt(seq, data, checksum)`.
        *   `udt_send(pkt)` (broadcast).
        *   Start a timer.
        *   Reset flags: `ack_B_received = false`, `ack_C_received = false`.
    *   **Transition:** To `Wait for ACK from B and C`.

2.  **Wait for ACK from B and C:**
    *   **Event:** Receive a non-corrupt `ACK` with `ack_num == seq` from **Host B**.
        *   **Action:** `ack_B_received = true`.
        *   **Check:** If `ack_C_received` is also `true`:
            *   Stop the timer.
            *   Flip sequence number: `seq = 1 - seq`.
            *   **Transition:** To `Wait for Call`.
        *   **Else:** Stay in this state.
    *   **Event:** Receive a non-corrupt `ACK` with `ack_num == seq` from **Host C**.
        *   **Action:** `ack_C_received = true`.
        *   **Check:** If `ack_B_received` is also `true`:
            *   Stop the timer.
            *   Flip sequence number: `seq = 1 - seq`.
            *   **Transition:** To `Wait for Call`.
        *   **Else:** Stay in this state.
    *   **Event:** Receive a corrupt ACK or an ACK with the wrong sequence number.
        *   **Action:** Ignore.
        *   **Transition:** Stay in this state.
    *   **Event:** Timeout.
        *   **Action:** Retransmit the packet: `udt_send(pkt)`. Restart the timer.
        *   **Transition:** Stay in this state.

#### Receiver (C) FSM (B is identical)

The receiver FSM is exactly the same as the standard `rdt3.0` receiver. It doesn't know or care that other receivers exist.

**Variables:**
*   `expected_seq`: The sequence number it is waiting for (0 or 1).

**States:**
1.  **Wait for 0 from below:**
    *   **Event:** Receive a non-corrupt `pkt` with `seq_num == 0`.
        *   **Action:** `deliver_data(data)`, `ack = make_pkt(ACK, 0, checksum)`, `udt_send(ack)`.
        *   `expected_seq = 1`.
    *   **Event:** Receive a corrupt `pkt` or a `pkt` with `seq_num == 1`.
        *   **Action:** It's a duplicate or corrupt. Re-send the last ACK: `ack = make_pkt(ACK, 1, checksum)`, `udt_send(ack)`.

2.  **Wait for 1 from below:**
    *   **Event:** Receive a non-corrupt `pkt` with `seq_num == 1`.
        *   **Action:** `deliver_data(data)`, `ack = make_pkt(ACK, 1, checksum)`, `udt_send(ack)`.
        *   `expected_seq = 0`.
    *   **Event:** Receive a corrupt `pkt` or a `pkt` with `seq_num == 0`.
        *   **Action:** Re-send the last ACK: `ack = make_pkt(ACK, 0, checksum)`, `udt_send(ack)`.

This design ensures A only moves on when it's confident both B and C have received the data, handling both packet loss (via timeout) and duplicate packets (via sequence numbers).

## P20. Alternating Delivery at Receiver C

Hosts A and B send messages to Host C over **independent unreliable channels**. C must deliver data alternately: first from A, then from B, then A, etc. Design a **stop-and-wait-like** protocol ensuring reliable transfer and alternating delivery. Provide FSMs for A and C and packet format(s).

---

### Solution

This protocol requires C to act as a controller, only accepting a packet from A when it's A's turn, and from B when it's B's turn. The senders (A and B) will behave like standard `rdt3.0` senders. The complexity is entirely within C's FSM.

#### Packet Formats

*   **Data Packet (from A or B):** `pkt = {seq_num, data, checksum}`. `seq_num` is 0 or 1.
*   **ACK Packet (from C):** `ack = {ack_num, checksum}`. `ack_num` is 0 or 1.

#### Sender (A) FSM

The FSM for sender A is the standard **`rdt3.0` sender FSM**. It sends a packet with an alternating sequence number (0, 1, 0, 1, ...) and waits for a corresponding ACK. If it times out or receives a bad ACK, it retransmits. It has no knowledge of Host B or the alternating delivery requirement. The FSM for B is identical.

#### Receiver (C) FSM

C's FSM needs four states to track both the expected sequence number *and* the expected source.

**States:**
1.  **Wait for pkt0 from A:** C is ready for the next packet from A (seq 0).
2.  **Wait for pkt0 from B:** C has received from A, now ready for B (seq 0).
3.  **Wait for pkt1 from A:** C has received from B, now ready for A (seq 1).
4.  **Wait for pkt1 from B:** C has received from A, now ready for B (seq 1).

*(Initial State: `Wait for pkt0 from A`)*

**State: `Wait for pkt0 from A`**
*   **Event:** Receive non-corrupt `pkt0` **from A**.
    *   **Action:** Deliver data, send `ACK0` to A.
    *   **Transition:** To `Wait for pkt0 from B`.
*   **Event:** Receive any packet **from B**.
    *   **Action:** It's not B's turn. Send the last ACK sent to B (e.g., `ACK1` if the last successful packet from B was `pkt1`). This tells B its packet was received and it should move on, but C doesn't deliver the data.
    *   **Transition:** Stay in this state.
*   **Event:** Receive corrupt packet or duplicate `pkt1` from A.
    *   **Action:** Send `ACK1` to A.
    *   **Transition:** Stay in this state.

**State: `Wait for pkt0 from B`**
*   **Event:** Receive non-corrupt `pkt0` **from B**.
    *   **Action:** Deliver data, send `ACK0` to B.
    *   **Transition:** To `Wait for pkt1 from A`.
*   **Event:** Receive any packet **from A**.
    *   **Action:** It's not A's turn. Send the last ACK sent to A (`ACK0`).
    *   **Transition:** Stay in this state.
*   **Event:** Receive corrupt packet or duplicate `pkt1` from B.
    *   **Action:** Send `ACK1` to B.
    *   **Transition:** Stay in this state.

*(The logic for `Wait for pkt1 from A` and `Wait for pkt1 from B` is symmetrical, just with the sequence numbers flipped.)*

This design correctly enforces reliable, in-order, alternating delivery. C simply ignores data from the sender whose turn it isn't, while still acknowledging it to prevent the sender from retransmitting forever.

## P21. Request–Data Protocol

Host A requests data from Host B using R (Request) messages. B replies with D (Data) messages only upon receiving R. R messages can be lost; D messages are always delivered correctly. Design a protocol (FSM) that ensures A delivers **exactly one copy** of each D message to its upper layer. Use only the mechanisms necessary.

---

### Solution

The challenge is that A's Request (R) messages can be lost. If A sends R, doesn't get a reply, and sends R again, it might receive two copies of the corresponding Data (D) message from B. A must be able to distinguish a new D message from a retransmitted one.

The key mechanism needed is a **sequence number for the requests**.

#### Protocol Design

*   A will send requests `R0, R1, R0, R1, ...`
*   B will reply with data `D0, D1, D0, D1, ...` where `Di` is the data corresponding to request `Ri`.
*   Since D messages are never lost or corrupted, B doesn't need a complex FSM. It just replies to whatever request it receives.
*   A needs an FSM to handle timeouts on its requests and to identify duplicate data packets.

#### FSM for Host A

**Variables:**
*   `seq`: The sequence number for the next request to send (0 or 1).

**States:**
1.  **Wait for Call from Above:** Ready to send a new request.
    *   **Event:** `rdt_send(request_data)`.
    *   **Action:**
        *   `pkt = make_pkt(R, seq, request_data)`.
        *   `udt_send(pkt)`.
        *   Start a timer.
    *   **Transition:** To `Wait for Data`.

2.  **Wait for Data:** Waiting for the data packet `D` with the matching sequence number.
    *   **Event:** Receive `D` packet with `seq_num == seq`.
    *   **Action:**
        *   Stop the timer.
        *   `deliver_data(data)`.
        *   Flip sequence number: `seq = 1 - seq`.
    *   **Transition:** To `Wait for Call from Above`.
    *   **Event:** Receive `D` packet with `seq_num != seq`.
    *   **Action:** This is a duplicate response to a previous request. Discard the data.
    *   **Transition:** Stay in this state.
    *   **Event:** Timeout.
    *   **Action:** The request `R` was likely lost. Retransmit it.
        *   `udt_send(pkt)`.
        *   Restart the timer.
    *   **Transition:** Stay in this state.

This FSM ensures "exactly once" delivery. The sequence number allows A to identify and discard duplicate data packets resulting from retransmitted requests.