# Computer Networking Problems Solutions - Part 5

This document contains detailed solutions to problems P21-P25. Each problem includes the question, the answer, and a step-by-step explanation designed for complete beginners to understand and memorize the concepts.

## Table of Contents

- [P21. Recent access detection](#p21-suppose-that-your-department-has-a-local-dns-server-for-all-computers-in-the-department-you-are-an-ordinary-user-ie-not-a-networksystem-administrator)
- [P22. File distribution times](#p22-consider-distributing-a-file-of-f-20-gbits-to-n-peers)
- [P23. Client-server distribution](#p23-consider-distributing-a-file-of-f-bits-to-n-peers-using-a-client-server-architecture)
- [P24. P2P distribution](#p24-consider-distributing-a-file-of-f-bits-to-n-peers-using-a-p2p-architecture)
- [P25. Overlay network nodes and edges](#p25-consider-an-overlay-network-with-n-active-peers-with-each-pair-of-peers-having-an-active-tcp-connection)

## P21. Suppose that your department has a local DNS server for all computers in the department. You are an ordinary user (i.e., not a network/system administrator). Can you determine if an external Web site was likely accessed from a computer in your department a couple of seconds ago? Explain.

**Answer:** No, as an ordinary user, you cannot access the DNS server's cache or logs.

**Explanation:**

1. **DNS server access:** Local DNS servers are typically restricted to administrators.

2. **Cache inspection:** Requires privileged access to view cache contents.

3. **Log access:** DNS query logs are usually protected.

4. **Why not possible:** Security prevents users from accessing sensitive DNS information.

5. **Alternative:** Use packet sniffing if on same network, but that's not standard user access.

6. **Key concept to memorize:** DNS server internals are protected from ordinary users.

## P22. Consider distributing a file of F =20 Gbits to N peers. The server has an upload rate of us =30 Mbps, and each peer has a download rate of di =2 Mbps and an upload rate of u. For N =10, 100, and 1,000 and u =300 Kbps, 700 Kbps, and 2 Mbps, prepare a chart giving the minimum distribution time for each of the combinations of N and u for both client-server distribution and P2P distribution.

**Answer:** Chart showing times for different N and u values.

**Explanation:**

1. **Client-server:** Time = max(F/us, F/di) but since us=30Mbps, di=2Mbps, bottleneck is di.

2. **P2P:** Time = max(F/us, F/(us + sum u_i)) approximately F/us for large N.

3. **Calculate for each combination:**

   - N=10, u=300Kbps: CS: 20e9/(2e6)=10000s, P2P: 20e9/(30e6 + 10*0.3e6)≈20e9/33e6≈606s

   - N=10, u=700Kbps: CS: 10000s, P2P: 20e9/(30e6 + 10*0.7e6)≈20e9/37e6≈541s

   - N=10, u=2Mbps: CS: 10000s, P2P: 20e9/(30e6 + 10*2e6)≈20e9/50e6≈400s

   - N=100, u=300Kbps: CS: 10000s, P2P: 20e9/(30e6 + 100*0.3e6)≈20e9/60e6≈333s

   - N=100, u=700Kbps: CS: 10000s, P2P: 20e9/(30e6 + 100*0.7e6)≈20e9/100e6≈200s

   - N=100, u=2Mbps: CS: 10000s, P2P: 20e9/(30e6 + 100*2e6)≈20e9/230e6≈87s

   - N=1000, u=300Kbps: CS: 10000s, P2P: 20e9/(30e6 + 1000*0.3e6)≈20e9/330e6≈61s

   - N=1000, u=700Kbps: CS: 10000s, P2P: 20e9/(30e6 + 1000*0.7e6)≈20e9/730e6≈27s

   - N=1000, u=2Mbps: CS: 10000s, P2P: 20e9/(30e6 + 1000*2e6)≈20e9/2030e6≈10s

4. **Key concept to memorize:** P2P scales better with more peers.

## P23. Consider distributing a file of F bits to N peers using a client-server architecture. Assume a fluid model where the server can simultaneously transmit to multiple peers, transmitting to each peer at different rates, as long as the combined rate does not exceed us.

### a. Suppose that us/N ...dmin. Specify a distribution scheme that has a distribution time of NF/us.

**Answer:** Server sends file sequentially to each peer at rate us/N.

**Explanation:**

1. **Condition:** us/N ≤ dmin (server upload per peer ≤ peer download capacity).

2. **Scheme:** Server divides bandwidth equally among peers.

3. **Time:** Each peer gets us/N rate, time = F / (us/N) = NF/us.

4. **Key concept to memorize:** When server bandwidth limits, time proportional to N.

### b. Suppose that us/N Údmin. Specify a distribution scheme that has a distribution time of F/dmin.

**Answer:** Server sends to peers at their max rate dmin.

**Explanation:**

1. **Condition:** us/N ≥ dmin (peers can download faster than allocated).

2. **Scheme:** Server sends at dmin to each peer.

3. **Time:** F / dmin.

4. **Key concept to memorize:** When peers limit, time = F/dmin.

### c. Conclude that the minimum distribution time is in general given by max 5NF/us, F/dmin 6.

**Answer:** Yes, minimum time is max(NF/us, F/dmin).

**Explanation:**

1. **General case:** Take the maximum of the two bounds.

2. **Reason:** Can't be faster than either constraint.

3. **Key concept to memorize:** Client-server distribution time bounded by server and peer capacities.

## P24. Consider distributing a file of F bits to N peers using a P2P architecture. Assume a fluid model. For simplicity assume that dmin is very large, so that peer download bandwidth is never a bottleneck.

### a. Suppose that us ...(us +u1 +. . . +uN)/N. Specify a distribution scheme that has a distribution time of F/us.

**Answer:** Server sends to one peer, who shares with others.

**Explanation:**

1. **Condition:** us ≤ average upload rate.

2. **Scheme:** Server uploads to first peer at us, then peers redistribute.

3. **Time:** Limited by server upload rate F/us.

4. **Key concept to memorize:** When server is bottleneck, time = F/us.

### b. Suppose that us Ú(us +u1 +. . . +uN)/N. Specify a distribution scheme that has a distribution time of NF/(us +u1 +. . . + uN).

**Answer:** All peers download simultaneously from server and each other.

**Explanation:**

1. **Condition:** us ≥ average upload rate.

2. **Scheme:** BitTorrent-like distribution.

3. **Time:** NF / total upload capacity.

4. **Key concept to memorize:** P2P exploits aggregate bandwidth.

### c. Conclude that the minimum distribution time is in general given by max 5F/us, NF/(us +u1 +. . . +uN) 6.

**Answer:** Yes, minimum time is max(F/us, NF/total_upload).

**Explanation:**

1. **General case:** Take the maximum of the bounds.

2. **Reason:** Can't exceed either constraint.

3. **Key concept to memorize:** P2P distribution scales with peer upload capacity.

## P25. Consider an overlay network with N active peers, with each pair of peers having an active TCP connection. Additionally, suppose that the TCP connections pass through a total of M routers. How many nodes and edges are there in the corresponding overlay network?

**Answer:** Nodes: N peers, Edges: N(N-1)/2 connections.

**Explanation:**

1. **Overlay network:** Logical network of peers.

2. **Nodes:** N active peers.

3. **Edges:** Each pair has TCP connection, so complete graph with N(N-1)/2 edges.

4. **M routers:** Part of underlying network, not overlay nodes.

5. **Key concept to memorize:** Overlay has peers as nodes, connections as edges.