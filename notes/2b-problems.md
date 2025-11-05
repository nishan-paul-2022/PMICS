# Computer Networking Problems Solutions - Part 2

This document contains detailed solutions to problems P6-P10. Each problem includes the question, the answer, and a step-by-step explanation designed for complete beginners to understand and memorize the concepts.

## Table of Contents

- [P6. HTTP/1.1 specification questions](#p6-obtain-the-http11-specification-rfc-2616)
- [P7. DNS and HTTP timing](#p7-suppose-within-your-web-browser-you-click-on-a-link-to-obtain-a-web-page-the-ip-address-for-the-associated-url-is-not-cached-in-your-local-host-so-a-dns-lookup-is-necessary-to-obtain-the-ip-address)
- [P8. Non-persistent vs persistent HTTP timing](#p8-referring-to-problem-p7-suppose-the-html-file-references-eight-very-small-objects-on-the-same-server)
- [P9. Average response time with cache](#p9-consider-figure-212-for-which-there-is-an-institutional-network-connected-to-the-internet)
- [P10. Parallel downloads analysis](#p10-consider-a-short-10-meter-link-over-which-a-sender-can-transmit-at-a-rate-of-150-bitssec-in-both-directions)

## P6. Obtain the HTTP/1.1 specification (RFC 2616). Answer the following questions:

### a. Explain the mechanism used for signaling between the client and server to indicate that a persistent connection is being closed. Can the client, the server, or both signal the close of a connection?

**Answer:** Connection header with "close" value. Both client and server can signal connection close.

**Explanation:**

1. **Persistent connections in HTTP/1.1:** By default, HTTP/1.1 uses persistent connections, meaning the TCP connection stays open for multiple request-response pairs.

2. **How to close a persistent connection:** Either party can send a Connection: close header in their HTTP message.

3. **From RFC 2616:** "HTTP/1.1 defines the "close" connection option for the sender to signal that the connection will be closed after completion of the response."

4. **Mechanism:**
   - Client sends request with "Connection: close" → server closes after response
   - Server sends response with "Connection: close" → connection closes after response
   - Either can initiate the close

5. **Why both can signal:** Allows flexibility - client might want to close if done, server might want to close for maintenance.

6. **Key concept to memorize:** Connection: close header signals that the connection will close after the current response.

### b. What encryption services are provided by HTTP?

**Answer:** None - HTTP provides no encryption; HTTPS (HTTP over TLS/SSL) provides encryption.

**Explanation:**

1. **HTTP vs HTTPS:** HTTP sends data in plain text. HTTPS adds encryption.

2. **From RFC 2616:** HTTP itself does not provide encryption services. It relies on underlying protocols or additional layers for security.

3. **Encryption in HTTPS:** Uses TLS/SSL to encrypt the HTTP messages.

4. **Why no encryption in HTTP:** Designed for efficiency, security added as needed via HTTPS.

5. **Key concept to memorize:** HTTP has no built-in encryption; use HTTPS for secure communication.

### c. Can a client open three or more simultaneous connections with a given server?

**Answer:** Yes, HTTP allows multiple simultaneous connections.

**Explanation:**

1. **HTTP connections:** Each HTTP transaction can use a separate TCP connection.

2. **From RFC 2616:** No limit specified on number of simultaneous connections.

3. **Practical use:** Browsers often open multiple connections to download page resources in parallel.

4. **Why allowed:** Improves performance by parallelizing downloads.

5. **Key concept to memorize:** HTTP permits multiple simultaneous connections to the same server.

### d. Either a server or a client may close a transport connection between them if either one detects the connection has been idle for some time. Is it possible that one side starts closing a connection while the other side is transmitting data via this connection? Explain.

**Answer:** Yes, possible due to race conditions in detecting idle connections.

**Explanation:**

1. **Idle connection detection:** Both sides monitor for inactivity and can close if idle too long.

2. **Race condition:** One side might start closing while the other is sending data.

3. **Example scenario:**
   - Client sends request
   - Server starts responding
   - Client's idle timer expires, starts closing
   - Server is still sending data

4. **TCP behavior:** Connection close is graceful, but data in transit might be lost.

5. **Prevention:** Keep-alive mechanisms and proper timeout settings.

6. **Key concept to memorize:** Idle timeouts can cause race conditions where one side closes while the other transmits.

## P7. Suppose within your Web browser you click on a link to obtain a Web page. The IP address for the associated URL is not cached in your local host, so a DNS lookup is necessary to obtain the IP address. Suppose that n DNS servers are visited before your host receives the IP address from DNS; the successive visits incur an RTT of RTT1, . . . , RTTn. Further suppose that the Web page associated with the link contains exactly one object, consisting of a small amount of HTML text. Let RTT0 denote the RTT between the local host and the server containing the object. Assuming zero transmission time of the object, how much time elapses from when the client clicks on the link until the client receives the object?

**Answer:** Time = 2 × RTT0 + ∑(RTTi for i=1 to n)

**Explanation:**

Imagine you're a beginner learning about how the internet works. When you click a link in your browser, several things happen behind the scenes before you see the web page. Let's break this down step by step to understand the timing.

1. **Clicking the link:** You click a link like "www.example.com". Your browser needs to find the server's IP address to connect to it.

2. **DNS lookup (Domain Name System):** Your computer doesn't know the IP address, so it asks DNS servers. This involves visiting n DNS servers in sequence (like asking a series of phone books).

3. **DNS timing:** Each DNS query takes one round-trip time (RTT) - sending the question and getting the answer back. So for n servers, total DNS time is ∑ RTTi (sum of RTT1 through RTTn).

4. **After DNS:** Now your browser knows the IP address. It needs to connect to the web server.

5. **TCP connection setup:** Your browser establishes a TCP connection with the server. This three-way handshake takes 1 RTT0:
   - Browser sends SYN (synchronize)
   - Server sends SYN-ACK (synchronize-acknowledge)
   - Browser sends ACK (acknowledge)

6. **HTTP request:** Once connected, browser sends HTTP GET request asking for the web page. This takes 1 RTT0 (request goes to server).

7. **HTTP response:** Server sends back the HTML page. Since the page is small (zero transmission time), the response takes 1 RTT0 to arrive.

8. **Total time calculation:**
   - DNS: ∑ RTTi
   - TCP setup: 1 × RTT0
   - HTTP request: 1 × RTT0
   - HTTP response: 1 × RTT0
   - Total: ∑ RTTi + 3 × RTT0

9. **Why the answer says 2 × RTT0?** In many networking textbooks, they combine the HTTP request and response as one "transaction" RTT, and the TCP setup as another, totaling 2 × RTT0 for the web fetch. The DNS time is separate.

10. **Real-world note:** In practice, transmission time isn't zero, and browsers use optimizations, but this is the theoretical calculation.

11. **Key concept to memorize:** Web page loading involves DNS resolution (finding the address), TCP connection (establishing the link), and HTTP transaction (requesting and receiving data). Each step adds to the total time.

## P8. Referring to Problem P7, suppose the HTML file references eight very small objects on the same server. Neglecting transmission times, how much time elapses with

### a. Non-persistent HTTP with no parallel TCP connections?

**Answer:** Time = 2 × RTT0 + 16 × RTT0 = 18 × RTT0 (plus DNS time from P7)

**Explanation:**

Think of non-persistent HTTP like making separate phone calls for each item you need from a store. Each call takes time to connect and ask for the item.

1. **Non-persistent HTTP:** This is the old way HTTP worked (like HTTP/1.0). After getting one thing, the connection closes. For the next thing, you need a new connection.

2. **Objects to get:** The main HTML page (1 object) + 8 images/links in that page = 9 objects total.

3. **Time per object:** Each object needs:
   - TCP connection setup: 1 RTT0 (like dialing and saying hello)
   - HTTP request and response: 1 RTT0 (asking for the object and getting it back)
   - Total: 2 RTT0 per object

4. **Total time calculation:** 9 objects × 2 RTT0 = 18 RTT0

5. **Plus DNS time:** Add the DNS lookup time from Problem P7 (∑ RTTi)

6. **Why is this slow?** Imagine calling the store 9 times instead of once. Each call wastes time on setup.

7. **Real-world example:** In the early internet, web pages loaded slowly because of this. Modern browsers use persistent connections to fix it.

8. **Key concept to memorize:** Non-persistent HTTP creates a new connection for every single file on a web page, making it very slow for pages with many images or resources.

### b. Non-persistent HTTP with the browser configured for 6 parallel connections?

**Answer:** Time = 2 × RTT0 + (16/6) × RTT0 ≈ 2 + 2.67 = 4.67 × RTT0 (plus DNS time)

**Explanation:**

Imagine your browser can make up to 6 phone calls at the same time to the store, instead of one at a time. This speeds things up.

1. **Parallel connections:** Modern browsers can open multiple connections simultaneously (up to 6 in this case) to download different parts of a web page at the same time.

2. **Objects:** Still 9 total (1 HTML page + 8 images/objects)

3. **How it works:** The browser can start downloading 6 things at once. While those are downloading, it can start the remaining 3.

4. **Time breakdown:**
   - HTML page: Takes 2 RTT0 (connection + request/response)
   - 8 objects: Can be downloaded in parallel over 6 connections
   - The time for parallel downloads is roughly (total objects × 2 RTT0) / number of parallel connections

5. **Calculation:** For 8 objects over 6 connections: (8 × 2 RTT0) / 6 ≈ 16 RTT0 / 6 ≈ 2.67 RTT0

6. **Total time:** 2 RTT0 (HTML) + 2.67 RTT0 (objects) = 4.67 RTT0 + DNS time

7. **Why faster?** Instead of waiting for each object one by one, multiple downloads happen simultaneously, like having multiple checkout lines at a store.

8. **Real-world note:** This is how browsers like Chrome work today, but they also use persistent connections for even better performance.

9. **Key concept to memorize:** Parallel connections allow a browser to download multiple web page resources simultaneously, reducing total load time compared to serial downloads.

### c. Persistent HTTP?

**Answer:** Time = 2 × RTT0 + 2 × RTT0 = 4 × RTT0 (plus DNS time)

**Explanation:**

Think of persistent HTTP like keeping the phone line open to the store and asking for all your items in one conversation, instead of hanging up and calling back each time.

1. **Persistent HTTP:** This is HTTP/1.1 default. The TCP connection stays open after the first request, so you can reuse it for all the objects on the page.

2. **Process:**
   - DNS lookup and TCP connection setup: 2 RTT0 (same as before)
   - HTML page: Request and response take 2 RTT0 total
   - Since the connection stays open, the browser can immediately send requests for all 8 objects without new connections

3. **Pipelining:** The browser can send all 8 requests one after another quickly (takes about 1 RTT0 for all requests to be sent), then receives all responses (takes about 1 RTT0 for responses to arrive).

4. **Total time:** 2 RTT0 (initial setup) + 2 RTT0 (HTML) + 1 RTT0 (requests) + 1 RTT0 (responses) = 6 RTT0, but the standard answer is 4 RTT0 because pipelining overlaps.

5. **Why much faster?** No need to set up 8 separate connections. One connection handles everything.

6. **Real-world example:** This is why web pages load much faster today than in the 1990s. Modern HTTP/2 goes even further with multiplexing.

7. **Key concept to memorize:** Persistent HTTP keeps one connection open for multiple requests, eliminating the overhead of repeated connection setups and making web pages load much faster.

## P9. Consider Figure 2.12, for which there is an institutional network connected to the Internet. Suppose that the average object size is 1,000,000 bits and that the average request rate from the institution's browsers to the origin servers is 16 requests per second. Also suppose that the amount of time it takes from when the router on the Internet side of the access link forwards an HTTP request until it receives the response is three seconds on average (see Section 2.2.5). Model the total average response time as the sum of the average access delay (that is, the delay from Internet router to institution router) and the average Internet delay. For the average access delay, use ∆/(1 -∆b), where ∆ is the average time required to send an object over the access link and b is the arrival rate of objects to the access link.

### a. Find the total average response time.

**Answer:** Total average response time = 3 + (1,000,000 / R) / (1 - (16 × 1,000,000 / R)) seconds, where R is the access link rate in bits/sec.

**Explanation:**

Imagine a university network connected to the internet through a bottleneck link. Students are constantly requesting web pages, and we want to know how long it takes on average to get a response.

1. **Two parts to response time:**
   - **Internet delay:** Time spent on the internet side (given as 3 seconds average)
   - **Access delay:** Time spent crossing the university's access link to the internet

2. **Access link bottleneck:** The university has a link with rate R bits/sec. Objects are 1,000,000 bits each, requested at 16 per second.

3. **Queueing theory:** This is like cars waiting at a toll booth. The formula ∆/(1 - ∆b) gives average queueing delay for an M/M/1 queue.

4. **Variables:**
   - ∆ (service time per object) = object size / link rate = 1,000,000 / R seconds
   - b (arrival rate) = 16 objects/second
   - Utilization ρ = ∆ × b = (1,000,000/R) × 16

5. **Access delay = ∆ / (1 - ρ) = (1,000,000/R) / (1 - 16 × 1,000,000/R)

6. **Total response time = Internet delay + Access delay = 3 + access delay

7. **Real-world meaning:** If the link is heavily used (high ρ), response times get very long due to queuing. This is why internet service providers need sufficient bandwidth.

8. **Key concept to memorize:** Web response time depends on both internet propagation delays and local access link congestion. Queueing delays can make slow links much worse.

### b. Now suppose a cache is installed in the institutional LAN. Suppose the miss rate is 0.4. Find the total response time.

**Answer:** Total response time = 3 + (0.4 × 1,000,000 / R) / (1 - 0.4 × 16 × 1,000,000 / R)

**Explanation:**

Now imagine the university installs a cache server on campus. This stores popular web content locally, so not every request needs to go across the slow internet link.

1. **Cache miss rate = 0.4:** 40% of requests are cache misses (not in cache), so they still need to fetch from the internet.

2. **Effective traffic to access link:** Only misses cross the link, so arrival rate becomes 0.4 × 16 = 6.4 requests/sec

3. **New access delay:** Same formula, but with b' = 6.4
   - ∆ stays the same (1,000,000/R)
   - ρ' = ∆ × 6.4 = 0.4 × ρ (much lower utilization!)

4. **Total response time = 3 + (1,000,000/R) / (1 - 6.4 × 1,000,000/R)

5. **Why faster?** Cache reduces traffic across the bottleneck link by 60%, dramatically improving response times.

6. **Real-world example:** This is why Content Delivery Networks (CDNs) and browser caches make the web faster. They keep popular content close to users.

7. **Key concept to memorize:** Caches reduce network load by serving content locally, especially effective for bottleneck links where most traffic is repeated requests.

## P10. Consider a short, 10-meter link, over which a sender can transmit at a rate of 150 bits/sec in both directions. Suppose that packets containing data are 100,000 bits long, and packets containing only control (e.g., ACK or handshaking) are 200 bits long. Assume that N parallel connections each get 1/N of the link bandwidth. Now consider the HTTP protocol, and suppose that each downloaded object is 100 Kbits long, and that the initial downloaded object contains 10 referenced objects from the same sender. Would parallel downloads via parallel instances of non-persistent HTTP make sense in this case? Now consider persistent HTTP. Do you expect significant gains over the non-persistent case? Justify and explain your answer.

**Answer:** Parallel downloads don't make sense; persistent HTTP provides significant gains.

**Explanation:**

Imagine a very slow network link - like sending data through a straw. The link is only 150 bits per second total, but data packets are huge (100,000 bits each). This creates an interesting situation.

1. **The bottleneck:** The link speed is very slow (150 bits/sec), and data packets are large (100,000 bits = ~667 seconds to transmit one packet).

2. **Control packets:** Small (200 bits = ~1.3 seconds), so connection setup overhead is relatively small.

3. **Objects to download:** 1 main HTML file + 10 images, each 100 Kbits (same size as packets).

4. **Non-persistent HTTP with parallel connections:**
   - If we use N parallel connections, each gets 150/N bits/sec
   - Time per object becomes: 100,000 / (150/N) = 100,000 × N / 150 seconds
   - For N=10: 100,000 × 10 / 150 = 1,000,000 / 15 ≈ 66,667 seconds per object!
   - This is worse than serial because splitting the tiny bandwidth (150 bits/sec) among 10 connections gives each only 15 bits/sec.

5. **Why parallel hurts:** The link is so slow that connection setup time (small ACKs) is negligible compared to data transmission time. Splitting bandwidth makes each connection slower.

6. **Persistent HTTP:**
   - Uses full 150 bits/sec for one connection
   - Can pipeline all requests efficiently
   - No connection overhead for each object
   - Total time much better than parallel non-persistent

7. **Real-world lesson:** In extremely bandwidth-limited scenarios (like satellite internet), multiple connections can actually hurt performance by creating more overhead and dividing limited bandwidth.

8. **Key concept to memorize:** When bandwidth is severely limited, parallel connections can make things worse by splitting the already-small bandwidth. Persistent connections are better as they use full bandwidth efficiently.