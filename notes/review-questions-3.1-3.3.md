Here’s your text formatted for **maximum clarity and professional readability**, without changing **any words or text** — only the layout, spacing, and hierarchy have been improved.

---

# **SECTIONS 3.1–3.3**

---

[Section 3.1-3.3 PDF](documents/section-3.1-3.3.pdf)

### **R1.**

Suppose the network layer provides the following service. The network layer in the source host accepts a segment of maximum size 1,200 bytes and a destination host address from the transport layer. The network layer then guarantees to deliver the segment to the transport layer at the destination host. Suppose many network application processes can be running at the destination host.

a. Design the simplest possible transport-layer protocol that will get application data to the desired process at the destination host. Assume the operating system in the destination host has assigned a 4-byte port number to each running application process.
b. Modify this protocol so that it provides a "return address" to the destination process.
c. In your protocols, does the transport layer "have to do anything" in the core of the computer network?

---

### **R2.**

Consider a planet where everyone belongs to a family of six, every family lives in its own house, each house has a unique address, and each person in a given house has a unique name. Suppose this planet has a mail service that delivers letters from source house to destination house. The mail service requires that
(1) the letter be in an envelope, and that
(2) the address of the destination house (and nothing more) be clearly written on the envelope.

Suppose each family has a delegate family member who collects and distributes letters for the other family members. The letters do not necessarily provide any indication of the recipients of the letters.

a. Using the solution to Problem R1 above as inspiration, describe a protocol that the delegates can use to deliver letters from a sending family member to a receiving family member.
b. In your protocol, does the mail service ever have to open the envelope and examine the letter in order to provide its service?

---

### **R3.**

Consider a TCP connection between Host A and Host B. Suppose that the TCP segments traveling from Host A to Host B have source port number **x** and destination port number **y**.
What are the source and destination port numbers for the segments traveling from Host B to Host A?

---

### **R4.**

Describe why an application developer might choose to run an application over **UDP** rather than **TCP**.

---

### **R5.**

Why is it that **voice and video traffic** is often sent over **TCP** rather than **UDP** in today's Internet?
*(Hint: The answer we are looking for has nothing to do with TCP's congestion-control mechanism.)*

---

### **R6.**

Is it possible for an application to enjoy reliable data transfer even when the application runs over **UDP**? If so, how?

---

### **R7.**

Suppose a process in Host C has a UDP socket with port number **6789**.
Suppose both Host A and Host B each send a UDP segment to Host C with destination port number **6789**.

Will both of these segments be directed to the same socket at Host C?
If so, how will the process at Host C know that these two segments originated from two different hosts?

---

### **R8.**

Suppose that a Web server runs in Host C on port **80**. Suppose this Web server uses **persistent connections**, and is currently receiving requests from two different Hosts, A and B.

Are all of the requests being sent through the same socket at Host C?
If they are being passed through different sockets, do both of the sockets have port **80**?

Discuss and explain.