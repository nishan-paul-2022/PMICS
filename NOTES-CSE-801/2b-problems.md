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

**Answer:** The `Connection: close` header field is used to signal that the connection will be closed after the current request/response. Both client and server can signal connection closure.

**Explanation:**

Imagine HTTP/1.1 as a conversation over a phone line. Normally, the line stays open for multiple exchanges (persistent connection), but sometimes you need to hang up cleanly.

1. **Persistent connections in HTTP/1.1:** By default, HTTP/1.1 keeps TCP connections open for multiple request-response pairs to improve efficiency.

2. **How to close a persistent connection:** Either party can send a `Connection: close` header in their HTTP message to signal clean shutdown.

3. **From RFC 2616:** "HTTP/1.1 defines the 'close' connection option for the sender to signal that the connection will be closed after completion of the response."

4. **Mechanism:**
   - **Client:** Includes `Connection: close` in request to indicate it will close after receiving response
   - **Server:** Includes `Connection: close` in response to indicate it will close after sending response
   - Either can initiate the close; absence of the header implies the connection should persist

5. **Why both can signal:** Allows flexibility - client might want to close if done browsing, server might want to close for maintenance or resource limits.

6. **Additional details:** Either party can close the connection at any time, but using the header provides clean shutdown. This prevents abrupt disconnections that could lose data.

7. **Key concept to memorize:** The `Connection: close` header signals that the connection will close after the current response, allowing both client and server to initiate clean shutdowns.

### b. What encryption services are provided by HTTP?

**Answer:** HTTP itself provides NO encryption services. HTTP is a plaintext protocol that transmits data in clear text. For encryption, HTTPS (HTTP Secure) must be used, which combines HTTP with TLS/SSL for encryption.

**Explanation:**

Think of HTTP as sending a postcard through the mail - anyone handling it can read the message. HTTPS is like sending it in a sealed envelope.

1. **HTTP vs HTTPS:** HTTP sends data in plain text, meaning anyone intercepting the traffic can read the content. HTTPS adds encryption to protect the data.

2. **From RFC 2616:** HTTP itself does not provide encryption services. It relies on underlying protocols or additional layers for security.

3. **Encryption in HTTPS:** Uses TLS/SSL (Transport Layer Security/Secure Sockets Layer) to encrypt the HTTP messages, providing:
   - **Encryption** of data in transit
   - **Authentication** of the server (and optionally client)
   - **Integrity** protection against tampering

4. **Why no encryption in HTTP:** Designed for efficiency and simplicity, with security added as needed via HTTPS for sensitive communications.

5. **Key concept to memorize:** HTTP transmits data in plaintext; always use HTTPS for secure communication to protect sensitive information like passwords or personal data.

### c. Can a client open three or more simultaneous connections with a given server?

**Answer:** YES. HTTP allows multiple simultaneous connections, though RFC 2616 recommends limiting them.

**Explanation:**

Imagine a busy restaurant where customers can have multiple waiters serving them simultaneously to speed up service.

1. **HTTP connections:** Each HTTP transaction can use a separate TCP connection, allowing multiple simultaneous connections to the same server.

2. **From RFC 2616, Section 8.1.4:**
   - Clients that use persistent connections SHOULD limit the number of simultaneous connections
   - **Recommendation:** Single-user clients should maintain at most 2 connections
   - **However:** This is a SHOULD (recommendation), not a MUST (requirement)

3. **Practical use:** Browsers typically open 6-8 simultaneous connections to download page resources in parallel and improve performance.

4. **Why allowed:** Improves performance by parallelizing downloads, especially for web pages with many images or resources.

5. **Server limits:** Servers may impose their own limits and refuse excessive connections to prevent overload.

6. **Key concept to memorize:** HTTP permits multiple simultaneous connections to the same server, though browsers and servers often limit them for efficiency and resource management.

### d. Either a server or a client may close a transport connection between them if either one detects the connection has been idle for some time. Is it possible that one side starts closing a connection while the other side is transmitting data via this connection? Explain.

**Answer:** YES, this is possible due to race conditions in detecting idle connections.

**Explanation:**

Think of two friends on a phone call where either can hang up if the conversation goes quiet for too long. Sometimes one might start hanging up just as the other begins speaking.

1. **Idle connection detection:** Both sides monitor for inactivity and can close idle connections to free up resources.

2. **Race condition:** Network delays and timing can cause one side to detect idle timeout and begin closing while the other side is simultaneously sending data.

3. **Example scenario:**
   - Client sends a request
   - Server starts responding with data
   - Client's idle timer expires and begins closing the connection
   - Server is still transmitting data, unaware of client's decision

4. **TCP behavior:** Connection close is graceful, but the transmitting side may receive a connection reset or error, potentially losing data in transit.

5. **Prevention:** Keep-alive mechanisms, proper timeout settings, and RFC 2616 recommends clients be prepared to retry requests if connections close unexpectedly.

6. **Retry considerations:** Idempotent methods (GET, HEAD, PUT, DELETE) can be safely retried; non-idempotent methods (POST) require user confirmation.

7. **Key concept to memorize:** Idle timeouts can create race conditions where one side closes a connection while the other is transmitting, requiring robust error handling and retry mechanisms.

## P7. Suppose within your Web browser you click on a link to obtain a Web page. The IP address for the associated URL is not cached in your local host, so a DNS lookup is necessary to obtain the IP address. Suppose that n DNS servers are visited before your host receives the IP address from DNS; the successive visits incur an RTT of RTT1, . . . , RTTn. Further suppose that the Web page associated with the link contains exactly one object, consisting of a small amount of HTML text. Let RTT0 denote the RTT between the local host and the server containing the object. Assuming zero transmission time of the object, how much time elapses from when the client clicks on the link until the client receives the object?

**Answer:** Total Time = Σ(RTTi for i=1 to n) + 2·RTT₀

**Explanation:**

Imagine clicking a link is like ordering food at a restaurant. First you need to find the restaurant's address (DNS), then call to place the order (TCP connection), then ask for your food (HTTP request), and finally receive it (HTTP response).

1. **Clicking the link:** You click a link like "www.example.com". Your browser needs the server's IP address to connect.

2. **DNS lookup (Domain Name System):** Your computer asks DNS servers sequentially to translate the domain name to an IP address.

3. **DNS timing:** Each DNS query takes one round-trip time (RTT) - sending the question and getting the answer back. Total DNS time: RTT₁ + RTT₂ + ... + RTTₙ

4. **TCP connection setup:** After getting the IP, browser establishes a TCP connection with the server using a 3-way handshake:
   - Client sends SYN
   - Server sends SYN-ACK
   - Client sends ACK
   - Takes 1 RTT₀

5. **HTTP request/response:** Once connected, browser sends GET request and receives the HTML response. Since transmission time is zero, this takes 1 RTT₀ for the request and 1 RTT₀ for the response, totaling 2 RTT₀.

6. **Total time breakdown:**
   - DNS Resolution: Σ RTTi (i=1 to n)
   - TCP Connection Setup: 1·RTT₀
   - HTTP Transaction: 1·RTT₀ (request) + 1·RTT₀ (response) = 2·RTT₀
   - **Grand Total: Σ RTTi + 2·RTT₀**

7. **Why 2×RTT₀ for HTTP?** The HTTP request and response are separate round trips, each taking RTT₀.

8. **Real-world note:** In practice, transmission time isn't zero, browsers cache DNS results, and use persistent connections, but this is the theoretical minimum time.

9. **Key concept to memorize:** Web page loading involves DNS resolution (finding the IP), TCP connection establishment (3-way handshake), and HTTP transaction (request/response exchange), each contributing to total latency.

## P8. Referring to Problem P7, suppose the HTML file references eight very small objects on the same server. Neglecting transmission times, how much time elapses with

### a. Non-persistent HTTP with no parallel TCP connections

**Answer:** 18·RTT₀ (plus DNS time from P7)

**Explanation:**

Non-persistent HTTP is like going to a store and buying one item per shopping trip, driving back and forth each time.

1. **Non-persistent HTTP:** Each object requires a separate TCP connection that closes after use (like HTTP/1.0).

2. **Objects to retrieve:** Initial HTML page + 8 referenced objects = 9 total objects.

3. **Time per object:** Each requires:
   - TCP connection setup: 1·RTT₀ (3-way handshake)
   - HTTP request/response: 1·RTT₀ (GET request + response)
   - Total: 2·RTT₀ per object

4. **Total calculation:**
   - Initial HTML: 2·RTT₀
   - 8 objects: 8 × 2·RTT₀ = 16·RTT₀
   - **Total: 18·RTT₀** (plus DNS time from P7)

5. **Why slow?** Each object wastes time on connection setup and teardown, like driving to the store 9 separate times.

6. **Real-world impact:** This made early web pages load very slowly, especially those with many images.

7. **Key concept to memorize:** Non-persistent HTTP creates/tears down a TCP connection for every single object, making it inefficient for web pages with multiple resources.

### b. Non-persistent HTTP with the browser configured for 6 parallel connections

**Answer:** 6·RTT₀ (plus DNS time)

**Explanation:**

Parallel connections are like having multiple checkout lines at a store - you can serve more customers simultaneously.

1. **Parallel connections:** Browser can open multiple simultaneous TCP connections (6 in this case) to download objects in parallel.

2. **Objects:** 9 total (1 HTML + 8 referenced objects)

3. **How it works:**
   - HTML page: Requires its own connection, takes 2·RTT₀
   - 8 objects: Downloaded over 6 parallel connections
   - First batch: 6 objects start simultaneously (each takes 2·RTT₀)
   - Second batch: Remaining 2 objects start after first batch begins (takes another 2·RTT₀)

4. **Calculation:**
   - HTML: 2·RTT₀
   - First batch (6 objects): 2·RTT₀
   - Second batch (2 objects): 2·RTT₀
   - **Total: 6·RTT₀** (plus DNS time)

5. **Why faster?** Multiple connections allow simultaneous downloads, reducing the time from 18·RTT₀ to 6·RTT₀.

6. **Real-world note:** Modern browsers use both parallel connections and persistent HTTP for optimal performance.

7. **Key concept to memorize:** Parallel TCP connections allow browsers to download multiple web resources simultaneously, significantly reducing page load times compared to serial downloads.

### c. Persistent HTTP

**Answer:** 3·RTT₀ (plus DNS time) - with pipelining

**Explanation:**

Persistent HTTP is like keeping a shopping cart and checkout line open while you gather all your items, instead of checking out after each item.

1. **Persistent HTTP:** TCP connection stays open for multiple requests (HTTP/1.1 default), allowing reuse for all page objects.

2. **Process:**
   - DNS lookup and TCP connection setup: 1·RTT₀ (3-way handshake)
   - Initial HTML request/response: 1·RTT₀
   - All 8 objects can be pipelined over the same connection

3. **Pipelining:** Browser sends all requests sequentially, then receives responses:
   - Without pipelining: 8·RTT₀ (one request/response at a time)
   - With pipelining: 1·RTT₀ (all requests sent at once, all responses return together)

4. **Total calculation:**
   - TCP setup: 1·RTT₀
   - HTML request/response: 1·RTT₀
   - Pipelined objects: 1·RTT₀
   - **Total: 3·RTT₀** (plus DNS time)

5. **Why much faster?** Eliminates 8 separate connection setups, reducing time from 18·RTT₀ (non-persistent) to 3·RTT₀.

6. **Real-world example:** This revolutionized web performance; HTTP/2 builds on this with multiplexing for even better efficiency.

7. **Key concept to memorize:** Persistent HTTP with pipelining keeps one TCP connection open for multiple requests, dramatically reducing connection overhead and improving web page loading speed.

## P9. Consider Figure 2.12, for which there is an institutional network connected to the Internet. Suppose that the average object size is 1,000,000 bits and that the average request rate from the institution's browsers to the origin servers is 16 requests per second. Also suppose that the amount of time it takes from when the router on the Internet side of the access link forwards an HTTP request until it receives the response is three seconds on average (see Section 2.2.5). Model the total average response time as the sum of the average access delay (that is, the delay from Internet router to institution router) and the average Internet delay. For the average access delay, use ∆/(1 -∆b), where ∆ is the average time required to send an object over the access link and b is the arrival rate of objects to the access link.

### a. Find the total average response time.

**Answer:** Total average response time ≈ 3.012 seconds (assuming 100 Mbps access link)

**Explanation:**

Think of a university campus connected to the internet through a single bottleneck link. Students are downloading web pages, creating traffic that can cause delays.

1. **Two components of response time:**
   - **Internet delay:** Average 3 seconds for data to travel across the internet
   - **Access delay:** Time to cross the university's local access link to reach the internet

2. **Access link characteristics:**
   - Object size: 1,000,000 bits each
   - Request rate: 16 objects/second
   - Link rate: R bits/second (needs to be determined)

3. **Queueing theory (M/M/1 model):** The access delay uses the formula Δ/(1 - Δβ) where:
   - Δ = service time per object = object size / link rate = 1,000,000/R seconds
   - β = arrival rate = 16 objects/second
   - Utilization ρ = Δ × β = (1,000,000/R) × 16

4. **Problem with typical assumptions:** If we assume 15 Mbps (common for institutional links), ρ > 1, making the system unstable.

5. **Realistic assumption:** Using 100 Mbps access link:

   ```
   Δ = 1,000,000 / 100,000,000 = 0.01 seconds
   ρ = 0.01 × 16 = 0.16 (16% utilization)
   Access delay = 0.01 / (1 - 0.16) = 0.0119 seconds
   Total response time = 3 + 0.0119 ≈ 3.012 seconds
   ```

6. **General formula:** Total time = 3 + (1,000,000/R) / (1 - 16 × 1,000,000/R)

7. **Real-world significance:** When link utilization approaches 100%, response times become extremely long due to queuing. This explains why network congestion causes slowdowns.

8. **Key concept to memorize:** Response time = Internet delay + Access delay; queueing delays grow dramatically as link utilization approaches capacity, making bandwidth upgrades crucial for performance.

### b. Now suppose a cache is installed in the institutional LAN. Suppose the miss rate is 0.4. Find the total response time.

**Answer:** Total response time ≈ 1.21 seconds (assuming 100 Mbps access link)

**Explanation:**

Adding a cache is like opening a campus bookstore that stocks popular textbooks locally, so students don't always need to order from distant suppliers.

1. **Cache miss rate = 0.4:** 40% of requests are misses (content not in cache), requiring internet fetch; 60% are hits (served locally).

2. **Traffic reduction:** Only cache misses (0.4 × 16 = 6.4 requests/sec) cross the bottleneck access link.

3. **New access delay calculation:**

   ```
   Effective arrival rate β' = 6.4 requests/sec
   ρ' = Δ × β' = 0.01 × 6.4 = 0.064 (6.4% utilization)
   Access delay = 0.01 / (1 - 0.064) = 0.0106 seconds
   ```

4. **Response time breakdown:**
   - Cache hits: 60% × ~0.01 sec (LAN speed) = 0.006 seconds
   - Cache misses: 40% × (3 + 0.0106) = 1.2042 seconds
   - **Total: 0.006 + 1.2042 ≈ 1.21 seconds**

5. **General formula:** Total time = 0.4 × (3 + Δ/(1 - 0.4 × 16 × Δ)) + 0.6 × LAN_delay

6. **Why dramatic improvement?** Cache reduces bottleneck traffic by 60%, dropping utilization from 16% to 6.4%, cutting response time by ~60%.

7. **Real-world example:** This explains why CDNs, browser caches, and proxy servers accelerate web performance by serving popular content locally.

8. **Key concept to memorize:** Web caches reduce network congestion by serving frequently requested content locally, especially valuable for bottleneck links where repeated requests cause queuing delays.

## P10. Consider a short, 10-meter link, over which a sender can transmit at a rate of 150 bits/sec in both directions. Suppose that packets containing data are 100,000 bits long, and packets containing only control (e.g., ACK or handshaking) are 200 bits long. Assume that N parallel connections each get 1/N of the link bandwidth. Now consider the HTTP protocol, and suppose that each downloaded object is 100 Kbits long, and that the initial downloaded object contains 10 referenced objects from the same sender. Would parallel downloads via parallel instances of non-persistent HTTP make sense in this case? Now consider persistent HTTP. Do you expect significant gains over the non-persistent case? Justify and explain your answer.

**Answer:** Parallel downloads do NOT make sense; persistent HTTP provides modest gains over non-persistent.

**Explanation:**

This scenario is like trying to download files over a very slow straw. The link is extremely bandwidth-limited (150 bits/sec), making parallel connections counterproductive.

1. **Link characteristics:**
   - Length: 10 meters (propagation delay negligible: ~50 nanoseconds)
   - Bandwidth: 150 bits/sec total (extremely slow)
   - Data packets: 100,000 bits (~666.67 seconds transmission time)
   - Control packets: 200 bits (~1.33 seconds)

2. **Objects:** 11 total (1 HTML + 10 referenced objects), each 100 Kbits

3. **Non-persistent HTTP (sequential):**

   ```
   Per object:
   - TCP setup: 3 × 1.33 = 4 seconds
   - HTTP request: 1.33 seconds
   - HTTP response: 666.67 seconds
   - Total per object: 672 seconds
   Total for 11 objects: 7,392 seconds
   ```

4. **Non-persistent HTTP with N=10 parallel connections:**

   ```
   Each connection gets 150/10 = 15 bits/sec
   Data transmission per object: 100,000 / 15 = 6,666.67 seconds
   Initial object: 672 seconds
   10 objects in parallel: 6,666.67 seconds
   Total: ~7,339 seconds (barely better than sequential!)
   ```

5. **Why parallel doesn't help:** Bandwidth is so limited that splitting it among connections (15 bits/sec each) doesn't compensate for the massive transmission times. Connection setup overhead becomes negligible.

6. **Persistent HTTP:**

   ```
   TCP setup once: 4 seconds
   Initial object: 668 seconds
   10 objects sequentially: 10 × (1.33 + 666.67) = 6,680 seconds
   Total: 7,352 seconds
   Savings: 40 seconds (10 × 4 seconds saved on TCP setup)
   ```

7. **Conclusion:**
   - Parallel downloads counterproductive due to extreme bandwidth limitation
   - Persistent HTTP provides minor gains (saves TCP setup overhead)
   - Real improvement requires increasing link bandwidth, not protocol changes

8. **Real-world lesson:** In severely bandwidth-constrained environments (satellite internet, dial-up), parallel connections can hurt performance by dividing already-limited bandwidth.

9. **Key concept to memorize:** When transmission times dominate connection setup times, parallel connections can be counterproductive; persistent HTTP saves connection overhead but bandwidth upgrades provide the real solution.
