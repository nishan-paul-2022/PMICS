# Computer Networking: Comprehensive Problem Solutions - Part 2

Welcome to Part 2 of the comprehensive guide for Computer Networking problems. This document contains detailed, step-by-step solutions for problems P6 through P10, covering fundamental concepts in delays, switching, and network performance.

## Table of Contents

- [P6: Propagation and Transmission Delay](#p6-propagation-and-transmission-delay)
- [P7: VoIP Delay](#p7-voip-delay)
- [P8: Circuit vs Packet Switching](#p8-circuit-vs-packet-switching)
- [P9: Packet Switching with 1 Gbps Link](#p9-packet-switching-with-1-gbps-link)
- [P10: End-to-End Delay](#p10-end-to-end-delay)

---

## P6: Propagation and Transmission Delay

**Problem:** Consider two hosts, A and B, connected by a single link of rate R bps. Suppose that the two hosts are separated by m meters, and suppose the propagation speed along the link is s meters/sec. Host A is to send a packet of size L bits to Host B.
a. Express the propagation delay, dprop, in terms of m and s.
b. Determine the transmission time of the packet, dtrans, in terms of L and R.
c. Ignoring processing and queuing delays, obtain an expression for the end-to-end delay.
d. Suppose Host A begins to transmit the packet at time t = 0. At time t = dtrans, where is the last bit of the packet?
e. Suppose dprop is greater than dtrans. At time t = dtrans, where is the first bit of the packet?
f. Suppose dprop is less than dtrans. At time t = dtrans, where is the first bit of the packet?
g. Suppose s =2.5 × 10^8, L =1500 bytes, and R =10 Mbps. Find the distance m so that dprop equals dtrans.

### Solution Steps

**Step 1: Understanding the Network Setup**
Imagine two computers, A and B, connected by a single cable (link) that can carry data at a rate of R bits per second. The computers are separated by a distance of m meters, and signals travel through this cable at a speed of s meters per second.

Host A wants to send a packet containing L bits of data to Host B. We need to understand the timing and positioning of this data as it travels through the network.

**Step 2: Calculating Propagation Delay (Part a)**
Propagation delay is the time it takes for a signal to travel from one end of the link to the other. It's determined purely by the physical distance and the speed at which signals travel.

**Formula:**
dprop = m/s

**Explanation:**

- m = distance between hosts (meters)
- s = propagation speed through the medium (meters/second)
- This is like calculating how long it takes to drive from one city to another at a given speed

**Step 3: Calculating Transmission Time (Part b)**
Transmission time is how long it takes to put all the bits of the packet onto the link. This depends on the packet size and the link's transmission rate.

**Formula:**
dtrans = L/R

**Explanation:**

- L = number of bits in the packet
- R = transmission rate of the link (bits/second)
- This is like calculating how long it takes to load a truck with cargo at a given loading rate

**Step 4: Calculating Total End-to-End Delay (Part c)**
The end-to-end delay is the total time from when the first bit starts transmitting until the last bit arrives at the destination. For a single link with no other delays, this is simply the sum of transmission and propagation delays.

**Formula:**
Delay = dtrans + dprop = L/R + m/s

**Explanation:**

- First, all L bits must be transmitted onto the link (takes L/R time)
- Then, the signal propagates the distance m at speed s (takes m/s time)
- Total time = transmission time + propagation time

**Step 5: Finding the Last Bit's Position at t = dtrans (Part d)**
At time t = dtrans, the transmission of the packet has just completed at Host A.

**Position of Last Bit:** Just leaving Host A

**Explanation:**

- At t = 0, transmission begins
- During the first dtrans seconds, all L bits are being transmitted
- At exactly t = dtrans, the last bit has just finished being transmitted and is leaving Host A
- The first bit is already dtrans meters down the link (traveling at speed s)

**Step 6: Finding the First Bit's Position at t = dtrans When dprop > dtrans (Part e)**
When propagation delay is longer than transmission time, the packet is "skinny" - it's shorter than the distance it needs to travel.

**Position of First Bit:** dtrans meters from Host B (or equivalently, m - dtrans meters from Host A)

**Explanation:**

- The first bit started traveling at t = 0
- After dtrans seconds, the first bit has traveled dtrans × s meters
- Since dprop > dtrans, the first bit hasn't reached Host B yet
- Distance from Host B = total distance - distance traveled = m - (dtrans × s)
- But dtrans × s = dtrans × (m/dprop) × (s/s) wait, let's calculate properly:
- Speed s = m/dprop, so distance traveled by first bit = dtrans × s = dtrans × (m/dprop)
- Since dprop > dtrans, dtrans/dprop < 1, so distance traveled = (dtrans/dprop) × m < m
- So first bit is dtrans meters from Host B

**Step 7: Finding the First Bit's Position at t = dtrans When dprop < dtrans (Part f)**
When transmission time is longer than propagation delay, the packet is "fat" - it's longer than the distance it needs to travel.

**Position of First Bit:** Already arrived at Host B; the last bit is (dtrans - dprop) meters from Host B

**Explanation:**

- The first bit reaches Host B after dprop seconds
- But transmission continues until dtrans seconds
- At t = dtrans, the first bit has been at Host B for (dtrans - dprop) seconds
- The last bit is still traveling and is dtrans meters from Host A, so it's (m - dtrans) meters from Host B
- Since dprop < dtrans, and speed is s = m/dprop, we can calculate: distance from Host B = m - (dtrans × s) = m - dtrans × (m/dprop) = m × (1 - dtrans/dprop) = m × (dprop - dtrans)/dprop
- So last bit is m × (dprop - dtrans)/dprop meters from Host B

**Step 8: Numerical Calculation for Specific Values (Part g)**
Given: s = 2.5 × 10^8 m/s, L = 1500 bytes = 12,000 bits, R = 10 Mbps = 10 × 10^6 bps

**First, calculate dtrans and dprop:**
dtrans = L/R = 12,000 / 10,000,000 = 0.0012 seconds = 1.2 ms
dprop = m/s, so we need to find m where dprop = dtrans

**Set dprop = dtrans:**
m/s = L/R
m = (L/R) × s = 0.0012 × 2.5 × 10^8 = 3 × 10^5 meters = 300 meters

**Step 9: Key Insights**

- **Transmission delay** depends on packet size and link speed
- **Propagation delay** depends on distance and signal speed
- The relative sizes of these delays determine how "spread out" the packet is on the link
- This understanding is crucial for analyzing network performance and designing protocols

---

## P7: VoIP Delay

**Problem:** Host A converts analog voice to a digital 64 kbps bit stream on the fly. Host A then groups the bits into 56-byte packets. There is one link between Hosts A and B; its transmission rate is 10 Mbps and its propagation delay is 10 msec. As soon as Host A gathers a packet, it sends it to Host B. As soon as Host B receives an entire packet, it converts the packet's bits to an analog signal. How much time elapses from the time a bit is created (from the original analog signal at Host A) until the bit is decoded (as part of the analog signal at Host B)?

### Solution Steps

**Step 1: Understanding VoIP (Voice over IP)**
VoIP stands for Voice over IP - it's technology that lets you make phone calls over the internet instead of traditional phone lines. The problem describes how Host A converts analog voice (regular sound waves) into digital data that can be sent over a network.

**Step 2: Understanding the Data Conversion Process**

- **Analog to Digital Conversion:** Host A takes continuous voice signals and converts them to digital format
- **Bit Rate:** The voice is digitized at 64 kbps (64,000 bits per second) - this is a standard rate for telephone-quality voice
- **Packetization:** The digital bits are grouped into packets of 56 bytes each for transmission

**Step 3: Calculating Packet Size in Bits**
First, we need to understand how big each packet is:

- Each packet contains 56 bytes of voice data
- 1 byte = 8 bits
- So packet size = 56 × 8 = 448 bits

**Step 4: Understanding the Network Path**

- Host A and Host B are connected by a single link
- Link transmission rate = 10 Mbps (10,000,000 bits per second)
- Propagation delay = 10 milliseconds (time for signal to travel from A to B)

**Step 5: Calculating Packetization Delay**
Packetization delay is the time it takes to collect enough bits to fill a complete packet before transmission can begin.

**Formula:** Packetization delay = Packet size ÷ Bit rate

**Calculation:**
Packetization delay = 448 bits ÷ 64,000 bits/second
= 0.007 seconds
= 7 milliseconds (ms)

**Step 6: Calculating Transmission Delay**
Transmission delay is the time to put the entire packet onto the link:

**Formula:** Transmission delay = Packet size ÷ Link transmission rate

**Calculation:**
Transmission delay = 448 bits ÷ 10,000,000 bits/second
= 448 ÷ 10,000,000 seconds
= 0.0000448 seconds
= 44.8 microseconds (μs)

**Step 7: Understanding Propagation Delay**
Propagation delay is given as 10 milliseconds. This is the time it takes for the signal to travel through the physical medium from Host A to Host B.

**Step 8: Calculating Total End-to-End Delay**
The total delay from bit creation to bit playback includes:

- **Packetization delay:** Time to fill the packet (7 ms)
- **Transmission delay:** Time to send the packet (0.0448 ms)
- **Propagation delay:** Time for the packet to travel to Host B (10 ms)

**Key Insight:** For a bit that arrives just as a packet is completed, it must wait for the packet to be transmitted and propagated before it can be decoded at Host B.

**Total Delay = Packetization delay + Transmission delay + Propagation delay**
**Total Delay = 7 + 0.0448 + 10 = 17.0448 ms ≈ 17 ms**

**Step 9: Why Packetization Delay Matters**
The packetization delay is often overlooked but is crucial in VoIP systems. Voice data arrives continuously, but packets can only be sent when they are full. This introduces a waiting time that depends on the packet size and the data arrival rate.

**Step 10: Real-World Implications**
This calculation shows why VoIP calls can have delays:

- **Local calls:** Short propagation delays (microseconds)
- **Long-distance/international calls:** Long propagation delays (milliseconds)
- **Satellite calls:** Very long delays (hundreds of milliseconds)

The 17 ms delay calculated here includes the packetization delay that I initially missed. This is still acceptable for voice communication, as humans can tolerate delays up to about 150-200 ms before the conversation feels unnatural.

**Step 11: Key Takeaways**

- VoIP converts analog voice to digital packets for internet transmission
- Total delay includes packetization, transmission, and propagation times
- Packetization delay depends on packet size and data rate
- For reasonable distances, propagation delay usually dominates, but packetization delay is significant for real-time applications
- This delay affects the quality of real-time voice communication

---

## P8: Circuit vs Packet Switching

**Problem:** Suppose users share a 10 Mbps link. Also suppose each user requires 200 kbps when transmitting, but each user transmits only 10 percent of the time. (See the discussion of packet switching versus circuit switching in Section 1.3.)
a. When circuit switching is used, how many users can be supported?
b. For the remainder of this problem, suppose packet switching is used. Find the probability that a given user is transmitting.
c. Suppose there are 120 users. Find the probability that at any given time, exactly n users are transmitting simultaneously. (Hint: Use the binomial distribution.)
d. Find the probability that there are 51 or more users transmitting simultaneously.

### Solution Steps

**Step 1: Understanding the Network Setup**
Imagine a shared 10 Mbps link that multiple users are trying to use simultaneously. Each user needs 200 kbps when they're actively transmitting data, but they only transmit 10% of the time. This is a classic scenario comparing circuit switching (like telephone networks) versus packet switching (like the internet).

**Step 2: Circuit Switching Analysis (Part a)**
Circuit switching reserves dedicated bandwidth for each user. If a user gets a circuit, they have guaranteed access to their full bandwidth requirement whenever they need it.

**Link Capacity:** 10 Mbps = 10,000 kbps

**Per User Requirement:** 200 kbps

**Maximum Users:** Link capacity ÷ Per user requirement = 10,000 ÷ 200 = 50 users

**Explanation:**

- Each user needs a dedicated 200 kbps circuit
- The link can only support 10,000 kbps total
- 50 users × 200 kbps = 10,000 kbps (uses the full link capacity)
- 51 users would require 10,200 kbps, which exceeds the link capacity

**Step 3: Packet Switching - Transmission Probability (Part b)**
In packet switching, users don't get dedicated circuits. Instead, they share the link and transmit when they have data. The problem states each user transmits only 10% of the time.

**Probability a user is transmitting:** P(transmitting) = 0.1 (10%)

This means each user is idle 90% of the time.

**Step 4: Packet Switching - Simultaneous Transmitters (Part c)**
With 120 users, we want to find the probability that exactly n users are transmitting at the same time. This follows a binomial distribution because:

- Each user is either transmitting (success) or not (failure)
- Probability of transmitting = 0.1 (constant for each user)
- Users transmit independently
- We have a fixed number of users (120)

**Binomial Distribution Formula:**
P(X = n) = C(120,n) × (0.1)^n × (0.9)^(120-n)

Where:

- C(120,n) = number of ways to choose n users out of 120
- (0.1)^n = probability that n specific users transmit
- (0.9)^(120-n) = probability that the other (120-n) users don't transmit

**Step 5: Packet Switching - Probability of 51+ Transmitters (Part d)**
Now we want the probability that 51 or more users are transmitting simultaneously. This would be a problem because 51 users × 200 kbps = 10,200 kbps, which exceeds the 10,000 kbps link capacity.

**Calculation Method:**
P(X ≥ 51) = 1 - P(X ≤ 50)

This means we subtract the probability of having 50 or fewer transmitters from 1 (the total probability).

**Step 6: Key Differences Between Circuit and Packet Switching**

**Circuit Switching:**

- **Advantages:** Guaranteed bandwidth, no interference from other users
- **Disadvantages:** Inefficient when users aren't constantly transmitting (wastes bandwidth)
- **In this scenario:** Supports exactly 50 users, no more

**Packet Switching:**

- **Advantages:** Efficient bandwidth usage, supports more users through statistical multiplexing
- **Disadvantages:** No bandwidth guarantees, potential congestion when many users transmit simultaneously
- **In this scenario:** Can support 120 users, but with risk of overload when many transmit at once

**Step 7: Statistical Multiplexing Benefits**
The key insight is that packet switching allows more users because they don't all transmit simultaneously. With 120 users each transmitting 10% of the time, the average number transmitting is 120 × 0.1 = 12 users. This is much less than the circuit switching limit of 50.

However, there's still a chance that more than 50 users could transmit simultaneously, causing congestion. The binomial calculation helps quantify this risk.

**Step 8: Real-World Implications**

- **Circuit switching:** Good for constant bit rate applications (like traditional phone calls)
- **Packet switching:** Good for bursty traffic (like web browsing, email)
- **Trade-off:** Reliability vs efficiency

This problem illustrates the fundamental difference between the two switching paradigms and why packet switching powers the modern internet.

---

## P9: Packet Switching with 1 Gbps Link

**Problem:** Consider the discussion in Section 1.3 of packet switching versus circuit switching in which an example is provided with a 1 Mbps link. Users are generating data at a rate of 100 kbps when busy, but are busy generating data only with probability p = 0.1. Suppose that the 1 Mbps link is replaced by a 1 Gbps link.
a. What is N, the maximum number of users that can be supported simultaneously under circuit switching?
b. Now consider packet switching and a user population of M users. Give a formula (in terms of p, M, N) for the probability that more than N users are sending data.

### Solution Steps

**Step 1: Understanding the Scenario**
The problem starts with a 1 Mbps link where users generate data at 100 kbps when busy, but are busy (transmitting) only 10% of the time (p = 0.1). Now we're upgrading to a 1 Gbps link and need to recalculate the capacity limits.

**Step 2: Circuit Switching Maximum Users (Part a)**
In circuit switching, each user needs dedicated bandwidth. Since each user requires 100 kbps when transmitting, and circuit switching guarantees that bandwidth, we calculate how many such users the link can support.

**Link Capacity:** 1 Gbps = 1,000 Mbps = 1,000,000 kbps

**Per User Requirement:** 100 kbps

**Maximum Users (N):** 1,000,000 ÷ 100 = 10,000 users

**Explanation:**

- Each user gets a dedicated 100 kbps circuit
- The 1 Gbps link can be divided into 1,000,000 ÷ 100 = 10,000 such circuits
- This is the hard limit - no more than 10,000 users can be supported simultaneously

**Step 3: Packet Switching Overload Probability (Part b)**
In packet switching, users share the link and don't get dedicated bandwidth. The problem considers M users sharing the link, and we want the probability that more than N users are transmitting simultaneously.

**Parameters:**

- M = number of users
- N = 10,000 (maximum for circuit switching)
- p = 0.1 (probability each user is transmitting)
- 1-p = 0.9 (probability each user is idle)

**Why This Matters:**
If more than N=10,000 users try to transmit simultaneously, the total demand would be more than 10,000 × 100 kbps = 1,000,000 kbps = 1 Gbps, which equals the link capacity. With exactly the link capacity demand, the system would be at 100% utilization, which could cause performance issues.

**Binomial Distribution Setup:**

- Each user is either transmitting (success) or not (failure)
- Probability of success p = 0.1
- We have M independent trials (users)
- X = number of users transmitting simultaneously

**Probability of Overload:**
P(X > N) = Probability that more than 10,000 users are transmitting

**Using Binomial Distribution:**
P(X = k) = C(M,k) × p^k × (1-p)^(M-k)

**So:**
P(X > N) = 1 - ∑\_{k=0 to N} C(M,k) × p^k × (1-p)^(M-k)

**Step 4: Interpreting the Formula**
This formula gives the probability of congestion (overload) for different numbers of users M. For example:

- If M = 20,000 users, each transmitting 10% of the time, the average number transmitting is 20,000 × 0.1 = 2,000
- But there's still a chance that more than 10,000 could transmit simultaneously
- The formula calculates exactly that probability

**Step 5: Key Insights**

**Circuit Switching:**

- Fixed capacity: exactly 10,000 users maximum
- Predictable performance
- Inefficient for bursty traffic

**Packet Switching:**

- Can support many more users through statistical multiplexing
- Risk of overload when many users transmit simultaneously
- More efficient for variable traffic patterns

**Statistical Multiplexing Gain:**

- Circuit switching: 10,000 users
- Packet switching: Can support 20,000+ users with low overload probability
- The "gain" comes from the fact that users don't transmit simultaneously

**Step 6: Real-World Application**
This calculation is crucial for network design:

- **Network providers** use such calculations to determine how many subscribers they can support
- **Quality of Service** depends on keeping overload probabilities low
- **Bandwidth allocation** decisions are based on these statistical models

The problem shows how upgrading link speed from 1 Mbps to 1 Gbps increases capacity by 1000x, dramatically changing the economics of network provision.

---

## P10: End-to-End Delay

**Problem:** Consider a packet of length L that begins at end system A and travels over three links to a destination end system. These three links are connected by two packet switches. Let di, si, and Ri denote the length, propagation speed, and the transmission rate of link i, for i =1, 2, 3. The packet switch delays each packet by dproc. Assuming no queuing delays, in terms of di, si, Ri, (i =1, 2, 3), and L, what is the total end-to-end delay for the packet? Suppose now the packet is 1,500 bytes, the propagation speed on all three links is 2.5 × 10^8 m/s, the transmission rates of all three links are 2.5 Mbps, the packet switch processing delay is 3 msec, the length of the first link is 5,000 km, the length of the second link is 4,000 km, and the length of the last link is 1,000 km. For these values, what is the end-to-end delay?

### Solution Steps

**Step 1: Understanding the Network Topology**
The problem describes a packet traveling from Host A to Host B through three links connected by two packet switches (routers). This is a typical internet path where data goes through multiple intermediate devices.

**Network Layout:**
Host A → Link 1 → Router 1 → Link 2 → Router 2 → Link 3 → Host B

**Parameters for each link:**

- **di**: Length of link i (distance)
- **si**: Propagation speed on link i
- **Ri**: Transmission rate of link i
- **L**: Packet length (same for all links)
- **dproc**: Processing delay at each router

**Step 2: Identifying All Delay Components**
For a packet traveling through a network, the total delay includes:

1. **Transmission Delays:** Time to put the packet onto each link (L/R_i)
2. **Propagation Delays:** Time for the signal to travel through each link (d_i/s_i)
3. **Processing Delays:** Time for routers to examine and forward the packet (dproc each)

**Assumptions:** No queuing delays (links are uncongested)

**Step 3: Calculating Transmission Delays**
Transmission delay on each link depends on packet size and link speed:

- **Link 1:** L/R_1
- **Link 2:** L/R_2
- **Link 3:** L/R_3

**Total Transmission Delay:** (L/R_1) + (L/R_2) + (L/R_3)

**Step 4: Calculating Propagation Delays**
Propagation delay depends on link length and signal speed:

- **Link 1:** d_1/s_1
- **Link 2:** d_2/s_2
- **Link 3:** d_3/s_3

**Total Propagation Delay:** (d_1/s_1) + (d_2/s_2) + (d_3/s_3)

**Step 5: Calculating Processing Delays**
Each router introduces processing delay:

- **Router 1:** dproc
- **Router 2:** dproc

**Total Processing Delay:** 2 × dproc

**Step 6: Combining All Delays**
**Total End-to-End Delay = Transmission Delays + Propagation Delays + Processing Delays**

**Formula:**
Delay = ∑(L/R_i + d_i/s_i) + 2 × dproc

Where the summation is over i = 1, 2, 3

**Step 7: Numerical Calculation**
Now plug in the specific values:

**Given:**

- L = 1,500 bytes = 12,000 bits
- Propagation speed s_i = 2.5 × 10^8 m/s for all links
- Transmission rates R_i = 2.5 Mbps = 2,500,000 bps for all links
- Processing delay dproc = 3 ms = 0.003 seconds
- Link lengths: d_1 = 5,000 km, d_2 = 4,000 km, d_3 = 1,000 km

**Convert distances to meters:**

- d_1 = 5,000,000 m
- d_2 = 4,000,000 m
- d_3 = 1,000,000 m

**Calculate Transmission Delay per link:**
L/R = 12,000 bits / 2,500,000 bps = 0.0048 seconds = 4.8 ms

**Total Transmission Delay:** 3 × 4.8 ms = 14.4 ms

**Calculate Propagation Delays:**

- Link 1: 5,000,000 m / 2.5 × 10^8 m/s = 0.02 seconds = 20 ms
- Link 2: 4,000,000 m / 2.5 × 10^8 m/s = 0.016 seconds = 16 ms
- Link 3: 1,000,000 m / 2.5 × 10^8 m/s = 0.004 seconds = 4 ms

**Total Propagation Delay:** 20 + 16 + 4 = 40 ms

**Processing Delay:** 2 × 3 ms = 6 ms

**Total Delay:** 14.4 + 40 + 6 = 60.4 ms

**Step 8: Key Insights**

- **Propagation delay dominates:** 40 ms out of 60.4 ms total
- **Long-distance links:** The 5,000 km link contributes the most delay
- **Processing overhead:** 6 ms for two routers
- **Transmission time:** Relatively small at 4.8 ms per link

**Step 9: Real-World Implications**
This calculation shows why:

- **Geographic distance** significantly affects network performance
- **Router processing** adds consistent delays
- **High-speed links** reduce transmission delays but not propagation delays
- **Satellite links** would have much higher propagation delays

This is fundamental to understanding internet performance and designing efficient networks.

---

## Conclusion

You've completed Part 2 of the comprehensive guide for Computer Networking problems. These solutions cover fundamental concepts in propagation and transmission delays, VoIP systems, switching paradigms, and end-to-end delay calculations.
