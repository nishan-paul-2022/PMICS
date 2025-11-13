# Computer Networking Problems Solutions - Part 3

This document contains detailed solutions to problems P11-P15. Each problem includes the question, the answer, and a step-by-step explanation designed for complete beginners to understand and memorize the concepts.

## Table of Contents

- [P11. Shared link parallel connections](#p11-consider-the-scenario-introduced-in-the-previous-problem-now-suppose-that-the-link-is-shared-by-bob-with-four-other-users)
- [P12. TCP program for proxy](#p12-write-a-simple-tcp-program-for-a-server-that-accepts-lines-of-input-from-a-client-and-prints-the-lines-onto-the-servers-standard-output)
- [P13. HTTP/2 frame times](#p13-consider-sending-over-http2-a-web-page-that-consists-of-one-video-clip-and-five-images)
- [P14. HTTP/2 prioritization](#p14-consider-the-web-page-in-problem-13-now-http2-prioritization-is-employed)
- [P15. SMTP vs mail message From](#p15-what-is-the-difference-between-mail-from-in-smtp-and-from-in-the-mail-message-itself)

## P11. Consider the scenario introduced in the previous problem. Now suppose that the link is shared by Bob with four other users. Bob uses parallel instances of non-persistent HTTP, and the other four users use non-persistent HTTP without parallel downloads.

**Given:**

- Bob shares link with 4 other users (5 users total)
- Bob uses parallel instances of non-persistent HTTP
- Other 4 users use non-persistent HTTP without parallel

### a. Do Bob's parallel connections help him get pages more quickly?

**Answer: YES, Bob benefits from parallel connections**

**Explanation:**

**Background for beginners:** In computer networking, bandwidth is the amount of data that can be transmitted over a network link per second. When multiple users share the same link, the total bandwidth is divided among all active connections. TCP (Transmission Control Protocol) connections are like separate lanes on a highway - each connection gets its own share of the available bandwidth.

Assuming fair sharing of bandwidth:

- **Without coordination:** Each TCP connection gets equal share
- If Bob opens N parallel connections while others each open 1:
  - Total connections: N (Bob) + 4 (others) = N + 4
  - Bob's share: N/(N+4) of total bandwidth
  - Each other user's share: 1/(N+4) of total bandwidth

**Example with N=5:**

- Total connections: 5 + 4 = 9
- Bob gets: 5/9 ≈ 55.6% of bandwidth
- Each other user gets: 1/9 ≈ 11.1% of bandwidth

**Bob downloads faster because:**

1. He gets more aggregate bandwidth
2. Multiple objects download in parallel
3. TCP slow-start affects each connection, but with more connections, Bob overcomes this faster

**Ethical consideration:** Bob is being "greedy" and getting unfair advantage

### b. If all five users open five parallel instances of non-persistent HTTP, then would Bob's parallel connections still be beneficial? Why or why not?

**Answer: NO, Bob gains no advantage**

**Explanation:**

**Background for beginners:** When all users use the same strategy, the network becomes congested with many connections competing for limited bandwidth. This is similar to a highway where everyone tries to use multiple lanes - it doesn't help anyone go faster and may even slow everyone down due to increased traffic management overhead.

When all users use same strategy:

- Total connections: 5 × 5 = 25
- Each user opens 5 connections
- Each user gets: 5/25 = 1/5 = 20% of total bandwidth

**Result:**

- **Fair distribution:** Each user gets equal share (20%)
- Bob has no advantage over others
- All users experience:
  - More overhead from managing multiple connections
  - More complexity
  - Same overall throughput

**Additional problems when all use parallel connections:**

- Increased congestion
- More packet loss
- More TCP retransmissions
- Network operates less efficiently

**Conclusion:** Parallel connections only help when others don't use them. When everyone uses them, it becomes a "tragedy of the commons" situation with no individual benefit and collective harm.

**Key concept to memorize:** Parallel connections provide advantage only in asymmetric scenarios where not all users employ them.

## P12. Write a simple TCP program for a server that accepts lines of input from a client and prints the lines onto the server’s standard output. (You can do this by modifying the TCPServer.py program in the text.) Compile and execute your program. On any other machine that contains a Web browser, set the proxy server in the browser to the host that is running your server program; also configure the port number appropriately. Your browser should now send its GET request messages to your server, and your server should display the messages on its standard output. Use this platform to determine whether your browser generates conditional GET messages for objects that are locally cached.

**Answer:**

```python
# TCPServer.py - Modified to display HTTP GET requests
from socket import *

serverPort = 12000
serverSocket = socket(AF_INET, SOCK_STREAM)
serverSocket.bind(('', serverPort))
serverSocket.listen(1)
print('The server is ready to receive')

while True:
    connectionSocket, addr = serverSocket.accept()
    try:
        message = connectionSocket.recv(4096).decode()
        print('='*50)
        print('Received from:', addr)
        print(message)
        print('='*50)

        # Send a simple HTTP response
        response = 'HTTP/1.1 200 OK\r\n\r\n'
        connectionSocket.send(response.encode())
    except:
        pass
    finally:
        connectionSocket.close()
```

**Testing for Conditional GET:**

**Background for beginners:** A proxy server acts as an intermediary between a client (like your web browser) and the internet. It receives requests from the client, forwards them to the destination server, and returns the responses. This setup allows you to inspect and analyze HTTP traffic.

To test if browser generates conditional GET messages:

1. **Run the server program:** Execute the Python script above on your machine.

2. **Configure browser proxy:** In your web browser settings, set the proxy server to point to your server (e.g., `localhost:12000` or your IP address and port 12000).

3. **Visit a webpage multiple times:** Navigate to any website and refresh the page or visit it again.

4. **Check server output:** The server will display all HTTP requests sent by the browser.

**Indicators of Conditional GET:**

- `If-Modified-Since` header present (with a date)
- `If-None-Match` header present (with ETag)

**First request (unconditional GET):**

```
GET /page.html HTTP/1.1
Host: example.com
```

**Subsequent request (conditional GET):**

```
GET /page.html HTTP/1.1
Host: example.com
If-Modified-Since: Wed, 21 Oct 2015 07:28:00 GMT
If-None-Match: "686897696a7c876b7e"
```

**Observation:** Most modern browsers **DO generate conditional GET** messages for cached objects to validate freshness and avoid unnecessary downloads.

**Key concept to memorize:** Conditional GET requests use headers like `If-Modified-Since` and `If-None-Match` to check if cached content is still valid, reducing bandwidth usage and improving performance.

## P13. Consider sending over HTTP/2 a Web page that consists of one video clip, and five images. Suppose that the video clip is transported as 2000 frames, and each image has three frames.

**Given:**

- 1 video clip: 2000 frames
- 5 images: 3 frames each (total 15 frames)
- Total frames: 2015

**Background for beginners:** HTTP/2 is a protocol for transferring web content efficiently. It breaks data into small units called "frames" that can be sent over the network. Each frame takes a certain amount of time to transmit, called a "frame time." Interleaving means mixing frames from different resources (like video and images) instead of sending all frames from one resource first.

### a. If all the video frames are sent first without interleaving, how many “frame times” are needed until all five images are sent?

**Answer: 2000 + 15 = 2015 frame times**

**Explanation:**

- Video frames: 1, 2, 3, ..., 2000
- Images start after video completes
- First image frame sent at time 2001
- Last image frame sent at time 2015

**Time until all 5 images are sent: 2000 + 15 = 2015 frame times**
**Time until all 5 images START being sent: 2000 frame times**

### b. If frames are interleaved, how many frame times are needed until all five images are sent.

**Answer: 15 frame times**

**Explanation:**

**Background for beginners:** Interleaving is like shuffling cards from different decks. Instead of dealing all cards from one deck first, you deal one card from each deck in turn. This helps smaller resources (like images) get transmitted faster instead of waiting for large resources (like videos) to finish.

With optimal interleaving (round-robin):

- Frame 1: Video frame 1
- Frame 2: Image 1, frame 1
- Frame 3: Image 2, frame 1
- Frame 4: Image 3, frame 1
- Frame 5: Image 4, frame 1
- Frame 6: Image 5, frame 1
- Frame 7: Video frame 2
- Frame 8: Image 1, frame 2
- ...
- Frame 15: Image 5, frame 3 ✓ (all images complete)

**Time until all 5 images sent: 15 frame times**

**Benefit:** Dramatic improvement! 2000 → 15 frame times (99.25% faster for images)

**Key concept to memorize:** HTTP/2 interleaving allows smaller resources to be delivered much faster by mixing their frames with larger resources, improving perceived page load times.

## P14. Consider the Web page in problem 13. Now HTTP/2 prioritization is employed. Suppose all the images are given priority over the video clip, and that the first image is given priority over the second image, the second image over the third image, and so on. How many frame times will be needed until the second image is sent?

**Given:**

- All images prioritized over video
- Image 1 > Image 2 > Image 3 > Image 4 > Image 5 > Video
- Each image: 3 frames

**Question:** How many frame times until second image is sent?

**Background for beginners:** HTTP/2 prioritization allows web browsers to tell servers which resources (like images, videos, CSS files) are more important. It's like telling a waiter that you want your appetizer before your main course. Higher priority resources get sent first, improving how quickly important content appears on web pages.

**Answer: 6 frame times**

**Explanation:**

Priority order (highest to lowest):

1. Image 1 (3 frames)
2. Image 2 (3 frames) ← **We want to know when this completes**
3. Image 3 (3 frames)
4. Image 4 (3 frames)
5. Image 5 (3 frames)
6. Video (2000 frames)

**Frame schedule:**

- Frames 1-3: Image 1 (frames 1, 2, 3)
- Frames 4-6: Image 2 (frames 1, 2, 3) ✓ **Complete**

**Answer: 6 frame times** until the second image is completely sent.

**Key concept to memorize:** HTTP/2 prioritization ensures critical resources (like above-the-fold images) load before less important content (like below-the-fold videos), improving user experience by showing important content faster.

## P15. What is the difference between MAIL FROM: in SMTP and From: in the mail message itself?

**Answer:**

**Background for beginners:** Email consists of two parts: the "envelope" (like the outside of a postal letter with addresses) and the "message content" (like the letter inside). These can have different sender information, which is sometimes used legitimately (like mailing lists) but can also be abused (like in spam or phishing).

### MAIL FROM: (SMTP Protocol Command)

- **Purpose:** Part of the **SMTP envelope**
- **Used by:** Mail servers for routing and delivery
- **Format:** `MAIL FROM:<sender@example.com>`
- **Function:**
  - Tells receiving server where to send bounce messages
  - Used for return-path in case of delivery failure
  - Part of the actual SMTP protocol handshake
- **Visibility:** Not typically seen by end users
- **Can be different from:** The From: header in the message

### From: (Email Header)

- **Purpose:** Part of the **message content** (email headers)
- **Used by:** Email clients to display sender to recipient
- **Format:** `From: John Doe <john@example.com>`
- **Function:**
  - Shows who the message is purportedly from
  - Displayed in email client
  - Part of the message itself (like Subject, To, Date)
- **Visibility:** Always visible to end users

### Key Differences:

1. **Layer:**
   - MAIL FROM: Envelope (transport layer)
   - From: Message header (content layer)

2. **Analogy:**
   - MAIL FROM: Return address on outside of postal envelope
   - From: Return address on letter inside envelope

3. **Spoofing:**
   - From: Can be easily forged
   - MAIL FROM: Also can be forged but used for routing
   - This discrepancy is often exploited in phishing/spam

4. **Bounce handling:**
   - MAIL FROM: Receives bounce notifications
   - From: May never know about bounces

**Example of legitimate difference:**

- Mailing list: MAIL FROM: <list-bounces@mailinglist.com>
- Message From: <member@example.com>

**Key concept to memorize:** The envelope sender (MAIL FROM) handles delivery logistics, while the header sender (From:) is what recipients see and trust.
