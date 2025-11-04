# Computer Networking: Comprehensive Problem Solutions - Part 5

Welcome to Part 5 of the comprehensive guide for Computer Networking problems. This document contains detailed, step-by-step solutions for problems P21 through P25, covering fundamental concepts in network throughput, packet loss, inter-arrival times, data transfer comparisons, and bandwidth-delay products.

## Table of Contents

- [P21: Throughput with M Paths](#p21-throughput-with-m-paths)
- [P22: Packet Loss Probability](#p22-packet-loss-probability)
- [P23: Packet Inter-Arrival Time](#p23-packet-inter-arrival-time)
- [P24: Data Transfer Comparison](#p24-data-transfer-comparison)
- [P25: Bandwidth-Delay Product](#p25-bandwidth-delay-product)

---

## P21: Throughput with M Paths

**Problem:** Consider Figure 1.19(b). Now suppose that there are M paths between the server and the client. No two paths share any link. Path k (k =1, c, M) consists of N links with transmission rates Rk1, Rk2, c, RkN. If the server can only use one path to send data to the client, what is the maximum throughput that the server can achieve? If the server can use all M paths to send data, what is the maximum throughput that the server can achieve?

### Solution Steps

**Step 1: Understanding the Network Topology**
Figure 1.19(b) shows a server connected to a client through multiple parallel paths. Each path consists of N links with different transmission rates. No two paths share any links, so they provide completely independent routes.

**Network Elements:**
- **Server link:** Rs (server's connection capacity)
- **Client link:** Rc (client's connection capacity)
- **M paths:** Each path k has N links with rates Rk1, Rk2, ..., RkN
- **Path bottleneck:** Each path's capacity is limited by its slowest link: min(Rk1, Rk2, ..., RkN)

**Step 2: Single Path Throughput (Part 1)**
If the server can only use one path to send data:

**Throughput = min(Rs, Rc, min(Rk))**

Where min(Rk) is the minimum link rate on path k.

**Explanation:**
- **Server limit (Rs):** Server can't send faster than its link allows
- **Client limit (Rc):** Client can't receive faster than its link allows
- **Path limit (min(Rk)):** Path can't carry data faster than its slowest link

**Step 3: Multiple Path Throughput (Part 2)**
If the server can use all M paths simultaneously:

**Throughput = min(Rs, Rc, ∑ min(Rk))**

Where ∑ min(Rk) is the sum of the minimum link rates across all paths.

**Explanation:**
- **Server limit (Rs):** Server's total capacity across all paths
- **Client limit (Rc):** Client's total receiving capacity
- **Total path capacity (∑ min(Rk)):** Combined capacity of all paths

**Step 4: Detailed Analysis**

**Single Path Scenario:**
- Server sends all data through one path
- Throughput limited by that path's bottleneck
- Other paths remain unused

**Multiple Path Scenario:**
- Server can split traffic across all M paths
- Each path contributes its bottleneck capacity
- Total throughput is sum of individual path throughputs
- Limited by server/client total capacity

**Step 5: Example Calculations**

**Example:** M = 3 paths, each with different bottleneck rates
- Path 1: min(R11,R12,...,R1N) = 10 Mbps
- Path 2: min(R21,R22,...,R2N) = 15 Mbps
- Path 3: min(R31,R32,...,R3N) = 20 Mbps
- Rs = 50 Mbps, Rc = 40 Mbps

**Single Path:** max throughput = min(50, 40, 20) = 20 Mbps (using best path)

**Multiple Paths:** max throughput = min(50, 40, 10+15+20) = min(50, 40, 45) = 40 Mbps

**Step 6: Key Insights**

**Path Diversity Benefits:**
- Multiple paths provide redundancy
- Allow load balancing for higher throughput
- Improve reliability (if one path fails)

**Bottleneck Analysis:**
- Each path's capacity determined by slowest link
- Total capacity is sum of individual path capacities
- End-system capacities may still limit overall throughput

**Step 7: Real-World Applications**
- **Multi-homing:** Servers connected via multiple ISPs
- **Load balancing:** Distributing traffic across multiple paths
- **CDN networks:** Multiple routes to content delivery
- **MPLS networks:** Traffic engineering with multiple paths

**Step 8: Practical Considerations**
- **Path selection:** Choose paths with highest min(Rk) for single path
- **Traffic splitting:** Need mechanisms to distribute load across paths
- **Path independence:** No shared bottlenecks between paths
- **Synchronization:** Coordinating data across multiple paths

This analysis shows how network topology design and path diversity can significantly improve throughput and reliability.

---

## P22: Packet Loss Probability

**Problem:** Consider Figure 1.19(b). Suppose that each link between the server and the client has a packet loss probability p, and the packet loss probabilities for these links are independent. What is the probability that a packet (sent by the server) is successfully received by the receiver? If a packet is lost in the path from the server to the client, then the server will re-transmit the packet. On average, how many times will the server re-transmit the packet in order for the client to successfully receive the packet?

### Solution Steps

**Step 1: Understanding Packet Loss in Networks**
Figure 1.19(b) shows a path from server to client with multiple links. The problem assumes each link in the path has an independent packet loss probability p. This means each link drops packets randomly with probability p, and link failures are independent.

**Step 2: Calculating Success Probability**
For a packet to successfully reach the client, it must survive all links in the path. Since each link has independent loss probability p, the probability that a packet passes through all links is:

**(1 - p) × (1 - p) × ... × (1 - p)** = (1 - p)^k

Where k is the number of links in the path.

**Success Probability = (1 - p)^k**

But the problem simplifies this to **1 - p**, suggesting k = 1 or they're considering the effective loss probability.

Looking at the context, they might be considering the path as having an overall loss probability p, so success probability is 1 - p.

**Step 3: Understanding Retransmission**
When a packet is lost, the server retransmits it. The process continues until the packet successfully reaches the client.

**Step 4: Calculating Average Retransmissions**
This is a geometric distribution problem. Each transmission attempt has:
- Success probability: 1 - p
- Failure probability: p

**Average retransmissions = p / (1 - p)**

**Explanation:**
- The first transmission succeeds with probability (1-p)
- If it fails, we retransmit, and this continues until success
- The expected number of attempts is 1 / (1-p)
- So expected retransmissions = [1 / (1-p)] - 1 = p / (1-p)

**Step 5: Detailed Analysis**

**Transmission Attempts:**
- Attempt 1: Success probability (1-p), Retransmissions = 0
- Attempt 2: Failure on 1, success on 2: p × (1-p), Retransmissions = 1
- Attempt 3: Failure on 1&2, success on 3: p² × (1-p), Retransmissions = 2
- And so on...

**Expected Retransmissions = ∑ [k × p^k × (1-p)] for k=0 to ∞**
**= (1-p) × ∑ (k × p^k) for k=0 to ∞**
**= (1-p) × p/(1-p)² = p/(1-p)**

Yes, matches the formula.

**Step 6: Real-World Implications**

**Impact of Loss Probability:**
- p = 0.01 (1% loss): Average retransmissions ≈ 0.01
- p = 0.1 (10% loss): Average retransmissions ≈ 0.11
- p = 0.5 (50% loss): Average retransmissions ≈ 1

**Performance Impact:**
- Higher loss rates dramatically increase retransmissions
- Each retransmission adds delay and consumes bandwidth
- TCP congestion control amplifies these effects

**Step 7: Network Design Considerations**
- **Error recovery:** Protocols need retransmission mechanisms
- **Forward error correction:** Add redundancy to reduce effective loss
- **Path diversity:** Multiple paths can reduce loss correlation
- **Quality of Service:** Loss-sensitive applications need better paths

**Step 8: Key Insights**
- Even small loss probabilities require significant retransmission overhead
- Independent link losses compound along the path
- Retransmission strategies are essential for reliable data transfer

This analysis shows why reliable transport protocols like TCP include sophisticated loss recovery mechanisms.

---

## P23: Packet Inter-Arrival Time

**Problem:** Consider Figure 1.19(a). Assume that we know the bottleneck link along the path from the server to the client is the first link with rate Rs bits/sec. Suppose we send a pair of packets back to back from the server to the client, and there is no other traffic on this path. Assume each packet of size L bits, and both links have the same propagation delay dprop.
a. What is the packet inter-arrival time at the destination? That is, how much time elapses from when the last bit of the first packet arrives until the last bit of the second packet arrives?
b. Now assume that the second link is the bottleneck link (i.e., Rc < Rs). Is it possible that the second packet queues at the input queue of the second link? Explain. Now suppose that the server sends the second packet T seconds after sending the first packet. How large must T be to ensure no queuing before the second link? Explain.

### Solution Steps

**Step 1: Understanding the Network Setup**
Figure 1.19(a) shows a simple two-link path: Server → Link 1 (Rs) → Router → Link 2 (Rc) → Client. The server sends two packets back-to-back (one right after the other) with no other traffic on the path. Each packet has size L bits.

**Key Assumption:** The first link (Rs) is the bottleneck, meaning Rs < Rc.

**Step 2: Analyzing Inter-Arrival Time at Destination (Part a)**
**Inter-arrival time** is the time between when the last bit of the first packet arrives at the client and when the last bit of the second packet arrives.

**First Packet Journey:**
- Starts transmission at t = 0
- Takes L/Rs to transmit on first link
- Takes L/Rs + d_prop to arrive at router (ignoring propagation for simplicity)
- Takes additional L/Rc to transmit on second link
- Total time for first packet: L/Rs + L/Rc

**Second Packet Journey:**
- Starts transmission immediately after first packet (at t = L/Rs)
- Takes L/Rs to transmit on first link
- Arrives at router at t = L/Rs + L/Rs = 2×(L/Rs)
- Takes L/Rc to transmit on second link
- Arrives at client at t = 2×(L/Rs) + L/Rc

**Inter-Arrival Time = Arrival of second - Arrival of first**
**= [2×(L/Rs) + L/Rc] - [L/Rs + L/Rc] = L/Rs**

Since Rs is the bottleneck (Rs < Rc), the second packet catches up to the first packet on the second link.

**Step 3: Understanding Packet Spacing (Part b)**
The question asks whether the second packet can queue at the input of the second link, and how large the spacing T must be to prevent queuing.

**Scenario Analysis:**
- If Rc < Rs (second link is bottleneck), then the second link is slower
- The second packet might arrive at the router before the first packet has finished transmitting on the second link
- This would cause the second packet to queue

**Minimum Spacing T:**
To prevent queuing, the second packet should arrive at the router only after the first packet has completely left the second link.

**Time for first packet to clear second link:** L/Rc
**Second packet starts at:** T
**Second packet arrives at router:** T + L/Rs

**Condition for no queuing:** T + L/Rs ≥ L/Rc
**Minimum T = L/Rc - L/Rs**

Since Rc < Rs (second link bottleneck), L/Rc > L/Rs, so T > 0.

**Step 4: Key Insights**

**Bottleneck Effects:**
- When the first link is faster (Rs > Rc), packets bunch up at the slower second link
- This causes queuing and increased delays
- The spacing between packets changes as they traverse the network

**Traffic Shaping:**
- Proper spacing (T) can prevent unnecessary queuing
- This is important for real-time traffic like VoIP
- Network protocols use pacing to control packet spacing

**Step 5: Real-World Applications**
- **TCP congestion control:** Prevents overwhelming slow links
- **Traffic engineering:** Ensures smooth flow through bottlenecks
- **Quality of Service:** Maintains delay bounds for sensitive applications

**Step 6: General Principle**
The inter-arrival time between packets changes as they pass through links of different speeds. Faster links cause packets to bunch up, while slower links spread them out. Understanding this is crucial for network performance analysis and protocol design.

---

## P24: Data Transfer Comparison

**Problem:** Suppose you would like to urgently deliver 50 terabytes data from Boston to Los Angeles. You have available a 100 Mbps dedicated link for data transfer. Would you prefer to transmit the data via this link or instead use FedEx overnight delivery? Explain.

### Solution Steps

**Step 1: Understanding the Data Transfer Challenge**
You have an urgent need to deliver 50 terabytes of data from Boston to Los Angeles. You have two options:
1. Use a dedicated 100 Mbps network link
2. Send it via FedEx overnight delivery

The question is which method is faster for such a large data transfer.

**Step 2: Calculating Network Transfer Time**
**Data Size:** 50 terabytes = 50 × 10^12 bytes = 400 × 10^12 bits (since 1 byte = 8 bits)

**Link Speed:** 100 Mbps = 100 × 10^6 bits/second

**Transfer Time = Data Size ÷ Link Speed**
**= 400 × 10^12 bits ÷ 100 × 10^6 bits/second**
**= 4 × 10^6 seconds**

**Convert to days:**
**4 × 10^6 seconds ÷ 86,400 seconds/day ≈ 46.3 days**

**Step 3: Comparing with FedEx**
FedEx overnight delivery takes approximately 1 day (24 hours) to go from Boston to Los Angeles.

**Comparison:**
- Network transfer: ~46 days
- FedEx delivery: 1 day

**FedEx is approximately 46 times faster!**

**Step 4: Understanding Why Network Transfer is Slow**
**Bandwidth Limitations:**
- 100 Mbps seems fast, but for huge data transfers, it's actually quite slow
- Compare: downloading a 1 GB movie takes ~80 seconds at 100 Mbps
- 50 TB is 50,000 GB - that's 50,000 movies!

**Real-World Context:**
- Typical home internet: 10-100 Mbps
- Even "fast" business connections: 100-1000 Mbps
- Large data centers use 10-100 Gbps links

**Step 5: Practical Considerations**

**Network Transfer Advantages:**
- No physical shipping required
- Can start immediately
- Automatic and reliable

**Network Transfer Disadvantages:**
- Very slow for massive data
- Requires continuous connection
- Cost accumulates over time

**FedEx Advantages:**
- Extremely fast for physical media
- No technical setup required
- Reliable delivery guarantee

**FedEx Disadvantages:**
- Requires data to be copied to physical media
- Shipping costs
- Security concerns with physical transport

**Step 6: Modern Alternatives**
Today, there are better options than the original 100 Mbps link:

**High-Speed Networks:**
- 10 Gbps links: ~5 days for 50 TB
- 100 Gbps links: ~12 hours for 50 TB

**Cloud Services:**
- AWS Snowball/Snowmobile: Physical devices for large transfers
- Azure Data Box: Similar service
- Google Transfer Appliance: High-capacity transfer devices

**Step 7: Key Insights**
- **Scale matters:** What seems fast for small transfers is slow for large ones
- **Physical shipping** can be faster than slow networks for huge data
- **Technology evolution:** Network speeds have improved dramatically
- **Hybrid approaches:** Often combine network and physical transfer

This problem illustrates that while networks are essential for most data transfer needs, physical shipping can sometimes be the fastest option for extremely large data sets.

---

## P25: Bandwidth-Delay Product

**Problem:** Suppose two hosts, A and B, are separated by 20,000 kilometers and are connected by a direct link of R = 5 Mbps. Suppose the propagation speed over the link is 2.5 × 10^8 meters/sec.
a. Calculate the bandwidth-delay product, R × dprop.
b. Consider sending a file of 800,000 bits from Host A to Host B. Suppose the file is sent continuously as one large message. What is the maximum number of bits that will be in the link at any given time?
c. Provide an interpretation of the bandwidth-delay product.
d. What is the width (in meters) of a bit in the link? Is it longer than a football field?
e. Derive a general expression for the width of a bit in terms of the propagation speed s, the transmission rate R, and the length of the link m.

### Solution Steps

**Step 1: Understanding Bandwidth-Delay Product**
The bandwidth-delay product (BDP) is a fundamental concept in networking that tells us how much data can be "in flight" on a link at any given time. It's calculated as:

**BDP = Bandwidth × Delay**

Where:
- Bandwidth (R) = link capacity (bits/second)
- Delay (d) = round-trip propagation delay (seconds)

**Step 2: Given Parameters**
- Distance: 20,000 km between hosts
- Link speed: R = 5 Mbps = 5 × 10^6 bits/second
- Propagation speed: s = 2.5 × 10^8 m/s (speed of light in fiber)

**Step 3: Calculating Propagation Delay (Part a)**
First, we need the one-way propagation delay:

**Distance = 20,000 km = 20,000,000 meters**

**Propagation delay (d_prop) = Distance ÷ Speed**
**= 20,000,000 m ÷ 2.5 × 10^8 m/s**
**= 0.08 seconds = 80 ms**

**BDP = R × d_prop**
**= 5 × 10^6 bits/s × 0.08 s**
**= 400,000 bits**
**= 50,000 bytes** (since 400,000 ÷ 8 = 50,000)

**Step 4: Maximum Bits in Transit (Part b)**
When sending a continuous stream of data, the maximum number of bits that can be "in the pipe" at any time is exactly the bandwidth-delay product.

For a file of 800,000 bits:
- This is larger than the BDP (400,000 bits)
- So maximum bits in transit = BDP = 400,000 bits = 50,000 bytes

**Step 5: Interpretation of Bandwidth-Delay Product (Part c)**
The BDP represents the maximum amount of unacknowledged data that can be in transit on a link.

**Why it matters:**
- **TCP performance:** TCP can send up to BDP worth of data before needing acknowledgments
- **Buffer sizing:** Network devices need buffers at least as large as BDP
- **Link utilization:** Determines how efficiently high-bandwidth, high-delay links can be used

**Step 6: Bit Width Calculation (Part d)**
The "width" of a bit is how much physical distance it occupies on the link.

**Bit width = Propagation speed ÷ Bandwidth**
**= s ÷ R**
**= 2.5 × 10^8 m/s ÷ 5 × 10^6 bits/s**
**= 50 meters per bit**

**Comparison to football field:** A football field is about 100 meters, so one bit spans half a football field!

**Step 7: General Expression (Part e)**
**Bit width = s / R meters**

Where:
- s = propagation speed (m/s)
- R = link bandwidth (bits/s)

**Step 8: Key Insights**

**High BDP Links:**
- Long-distance links (satellite, transoceanic cables)
- High-speed links (10Gbps+)
- Require large buffers and window sizes

**Performance Implications:**
- **TCP window size:** Should be at least BDP for full link utilization
- **Latency impact:** High delay links need large windows to maintain throughput
- **Buffer requirements:** Network equipment must handle BDP-sized bursts

**Step 9: Real-World Examples**
- **Geostationary satellite:** 250ms delay × 10Mbps = 312.5 KB BDP
- **Transatlantic cable:** 50ms delay × 10Gbps = 62.5 MB BDP
- **Local Ethernet:** 0.1ms delay × 1Gbps = 12.5 KB BDP

**Step 10: Practical Applications**
- **Network design:** Determining buffer sizes and TCP parameters
- **Performance tuning:** Optimizing protocols for different link characteristics
- **Quality of Service:** Understanding delay-bandwidth tradeoffs

This concept is crucial for understanding why some links perform better than others and how to optimize network protocols for different environments.

---

## Conclusion

You've completed Part 5 of the comprehensive guide for Computer Networking problems. These solutions cover fundamental concepts in network throughput with multiple paths, packet loss probabilities, packet inter-arrival times, data transfer comparisons, and bandwidth-delay products.