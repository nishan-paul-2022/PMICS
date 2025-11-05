# Computer Networking Problems Solutions - Part 4

This document contains detailed solutions to problems P16-P20. Each problem includes the question, the answer, and a step-by-step explanation designed for complete beginners to understand and memorize the concepts.

## Table of Contents

- [P16. Message end markers](#p16-how-does-smtp-mark-the-end-of-a-message-body-how-about-http-can-http-use-the-same-method-as-smtp-to-mark-the-end-of-a-message-body-explain)
- [P17. SMTP RFC and spam identification](#p17-read-rfc-5321-for-smtp-what-does-mta-stand-for-consider-the-following-received-spam-e-mail)
- [P18. Whois and DNS queries](#p18-a-what-is-a-whois-database)
- [P19. Dig tool DNS hierarchy](#p19-in-this-problem-we-use-the-useful-dig-tool-available-on-unix-and-linux-hosts-to-explore-the-hierarchy-of-dns-servers)
- [P20. Popular web servers from DNS cache](#p20-suppose-you-can-access-the-caches-in-the-local-dns-servers-of-your-department)

## P16. How does SMTP mark the end of a message body? How about HTTP? Can HTTP use the same method as SMTP to mark the end of a message body? Explain.

**Answer:** SMTP uses `<CRLF>.<CRLF>`, HTTP uses Content-Length or chunked transfer. HTTP cannot use SMTP's method because HTTP messages are binary and may contain `<CRLF>.<CRLF>`.

**Explanation:**

1. **SMTP end marker:** The message body ends with a line containing only a period (.) followed by `<CRLF>.<CRLF>`.

2. **HTTP end markers:** Uses Content-Length header (specifies exact byte count) or Transfer-Encoding: chunked (sends data in chunks with size indicators).

3. **Why HTTP can't use SMTP method:** HTTP messages can contain arbitrary binary data, including the sequence `<CRLF>.<CRLF>`. SMTP assumes text and escapes dots.

4. **Key concept to memorize:** SMTP uses dot-stuffing for text messages, HTTP uses length-based or chunked encoding for binary safety.

## P17. Read RFC 5321 for SMTP. What does MTA stand for? Consider the following received spam e-mail (modified from a real spam e-mail). Assuming only the originator of this spam e-mail is malicious and all other hosts are honest, identify the malacious host that has generated this spam e-mail.

```
From - Fri Nov 07 13:41:30 2008
Return-Path: <tennis5@pp33head.com>
Received: from barmail.cs.umass.edu (barmail.cs.umass.
edu
[128.119.240.3]) by cs.umass.edu (8.13.1/8.12.6) for
<hg@cs.umass.edu>; Fri, 7 Nov 2008 13:27:10 -0500
Received: from asusus-4b96 (localhost [127.0.0.1]) by
barmail.cs.umass.edu (Spam Firewall) for <hg@cs.umass.
edu>; Fri, 7
Nov 2008 13:27:07 -0500 (EST)
Received: from asusus-4b96 ([58.88.21.177]) by barmail.
cs.umass.edu
for <hg@cs.umass.edu>; Fri, 07 Nov 2008 13:27:07 -0500
(EST)
Received: from [58.88.21.177] by inbnd55.exchangeddd.
com; Sat, 8
Nov 2008 01:27:07 +0700
From: "Jonny" <tennis5@pp33head.com>
To: <hg@cs.umass.edu>
 
Subject: How to secure your savings
```

**Answer:** MTA = Mail Transfer Agent. Malicious host is [58.88.21.177] (asusus-4b96).

**Explanation:**

1. **MTA:** Mail Transfer Agent - software that transfers email messages from one computer to another.

2. **Received headers analysis:** Read from bottom to top to trace the path.

3. **Bottom header:** Received from [58.88.21.177] by inbnd55.exchangeddd.com - this is the originating server.

4. **Next:** From asusus-4b96 ([58.88.21.177]) - same IP.

5. **The spammer used IP 58.88.21.177 to send the email.**

6. **All other hosts are honest intermediaries.**

7. **Key concept to memorize:** Received headers show email routing path; bottom header indicates originator.

## P18. a. What is a whois database?

**Answer:** A whois database is a public database containing registration information for domain names and IP addresses.

**Explanation:**

1. **Whois database:** Contains details about domain registration, including owner, contact info, registration dates, and name servers.

2. **Purpose:** Allows lookup of domain/IP ownership and contact information.

3. **Managed by:** Regional Internet Registries (RIRs) for IP addresses, domain registrars for domains.

4. **Key concept to memorize:** Whois provides public registration data for domains and IP blocks.

### b. Use various whois databases on the Internet to obtain the names of two DNS servers. Indicate which whois databases you used.

**Answer:** Example: For google.com - ns1.google.com, ns2.google.com (using whois.verisign-grs.com or whois.iana.org).

**Explanation:**

1. **Process:** Query whois for a domain to get name server information.

2. **Databases:** whois.iana.org, whois.verisign-grs.com, etc.

3. **Example output:** Name servers listed in whois response.

4. **Key concept to memorize:** Whois queries reveal authoritative name servers for domains.

### c. Use nslookup on your local host to send DNS queries to three DNS servers: your local DNS server and the two DNS servers you found in part (b). Try querying for Type A, NS, and MX reports. Summarize your findings.

**Answer:** nslookup queries return IP addresses (A), name servers (NS), and mail servers (MX) for domains.

**Explanation:**

1. **nslookup usage:** Command-line tool for DNS queries.

2. **Record types:**
   - A: IPv4 address
   - NS: Name servers
   - MX: Mail exchange servers

3. **Findings:** Different servers may give same or different answers based on caching and authority.

4. **Key concept to memorize:** nslookup tests DNS resolution and compares responses from different servers.

### d. Use nslookup to find a Web server that has multiple IP addresses. Does the Web server of your institution (school or company) have multiple IP addresses?

**Answer:** Many large sites have multiple IPs for load balancing. Institutional servers may or may not.

**Explanation:**

1. **Multiple IPs:** For redundancy, load balancing, or CDNs.

2. **Check:** nslookup domain → multiple A records.

3. **Institutional:** Depends on setup; universities often have multiple for different services.

4. **Key concept to memorize:** Large websites use multiple IPs for scalability.

### e. Use the ARIN whois database to determine the IP address range used by your university.

**Answer:** Query ARIN whois with university name or IP to find allocated ranges.

**Explanation:**

1. **ARIN:** American Registry for Internet Numbers, manages IP allocations in Americas.

2. **Query:** whois.arin.net with organization name.

3. **Result:** CIDR blocks assigned to the university.

4. **Key concept to memorize:** RIR whois databases show IP address allocations.

### f. Describe how an attacker can use whois databases and the nslookup tool to perform reconnaissance on an institution before launching an attack.

**Answer:** Attacker can gather domain info, IP ranges, mail servers, and DNS structure for targeted attacks.

**Explanation:**

1. **Reconnaissance:** Gather intelligence before attack.

2. **Using whois:** Find contact info, IP ranges, name servers.

3. **Using nslookup:** Map DNS structure, find subdomains, mail servers.

4. **Attack preparation:** Identify vulnerable services, plan phishing, DDoS targets.

5. **Key concept to memorize:** Public DNS/whois data aids attacker reconnaissance.

### g. Discuss why whois databases should be publicly available.

**Answer:** Public access enables troubleshooting, security research, and accountability.

**Explanation:**

1. **Benefits:**
   - Network troubleshooting
   - Abuse reporting
   - Research and statistics
   - Transparency and accountability

2. **Drawbacks:** Privacy concerns, enables malicious reconnaissance.

3. **Balance:** Public access outweighs risks for internet health.

4. **Key concept to memorize:** Whois transparency supports internet stability and security.

## P19. In this problem, we use the useful dig tool available on Unix and Linux hosts to explore the hierarchy of DNS servers. Recall that in Figure 2.19, a DNS server in the DNS hierarchy delegates a DNS query to a DNS server lower in the hierarchy, by sending back to the DNS client the name of that lower-level DNS server. First read the man page for dig, and then answer the following questions.

### a. Starting with a root DNS server (from one of the root servers [a-m].root-servers.net), initiate a sequence of queries for the IP address for your department's Web server by using dig. Show the list of the names of DNS servers in the delegation chain in answering your query.

**Answer:** Delegation chain: root → TLD server → authoritative server.

**Explanation:**

1. **dig usage:** dig @server domain

2. **Start with root:** dig @a.root-servers.net domain

3. **Follow delegations:** Each response gives next level servers.

4. **Chain example:** . → .edu → university.edu → dept.university.edu

5. **Key concept to memorize:** DNS resolution follows hierarchical delegation chain.

### b. Repeat part (a) for several popular Web sites, such as google.com, yahoo.com, or amazon.com.

**Answer:** Similar chains for .com domains.

**Explanation:**

1. **Process:** Same as part (a), starting from root.

2. **Findings:** .com TLD servers, then site-specific authoritative servers.

3. **Key concept to memorize:** All domains follow same hierarchical resolution.

## P20. Suppose you can access the caches in the local DNS servers of your department. Can you propose a way to roughly determine the Web servers (outside your department) that are most popular among the users in your department? Explain.

**Answer:** Analyze cache entries for frequency of DNS queries to external domains.

**Explanation:**

1. **DNS cache:** Stores recent query results.

2. **Access cache:** View cached records and timestamps.

3. **Popularity metric:** Count queries or cache hits for each domain.

4. **External servers:** Focus on non-department domains.

5. **Limitations:** Cache has limited size, LRU eviction, doesn't show all queries.

6. **Key concept to memorize:** DNS cache analysis reveals access patterns.