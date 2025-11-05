# **SECTION 3.7**

---

[Section 3.7 PDF](documents/section-3.7.pdf)

### **R17.**

Suppose two TCP connections are present over some **bottleneck link** of rate **R bps**.
Both connections have a huge file to send (in the same direction over the bottleneck link).
The transmissions of the files start at the same time.

What transmission rate would TCP like to give to each of the connections?

---

### **R18.**

**True or false?**
Consider congestion control in TCP.
When the timer expires at the sender, the value of **ssthresh** is set to one half of its previous value.

---

### **R19.**

In the discussion of **TCP splitting** in the sidebar in Section 3.7, it was claimed that the response time with TCP splitting is approximately:

> **4 × RTTFE + RTTBE + processing time**

Justify this claim.