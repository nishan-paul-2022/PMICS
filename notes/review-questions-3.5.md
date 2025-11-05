# **SECTION 3.5**

---

[Section 3.5 PDF](documents/section-3.5.pdf)

### **R14.**

**True or false?**

a. Host A is sending Host B a large file over a TCP connection. Assume Host B has no data to send Host A. Host B will not send acknowledgments to Host A because Host B cannot piggyback the acknowledgments on data.
b. The size of the TCP **rwnd** never changes throughout the duration of the connection.
c. Suppose Host A is sending Host B a large file over a TCP connection. The number of unacknowledged bytes that A sends cannot exceed the size of the receive buffer.
d. Suppose Host A is sending a large file to Host B over a TCP connection. If the sequence number for a segment of this connection is **m**, then the sequence number for the subsequent segment will necessarily be **m + 1**.
e. The TCP segment has a field in its header for **rwnd**.
f. Suppose that the last **SampleRTT** in a TCP connection is equal to 1 sec. The current value of **TimeoutInterval** for the connection will necessarily be ≥ 1 sec.
g. Suppose Host A sends one segment with sequence number **38** and 4 bytes of data over a TCP connection to Host B. In this same segment, the acknowledgment number is necessarily **42**.

---

### **R15.**

Suppose Host A sends two TCP segments back to back to Host B over a TCP connection.
The first segment has sequence number **90**; the second has sequence number **110**.

a. How much data is in the first segment?
b. Suppose that the first segment is lost but the second segment arrives at B. In the acknowledgment that Host B sends to Host A, what will be the acknowledgment number?

---

### **R16.**

Consider the **Telnet example** discussed in Section 3.5.
A few seconds after the user types the letter **'C'**, the user types the letter **'R'**.

After typing the letter 'R,' how many segments are sent, and what is put in the **sequence number** and **acknowledgment fields** of the segments?