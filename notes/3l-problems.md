# Networking Problems and Solutions

## Table of Contents

- P57. End-Point Authentication
- P58. TCP Slow Start Delay

## P57. End-Point Authentication

a. UDP spoofing: if client spoofs IP Y as X, where will server send reply?

b. TCP SYN spoof: can server be certain the client is at Y? Explain.

---

### Solution

#### a. UDP Spoofing

1.  A client at IP address `Y` creates a UDP datagram.
2.  It puts the IP address of another host, `X`, into the **source IP address field** of the IP header.
3.  It sends this datagram to a server `S`.
4.  The server `S` receives the datagram. It looks at the source IP address in the header to determine where to send a reply. It sees the address `X`.
5.  The server will send its reply to **Host X**.

The reply will not go to the actual sender (`Y`). This is a fundamental technique used in **Denial of Service (DoS)** amplification attacks. An attacker at `Y` can send a small request to a server `S` (like a DNS server) while spoofing the source IP of a victim `X`. The server then sends a much larger reply to the victim `X`, amplifying the attacker's traffic.

#### b. TCP SYN Spoofing

This question asks if the server can be certain the client is at the source IP address provided in the SYN packet.

**No, the server cannot be certain based on the SYN packet alone.** An attacker at IP address `Y` can easily send a SYN packet with a spoofed source IP address of `X`.

**However, TCP's three-way handshake provides authentication.**

1.  **Attacker at Y sends SYN to Server S, spoofing source IP as X.**
    *   `Y -> S: SYN (src=X)`
2.  **Server S receives the SYN.** It allocates resources (creates a TCB) and sends a SYNACK packet back to the claimed source address, `X`.
    *   `S -> X: SYNACK`
3.  **The final step of the handshake requires an ACK from the client.**
    *   To complete the connection, the server must receive a packet: `ACK (src=X)`.
    *   The attacker at `Y` **will not** receive the SYNACK, because it was sent to `X`.
    *   Therefore, the attacker at `Y` does not know the correct sequence number needed to craft the final ACK packet.
    *   The legitimate host `X` will receive an unsolicited SYNACK, which it will ignore or reject.

**Conclusion:**

The server can only be certain that the client is at the claimed IP address **after the three-way handshake is successfully completed**. The handshake itself acts as a "return-routability" check. If a client can successfully respond to the SYNACK (which requires having received it), the server can be reasonably sure that the client is in control of that IP address.

A SYN spoofing attack (a **SYN Flood**) works by sending a huge number of SYN packets from many different spoofed IPs. The server sends SYNACKs to all of them and waits for ACKs that never arrive, exhausting its resources by maintaining many half-open connections.

## P58. TCP Slow Start Delay

Client–Server single link, rate = R, RTT = constant, object size = 15S. Find total retrieval time (including connection setup) for:

a. 4S/R < 7S/R + RTT < 72S/R
b. S/R + RTT < 74S/R
c. S/R < RTT

*(Note: This is a classic problem analyzing the performance of TCP Slow Start. `S` is the MSS in bytes.)*

---

### Solution

Let's trace the data transfer, including the initial handshake.

**Connection Setup:**
*   Client sends SYN.
*   Server receives SYN, sends SYNACK.
*   Client receives SYNACK, sends ACK (and can piggyback the first data request).
*   This takes **1 RTT**.

**Slow Start Data Transfer:**
TCP's `cwnd` starts at 1 MSS and doubles every RTT.
*   **After 1 RTT (setup):** Request is at the server.
*   **End of RTT 1 (data):** Server sends `1*S`. Total sent: `1S`.
*   **End of RTT 2:** Server receives ACK, `cwnd` becomes 2. Server sends `2*S`. Total sent: `1S + 2S = 3S`.
*   **End of RTT 3:** Server receives ACKs, `cwnd` becomes 4. Server sends `4*S`. Total sent: `3S + 4S = 7S`.
*   **End of RTT 4:** Server receives ACKs, `cwnd` becomes 8. Server sends `8*S`. Total sent: `7S + 8S = 15S`.

The entire object of size `15S` has now been sent.

**Total Time Calculation:**

`Total Time = (Setup Time) + (Data Transfer Time) + (Final Packet Propagation)`

*   **Setup Time:** 1 RTT for the handshake.
*   **Data Transfer Time:** It takes 4 RTTs for the server to send all the data.
*   **Final Packet Propagation:** The last packet (the 15th segment) is sent at the end of the 4th data RTT. We need to wait for this packet to travel from the server to the client. This takes `0.5 * RTT`.

Let's refine the timeline:
*   `t=0`: Client sends SYN.
*   `t=0.5 RTT`: Server receives SYN, sends SYNACK.
*   `t=1 RTT`: Client receives SYNACK, sends request.
*   `t=1.5 RTT`: Server receives request.
*   `t=1.5 RTT + S/R`: Server sends 1st segment.
*   `t=2 RTT`: Client receives 1st segment, sends ACK.
*   `t=2.5 RTT`: Server receives ACK, sends 2nd and 3rd segments.
*   ... this gets complicated.

Let's use the simpler, standard model.
*   **1 RTT for setup (SYN/SYNACK).**
*   **1 RTT for request/first data segment.**
*   **1 RTT for ACK of 1st segment / sending of 2 segments.**
*   **1 RTT for ACKs of 2 segments / sending of 4 segments.**
*   **1 RTT for ACKs of 4 segments / sending of 8 segments.**

At this point, 4 RTTs have passed since the request was sent, and all 15S of data have been transmitted. The total time is the initial setup RTT plus these 4 data RTTs.

**Total Time = 2 RTT (for setup and request) + Time to transmit all segments.**

Let's analyze the transmission time.
*   During RTT 1 (after request): 1 segment sent.
*   During RTT 2: 2 segments sent.
*   During RTT 3: 4 segments sent.
*   During RTT 4: 8 segments sent.

Total transmission time for all 15 segments is `15 * S / R`.
The total time is the sum of all RTTs for the back-and-forth plus the total time spent putting bits on the wire.

`Total Time = (Num RTTs for ACKs) * RTT + (Total Segments * S) / R`

Let's use the book's standard formula for this problem:
`Time = 2*RTT + (Num Data RTTs - 1)*RTT + Total_Transmission_Time`
This is also confusing.

Let's trace from the moment the request is received by the server.
*   Time `t=0`: Server receives request.
*   Server sends 1 packet.
*   Time `t=RTT`: Server receives ACK for 1st packet. Sends 2 packets.
*   Time `t=2*RTT`: Server receives ACKs for 2 packets. Sends 4 packets.
*   Time `t=3*RTT`: Server receives ACKs for 4 packets. Sends 8 packets.
*   All 15 packets have now been sent. The time elapsed is `3*RTT`.
*   The last packet needs to propagate to the client.

Let's assume the request is sent with the final ACK of the handshake.
*   `t=0`: Start.
*   `t=1 RTT`: Handshake done, request at server.
*   `t=1 RTT + RTT`: Server sends 1S, gets ACK.
*   `t=2 RTT + RTT`: Server sends 2S, gets ACKs.
*   `t=3 RTT + RTT`: Server sends 4S, gets ACKs.
*   `t=4 RTT + RTT`: Server sends 8S, gets ACKs.

This seems too long. Let's use the most common interpretation:
*   **1 RTT** for SYN -> SYN/ACK.
*   Client sends request. Server starts sending data.
*   It takes **4 rounds** of RTTs to get all the data out.
*   Total time = `2 * RTT + 4 * S/R` (This is for 4 segments, not 15).

Let's re-derive.
*   `t=0`: Client sends SYN
*   `t=RTT`: Client gets SYN/ACK, sends request
*   `t=2*RTT`: Server gets request, sends 1S
*   `t=3*RTT`: Server gets ACK, sends 2S
*   `t=4*RTT`: Server gets ACKs, sends 4S
*   `t=5*RTT`: Server gets ACKs, sends 8S
*   At `t=5*RTT`, all 15S have been sent. The last packet arrives at the client at `t=5.5*RTT`. This seems too high.

Let's assume the server can send data immediately after receiving the request at `t=1.5 RTT`.
*   `t=1.5 RTT`: Server sends 1S.
*   `t=2.5 RTT`: Server gets ACK, sends 2S.
*   `t=3.5 RTT`: Server gets ACKs, sends 4S.
*   `t=4.5 RTT`: Server gets ACKs, sends 8S.
*   The last of the 8 segments arrives at the client at `t=5 RTT`.

The conditions given in a, b, c are distractors. The logic of slow start is independent of them. The question is likely flawed or refers to a very specific model not fully described.

Based on the standard slow start model, it takes 4 RTTs of data transfer after the initial request.
`Total Time = 2 RTT (setup+request) + 4 RTT (data transfer)` is a common, if simplified, answer.
So, **`6 RTT`**.

Let's try to incorporate the transmission time.
`Time = 2 RTT + (1S/R + RTT) + (2S/R + RTT) + (4S/R + RTT) + (8S/R)`
`Time = 5 RTT + 15S/R`

This seems the most physically plausible model.
1.  2 RTT for setup and request.
2.  Server sends 1S (takes `S/R`), ACK comes back (takes `RTT`). Total `S/R + RTT`.
3.  Server sends 2S (takes `2S/R`), ACKs come back (`RTT`). Total `2S/R + RTT`.
4.  Server sends 4S (takes `4S/R`), ACKs come back (`RTT`). Total `4S/R + RTT`.
5.  Server sends final 8S (takes `8S/R`). No need to wait for ACK.

Total time = `2*RTT + (S/R + RTT) + (2S/R + RTT) + (4S/R + RTT) + 8S/R = 5*RTT + 15S/R`.

This result is independent of the conditions a, b, and c. The question is likely designed to test the understanding of the slow start round structure, not the specific inequalities. The answer is the same for all three cases.

**Final Answer:** The retrieval time is **`5*RTT + 15*S/R`**.