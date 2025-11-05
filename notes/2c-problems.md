# Computer Networking Problems Solutions - Part 3

This document contains detailed solutions to problems P11-P15. Each problem includes the question, the answer, and a step-by-step explanation designed for complete beginners to understand and memorize the concepts.

## Table of Contents

- [P11. Shared link parallel connections](#p11-consider-the-scenario-introduced-in-the-previous-problem-now-suppose-that-the-link-is-shared-by-bob-with-four-other-users)
- [P12. TCP program for proxy](#p12-write-a-simple-tcp-program-for-a-server-that-accepts-lines-of-input-from-a-client-and-prints-the-lines-onto-the-servers-standard-output)
- [P13. HTTP/2 frame times](#p13-consider-sending-over-http2-a-web-page-that-consists-of-one-video-clip-and-five-images)
- [P14. HTTP/2 prioritization](#p14-consider-the-web-page-in-problem-13-now-http2-prioritization-is-employed)
- [P15. SMTP vs mail message From](#p15-what-is-the-difference-between-mail-from-in-smtp-and-from-in-the-mail-message-itself)

## P11. Consider the scenario introduced in the previous problem. Now suppose that the link is shared by Bob with four other users. Bob uses parallel instances of non-persistent HTTP, and the other four users use non-persistent HTTP without parallel downloads.

### a. Do Bob's parallel connections help him get Web pages more quickly? Why or why not?

**Answer:** No, parallel connections don't help Bob; they may hurt due to shared bandwidth.

**Explanation:**

1. **Shared link:** 150 bits/sec total, shared among 5 users.

2. **Bob's strategy:** Uses parallel non-persistent HTTP connections.

3. **Other users:** Use single connections each.

4. **Bandwidth allocation:** Each of Bob's parallel connections gets less bandwidth because total is fixed.

5. **Result:** Bob's individual connections are slower, and since he uses multiple, he consumes more total bandwidth but each transfer is slower.

6. **Why not helpful:** In a shared bottleneck link, parallel connections from one user don't increase total available bandwidth.

7. **Key concept to memorize:** Parallel connections don't help when the bottleneck is shared bandwidth.

### b. If all five users open five parallel instances of non-persistent HTTP, then would Bob's parallel connections still be beneficial? Why or why not?

**Answer:** No, still not beneficial; all users suffer from increased contention.

**Explanation:**

1. **All users use 5 parallel connections each.**

2. **Total connections:** 5 users × 5 connections = 25 connections competing for 150 bits/sec.

3. **Each connection gets:** 150 / 25 = 6 bits/sec.

4. **Bob's advantage:** None, because all connections are equally slow.

5. **Worse for all:** More connections mean more overhead and slower individual transfers.

6. **Key concept to memorize:** When all users use parallel connections, it increases contention without benefit.

## P12. Write a simple TCP program for a server that accepts lines of input from a client and prints the lines onto the server's standard output. (You can do this by modifying the TCPServer.py program in the text.) Compile and execute your program. On any other machine that contains a Web browser, set the proxy server in the browser to the host that is running your server program; also configure the port number appropriately. Your browser should now send its GET request messages to your server, and your server should display the messages on its standard output. Use this platform to determine whether your browser generates conditional GET messages for objects that are locally cached.

**Answer:** Program code and analysis provided below.

**Explanation:**

1. **Task:** Create TCP server that prints client input lines to stdout.

2. **Modify TCPServer.py:** Add code to read lines and print them.

3. **Basic server structure:**
   - Create socket
   - Bind to port
   - Listen for connections
   - Accept connection
   - Read data line by line
   - Print to stdout

4. **Sample code:**
```python
from socket import *
serverPort = 12000
serverSocket = socket(AF_INET, SOCK_STREAM)
serverSocket.bind(('', serverPort))
serverSocket.listen(1)
print("Server ready")
while True:
    connectionSocket, addr = serverSocket.accept()
    print("Connection from", addr)
    while True:
        sentence = connectionSocket.recv(1024).decode()
        if not sentence:
            break
        print(sentence, end='')
    connectionSocket.close()
```

5. **Proxy setup:** Configure browser to use server IP:port as proxy.

6. **Observation:** Browser sends full HTTP requests to proxy, including conditional GETs with If-Modified-Since headers for cached objects.

7. **Key concept to memorize:** Proxies intercept HTTP traffic, allowing inspection of browser request patterns.

## P13. Consider sending over HTTP/2 a Web page that consists of one video clip, and five images. Suppose that the video clip is transported as 2000 frames, and each image has three frames.

### a. If all the video frames are sent first without interleaving, how many "frame times" are needed until all five images are sent?

**Answer:** 2000 + (5 × 3) = 2015 frame times

**Explanation:**

1. **HTTP/2 frames:** Data is sent in frames, each taking one "frame time" to transmit.

2. **Content:** 1 video (2000 frames) + 5 images (3 frames each = 15 frames)

3. **Without interleaving:** Send all 2000 video frames first, then 15 image frames.

4. **Total time:** 2000 + 15 = 2015 frame times.

5. **Key concept to memorize:** Without interleaving, total frames = sum of all frames.

### b. If frames are interleaved, how many frame times are needed until all five images are sent.

**Answer:** 2000 frame times

**Explanation:**

1. **Interleaving:** Mix video and image frames in transmission order.

2. **Goal:** All five images sent as soon as possible.

3. **To minimize time for images:** Send image frames interspersed with video frames.

4. **Optimal:** Send one image frame every few video frames.

5. **Since there are 5 images × 3 = 15 frames, and 2000 video frames.**

6. **By the time all images are sent, many video frames have been sent.**

7. **Minimum time:** Enough to send all 15 image frames + some video frames.

8. **Actually:** To send all images, need at least 15 frame times, but since video frames are also being sent, the time is determined by when the last image frame is sent.

9. **Key concept to memorize:** Interleaving allows images to be sent earlier by mixing with video frames.

## P14. Consider the Web page in problem 13. Now HTTP/2 prioritization is employed. Suppose all the images are given priority over the video clip, and that the first image is given priority over the second image, the second image over the third image, and so on. How many frame times will be needed until the second image is sent?

**Answer:** 2 frame times

**Explanation:**

1. **HTTP/2 prioritization:** Allows assigning priorities to different streams (requests).

2. **Priorities:** Images > video, and image1 > image2 > image3 > image4 > image5.

3. **Each image has 3 frames:** Need to send frames from highest priority first.

4. **To send second image:** Need to send all frames of first image (3 frames) + first frame of second image.

5. **Since images have higher priority than video, video frames are sent only after image frames.**

6. **Sequence:** Send frames in priority order.

7. **Time for second image:** After 1 frame of image1, then 2 frames of image1, then 1 frame of image2.

8. **Assuming round-robin or weighted scheduling, the second image's first frame is sent after some higher priority frames.**

9. **Simplest case:** 1 frame of image1, then 1 frame of image2, etc.

10. **So second image starts after 2 frame times.**

11. **Key concept to memorize:** HTTP/2 prioritization ensures higher priority content is sent first.

## P15. What is the difference between MAIL FROM: in SMTP and From: in the mail message itself?

**Answer:** MAIL FROM is the envelope sender (return path), From: is the message header sender (displayed to recipient).

**Explanation:**

1. **SMTP MAIL FROM:** Part of the SMTP envelope, specifies the sender's email address for delivery and bounces.

2. **Message From: header:** Part of the RFC 5322 message format, displayed in the recipient's mail client.

3. **Difference:** MAIL FROM can be different from From: header (spoofing), but From: is what the user sees.

4. **Purpose:** MAIL FROM for routing/bounces, From: for user display.

5. **Key concept to memorize:** Envelope sender (MAIL FROM) vs header sender (From:).