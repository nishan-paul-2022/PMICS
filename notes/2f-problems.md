# Computer Networking Problems Solutions - Part 6

This document contains detailed solutions to problems P26-P32. Each problem includes the question, the answer, and a step-by-step explanation designed for complete beginners to understand and memorize the concepts.

## Table of Contents

- [P26. BitTorrent free-riding](#p26-suppose-bob-joins-a-bittorrent-torrent-but-he-does-not-want-to-upload-any-data-to-any-other-peers)
- [P27. DASH files storage](#p27-consider-a-dash-system-for-which-there-are-n-video-versions-at-n-different-rates-and-qualities-and-n-audio-versions-at-n-different-rates-and-qualities)
- [P28. TCP/UDP client-server experiments](#p28-install-and-compile-the-python-programs-tcpclient-and-udpclient-on-one-host-and-tcpserver-and-udpserver-on-another-host)
- [P29. UDP socket binding](#p29-suppose-that-in-udpclientpy-after-we-create-the-socket-we-add-the-line-clientsocketbind)
- [P30. Browser simultaneous connections](#p30-can-you-configure-your-browser-to-open-multiple-simultaneous-connections-to-a-web-site)
- [P31. Byte stream vs message boundaries](#p31-we-have-seen-that-internet-tcp-sockets-treat-the-data-being-sent-as-a-byte-stream-but-udp-sockets-recognize-message-boundaries)
- [P32. Apache Web server](#p32-what-is-the-apache-web-server-how-much-does-it-cost-what-functionality-does-it-currently-have)

## P26. Suppose Bob joins a BitTorrent torrent, but he does not want to upload any data to any other peers (so called free-riding).

### a. Bob claims that he can receive a complete copy of the file that is shared by the swarm. Is Bob's claim possible? Why or why not?

**Answer:** Yes, possible if other peers upload to him.

**Explanation:**

1. **BitTorrent:** Peers download and upload pieces.

2. **Free-riding:** Bob downloads but doesn't upload.

3. **Possibility:** If others upload to him, he can get all pieces.

4. **In practice:** BitTorrent encourages uploading via choking algorithms.

5. **Key concept to memorize:** Free-riding possible but discouraged.

### b. Bob further claims that he can further make his "free-riding" more efficient by using a collection of multiple computers (with distinct IP addresses) in the computer lab in his department. How can he do that?

**Answer:** Run multiple peers, each downloading different pieces.

**Explanation:**

1. **Multiple computers:** Each acts as separate peer.

2. **Efficiency:** Each downloads unique pieces, then Bob combines them.

3. **Benefit:** Gets file faster by parallel downloads.

4. **Detection:** Harder to detect as free-riding.

5. **Key concept to memorize:** Multiple peers increase download speed.

## P27. Consider a DASH system for which there are N video versions (at N different rates and qualities) and N audio versions (at N different rates and qualities). Suppose we want to allow the player to choose at any time any of the N video versions and any of the N audio versions.

### a. If we create files so that the audio is mixed in with the video, so server sends only one media stream at given time, how many files will the server need to store (each a different URL)?

**Answer:** N × N files.

**Explanation:**

1. **DASH:** Dynamic Adaptive Streaming over HTTP.

2. **Mixed audio/video:** Each combination is separate file.

3. **Combinations:** N video × N audio = N² files.

4. **Key concept to memorize:** Mixed streams require all combinations.

### b. If the server instead sends the audio and video streams separately and has the client synchronize the streams, how many files will the server need to store?

**Answer:** N + N = 2N files.

**Explanation:**

1. **Separate streams:** Video and audio independent.

2. **Files:** N video + N audio = 2N files.

3. **Client sync:** Player combines streams.

4. **Key concept to memorize:** Separate streams reduce storage to sum of versions.

## P28. Install and compile the Python programs TCPClient and UDPClient on one host and TCPServer and UDPServer on another host.

### a. Suppose you run TCPClient before you run TCPServer. What happens? Why?

**Answer:** Connection fails, TCPClient can't connect to non-existent server.

**Explanation:**

1. **TCP:** Connection-oriented, requires server to be listening.

2. **Client first:** No server socket to connect to.

3. **Result:** Connection timeout or immediate failure.

4. **Key concept to memorize:** TCP requires server to accept connections.

### b. Suppose you run UDPClient before you run UDPServer. What happens? Why?

**Answer:** Client sends data, server may not receive if not running.

**Explanation:**

1. **UDP:** Connectionless, no handshake required.

2. **Client sends:** Datagram sent regardless of server status.

3. **Server not running:** Data lost, no response.

4. **Key concept to memorize:** UDP doesn't guarantee delivery.

### c. What happens if you use different port numbers for the client and server sides?

**Answer:** Communication fails, ports must match.

**Explanation:**

1. **Ports:** Client connects to specific server port.

2. **Mismatch:** Client sends to wrong port, server listens on different port.

3. **Result:** No communication.

4. **Key concept to memorize:** Client and server must agree on port.

## P29. Suppose that in UDPClient.py, after we create the socket, we add the line: clientSocket.bind((’’, 5432)) Will it become necessary to change UDPServer.py? What are the port numbers for the sockets in UDPClient and UDPServer? What were they before making this change?

**Answer:** Yes, need to change server port. Client port 5432, server port as before. Before: client ephemeral, server 12000.

**Explanation:**

1. **bind() in client:** Assigns specific port to client socket.

2. **Server change:** Server must send to client's new port.

3. **Ports:** Client 5432, server remains 12000.

4. **Before:** Client used ephemeral port, server 12000.

5. **Key concept to memorize:** bind() sets socket's local port.

## P30. Can you configure your browser to open multiple simultaneous connections to a Web site? What are the advantages and disadvantages of having a large number of simultaneous TCP connections?

**Answer:** Yes, browsers allow configuring connection limits. Advantages: faster loading. Disadvantages: server overload, resource waste.

**Explanation:**

1. **Configuration:** Browsers have settings for max connections per server.

2. **Advantages:** Parallel downloads speed up page loading.

3. **Disadvantages:** Increases server load, consumes client resources, may violate policies.

4. **Key concept to memorize:** Multiple connections improve performance but have costs.

## P31. We have seen that Internet TCP sockets treat the data being sent as a byte stream but UDP sockets recognize message boundaries. What are one advantage and one disadvantage of byte-oriented API versus having the API explicitly recognize and preserve application-defined message boundaries?

**Answer:** Advantage: flexibility. Disadvantage: complexity in message framing.

**Explanation:**

1. **Byte stream (TCP):** Data as continuous bytes, no boundaries.

2. **Message boundaries (UDP):** Each send is separate message.

3. **Advantage of byte stream:** Can send data of any size, flexible for applications.

4. **Disadvantage:** Applications must implement framing (e.g., length prefixes) to delineate messages.

5. **Key concept to memorize:** TCP requires application-level framing, UDP preserves send boundaries.

## P32. What is the Apache Web server? How much does it cost? What functionality does it currently have? You may want to look at Wikipedia to answer this question.

**Answer:** Apache HTTP Server is open-source web server software. Free. Supports HTTP/1.1, HTTPS, virtual hosts, modules, etc.

**Explanation:**

1. **Apache HTTP Server:** Popular open-source web server developed by Apache Software Foundation.

2. **Cost:** Free, open-source under Apache License.

3. **Functionality:** HTTP/1.1 and HTTP/2 support, SSL/TLS, virtual hosting, authentication, URL rewriting, proxying, extensive module system.

4. **Key concept to memorize:** Apache is free, modular web server powering much of the internet.