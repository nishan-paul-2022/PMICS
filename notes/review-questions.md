# [SECTION 2.1](../notes/documents/section-2.1.pdf)

**R1.** List five nonproprietary Internet applications and the application-layer protocols that they use.

**R2.** What is the difference between network architecture and application architecture?

**R3.** For a communication session between a pair of processes, which process is the client and which is the server?

**R4.** For a P2P file-sharing application, do you agree with the statement, "There is no notion of client and server sides of a communication session"? Why or why not?

**R5.** What information is used by a process running on one host to identify a process running on another host?

**R6.** Suppose you wanted to do a transaction from a remote client to a server as fast as possible. Would you use UDP or TCP? Why?

**R7.** Referring to Figure 2.4, we see that none of the applications listed in Figure 2.4 requires both no data loss and timing. Can you conceive of an application that requires no data loss and that is also highly time-sensitive?

**R8.** List the four broad classes of services that a transport protocol can provide. For each of the service classes, indicate if either UDP or TCP (or both) provides such a service.

**R9.** Recall that TCP can be enhanced with TLS to provide process-to-process security services, including encryption. Does TLS operate at the transport layer or the application layer? If the application developer wants TCP to be enhanced with TLS, what does the developer have to do?

# [SECTIONS 2.2–2.5](../notes/documents/section-2.2-2.5.pdf)

**R10.** What is meant by a handshaking protocol?

**R11.** Why do HTTP, SMTP, and IMAP run on top of TCP rather than on UDP?

**R12.** Consider an e-commerce site that wants to keep a purchase record for each of its customers. Describe how this can be done with cookies.

**R13.** Describe how Web caching can reduce the delay in receiving a requested object. Will Web caching reduce the delay for all objects requested by a user or for only some of the objects? Why?

**R14.** Telnet into a Web server and send a multiline request message. Include in the request message the If-modified-since: header line to force a response message with the 304 Not Modified status code.

**R15.** List several popular messaging apps. Do they use the same protocols as SMS?

**R16.** Suppose Alice, with a Web-based e-mail account (such as Hotmail or Gmail), sends a message to Bob, who accesses his mail from his mail server using IMAP. Discuss how the message gets from Alice's host to Bob's host. Be sure to list the series of application-layer protocols that are used to move the message between the two hosts.

**R17.** Print out the header of an e-mail message you have recently received. How many Received: header lines are there? Analyze each of the header lines in the message.

**R18.** What is the HOL blocking issue in HTTP/1.1? How does HTTP/2 attempt to solve it?

**R19.** Is it possible for an organization's Web server and mail server to have exactly the same alias for a hostname (for example, foo.com)? What would be the type for the RR that contains the hostname of the mail server?

**R20.** Look over your received e-mails, and examine the header of a message sent from a user with a .edu e-mail address. Is it possible to determine from the header the IP address of the host from which the message was sent? Do the same for a message sent from a Gmail account.

**R21.** In BitTorrent, suppose Alice provides chunks to Bob throughout a 30-second interval. Will Bob necessarily return the favor and provide chunks to Alice in this same interval? Why or why not?

**R22.** Consider a new peer Alice that joins BitTorrent without possessing any chunks. Without any chunks, she cannot become a top-four uploader for any of the other peers, since she has nothing to upload. How then will Alice get her first chunk?

**R23.** What is an overlay network? Does it include routers? What are the edges in the overlay network?

# [SECTION 2.6](../notes/documents/section-2.6.pdf)

**R24.** CDNs typically adopt one of two different server placement philosophies. Name and briefly describe them.

**R25.** Besides network-related considerations such as delay, loss, and bandwidth performance, there are other important factors that go into designing a CDN server selection strategy. What are they?

# [SECTION 2.7](../notes/documents/section-2.7.pdf)

**R26.** In Section 2.7, the UDP server described needed only one socket, whereas the TCP server needed two sockets. Why? If the TCP server were to support n simultaneous connections, each from a different client host, how many sockets would the TCP server need?

**R27.** For the client-server application over TCP described in Section 2.7, why must the server program be executed before the client program? For the client-server application over UDP, why may the client program be executed before the server program?