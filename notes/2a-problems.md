# Computer Networking Problems Solutions - Part 1

This document contains detailed solutions to problems P1-P5. Each problem includes the question, the answer, and a step-by-step explanation designed for complete beginners to understand and memorize the concepts.

## Table of Contents

- [P1. True or False?](#p1-true-or-false)
- [P2. SMS, iMessage, Wechat, and WhatsApp](#p2-sms-imessage-wechat-and-whatsapp)
- [P3. HTTP client protocols](#p3-consider-an-http-client-that-wants-to-retrieve-a-web-document-at-a-given-url-the-ip-address-of-the-http-server-is-initially-unknown-what-transport-and-application-layer-protocols-besides-http-are-needed-in-this-scenario)
- [P4. HTTP GET message analysis](#p4-the-text-below-shows-the-ascii-characters-that-were-captured-by-wireshark-when-the-browser-sent-an-http-get-message)
- [P5. HTTP response message analysis](#p5-the-text-below-shows-the-reply-sent-from-the-server-in-response-to-the-http-get-message-in-the-question-above)

## P1. True or False?

### a. A user requests a Web page that consists of some text and three images. For this page, the client will send one request message and receive four response messages.

**Answer:** False

**Explanation:**

Let's break this down step by step, starting from the basics.

1. **What is a Web page?** A Web page is a document that your browser displays. It usually includes HTML (HyperText Markup Language) code, which is the text part, and often references other files like images, CSS (stylesheets), and JavaScript.

2. **How does the browser get a Web page?** When you type a URL (Uniform Resource Locator) like "www.example.com" into your browser, the browser acts as a client and sends a request to the server hosting that page.

3. **What is HTTP?** HTTP stands for HyperText Transfer Protocol. It's the protocol (set of rules) that browsers and servers use to communicate. The browser sends HTTP requests, and the server sends HTTP responses.

4. **What happens with images in a Web page?** The HTML file contains links to images. The browser first downloads the HTML file, reads it, and then sends separate requests for each image it finds in the HTML.

5. **Step-by-step process for this scenario:**
   - The user clicks or types the URL.
   - Browser sends one HTTP GET request to the server for the main HTML page (which contains the text).
   - Server responds with the HTML page in one HTTP response.
   - Browser parses (reads) the HTML and sees references to three images.
   - Browser sends three separate HTTP GET requests, one for each image.
   - Server sends back three separate HTTP responses, each containing one image.
   - Total: Browser sends 4 requests (1 for HTML + 3 for images) and receives 4 responses.

6. **Why is the statement false?** The statement claims the client sends "one request message" but receives "four response messages." In reality, the client sends four requests and receives four responses. There is no scenario in standard HTTP where one request leads to four responses without corresponding requests.

7. **Key concept to memorize:** In HTTP, each resource (like HTML or image) typically requires its own request-response pair. This is different from protocols where one request can fetch multiple things at once.

### b. Two distinct Web pages (for example, www.mit.edu/research.html and www.mit.edu/students.html) can be sent over the same persistent connection.

**Answer:** True

**Explanation:**

1. **What is a persistent connection?** In older versions of HTTP (like HTTP/1.0), each request required a new TCP connection, which was inefficient. HTTP/1.1 introduced persistent connections (also called keep-alive connections), where the same TCP connection can be reused for multiple requests and responses.

2. **How does it work?** Once a TCP connection is established between the browser (client) and the server, it stays open. The client can send multiple HTTP requests over this single connection, and the server can send multiple responses back over the same connection.

3. **Step-by-step for this scenario:**
   - Browser connects to www.mit.edu using TCP.
   - Browser sends HTTP GET request for /research.html.
   - Server sends response with the content of research.html.
   - Without closing the connection, browser sends another HTTP GET request for /students.html over the same TCP connection.
   - Server sends response with the content of students.html.
   - The connection can remain open for more requests if needed.

4. **Why is this true?** Persistent connections allow multiplexing multiple HTTP transactions over one TCP connection, improving efficiency by reducing the overhead of opening and closing connections repeatedly.

5. **Key concept to memorize:** Persistent connections in HTTP/1.1 enable sending multiple requests and responses over a single TCP connection, unlike non-persistent connections where each request needs a new TCP connection.

### c. With nonpersistent connections between browser and origin server, it is possible for a single TCP segment to carry two distinct HTTP request messages.

**Answer:** False

**Explanation:**

1. **What is a nonpersistent connection?** In nonpersistent HTTP (common in HTTP/1.0), each HTTP request-response pair uses a separate TCP connection. After the response, the connection is closed.

2. **What is a TCP segment?** TCP (Transmission Control Protocol) breaks data into segments for transmission. Each segment has a header and payload. HTTP messages are carried inside TCP segments.

3. **How HTTP requests work in nonpersistent connections:**
   - For each resource, a new TCP connection is established.
   - The HTTP request is sent in one or more TCP segments.
   - The response is sent back.
   - The connection is closed.

4. **Why can't two HTTP requests be in one TCP segment?** Each HTTP request is a complete message with its own headers and body. In nonpersistent connections, since connections are separate, each request is sent over its own connection. Even if pipelined (which is more for persistent connections), HTTP/1.0 doesn't support pipelining well. In practice, each HTTP message is sent in its own TCP segment(s), not combined.

5. **Step-by-step reasoning:**
   - Suppose the browser needs two pages.
   - It establishes TCP connection 1, sends HTTP request 1 in TCP segment(s), gets response, closes connection.
   - Then establishes TCP connection 2, sends HTTP request 2 in TCP segment(s), etc.
   - No single TCP segment carries two distinct HTTP requests because each request is on a separate connection.

6. **Key concept to memorize:** In nonpersistent HTTP, each HTTP transaction uses its own TCP connection, so messages are not multiplexed in the same segment.

### d. The Date: header in the HTTP response message indicates when the object in the response was last modified.

**Answer:** False

**Explanation:**

1. **What are HTTP headers?** HTTP messages (requests and responses) have headers that provide metadata. Headers are key-value pairs.

2. **What is the Date: header?** The Date header in an HTTP response indicates the date and time when the response was generated by the server. It's like a timestamp of when the server sent the response.

3. **What is the Last-Modified: header?** This header indicates when the resource (object) on the server was last modified. It's used for caching and conditional requests.

4. **Difference:**
   - Date: When the response was created (server's current time).
   - Last-Modified: When the file was last changed on the server.

5. **Example:**
   - Suppose a file was modified on January 1, 2023.
   - Server generates response on January 2, 2023.
   - Last-Modified: January 1, 2023
   - Date: January 2, 2023

6. **Why is the statement false?** The Date header shows when the response was sent, not when the object was last modified.

7. **Key concept to memorize:** Date header = response generation time; Last-Modified header = object's last modification time.

### e. HTTP response messages never have an empty message body.

**Answer:** False

**Explanation:**

1. **What is an HTTP response message?** It includes status line, headers, and optional message body (the actual content).

2. **When is the message body empty?** For some responses, there's no content to send. Examples:
   - 304 Not Modified: The client has the cached version, so no need to send the body.
   - 204 No Content: Successful request but no content to return.
   - 1xx (informational) or some error responses.

3. **Step-by-step:**
   - HTTP allows responses without a body.
   - The Content-Length header can be 0, meaning empty body.
   - Browsers handle this by not expecting content.

4. **Why is the statement false?** HTTP responses can indeed have empty message bodies in certain cases.

5. **Key concept to memorize:** HTTP response bodies are optional; some status codes (like 304) have no body.

## P2. SMS, iMessage, Wechat, and WhatsApp are all smartphone real-time messaging systems. After doing some research on the Internet, for each of these systems write one paragraph about the protocols they use. Then write a paragraph explaining how they differ.

**SMS (Short Message Service):**

SMS is a protocol used for sending short text messages between mobile devices. It operates over the cellular network using the Signaling System No. 7 (SS7) protocol for routing messages between mobile carriers. Messages are limited to 160 characters (or 70 for non-Latin alphabets) and are stored and forwarded through Short Message Service Centers (SMSCs). SMS doesn't require internet connectivity, working directly through cellular signals, but it's not real-time in the instant messaging sense as delivery can take seconds to minutes depending on network conditions.

**iMessage:**

iMessage is Apple's proprietary messaging service for iOS and macOS devices. It uses a combination of protocols including Apple's Push Notification service (APNs) for real-time delivery and encryption. Messages are sent over the internet using Wi-Fi or cellular data, with end-to-end encryption provided by the iMessage protocol. Unlike SMS, iMessage supports multimedia content, read receipts, and integrates seamlessly across Apple devices. It falls back to SMS for non-iMessage users, but the core protocol is Apple's custom implementation built on top of standard internet protocols.

**WeChat:**

WeChat, developed by Tencent, is a comprehensive messaging and social media platform primarily used in China. It employs a proprietary protocol that combines elements of XMPP (Extensible Messaging and Presence Protocol) with custom extensions for multimedia and social features. Messages are transmitted over TCP/IP connections with encryption, and the service includes voice calls, video calls, and payments. WeChat's protocol is closed-source and heavily integrated with Chinese internet infrastructure, requiring users to register with phone numbers and often mandating real-name verification.

**WhatsApp:**

WhatsApp uses a proprietary protocol based on XMPP (Extensible Messaging and Presence Protocol) with significant modifications for security and efficiency. It employs end-to-end encryption using the Signal protocol, which is based on the Double Ratchet algorithm. Messages are sent over internet connections (Wi-Fi or cellular data) and support multimedia content, group chats, and voice/video calls. WhatsApp's protocol includes optimizations for low-bandwidth environments and uses a centralized server architecture for message routing and storage.

**Differences:**

These messaging systems differ primarily in their underlying protocols, infrastructure requirements, and feature sets. SMS relies on traditional cellular networks and SS7 signaling, making it universal but limited in functionality and requiring no internet connection. In contrast, iMessage, WeChat, and WhatsApp all require internet connectivity and use modern protocols like XMPP or proprietary variants over TCP/IP. iMessage is exclusive to Apple ecosystems with seamless device integration, while WeChat is deeply embedded in Chinese digital infrastructure with extensive social features. WhatsApp stands out for its strong emphasis on privacy through Signal-based encryption and global accessibility. While SMS is carrier-dependent and often incurs fees, the internet-based services are generally free but depend on data plans and can be subject to government surveillance or blocking in certain regions.

## P3. Consider an HTTP client that wants to retrieve a Web document at a given URL. The IP address of the HTTP server is initially unknown. What transport and application-layer protocols besides HTTP are needed in this scenario?

**Answer:** DNS (Domain Name System) for application layer, and TCP (Transmission Control Protocol) for transport layer.

**Explanation:**

Let's understand this step by step, as if you're learning networking for the first time.

1. **What is a URL?** A URL (Uniform Resource Locator) is the address you type in your browser, like "http://www.example.com/index.html". It tells the browser where to find the web page.

2. **What does the HTTP client need to do?** The client (your browser or any program) needs to get the web document from the server. But it only has the URL, not the server's IP address.

3. **Why is the IP address unknown?** Computers on the internet communicate using IP addresses (like 192.168.1.1), but humans use domain names (like www.example.com). The client needs to convert the domain name to an IP address.

4. **What is DNS?** DNS stands for Domain Name System. It's like the phone book of the internet. It translates human-readable domain names into IP addresses that computers can use.

5. **Step-by-step process:**
   - User enters URL: http://www.example.com/index.html
   - Client extracts the hostname: www.example.com
   - Client sends a DNS query to find the IP address of www.example.com
   - DNS server responds with the IP address (e.g., 93.184.216.34)
   - Now the client knows where to connect.

6. **What happens after getting the IP address?** The client needs to establish a connection to the server and send the HTTP request. This requires a transport protocol.

7. **What is TCP?** TCP (Transmission Control Protocol) is a transport layer protocol that provides reliable, ordered delivery of data between applications. HTTP runs on top of TCP.

8. **Why TCP specifically?** HTTP is designed to work over TCP because:
   - TCP ensures data arrives in order and without errors.
   - TCP handles flow control and congestion control.
   - HTTP needs reliable delivery for web pages.

9. **Could it use UDP?** No, because UDP (User Datagram Protocol) is unreliable - it doesn't guarantee delivery or order. HTTP requires reliability.

10. **Are there other protocols involved?** In some cases, HTTPS (secure HTTP) might be used, which adds TLS/SSL for encryption, but the question specifies HTTP, so we stick to the basics.

11. **Summary of protocols needed:**
    - Application layer: DNS (to resolve domain name to IP) and HTTP (to request the document)
    - Transport layer: TCP (to reliably transport the HTTP messages)

12. **Key concept to memorize:** For HTTP over the internet, you need DNS to find the server and TCP to reliably deliver the messages. HTTP itself is the application protocol for the web request/response.

## P4. The text below shows the ASCII characters that were captured by Wireshark when the browser sent an HTTP GET message (i.e., this is the actual content of an HTTP GET message). The characters <cr><lf> are carriage return and line-feed characters (that is, the italized character string <cr> in the text below represents the single carriage-return character that was contained at that point in the HTTP header). Answer the following questions, indicating where in the HTTP GET message below you find the answer.

```
GET /cs453/index.html HTTP/1.1<cr><lf>Host: gai
a.cs.umass.edu<cr><lf>User-Agent: Mozilla/5.0 (
Windows;U; Windows NT 5.1; en-US; rv:1.7.2) Gec
ko/20040804 Netscape/7.2 (ax) <cr><lf>Accept:ex
t/xml, application/xml, application/xhtml+xml, text
/html;q=0.9, text/plain;q=0.8,image/png,*/*;q=0.5
<cr><lf>Accept-Language: en-us,en;q=0.5<cr><lf>Accept-
Encoding: zip,deflate<cr><lf>Accept-Charset: ISO
-8859-1,utf-8;q=0.7,*;q=0.7<cr><lf>Keep-Alive: 300<cr>
<lf>Connection:keep-alive<cr><lf><cr><lf>
```

### a. What is the URL of the document requested by the browser?

**Answer:** /cs453/index.html

**Explanation:**

1. **What is an HTTP GET message?** It's the request your browser sends to a server to ask for a web page or file. The first line is called the request line.

2. **Structure of HTTP request:** The request line has three parts: Method (GET), URL path, and HTTP version.

3. **Looking at the message:** The first line is: `GET /cs453/index.html HTTP/1.1<cr><lf>`

4. **Breaking it down:**
   - GET: The method (asking to retrieve something)
   - /cs453/index.html: This is the path part of the URL
   - HTTP/1.1: The version of HTTP being used

5. **What about the full URL?** The full URL would be the Host header plus this path. But the question asks for "the URL of the document requested," and in the context, it means the path. The Host header gives the domain: gaia.cs.umass.edu

6. **Complete URL:** http://gaia.cs.umass.edu/cs453/index.html

7. **But the question says "the URL," and points to the request line.** In HTTP/1.1, the URL in the request line is the path, and the host is in the Host header.

8. **Key concept to memorize:** In HTTP GET request, the URL path is in the first line after GET, and the host is in the Host: header.

### b. What version of HTTP is the browser running?

**Answer:** HTTP/1.1

**Explanation:**

1. **Where is the HTTP version specified?** In the request line, the last part.

2. **From the message:** `GET /cs453/index.html HTTP/1.1<cr><lf>`

3. **HTTP versions:** Common versions are 1.0, 1.1, 2.0. HTTP/1.1 supports persistent connections, which we can see from the Connection: keep-alive header.

4. **Key concept to memorize:** HTTP version is specified in the request line, after the URL.

### c. Does the browser request a non-persistent or a persistent connection?

**Answer:** Persistent connection

**Explanation:**

1. **What are persistent vs non-persistent connections?** Non-persistent closes after each request-response. Persistent keeps the connection open for multiple requests.

2. **Look for the Connection header:** `Connection:keep-alive<cr><lf>`

3. **What does keep-alive mean?** It means the connection should remain open after the response, i.e., persistent connection.

4. **In HTTP/1.0, persistent was optional with keep-alive.** In HTTP/1.1, persistent is default, but the header confirms it.

5. **Key concept to memorize:** Connection: keep-alive header requests a persistent connection.

### d. What is the IP address of the host on which the browser is running?

**Answer:** Not specified in the message

**Explanation:**

1. **What information is in the HTTP request?** The request contains information about what the client wants, not necessarily about the client's network details.

2. **Headers present:**
   - Host: The server being requested
   - User-Agent: Browser info
   - Accept*: What content types accepted
   - Keep-Alive: Connection preference
   - Connection: Connection type

3. **No IP address of the browser:** HTTP doesn't include the client's IP in the headers. The server knows the client's IP from the TCP connection.

4. **Why not included?** For privacy and because it's not needed for the request.

5. **Key concept to memorize:** HTTP requests don't contain the client's IP address; that's handled at the network layer.

### e. What type of browser initiates this message? Why is the browser type needed in an HTTP request message?

**Answer:** Mozilla/5.0 (Netscape 7.2), needed for server to send appropriate content

**Explanation:**

1. **Browser type from User-Agent header:** `User-Agent: Mozilla/5.0 (Windows;U; Windows NT 5.1; en-US; rv:1.7.2) Gecko/20040804 Netscape/7.2 (ax)`

2. **What does this mean?** It's Netscape 7.2 browser on Windows, but identifies as Mozilla for compatibility.

3. **Why is it needed?** Servers can send different content based on browser capabilities. For example:
   - Different HTML for different browsers
   - Different features or workarounds for older browsers
   - Analytics and debugging

4. **Key concept to memorize:** User-Agent header identifies the browser/client, allowing servers to customize responses.

## P5. The text below shows the reply sent from the server in response to the HTTP GET message in the question above. Answer the following questions, indicating where in the message below you find the answer.

```
HTTP/1.1 200 OK<cr><lf>Date: Tue, 07 Mar 2008
12:39:45GMT<cr><lf>Server: Apache/2.0.52 (Fedora)
<cr><lf>Last-Modified: Sat, 10 Dec2005 18:27:46
GMT<cr><lf>ETag: "526c3-f22-a88a4c80"<cr><lf>Accept-
Ranges: bytes<cr><lf>Content-Length: 3874<cr><lf>
Keep-Alive: timeout=max=100<cr><lf>Connection:
Keep-Alive<cr><lf>Content-Type: text/html; charset=
ISO-8859-1<cr><lf><cr><lf><!doctype html public "-
//w3c//dtd html 4.0transitional//en"><lf><html><lf>
<head><lf> <meta http-equiv="Content-Type"
content="text/html; charset=iso-8859-1"><lf> <meta
name="GENERATOR" content="Mozilla/4.79 [en] (Windows NT
5.0; U) Netscape]"><lf> <title>CMPSCI 453 / 591 /
NTU-ST550ASpring 2005 homepage</title><lf></head><lf>
<much more document text following here (not shown)>
```

### a. Was the server able to successfully find the document or not? What time was the document reply provided?

**Answer:** Yes, successfully found (status 200 OK), at Tue, 07 Mar 2008 12:39:45 GMT

**Explanation:**

1. **HTTP status codes:** The first line of the response is the status line: `HTTP/1.1 200 OK<cr><lf>`

2. **What does 200 OK mean?** 200 is the status code for "OK" or successful request. The server found and is returning the document.

3. **Date header:** `Date: Tue, 07 Mar 2008 12:39:45 GMT<cr><lf>`

4. **What is the Date header?** It indicates when the response was generated by the server.

5. **Key concept to memorize:** Status line shows if request succeeded (200 OK), Date header shows response time.

### b. When was the document last modified?

**Answer:** Sat, 10 Dec 2005 18:27:46 GMT

**Explanation:**

1. **Last-Modified header:** `Last-Modified: Sat, 10 Dec 2005 18:27:46 GMT<cr><lf>`

2. **What does it mean?** This tells when the file was last changed on the server.

3. **Why is this important?** For caching - browsers can check if their cached version is still current.

4. **Key concept to memorize:** Last-Modified header shows when the resource was last updated on the server.

### c. How many bytes are there in the document being returned?

**Answer:** 3874 bytes

**Explanation:**

1. **Content-Length header:** `Content-Length: 3874<cr><lf>`

2. **What does it mean?** The size of the message body (the HTML content) in bytes.

3. **Note:** This doesn't include headers, only the actual content.

4. **Key concept to memorize:** Content-Length header specifies the size of the response body in bytes.

### d. What are the first 5 bytes of the document being returned? Did the server agree to a persistent connection?

**Answer:** First 5 bytes: <!doc (from <!doctype), Yes, persistent connection agreed

**Explanation:**

1. **First 5 bytes:** The message body starts after the double <cr><lf>: `<!doctype html public "-//w3c//dtd html 4.0transitional//en">`

2. **So first 5 bytes:** < ! d o c (but as characters: < ! d o c t y p e ... but question asks for bytes, so literally the first 5: < ! d o c

3. **Persistent connection:** Look at Connection header: `Connection: Keep-Alive<cr><lf>`

4. **Keep-Alive means:** The connection will remain open for more requests.

5. **Also see:** `Keep-Alive: timeout=max=100<cr><lf>` which gives timeout details.

6. **Key concept to memorize:** Response body follows headers after blank line, Connection: Keep-Alive means persistent connection.