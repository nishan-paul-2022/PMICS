# Computer Networking Problems Solutions - Part 5

This document contains detailed solutions to problems P21-P25. Each problem includes the question, the answer, and a step-by-step explanation designed for complete beginners to understand and memorize the concepts.

## Table of Contents

- [P21. Recent access detection](#p21-suppose-that-your-department-has-a-local-dns-server-for-all-computers-in-the-department-you-are-an-ordinary-user-ie-not-a-networksystem-administrator)
- [P22. File distribution times](#p22-consider-distributing-a-file-of-f-20-gbits-to-n-peers)
- [P23. Client-server distribution](#p23-consider-distributing-a-file-of-f-bits-to-n-peers-using-a-client-server-architecture)
- [P24. P2P distribution](#p24-consider-distributing-a-file-of-f-bits-to-n-peers-using-a-p2p-architecture)
- [P25. Overlay network nodes and edges](#p25-consider-an-overlay-network-with-n-active-peers-with-each-pair-of-peers-having-an-active-tcp-connection)

## P21. Suppose that your department has a local DNS server for all computers in the department. You are an ordinary user (i.e., not a network/system administrator). Can you determine if an external Web site was likely accessed from a computer in your department a couple of seconds ago? Explain.

**Answer:** YES, you can determine if an external site was likely accessed recently.

**Explanation:**

**Background for beginners:**
DNS (Domain Name System) is like the phone book of the internet. When you type a website name like "google.com", your computer asks a DNS server to translate it to an IP address (like a phone number). DNS servers cache (store) these translations temporarily to speed up future requests. If someone in your department recently visited a site, that site's IP address will be cached in the local DNS server.

**Method:**

**Use nslookup/dig with local DNS server:**

```bash
# Query your local DNS server
nslookup www.externalsite.com localhost
# or
dig @<local-dns-server> www.externalsite.com
```

**Analysis:**

1. **If query returns immediately (< 10ms):**
    - Answer was **cached** in local DNS server
    - Someone in department queried it recently (within TTL - Time To Live, typically 5 minutes to 1 hour)
    - **Likely accessed within last few minutes to hour**

2. **If query takes longer (> 100ms):**
    - Local DNS had to perform **recursive resolution** (ask other DNS servers)
    - Not in cache = not queried recently
    - **Probably NOT accessed in last TTL period**

**More precise method:**

```bash
# Check TTL value in response
dig @<local-dns-server> www.externalsite.com

# Response shows:
# www.externalsite.com. 285 IN A 93.184.216.34
#                       ^^^
#                       Current TTL (seconds remaining)

# If original TTL was 300 seconds:
# Remaining TTL of 285 → cached 15 seconds ago
# Remaining TTL of 100 → cached 200 seconds ago
```

**Calculation:**
```
Time since cached = Original_TTL - Current_TTL
```

**Limitations:**

1. **Multiple users:** Can't identify which specific computer
2. **TTL expiration:** After TTL expires, cache is cleared
3. **Automated access:** Could be automated systems, not humans
4. **Cache warming:** DNS server may pre-fetch popular domains
5. **No cache guarantee:** Some DNS servers don't cache certain records

**Privacy implication:** This is why DNS-over-HTTPS (DoH) and DNS-over-TLS (DoT) are important - they hide DNS queries from local network observation.

**Key concept to memorize:** DNS caching reveals recent access patterns without requiring administrator privileges.

## P22. Consider distributing a file of F =20 Gbits to N peers. The server has an upload rate of us =30 Mbps, and each peer has a download rate of di =2 Mbps and an upload rate of u. For N =10, 100, and 1,000 and u =300 Kbps, 700 Kbps, and 2 Mbps, prepare a chart giving the minimum distribution time for each of the combinations of N and u for both client-server distribution and P2P distribution.

**Answer:** Chart showing times for different N and u values.

**Explanation:**

**Background for beginners:**
File distribution means sending a file from one computer (server) to many computers (peers). Client-server means everyone downloads directly from the server. P2P (Peer-to-Peer) means peers also share the file with each other, like BitTorrent. The time depends on network speeds and how many copies need to be made.

**Given:**
- File size F = 20 Gbits = 20,000 Mbits
- Server upload rate us = 30 Mbps
- Each peer download rate di = 2 Mbps
- Each peer upload rate u = variable (300 Kbps, 700 Kbps, 2 Mbps)
- N = 10, 100, 1,000 peers

**Formulas:**

**Client-Server Distribution Time:**
```
Dcs = max{NF/us, F/dmin}
```

**P2P Distribution Time:**
```
Dp2p = max{F/us, F/dmin, NF/(us + Σui)}
```

### Calculations:

**For N=10:**

| u (Kbps) | Client-Server (sec) | P2P (sec) | Improvement |
|----------|-------------------|-----------|-------------|
| 300 | max{6,667, 10,000} = **10,000** | max{667, 10,000, 6,061} = **10,000** | None |
| 700 | **10,000** | max{667, 10,000, 5,714} = **10,000** | None |
| 2000 | **10,000** | max{667, 10,000, 4,000} = **10,000** | None |

**Calculations:**
- NF/us = 10×20,000/30 = 6,667 sec
- F/dmin = 20,000/2 = 10,000 sec (bottleneck)
- NF/(us + 10u):
  - u=300K=0.3M: 10×20,000/(30+3) = 6,061 sec
  - u=700K=0.7M: 10×20,000/(30+7) = 5,714 sec
  - u=2M: 10×20,000/(30+20) = 4,000 sec

**For N=100:**

| u (Kbps) | Client-Server (sec) | P2P (sec) | Improvement |
|----------|---------------------|-----------|-------------|
| 300 | **66,667** | max{667, 10,000, 33,333} = **33,333** | 50% |
| 700 | **66,667** | max{667, 10,000, 20,000} = **20,000** | 70% |
| 2000 | **66,667** | max{667, 10,000, 8,696} = **10,000** | 85% |

**Calculations:**
- NF/us = 100×20,000/30 = 66,667 sec (bottleneck for CS)
- F/dmin = 10,000 sec
- NF/(us + 100u):
  - u=0.3M: 100×20,000/(30+30) = 33,333 sec
  - u=0.7M: 100×20,000/(30+70) = 20,000 sec
  - u=2M: 100×20,000/(30+200) = 8,696 sec

**For N=1,000:**

| u (Kbps) | Client-Server (sec) | P2P (sec) | Improvement |
|----------|---------------------|-----------|-------------|
| 300 | **666,667** | max{667, 10,000, 64,516} = **64,516** | 90% |
| 700 | **666,667** | max{667, 10,000, 27,778} = **27,778** | 96% |
| 2000 | **666,667** | max{667, 10,000, 8,734} = **10,000** | 98.5% |

**Calculations:**
- NF/us = 1,000×20,000/30 = 666,667 sec
- NF/(us + 1000u):
  - u=0.3M: 1,000×20,000/(30+300) = 60,606 sec
  - u=0.7M: 1,000×20,000/(30+700) = 27,397 sec
  - u=2M: 1,000×20,000/(30+2000) = 9,852 sec

### Summary Chart:

| N | u (Kbps) | Client-Server | P2P | Speedup |
|---|----------|---------------|-----|---------|
| 10 | 300 | 10,000 | 10,000 | 1.0× |
| 10 | 700 | 10,000 | 10,000 | 1.0× |
| 10 | 2000 | 10,000 | 10,000 | 1.0× |
| 100 | 300 | 66,667 | 33,333 | 2.0× |
| 100 | 700 | 66,667 | 20,000 | 3.3× |
| 100 | 2000 | 66,667 | 10,000 | 6.7× |
| 1000 | 300 | 666,667 | 60,606 | 11.0× |
| 1000 | 700 | 666,667 | 27,397 | 24.3× |
| 1000 | 2000 | 666,667 | 9,852 | 67.7× |

**Key observations:**
- P2P advantage grows with N
- Higher peer upload rates dramatically improve P2P
- For small N, download rate is bottleneck
- For large N, P2P is vastly superior

**Key concept to memorize:** P2P scales better with more peers because it uses everyone's upload bandwidth, not just the server's.

## P23. Consider distributing a file of F bits to N peers using a client-server architecture. Assume a fluid model where the server can simultaneously transmit to multiple peers, transmitting to each peer at different rates, as long as the combined rate does not exceed us.

**Background for beginners:**
In client-server file distribution, one central server sends the file to all peers (clients). The "fluid model" means we assume smooth, continuous data flow without discrete packets. The server can split its upload bandwidth among multiple peers simultaneously.

### a. Suppose that us/N ≤ dmin. Specify a distribution scheme that has a distribution time of NF/us.

**Answer:** Server sends file simultaneously to all peers at rate us/N each.

**Explanation:**

**Given:** us/N ≤ dmin (server upload per peer ≤ minimum download rate)

**Distribution time:** NF/us

**Scheme:**
1. Server divides bandwidth equally among N peers
2. Each peer receives at rate us/N
3. Since us/N ≤ dmin, peer download capacity is not the bottleneck
4. Server operates at full capacity us
5. Total data to send: N × F bits
6. **Time = (N × F) / us = NF/us**

**Example:**
- us = 10 Mbps, N = 10, dmin = 2 Mbps
- us/N = 1 Mbps ≤ 2 Mbps ✓
- Each peer downloads at 1 Mbps (server-limited)
- Time = 10F/10 = F seconds per peer, but all in parallel
- Total time = NF/us

**Key concept to memorize:** When server bandwidth is the limiting factor, distribution time grows proportionally with the number of peers.

### b. Suppose that us/N ≥ dmin. Specify a distribution scheme that has a distribution time of F/dmin.

**Answer:** Server sends to each peer at their maximum download rate dmin.

**Explanation:**

**Given:** us/N ≥ dmin (server has excess capacity per peer)

**Distribution time:** F/dmin

**Scheme:**
1. Server sends to each peer at rate dmin
2. Each peer's download capacity is the bottleneck
3. Server uses only N × dmin of its us capacity
4. All peers complete simultaneously
5. **Time for each peer = F/dmin**
6. Total time = F/dmin

**Example:**
- us = 100 Mbps, N = 10, dmin = 2 Mbps
- us/N = 10 Mbps ≥ 2 Mbps ✓
- Each peer downloads at 2 Mbps (peer-limited)
- Server uses only 20 Mbps of 100 Mbps capacity
- Time = F/2 for all peers

**Key concept to memorize:** When peer download speeds limit the distribution, all peers finish at the same time, determined by the slowest peer's download rate.

### c. Conclude that the minimum distribution time is in general given by max(NF/us, F/dmin).

**Answer:** Yes, minimum time is max(NF/us, F/dmin).

**Explanation:**

**General case:**
- **NF/us:** Time for server to upload N copies (server must send N×F bits total)
- **F/dmin:** Time for slowest client to download (can't finish faster than this)
- Actual time is limited by the slower of these two constraints
- **Dcs = max(NF/us, F/dmin)**

**Proof:**

**Case 1:** Server is bottleneck (us/N ≤ dmin)
- Time = NF/us
- This occurs when NF/us ≥ F/dmin (i.e., us/N ≤ dmin)

**Case 2:** Client download is bottleneck (us/N ≥ dmin)
- Time = F/dmin
- This occurs when F/dmin ≥ NF/us (i.e., us/N ≥ dmin)

**Therefore:** Minimum time is the maximum of the two constraints.

**Interpretation:**
- Distribution cannot complete faster than either the server can upload N copies OR the slowest peer can download one copy
- The actual bottleneck depends on relative capacities

**Key concept to memorize:** Client-server distribution time is bounded by both server upload capacity (scaled by number of peers) and peer download capacity.

## P24. Consider distributing a file of F bits to N peers using a P2P architecture. Assume a fluid model. For simplicity assume that dmin is very large, so that peer download bandwidth is never a bottleneck.

**Background for beginners:**
P2P (Peer-to-Peer) distribution means peers share files with each other, not just downloading from a central server. This is like BitTorrent - once you have part of a file, you start sharing it with others. The "fluid model" assumes smooth data flow. We assume peer download speeds are unlimited, so only upload speeds matter.

### a. Suppose that us ≤ (us + u1 + ... + uN)/N. Specify a distribution scheme that has a distribution time of F/us.

**Answer:** Server sends entire file to one peer at rate us, then that peer redistributes to others.

**Explanation:**

**Given:** us ≤ (us + Σui)/N and dmin is very large (not a bottleneck)

**Distribution time:** F/us

**Scheme:**
1. Server is the bottleneck (has least upload capacity)
2. Server uploads entire file once at rate us
3. First peer receives complete file in time F/us
4. That peer then redistributes to others using its upload capacity
5. With large peer upload capacity, redistribution is fast
6. **Time = F/us**

**Explanation:**
- Condition means: us ≤ (us + total peer upload)/N
- Rearranging: N×us ≤ us + Σui
- Therefore: (N-1)×us ≤ Σui
- Peer upload capacity exceeds what's needed for redistribution
- Server upload is the bottleneck

**Key concept to memorize:** When the server has the lowest upload capacity, it becomes the bottleneck and determines the distribution time.

### b. Suppose that us ≥ (us + u1 + ... + uN)/N. Specify a distribution scheme that has a distribution time of NF/(us + u1 + ... + uN).

**Answer:** All peers download simultaneously from server and each other, utilizing all available upload capacity.

**Explanation:**

**Given:** us ≥ (us + Σui)/N

**Distribution time:** NF/(us + u1 + ... + uN)

**Scheme:**
1. Use all available upload capacity (server + all peers)
2. Total upload capacity: us + u1 + u2 + ... + uN
3. Total data to distribute: N × F bits (N copies)
4. **Time = NF/(us + Σui)**

**Explanation:**
- All nodes (server + peers) upload simultaneously
- As each peer receives pieces, it starts uploading to others
- System operates at maximum aggregate capacity
- Condition means server upload is relatively strong
- All upload capacity is utilized

**Key concept to memorize:** P2P leverages the combined upload capacity of all participants, dramatically improving scalability compared to client-server.

### c. Conclude that the minimum distribution time is in general given by max(F/us, F/dmin, NF/(us + u1 + ... + uN)).

**Answer:** Yes, minimum time is max(F/us, F/dmin, NF/(us + Σui)).

**Explanation:**

**Three constraints:**

1. **F/us:** Server must upload entire file at least once
    - Cannot distribute what hasn't been uploaded by server

2. **F/dmin:** Slowest client must download complete file
    - Even with perfect distribution, slowest peer takes F/dmin

3. **NF/(us + Σui):** Total data / Total upload capacity
    - N copies of F bits must be distributed
    - Maximum aggregate upload rate is us + Σui
    - Minimum time = total data / total rate

**Distribution time is maximum of all three constraints:**
```
Dp2p = max{F/us, F/dmin, NF/(us + Σui)}
```

**Key insight:** P2P leverages peer upload capacity, dramatically reducing distribution time compared to client-server as N increases, since denominator in third term grows with N.

**Key concept to memorize:** P2P distribution scales with peer upload capacity because it uses everyone's bandwidth, not just the server's.

## P25. Consider an overlay network with N active peers, with each pair of peers having an active TCP connection. Additionally, suppose that the TCP connections pass through a total of M routers. How many nodes and edges are there in the corresponding overlay network?

**Answer:** Nodes: N peers, Edges: N(N-1)/2 connections.

**Explanation:**

**Background for beginners:**
An overlay network is a virtual network built on top of the physical internet. Think of it as a logical layer where peers connect directly to each other, even though the actual data might travel through many routers. TCP connections are like virtual "tunnels" between peers. The routers are part of the underlying infrastructure that makes these connections possible.

**Given:**
- N active peers
- Each pair has active TCP connection
- TCP connections pass through M routers

**Answer:**

**Overlay network:**
- **Nodes:** N (only the peers, not the routers)
- **Edges:** N(N-1)/2 (complete graph - each peer connected to every other)

**Detailed Explanation:**

**Nodes (N):**
- Overlay network operates at application layer
- Only application endpoints (peers) are nodes
- Routers are invisible to overlay (they're underlay infrastructure)
- Total nodes = **N**

**Edges (N(N-1)/2):**
- Each pair of peers has one TCP connection
- This is a complete graph (K_N)
- Number of edges in complete graph:
  - Each of N nodes connects to (N-1) others
  - Total = N(N-1)
  - But each edge counted twice (once from each end)
  - Unique edges = N(N-1)/2

**Formula:** Number of edges = C(N,2) = **N(N-1)/2**

**Examples:**
- N=3: Edges = 3×2/2 = 3
- N=4: Edges = 4×3/2 = 6
- N=10: Edges = 10×9/2 = 45
- N=100: Edges = 100×99/2 = 4,950

**Note:** The M routers in the underlay network are transparent to the overlay. The overlay topology is determined by application-level connections, not physical network topology.

**Key concept to memorize:** Overlay networks abstract away the physical network - only the logical peer connections matter for the overlay structure.